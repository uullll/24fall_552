module RED (
    input [15:0]rs,
    input [15:0]rt,
    output [15:0]rd,
    output ovfl
);
    wire c1,c2,c3,c4,c5,c6,c7,c8;
    wire d1,d2,d3,d4,d5,d6,d7,d8;
    wire e1,e2,e3,e4,e5,e6,e7,e8,e9;
    wire [8:0]sum1, sum2;
    wire [8:0]final_sum;
    full_adder fa0 (rs[0] ,rt[0] ,1'b0,sum1[0],c1);
    full_adder fa1 (rs[1] ,rt[1] ,c1 ,sum1[1] ,c2);
    full_adder fa2 (rs[2] ,rt[2] ,c2 ,sum1[2] ,c3);
    full_adder fa3 (rs[3] ,rt[3] ,c3 ,sum1[3] ,c4);
    full_adder fa4 (rs[4] ,rt[4] ,c4 ,sum1[4] ,c5);
    full_adder fa5 (rs[5] ,rt[5] ,c5 ,sum1[5] ,c6);
    full_adder fa6 (rs[6] ,rt[6] ,c6 ,sum1[6] ,c7);
    full_adder fa7 (rs[7] ,rt[7] ,c7 ,sum1[7] ,c8);
    assign sum1[8] = c8 ^ rs[8] ^ rt[8];


    full_adder fb0 (rs[8] ,rt[8] ,1'b0,sum2[0],d1);
    full_adder fb1 (rs[9] ,rt[9] ,d1 ,sum2[1] ,d2);
    full_adder fb2 (rs[10] ,rt[10] ,d2 ,sum2[2] ,d3);
    full_adder fb3 (rs[11] ,rt[11] ,d3 ,sum2[3] ,d4);
    full_adder fb4 (rs[12] ,rt[12] ,d4 ,sum2[4] ,d5);
    full_adder fb5 (rs[13] ,rt[13] ,d5 ,sum2[5] ,d6);
    full_adder fb6 (rs[14] ,rt[14] ,d6 ,sum2[6] ,d7);
    full_adder fb7 (rs[15] ,rt[15] ,d7 ,sum2[7] ,d8);
    assign sum2[8] = d8 ^ rs[15] ^ rt[15];
    

    full_adder fc0 (sum1[0] ,sum2[0] ,1'b0  ,final_sum[0] ,e1);
    full_adder fc1 (sum1[1] ,sum2[1] ,e1 ,final_sum[1] ,e2);
    full_adder fc2 (sum1[2] ,sum2[2] ,e2 ,final_sum[2] ,e3);
    full_adder fc3 (sum1[3] ,sum2[3] ,e3 ,final_sum[3] ,e4);
    full_adder fc4 (sum1[4] ,sum2[4] ,e4 ,final_sum[4] ,e5);
    full_adder fc5 (sum1[5] ,sum2[5] ,e5 ,final_sum[5] ,e6);
    full_adder fc6 (sum1[6] ,sum2[6] ,e6 ,final_sum[6] ,e7);
    full_adder fc7 (sum1[7] ,sum2[7] ,e7 ,final_sum[7] ,e8);
    
    full_adder fc8 (sum1[8] ,sum2[8] ,e8 ,final_sum[8] ,e9);
    assign ovfl = e9;
    assign rd = {{7{e9}}, final_sum[8:0]};
endmodule