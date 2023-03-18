module testbench;
    logic [1:0] R, G;
    logic       C;

    arbiter dut(.clock(C), .r(R), .g(G));

    always #10 C = ~C;

    always #20 assert(G !== 'b11);

    initial begin
        $monitor("%6d: C=%b, R=%b, G=%b", $time, C, R, G);
        C = 'b0;
        R = 'b0;
        #20 R = 'b10;
        #20 R = 'b01;
        #20 R = 'b11;
        #20 R = 'b00;
        #20 R = 'b11;
        #20 R = 'b00;
        #20 $finish;
    end
endmodule: testbench

module arbiter(input clock, input [1:0] r, output logic [1:0] g);
  always_ff @(posedge clock) begin
    g[0] <= ~(r[0] & ~g[0]) & r[1];
    g[1] <= ~(r[1] & g[0]) & r[0];
  end
endmodule: arbiter