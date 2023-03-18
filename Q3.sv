module test_subnormal;
  logic [15:0] X;
  logic ANSWER;

  subnormal dut(.x(X), .a(ANSWER));

    initial begin
      X = 0;
      repeat (2**16) begin
        #1 assert(ANSWER == ((X[9:0] != 10'b0) & (X[14:10] == 5'b0)));
        //$display("%6d: X: %b answer: %b", $time, X, ANSWER);
        X = X + 16'b1;
      end
    end
endmodule: test_subnormal

module subnormal(input [15:0] x, output a);
  assign a = ~|x[14:10] & |x[9:0];   
endmodule: subnormal
