module test_tally #(parameter N=6, SAMPLES = 100);
  logic [N-1:0] I, I2;
  logic [N:0] O, O2;

  tally #(.N(N)) dut(.out(O), .in(I));
  tally2 #(.N(N)) dut2(.out(O2), .in(I2));
  
    initial begin
      if(N > 32) $display("Warning: $urandom only returns 32 bits");
      repeat (SAMPLES) begin: loop
        I = $urandom;
        I2 = I;
        if(N<=6) begin
        	#1 $display("%6d: IN: %b and OUT: %b", $time, I, O);
          	#1 $display("%6d: IN2: %b and OUT2: %b", $time, I2, O2);
        end
        assert(O == O2);
       end: loop
    end
endmodule: test_tally

module tally #(parameter N=6) (input [N-1:0] in, output logic [N:0] out);
always_comb begin  	
      	assign out = 'b1;
    	for (int i = 0; i < N; i++) begin: stage
          if(in[i]) assign out = out << 1;
    	end: stage
end
endmodule: tally

module tally2 #(parameter N=6) (input [N-1:0] in, output logic [N:0] out);
  generate
    for(genvar i=0; i<N; i++) begin: col
      for(genvar j=0; j<i+2; j++) begin: row
        logic outw;
        if(i==0) begin
          if(j==0) begin 
            assign outw = ~(in[i]);
          end else begin
            assign outw = in[i];
          end
        end else begin
     		if(j==0) begin 
              assign outw = ~in[i] & col[i-1].row[j].outw;
        	end else begin
    	  		if(j==i+1) begin 
                  assign outw = in[i] & col[i-1].row[j-1].outw;
          		end else begin
          			assign outw = in[i] ? col[i-1].row[j-1].outw : col[i-1].row[j].outw;
          		end
        	end
        end
        
        if(i==N-1) begin
          assign out[j] = outw;
        end    
        
      end: row
    end: col
  endgenerate
endmodule: tally2