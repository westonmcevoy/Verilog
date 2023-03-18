module test_integer;
    logic [15:0] X;
    logic        A;

    is_integer dut(.X(X), .answer(A));

    function logic check_int(logic [15:0] b16);
        if (b16[14:0] == 'b0) return 'b1;
        if (b16[14:10] < 'd15) return 0;
        if (b16[14:10] > 'd24) return 1;
        for (int i = 0; i <= 'd24 - b16[14:10]; i++)
          if (b16[i] != 'b0) return 0;
        return 1;
    endfunction: check_int

    initial begin
        //$monitor("%6d: X=%b, A=%b", $time, X, A);
        for (int i = 0; i < 2**16; i++) begin
            X = i;
            #1 assert(A == check_int(X)) 
              else $display("%6d: X=%b, A=%b",$time, X, A);
        end
        $finish;
    end

endmodule: test_integer

module is_integer (input [15:0] X, output logic answer);
    logic [4:0] Y;
    assign Y = X[14:10];
    always_comb begin
        if (Y < 'd15) begin
            answer = 1'b0;
        end
        else if (Y > 'd24) begin
            answer = 1'b1;
        end else begin
            for (int i = 0; i < 'd10; i++) begin: stage
                if (X[i] == 1'b1)
                    if ((Y-'d15) >= ('d10-i)) begin
                        answer = 1'b1;
                    end else begin
                        answer = 1'b0;
                    end
            end: stage
        end
    end
    
endmodule: is_integer

