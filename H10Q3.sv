module test_comparator;
  logic [3:0] A, B, G, L;
  comparator dut(.a(A), .b(B), .gout(G), .lout(L));
    initial begin
      $monitor("%6d: A=%b, B=%b, G=%b, L=%b", $time, A, B, G, L);
        A = 0;
        repeat (16) begin
            B = 0;
            repeat (15) begin
            #1  if (A > B) assert(G > L);
       		if (B > A) assert(L > G);
          	if (A == B) assert(G == L); 
              B = B + 4'b1;
            end
           #1 if (A > B) assert(G > L);
           if (B > A) assert(L > G);
           if (A == B) assert(G == L); 
           if (A != 4'd15) A = A + 4'b1;
        end
        $finish;
    end
endmodule: test_comparator

module comparator (input [3:0] g, l, a, b, output [3:0] gout, lout);
  fullcomp fc0(.g(1'b0), .l(1'b0), .a(a[3]), .b(b[3]), .gout(gout[3]), .lout(lout[3]));
  fullcomp fc1(.g(gout[3]), .l(lout[3]), .a(a[2]), .b(b[2]), .gout(gout[2]), .lout(lout[2]));
  fullcomp fc2(.g(gout[2]), .l(lout[2]), .a(a[1]), .b(b[1]), .gout(gout[1]), .lout(lout[1]));
  fullcomp fc3(.g(gout[1]), .l(lout[1]), .a(a[0]), .b(b[0]), .gout(gout[0]), .lout(lout[0]));    
endmodule: comparator
                 
module fullcomp(input g, l, a, b, output gout, lout);
    assign gout = g | ~l & a & ~b;          
    assign lout = l | ~g & ~a & b;		
endmodule: fullcomp