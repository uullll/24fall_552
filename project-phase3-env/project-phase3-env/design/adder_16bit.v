module adder_sub_16bit (
    input [15:0]  a, // input A
    input [15:0]  b, // input B
    input        is_sub, // 1==subtract
    output [15:0] sum, // sum output
    output       ovfl
);
    wire [4:0]c;
    wire [15:0]b_in;
    wire [3:0]g;
    wire [3:0]p;
    wire [15:0]sum_temp;

    assign b_in = is_sub ? ~b : b;
    assign c[0] = is_sub;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    CLA4 U_CLA4_0(
        .a(a[3:0]),
        .b(b_in[3:0]),
        .cin(c[0]),
        .sum(sum_temp[3:0]),
        .cout(),
        .ovfl(),
        .tg(g[0]),
        .tp(p[0])
        );

    CLA4 U_CLA4_1(
        .a(a[7:4]),
        .b(b_in[7:4]),
        .cin(c[1]),
        .sum(sum_temp[7:4]),
        .cout(),
        .ovfl(),
        .tg(g[1]),
        .tp(p[1])
        );

    CLA4 U_CLA4_2(
        .a(a[11:8]),
        .b(b_in[11:8]),
        .cin(c[2]),
        .sum(sum_temp[11:8]),
        .cout(),
        .ovfl(),
        .tg(g[2]),
        .tp(p[2])
        );

    CLA4 U_CLA4_3(
        .a(a[15:12]),
        .b(b_in[15:12]),
        .cin(c[3]),
        .sum(sum_temp[15:12]),
        .cout(),
        .ovfl(),
        .tg(g[3]),
        .tp(p[3])
        );

    // Overflow detection
    assign ovfl = is_sub ? 
                 // Subtraction: overflow if signs different and result matches a
                 ((a[15] ^ b[15]) & (sum_temp[15] == a[15])) :
                 // Addition: overflow if signs same but result sign different
                 ((~(a[15] ^ b[15])) & (sum_temp[15] ^ a[15]));

    // saturation
    assign sum = ovfl ? (sum_temp[15] ? 16'h8000 : 16'h7fff) : sum_temp;

endmodule