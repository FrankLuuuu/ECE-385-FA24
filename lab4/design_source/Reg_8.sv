// done
module reg_8 (
	input  logic 		  Clk, 
	input  logic 		  Reset, 
	input  logic 		  Shift_In, 
	input  logic 		  Load, 
	input  logic 		  Shift,
	input  logic [7:0]    D,

	output logic 		  Shift_Out,
	output logic [7:0] 	  Data_Out
);

	always_ff @(posedge Clk)
	begin

		if (Reset)
		begin
            Data_Out <= 8'h0;
        end
		else if (Load) 
		begin
			Data_Out = D;
		end
		else if (Shift)
		begin
			Data_Out = { Shift_In, Data_Out[7:1] };
		end

	end

	assign Shift_Out = Data_Out[0];

endmodule
