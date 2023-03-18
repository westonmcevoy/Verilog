module test_comparator #(parameter N=4, SAMPLES = 100);
  logic [N-1:0] A, B, G, L;

  comparator #(.N(N)) dut(.a(A), .b(B), .gout(G), .lout(L));

    initial begin
      if(N > 32) $display("Warning: $urandom only returns 32 bits");
      repeat (SAMPLES) begin: loop
        A = $urandom;
        B = $urandom;
        #1 if (A>B) assert(G>L);
        else if (A<B) assert(G<L) ;
        else assert(G==L);
        $display("%6d: A: %b and B: %b yielded G: %b and L: %b", $time, A, B, G, L);
       end: loop
    end
endmodule: test_comparator

module comparator #(parameter N=4) (input [N-1:0] a, b, output [N-1:0] gout, lout);
  
  generate
    for (genvar i=0; i<N; i++) begin: stage
      logic gi, li, go, lo;
      if (i==0) assign gi = 1'b0;
      else	    assign gi = stage[i-1].go;
      if (i==0) assign li = 1'b0;		
      else 		assign li = stage[i-1].lo;
      fullcomparator fc(.gin(gi), .lin(li), .a(a[N-i-1]), .b(b[N-i-1]), .gout(go), .lout(lo));
      assign gout[N-i-1] = go;
      assign lout[N-i-1] = lo;
    end: stage
  endgenerate
  
endmodule: comparator

module fullcomparator(input gin, lin, a, b, output gout, lout);
    assign gout = gin | ~lin & a & ~b; 
    assign lout = lin | ~gin & ~a & b; 
endmodule: fullcomparator
