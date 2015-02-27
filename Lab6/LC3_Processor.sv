module LC3_Processor(input logic   Clk,     	// Internal
                                Reset,   		// Push button 0
                                Run,			// Push button 1
                                Continue,		// Push button 2
                  input  [15:0] S,     		// input data from switches
						output logic  CE, UB, LB, OE, WE,
                  output [11:0] LED,
                  output [6:0]  HEX0,
										  HEX1,
										  HEX2,
										  HEX3,
						output [19:0] ADDR,
						inout [15:0]  Data);
						

	logic Reset_h, Run_h, Continue_h; 
	always_comb
	begin
		Reset_h = ~Reset;
		Continue_h = ~Continue;
		Run_h = ~Run;
	end
	
	logic [15:0] IR, MAR, MDR, PC_out, PC_new;
	logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC;
	
	reg16			regMAR(
						.Clk,
						.Load(LD_MAR),
						.Data_In(PC),
						.Data_Out(MAR),
						.Reset(Reset_h));
	reg16			regMDR(
						.Clk,
						.Load(LD_MDR),
						.Data_In(Data),
						.Data_Out(MDR),
						.Reset(Reset_h));
	reg16			regIR(
						.Clk,
						.Load(LD_IR),
						.Data_In(MDR),
						.Reset(Reset_h),
						.Data_Out(IR));
	reg16			regPC(
						.Clk,
						.Load(LD_PC),
						.Data_In(PC_new),
						.Data_Out(PC_out),
						.Reset(Reset_h));
	
	ISDU			Ctrl(
						.Clk,
						.Reset(Reset_h),
						.Run(Run_h),
						.Continue(Continue_h),
						.ContinueIR(Continue_h),
						.Mem_CE(CE),
						.Mem_UB(UB),
						.Mem_LB(LB),
						.Mem_OE(OE),
						.Mem_WE(WE));
							
	IncPC 		NextPC(.PC(PC_out),
							.PC_out(PC_new));
							
	test_memory MEM(
						.Clk,
						.Reset(Reset_h),
						.I_O(Data)						
						);
							
	HexDriver HexAL (
						.In0(MAR[3:0]),
                  .Out0(HEX0));
	HexDriver HexAU (
                  .In0(MAR[7:4]),
                  .Out0(HEX1));
	HexDriver HexBL (
                  .In0(MAR[11:8]),
                  .Out0(HEX2));
	HexDriver HexBU (
                  .In0(MAR[15:12]),
                  .Out0(HEX3));
						
endmodule 