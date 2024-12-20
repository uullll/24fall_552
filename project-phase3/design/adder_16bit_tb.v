`timescale 1ns/1ps

module tb_adder_16bit;
    
    // 输入和输出信号
    reg [15:0] a, b;
    reg is_sub;
    wire [15:0] sum;
    wire ovfl;

    // 实例化被测试的加法器模块
    adder_sub_16bit uut (
        .a(a),
        .b(b),
        .is_sub(is_sub),
        .sum(sum),
        .ovfl(ovfl)
    );

    initial begin
        // 设置监视器显示信号变化
        $monitor("Time: %0t | a = %d | b = %d | is_sub = %b | sum = %d | ovfl = %b", $time, a, b, is_sub, sum, ovfl);

        // 测试用例1：加法操作
        a = 16'h1234;     // 输入A
        b = 16'h4321;     // 输入B
        is_sub = 1'b0;    // 设置为0，表示执行加法
        #10;              // 等待10ns观察结果

        // 测试用例2：加法操作，检测溢出
        a = 16'h7FFF;     // 最大正数
        b = 16'h0001;     // 加1
        is_sub = 1'b0;    // 执行加法
        #10;              // 等待10ns观察结果

        // 测试用例3：减法操作，正常减法
        a = 16'h8000;     // 输入A
        b = 16'h0001;     // 输入B
        is_sub = 1'b1;    // 设置为1，表示执行减法
        #10;              // 等待10ns观察结果

        // 测试用例4：减法操作，检测溢出
        a = 16'h8000;     // 最小负数
        b = 16'h0001;     // 减去1
        is_sub = 1'b1;    // 执行减法
        #10;              // 等待10ns观察结果

        // 测试用例5：加法操作，两个负数相加
        a = 16'hFFFF;     // -1
        b = 16'hFFFE;     // -2
        is_sub = 1'b0;    // 执行加法
        #10;              // 等待10ns观察结果

        // 测试用例6：减法操作，两个负数相减
        a = 16'hFFFF;     // -1
        b = 16'hFFFE;     // -2
        is_sub = 1'b1;    // 执行减法
        #10;              // 等待10ns观察结果

        // 停止仿真
        $stop;
    end

endmodule
