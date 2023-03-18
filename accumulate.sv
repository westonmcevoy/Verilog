module test_accumulate #(parameter N = 8, M = 9);
    logic C, Rn, A;
    logic [N-1:0] Di, Do;
    accumulate #(.N(N)) dut(.clock(C), .reset_n(Rn), .add(A),
                            .data_in(Di), .data_out(Do));
    always #10 C = ~C;

    initial begin
        $monitor("%6d: C=%b, Rn=%b, A=%b, Di=%d, Do=%d",
                 $time, C, Rn, A, Di, Do);
        C = 'b0;
        Rn = 'b0;
        A = 'b0;
        Di = 'd1;
        #5 Rn = 'b1;
        #15 A = 'b1;
        for (int i = 1; i < M; i++) begin
            # 20 assert(Do == i*i);
            Di = Di + 'd2;
        end
        #20 assert(Do == M*M);
        A = 'b0;
        #20 $finish;
    end
endmodule: test_accumulate

// My module: Note reset case uses tilda, check  commas, use the nonblocking declarations

module accumulate #(parameter N = 8) 
(input clock, reset_n, add, input [N-1:0] data_in, 
 output logic [N-1:0] data_out);
  always_ff @ (posedge clock, negedge reset_n)
    if(~reset_n)
      data_out <= 'b0;
    else if (add)
      data_out <= data_out + data_in;
endmodule: accumulate

// Correct module:

// module accumulate #(parameter N = 8)
//     (input clock, reset_n, add, input [N-1:0] data_in, 
//      output logic [N-1:0] data_out);

//     always_ff @ (posedge clock, negedge reset_n)
//       if (~reset_n)
//         data_out <= 'b0;
//       else if (add)
//         data_out <= data_out + data_in;

// endmodule: accumulate
