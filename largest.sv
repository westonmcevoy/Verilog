module test_largest #(parameter N = 10, SAMPLES = 50);
    logic C, Rn;
    logic [N-1:0] D, L;

    largest #(.N(N)) dut(.clock(C), .reset_n(Rn), .data(D), .maximum(L));

    initial begin
        C = 'b0;
        Rn = 'b0;
        #5 Rn = 'b1;
    end

    always #10 C = ~C;

    initial begin
        $monitor("%6d: Rn=%b, D=%d, L=%d", $time, Rn, D, L);
        repeat (SAMPLES) begin
            D = $urandom;
            #20 assert(L >= D);
        end
        $finish;
    end

endmodule: test_largest


module largest #(parameter N = 10) (input [N-1:0] data, input clock, reset_n, output logic [N-1:0] maximum);
always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) begin
        maximum <= 'b0;
    end else begin
        if(data > maximum) begin
            maximum <= data;
        end
    end
end
endmodule: largest