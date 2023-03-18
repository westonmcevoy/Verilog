module testbench #(parameter N=4);
    logic ck;
    logic [1:0] cmd;
    logic [N-1:0] P, Q;

    rotate #(.N(N)) dut(.clock(ck), .cmd(cmd), .p(P), .q(Q));

    always #10 ck = ~ck;

    initial begin
        $monitor("%6d: ck=%b, cmd=%b, P=%b, Q=%b", $time, ck, cmd, P, Q);
        ck = 'b0;
        cmd = 'b1;          // load 1 in Q
        P = 'b1;
        #20 cmd = 'b10;     // rotate right for N cycles
        #(20*N) cmd = 'b11; // rotate left  for N cycles
        #(20*N) assert(Q == 'b1); // we're back to square 1
        #1 $finish;
    end
endmodule: testbench

module rotate #(parameter N=4) (input clock, input [N-1:0] p, input [1:0] cmd, output logic [N-1:0] q);
always_ff @(posedge clock) begin
    case(cmd)
        'b00: ;
        'b01: q <= p;
        'b10: q <= {q[0], q[N-1:1]};
        'b11: q <= {q[N-2:0], q[N-1]};
        default: q <='bx;
    endcase
end
endmodule: rotate
