module cache_fill_fsm(
    input clk,
    input rst, 

    input miss_detected, // active high when tag match logic detects a miss
    input [15:0] miss_address, // address that missed the cache
    output fsm_busy, // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
    output write_data_array, // write enable to cache data array to signal when filling with memory_data
    output write_tag_array, // write enable to cache tag array to signal when all words are filled in to data array

    output [7:0] word_sel, word_select,   // word selection
    output [15:0] memory_address, // address to read from memory
    input memory_data_valid // active high indicates valid data returning on memory bus
);
    wire [15:0] fill_address;

    wire current_state, next_state; // Wait = 1'b1, Idle = 1'b0
    wire fsm_busy_in, fsm_busy_out;
    wire chunks_left;

    wire [3:0] req_cout_in, req_cout_out, req_cout_sum;     // request counter signals
    wire [3:0] recv_cout_in, recv_cout_out, recv_cout_sum;  // receive counter signals

    
     // DFF instances for address components
    dff state_dff(
        .clk(clk),
        .rst(rst),
        .d(next_state),
        .q(current_state),
        .wen(1'b1)
    );
    
    dff fsm_busy_dff(
        .clk(clk),
        .rst(rst),
        .d(fsm_busy_in),
        .q(fsm_busy_out),
        .wen(1'b1)
    );

    dff req_counter_dff[3:0] (
        .clk(clk),
        .rst(rst | (req_cout_out == 4'b1011)),//4'b1011
        .d(req_cout_in),
        .q(req_cout_out),
        .wen(next_state)
    );

    dff recv_counter_dff[3:0] (
        .clk(clk),
        .rst(rst | ~current_state),
        .d(recv_cout_in),
        .q(recv_cout_out),
        .wen(memory_data_valid)
    );

    CLA4 req_inc(
        .a(req_cout_out),
        .b(4'b1),
        .cin(1'b0),
        .sum(req_cout_sum),
        .cout(),
        .ovfl(),
        .tg(),
        .tp()
    );

    CLA4 recv_inc(
        .a(recv_cout_out),
        .b(4'b1),
        .cin(1'b0),
        .sum(recv_cout_in),
        .cout(),
        .ovfl(),
        .tg(),
        .tp()
    );

    one_hot_8 word_sel1(
        .offset(fill_address[3:1]),
        .word_select(word_sel)
    );
    
    localparam IDLE = 0;
    localparam WAIT = 1;
    assign next_state=(current_state==1'b0)?miss_detected:chunks_left;
    assign chunks_left = ~(req_cout_out ==4'b1011);//req_cout_out ==4'b1011 

    assign req_cout_in = (~current_state)? 1'b0 :
                         (miss_detected)? req_cout_sum : req_cout_out;

    

    assign write_data_array = current_state  && memory_data_valid;
    assign write_tag_array = current_state && (req_cout_out == 4'b1011);//req_cout_out == 4'b1011
    
    assign fill_address = rst ? 16'b0 : {miss_address[15:4], recv_cout_out[2:0], 1'b0};
    assign memory_address = rst ? 16'b0 : {miss_address[15:4], req_cout_out[2:0], 1'b0};
    assign word_select = miss_detected ? word_sel : 8'b0;

    assign fsm_busy_in = (~current_state)? miss_detected : chunks_left;
    assign fsm_busy = miss_detected | current_state;

endmodule 
