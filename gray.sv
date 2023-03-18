module test_gray #(parameter N = 4);
    logic C, Rn;
    logic [N-1:0] G;
    
    gray #(.N(N)) dut(.clock(C), .reset_n(Rn), .g(G));

    always #10 C = ~C;

    always #20 assert(G ^ {1'b0,G[N-1:1]} == dut.q);

    initial begin
        if (N < 9)
          $monitor("%6d: Rn=%b, G=%b", $time, Rn, G);
        C = 'b0;
        Rn = 'b0;
        #5 Rn = 'b1;
        #(20*2**N) $finish;
    end

endmodule: test_gray

module gray #(parameter N = 4) (input clock, reset_n, output logic [N-1:0] g);
  logic [N-1:0] q;
  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) begin
      q <= 'b0;
    end else begin
      q <= q + 'b1;
    end
  end
  assign g = q ^ {1'b0,q[N-1:1]};
endmodule: gray





// module gray #(parameter N = 4)
//     (input clock, reset_n, output logic [N-1:0] g);

//     logic [N-1:0] q;

//     always_ff @(posedge clock, negedge reset_n)
//       if (~reset_n) q <= 'b0;
//       else          q <= q + 'b1;

//     assign g = q ^ {1'b0,q[N-1:1]};

// endmodule: gray

