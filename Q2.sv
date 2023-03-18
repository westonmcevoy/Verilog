module test_div #(parameter N=4, SAMPLES = 100);
  logic [N-1:0] X;
  logic D;

  div4 #(.N( N)) dut(.d(D), .x(X));

    initial begin
      if(N > 32) $display("Warning: $urandom only returns 32 bits");
      repeat (SAMPLES) begin: loop
        X = $urandom;
        #1 $display("%6d: X: %b or %d yielded d: %b", $time, X, X, D);
        assert(D == (X[1:0] == 2'b0));
       end: loop
    end
endmodule: test_div

module div4 #(parameter N = 4) (input[N-1:0] x, output d);
    assign d = ~|x[1:0];
endmodule: div4


