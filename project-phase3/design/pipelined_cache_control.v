module pipelined_cache_control(
    input clk,
    input rst,

    input Icache_write,
    input Icache_read,
    input Dcache_write,
    input Dcache_read,
    input [15:0] Icache_addr,
    input [15:0] Dcache_addr,
    input [15:0] memory_data_in,

    output [15:0] Icache_instr_out,
    output [15:0] Dcache_data_out,
    output Icache_stall,
    output Dcache_stall,
    output Icache_Hit,
    output Dcache_Hit
);
    wire [15:0] miss_address, memory_data_out, memory_address, memory_out, Icache_miss_address, Dcache_miss_address;
    wire [15:0] Dcache_data_in, Icache_data_in, Icache_instr_out0, Icache_instr_out1, Dcache_data_out0, Dcache_data_out1, Icache_memory_address, Dcache_memory_address;
    wire memory_data_valid, Icache_memory_data_valid, Dcache_memory_data_valid;
    wire Icache_LRU, Dcache_LRU;
    wire CacheEnable, Instr_VaildWay0, Instr_VaildWay1, Data_VaildWay0, Data_VaildWay1;
    wire Icache_MissDetected, Dcache_MissDetected, Icache_Hit, Dcache_Hit;
    wire Icache_fsm_DataWrite, Dcache_fsm_DataWrite, Dcache_fsm_TagWrite, Icache_fsm_TagWrite, Icache_fsm_busy, Dcache_fsm_busy;
    wire [63:0] Icache_set_enable, Dcache_set_enable;
    wire [7:0] Icache_word_select, Dcache_word_select, Icache_fsm_word_select, Dcache_fsm_word_select, Icache_word_sel, Dcache_word_sel;
    wire [7:0] Instr_metadata0, Instr_metadata1, Data_metadata0, Data_metadata1;
    wire [7:0] Instr_metadata0_out, Instr_metadata1_out, Data_metadata0_out, Data_metadata1_out;


    one_hot_64 IcacheIndex(.offset(Icache_addr[9:4]), .set_enable(Icache_set_enable));
    one_hot_64 DcacheIndex(.offset(Dcache_addr[9:4]), .set_enable(Dcache_set_enable));
    //one_hot_64 IcacheIndex(.offset(Icache_addr[9:4]), .enable(memory_data_valid), .set_enable(Icache_set_enable));
    //one_hot_64 DcacheIndex(.offset(Icache_addr[9:4]), .enable(memory_data_valid), .set_enable(Icache_set_enable));
    

    one_hot_8 IcacheOffset(.offset(Icache_addr[3:1]), .word_select(Icache_word_sel));
    one_hot_8 DcacheOffset(.offset(Dcache_addr[3:1]), .word_select(Dcache_word_sel));
    //one_hot_8 IcacheOffset(.offset(Icache_addr[3:1]), .enable(memory_data_valid), .word_select(Icache_word_sel));
    //one_hot_8 DcacheOffset(.offset(Dcache_addr[3:1]), .enable(memory_data_valid), .word_select(Dcache_word_sel));

    cache Instr_cache(
        .clk(clk),
        .rst(rst),
        .DataEnable(Icache_write | Icache_fsm_DataWrite),
        .TagEnable(Icache_fsm_TagWrite),
        .way0(Instr_VaildWay0 | Instr_write_way0),
        .way1(Instr_VaildWay1 | Instr_write_way1),
        .word_select(Icache_word_select),
        .tag_in({Icache_addr[15:10], 1'b1, Icache_LRU}),
        .data_in(Icache_data_in),
        .SetEnable(Icache_set_enable),
        .tag_out0(Instr_metadata0),
        .tag_out1(Instr_metadata1),
        .data_out0(Icache_instr_out0),
        .data_out1(Icache_instr_out1)
    );

    cache Data_cache(
        .clk(clk),
        .rst(rst),
        .DataEnable(Dcache_write | Dcache_fsm_DataWrite),
        .TagEnable(Dcache_fsm_TagWrite),
        .way0(Data_VaildWay0 | Data_write_way0),
        .way1(Data_VaildWay1 | Data_write_way1),
        .word_select(Dcache_word_select),
        .tag_in({Dcache_addr[15:10], Dcache_read, Dcache_LRU}),
        .data_in(Dcache_data_in),
        .SetEnable(Dcache_set_enable),
        .tag_out0(Data_metadata0),
        .tag_out1(Data_metadata1),
        .data_out0(Dcache_data_out0),
        .data_out1(Dcache_data_out1)
    );

    cache_fill_fsm Icache_fsm(
        .clk(clk),
        .rst(rst),
        .miss_detected(Icache_MissDetected),
        .miss_address(Icache_miss_address),
        .fsm_busy(Icache_fsm_busy),
        .write_data_array(Icache_fsm_DataWrite),
        .write_tag_array(Icache_fsm_TagWrite),
        .word_select(Icache_fsm_word_select),
        .memory_address(Icache_memory_address),
        .memory_data_valid(Icache_memory_data_valid)
        //.memory_data_valid(memory_data_valid)
    );

    cache_fill_fsm Dcache_fsm(
        .clk(clk),
        .rst(rst),
        .miss_detected((Dcache_read | Dcache_write) & (Dcache_MissDetected)),
        .miss_address(Dcache_miss_address),
        .fsm_busy(Dcache_fsm_busy),
        .write_data_array(Dcache_fsm_DataWrite),
        .write_tag_array(Dcache_fsm_TagWrite),
        .word_select(Dcache_fsm_word_select),
        .memory_address(Dcache_memory_address),
        .memory_data_valid(Dcache_memory_data_valid)
        //memory_data_valid(memory_data_valid)
    );

    memory4c memory(
        .data_out(memory_data_out),
        .data_valid(memory_data_valid),
        .data_in(memory_data_in),
        .addr(memory_address),
        //.enable(Icache_MissDetected | Dcache_MissDetected),
        .enable(Icache_fsm_busy | Dcache_fsm_busy),
        .wr(Dcache_write & ~Dcache_fsm_busy),
        .clk(clk),
        .rst(rst)
    );


    dff InstrMetadata0[7:0](.q(Instr_metadata0_out), .d(Instr_metadata0), .wen(1'b1), .clk(clk), .rst(rst));
    dff InstrMetadata1[7:0](.q(Instr_metadata1_out), .d(Instr_metadata1), .wen(1'b1), .clk(clk), .rst(rst));
    dff DataMetadata0[7:0](.q(Data_metadata0_out), .d(Data_metadata0), .wen(1'b1), .clk(clk), .rst(rst));
    dff DataMetadata1[7:0](.q(Data_metadata1_out), .d(Data_metadata1), .wen(1'b1), .clk(clk), .rst(rst));


    assign CacheEnable = Icache_read | Icache_write | Dcache_read | Dcache_write;
    assign memory_address = Icache_MissDetected ? Icache_memory_address : Dcache_memory_address;


    //metadata LRU = bit0, Valid = bit1, tag = bits[7:2]
    assign Instr_VaildWay0 = ((Icache_addr[15:10] == Instr_metadata0[7:2]) & Instr_metadata0[1]) & ~Icache_fsm_TagWrite;
    assign Instr_VaildWay1 = ((Icache_addr[15:10] == Instr_metadata1[7:2]) & Instr_metadata1[1]) & ~Icache_fsm_TagWrite;
    assign Data_VaildWay0 = ((Dcache_addr[15:10] == Data_metadata0[7:2]) & Data_metadata0[1]) & ~Dcache_fsm_TagWrite;
    assign Data_VaildWay1 = ((Dcache_addr[15:10] == Data_metadata1[7:2]) & Data_metadata1[1]) & ~Dcache_fsm_TagWrite;
    /*assign Icache_fsm_TagWrite = Icache_write & fsm_TagWrite;
    assign Dcache_fsm_TagWrite = Dcache_write & fsm_TagWrite;
    assign Instr_VaildWay0 = ((Icache_addr[15:10] == Instr_metadata0[7:2]) & Instr_metadata0[1]) & ~Icache_fsm_TagWrite;
    assign Instr_VaildWay1 = ((Icache_addr[15:10] == Instr_metadata1[7:2]) & Instr_metadata1[1]) & ~Icache_fsm_TagWrite;
    assign Data_VaildWay0 = ((Dcache_addr[15:10] == Data_metadata0[7:2]) & Data_metadata0[1]) & ~Dcache_fsm_TagWrite;
    assign Data_VaildWay1 = ((Dcache_addr[15:10] == Data_metadata1[7:2]) & Data_metadata1[1]) & ~Dcache_fsm_TagWrite; */
    assign Dcache_LRU = Data_VaildWay0 ? 1'b1 : 
                        Data_VaildWay1 ? 1'b0 :
                        Data_metadata0_out[0];
    assign Icache_LRU = Instr_VaildWay0 ? 1'b1 : 
                        Instr_VaildWay1 ? 1'b0 :
                        Instr_metadata0_out[0];

    //miss detect
    //assign Icache_MissDetected = ~(Instr_VaildWay0 | Instr_VaildWay1);
    assign Icache_MissDetected = ~(Instr_VaildWay0 | Instr_VaildWay1) & Icache_read;
    assign Icache_Hit = ~Icache_MissDetected;
    //assign Dcache_MissDetected = ~(Data_VaildWay0 | Data_VaildWay1) & (Dcache_read | Dcache_write);
    assign Dcache_MissDetected = ~(Data_VaildWay0 | Data_VaildWay1) & (Dcache_read | Dcache_write);
    assign Dcache_Hit = ~Dcache_MissDetected & (Dcache_read | Dcache_write);

    //get miss_address
    assign Icache_miss_address = Icache_addr;
    assign Dcache_miss_address = Dcache_addr;

    //data_in for cache
    //assign memory_data_out = (Dcache_write& ~Dcache_MissDetected) ? 16'b0 : memory_out;
    assign Dcache_data_in = (Dcache_MissDetected & Dcache_memory_data_valid) ? memory_data_out : memory_data_in; 
    //assign Icache_data_in = Icache_MissDetected ? memory_data_out :16'b0;
    assign Icache_data_in = (Icache_MissDetected & Icache_memory_data_valid) ? memory_data_out : 16'h4000;

    assign Icache_word_select = Icache_MissDetected ? Icache_fsm_word_select: Icache_word_sel;
    // assign Icache_word_select = Icache_fsm_word_select;
    assign Dcache_word_select = Dcache_MissDetected ? Dcache_fsm_word_select : Dcache_word_sel;
    // assign Dcache_word_select = Dcache_fsm_word_select;
    //memory data valid
    assign Icache_memory_data_valid = (Icache_MissDetected) & memory_data_valid;
    assign Dcache_memory_data_valid = (Dcache_MissDetected) & memory_data_valid;


    //data_out for cache
    assign Icache_instr_out = (Icache_fsm_busy) ? 16'h4000 :
                              (Dcache_fsm_busy) ? 16'h4000 :
                              Instr_VaildWay0 ? Icache_instr_out0: Icache_instr_out1;
    //assign Icache_instr_out = (Icache_stall & ~Icache_Hit)? 16'h4000 : Icache_instr_out0;
    //assign Icache_instr_out = (Icache_Hit) ? Icache_instr_out0 :
                              //(Icache_MissDetected) ? Icache_instr_out0 : 16'h4000;

                          
                    
    assign Dcache_data_out = (Dcache_fsm_busy) ? 14'b0000 :
                             Data_VaildWay0 ? Dcache_data_out0 : Dcache_data_out1;
    
    //stall
    assign Icache_stall = (Icache_read | Icache_write) & Icache_fsm_busy;
    assign Dcache_stall = (Dcache_read | Dcache_write) & Dcache_fsm_busy;

    //write enable
    assign Instr_write_way0 = (Instr_metadata0_out[0] == 0) ? 1'b1 : (Instr_metadata0_out[1]);
    assign Instr_write_way1 = (Instr_metadata1_out[0] == 0 & ~Instr_write_way0) ? 1'b1 : (Instr_metadata1_out[1]);
    assign Data_write_way0 = (Data_metadata0_out[0] == 0) ? 1'b1 : (Data_metadata0_out[1]);
    assign Data_write_way1 = (Data_metadata1_out[0] == 0 & ~Data_write_way0) ? 1'b1 : (Data_metadata1_out[1]);

endmodule


