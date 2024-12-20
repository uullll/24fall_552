module CLA4 (
    input [3:0]a,
    input [3:0]b,
    input cin,
    output [3:0]sum,
    output cout,
    output ovfl,
    output tg,
    output tp
    );

    wire [4:0]c;
    wire [3:0]g;
    wire [3:0]p;

    // p & g gen
    assign g = a & b;
    

    assign p = a | b;
    

    assign tp = &p;
    assign tg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // carry gen
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign cout = c[4];
        
    assign sum=a+b;

    assign ovfl = (b[3] ~^ a[3]) & (sum[3] != a[3]);

endmodule
