module testbench #(parameter N = 4, WORDS = 4);
    logic [N-1:0] OUT;
    logic         C, Rn;

    system #(.N(N), .WORDS(WORDS)) dut(.clock(C), .reset_n(Rn), .data_out(OUT));

    always #10 C = ~C;

    initial begin
        $monitor("%6d: C=%b, Rn=%b, state=%b, req=%b, ack=%b, write=%b, full=%b, OUT=%b", 
                 $time, C, Rn, dut.a.state, dut.req, dut.ack, dut.write, dut.full, OUT);
        C = 'b0;
        Rn = 'b0;
        #5 Rn = 'b1;
        #1000 $finish;
    end
endmodule: testbench

module system #(parameter N = 4, WORDS = 4)
    (input clock, reset_n, output logic [N-1:0] data_out);

    logic [N-1:0] data_in;
    logic [N-1:0] data [0:1];
    logic [1:0]   req, ack, write;
    logic         push, pop, full, empty;

    arbiter a(.clock(clock), .reset_n(reset_n), .r(req), .g(ack));

    FIFO #(.N(N), .WORDS(WORDS)) f(.clock(clock), .reset_n(reset_n),
                                   .push(push), .pop(pop), .data_in(data_in),
                                   .data_out(data_out), .full(full),
                                   .empty(empty));

    generate
        for (genvar i = 0; i < 2; i++)
          client #(.N(N), .ID(i)) c(.clock(clock), .reset_n(reset_n), 
                                    .ack(ack[i]), .full(full), .req(req[i]),
                                    .data(data[i]), .write(write[i]));
    endgenerate

    assign push = |write;
    assign pop = write == 'b0 && ~empty;
    assign data_in = data[write[1]];
            
endmodule: system

module client #(parameter N = 4, ID = 0)
    (input clock, reset_n, ack, full,
     output logic req, write, output logic [N-1:0] data);

    assign write = ack & ~full;

    always_ff @(posedge clock, negedge reset_n) begin
        if (~reset_n) begin
            data[N-1] <= ID;
            data[N-2:0] <= $urandom;
            req <= 'b0;
        end else begin
            req <= $urandom;
            if (write) // prepare new data for next write
              data[N-2:0] <= $urandom;
        end
    end
endmodule: client

module FIFO #(parameter N = 4, WORDS = 16)
    (input clock, reset_n, push, pop, input [N-1:0] data_in,
     output [N-1:0] data_out, output logic full, empty);

    logic [N-1:0]   mem [0:WORDS-1];
    logic [$clog2(WORDS)-1:0] head, tail;

    always_ff @ (posedge clock, negedge reset_n) begin
        if (~reset_n) begin
            head = 'b0;
            tail = 'b0;
            empty = 'b1;
        end else begin
            if (push & ~full) begin
                mem[head] <= data_in;
                head <= head + 'b1;
                empty <= 0;
            end 
            else if (pop & ~empty) begin
                tail <= tail + 1;
                if (tail + 1 == head)
                  empty <= 1;
            end
        end
    end

    assign data_out = mem[tail];
    assign full = (tail == head) & ~empty;

endmodule: FIFO

typedef enum logic [1:0] {IDL0, ACK0, ACK1, IDL1} state_e;

module arbiter(input clock, reset_n, input [1:0] r, output logic [1:0] g);
    // your code here
    state_e state;
    always_ff @(posedge clock, negedge reset_n) begin
        if(~reset_n) begin
            state <= IDL0;
        end else begin
            case(state)
                IDL0: 
                    case(r)
                        'b00: state <= IDL0;
                        'b01: state <= ACK0;
                        'b10: state <= ACK1;
                        'b11: state <= ACK0;
                        default: state <= IDL0;
                    endcase
                ACK0:
                    case(r)
                        'b00: state <= IDL1;
                        'b01: state <= ACK0;
                        'b10: state <= ACK1;
                        'b11: state <= ACK1;
                        default: state <= ACK0;
                    endcase
                ACK1: 
                    case(r)
                        'b00: state <= IDL0;
                        'b01: state <= ACK0;
                        'b10: state <= ACK1;
                        'b11: state <= ACK0;
                        default: state <= ACK1;
                    endcase
                IDL1: 
                    case(r)
                        'b00: state <= IDL1;
                        'b01: state <= ACK0;
                        'b10: state <= ACK1;
                        'b11: state <= ACK1;
                        default: state <= IDL1;
                    endcase
                default: state <= IDL0;
            endcase
        g <= state;
        end
    end
endmodule: arbiter
