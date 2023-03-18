module testbench;
    logic C, D, Q, Qn;

    ff dut(.c(C), .d(D), .q(Q), .qn(Qn));

    always #10 C = ~C;

    initial begin
        $monitor("%6d: C=%b, D=%b, Q=%b, Qn=%b", $time, C, D, Q, Qn);
        C = 'b0;
        D = 'b0;
        #20 D = 'b1;
        #4  D = 'b0;
        #2  D = 'b1;
        #9  D = 'b0;
        #25 $finish;
    end
endmodule: testbench

module ff(input c, d, output q, qn);
  nand #(1) (e, f, d);
  nand #(1) (f, e, c, g);
  nand #(1) (g, h, c);
  nand #(1) (h, g, e);
  nand #(1) (qn, f, q);
  nand #(1) (q, g, qn);
endmodule: ff
