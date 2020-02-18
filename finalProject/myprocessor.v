/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module myprocessor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB);                   // I: Data from port B of regfile
	 
	 //control signal
	// Rwe, ALUinB, DMwe, Rwd, JP, BR, JAL, JR, SETX, BEX, BLT, ctrl_ALUopcode, Addi,
	 //problem when testing
	 //imme_sx, data_result, overflow, isoverflow);
    // Control signals
	 wire isoverflow;
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output[31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

	 //wire of four types
	 wire[4:0] opcode; 
	 assign opcode = q_imem[31:27];
	 wire[4:0] rd;
	 assign rd = q_imem[26:22];
	 wire[4:0] rs;
	 assign rs = q_imem[21:17];
	 wire[4:0] rt;
	 assign rt = q_imem[16:12];
	 wire[16:0] imme;
	 assign imme = q_imem[16:0];
	 wire[31:0] imme_sx;
	 assign imme_sx = q_imem[16] ? ({{15{1'b1}}, imme}): ({15'b0, imme});
	 wire[26:0] target;
	 assign target = q_imem[26:0];
	 wire[4:0] ctrl_shiftamt;
	 assign ctrl_shiftamt = q_imem[11:7];
	 wire[4:0] ctrl_ALUopcode;
	 wire[4:0] ALUop;
	 assign ALUop = q_imem[6:2];
	 MUX5 mux16(ALUop, 5'b0, Addi, ctrl_ALUopcode);
	 
	 
	 //wire added
wire[31:0] insn;
wire clk_out, out_or1, out_or2,out_or3, out_and1, out_and2, out_and3, out_not, S0, S1;
wire[4:0] out_mux1, out_mux2, out_mux3, out_mux14;
wire[31:0] out_mux4, out_mux7, out_mux8, out_mux9, out_mux_4to1;
wire[11:0] out_mux5, out_mux6, out_mux10, out_mux11;
wire[31:0] data_operandA, data_operandA2, data_operandA3;
wire[31:0] data_operandB, data_operandB2, data_operandB3;
wire[4:0]  ctrl_ALUopcode2, ctrl_shiftamt2;
wire[4:0]  ctrl_ALUopcode3, ctrl_shiftamt3;
wire isNotEqual2, isLessThan2, overflow2;
wire isNotEqual, isLessThan;
wire overflow;
wire isNotEqual3, isLessThan3, overflow3;
wire[31:0] data_result2, data_result3;
//problem when testing
wire[31:0] data_result;
wire[11:0] PC_next;

wire[11:0] address_dmem;
wire[31:0] data;
assign data = data_readRegB;
wire wren = DMwe;
	 assign address_imem = dataQ;
	  wire Rwe, ALUinB, DMwe, Rwd, JP, BR, JAL, JR, SETX, BEX, BLT, Addi;
	   
    /* YOUR CODE STARTS HERE */

/*decoder and control*/
dec5to32
my_decoder(insn, opcode);
control
my_control(insn, Rwe, ALUinB, DMwe, Rwd, JP, BR, JAL, JR, SETX, BEX, BLT, Addi);

assign ctrl_writeEnable = Rwe;




/*ALU*/
	 MUX32
	 mux4(data_readRegB, imme_sx, ALUinB, out_mux4);
	 assign data_operandA = data_readRegA;
	 assign data_operandB = out_mux4;
	
	 alu
	 alu1(data_operandA, data_operandB, ctrl_ALUopcode,
			ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
	wire n0, n1, n2, n3, n4, of_out1, of_out2, of_or;
	not
	not_overflow1(n0, ctrl_ALUopcode[0]),
	not_overflow2(n1, ctrl_ALUopcode[1]),
	not_overflow3(n2, ctrl_ALUopcode[2]),
	not_overflow4(n3, ctrl_ALUopcode[3]),
	not_overflow5(n4, ctrl_ALUopcode[4]);
	and
	and_oveflow(of_out1, n0, n1, n2, n3, n4),
	and_overflow2(of_out2, ctrl_ALUopcode[0], n1, n2, n3, n4);
	or
	or_overflow(of_or, of_out1, of_out2);
	and
	and_overflow3(isoverflow, overflow, of_or);
	//assign isoverflow = (((~ctrl_ALUopcode[0]) & (~ctrl_ALUopcode[1] ) & (~ctrl_ALUopcode[2]) & (~ctrl_ALUopcode[3]) & (~ctrl_ALUopcode[4])) | ((~ctrl_ALUopcode[1]) & ctrl_ALUopcode[0] & (~ctrl_ALUopcode[2]) & (~ctrl_ALUopcode[3]) & (~ctrl_ALUopcode[4]))) & overflow;
	or or1(out_or1, SETX, isoverflow);
assign address_dmem = data_result[11:0];
/*register file*/
	or or3(out_or3, JR, BLT);
MUX5 
mux1(rd, 5'b11110, out_or1, out_mux1),
mux2(out_mux1, 5'b11111, JAL, ctrl_writeReg),
mux3(rs, 5'b11110, BEX, out_mux3),
mux14(rt, rd, DMwe, out_mux14),
mux13(out_mux3, rd, out_or3, ctrl_readRegA),
mux15(out_mux14, rs, BLT, ctrl_readRegB);


	assign data_operandA2 = {20'b1, PC_next};
	assign data_operandB2 = imme_sx;
	assign ctrl_ALUopcode2 = 5'b0; 
	assign ctrl_shiftamt2 = 5'b0;
	alu
	alu2(data_operandA2, data_operandB2, ctrl_ALUopcode2,
			ctrl_shiftamt2, data_result2, isNotEqual2, isLessThan2, overflow2);
	 
	 and
	 and1(out_and1, BR, isNotEqual),
	 and2(out_and2, BLT, isLessThan);
	 or
	 or2(out_or2, out_and1, out_and2);
	 MUX12
	 mux5(PC_next, data_result2, out_or2, out_mux5),
	 mux6(out_mux5, target, JP, out_mux6);
	
	 /*data memory*/
	
	MUX32
	mux7(data_result, q_dmem, Rwd, out_mux7),
	mux8( out_mux7, PC_next, JAL, out_mux8),
	mux9(out_mux8, target, SETX, out_mux9);
	assign S0 = ctrl_ALUopcode[0];
	assign S1 = opcode[0];
	mux4to1
	mux_4to1(32'b1, 32'b10, 32'b11, 32'b0, S0, S1, out_mux_4to1);
MUX32
mux12(out_mux9, out_mux_4to1, isoverflow, data_writeReg);	
	
	/*PC*/
	or or4(out_not, data_result[31], data_result[30], data_result[29], data_result[28], data_result[27], data_result[26], data_result[25], data_result[24], data_result[23], data_result[22], data_result[21],
	       data_result[20], data_result[19], data_result[18], data_result[17], data_result[16], data_result[15], data_result[14], data_result[13], data_result[12], data_result[11],
	       data_result[10], data_result[9], data_result[8], data_result[7], data_result[6], data_result[5], data_result[4], data_result[3], data_result[2], data_result[1],
	       data_result[0]);
	and    
	and3(out_and3, BEX, out_not);
	MUX12
	mux10(out_mux6, target, out_and3, out_mux10),
	mux11(out_mux10, data_readRegA, JR, out_mux11);
	wire en, rst;
	wire[11:0] dataQ;
	assign en = 1'b1;
	assign rst = reset;
	 PC
	 my_PC(dataQ, out_mux11, clock, en, rst); 
	assign data_operandA3 = 32'b1;
	assign data_operandB3 = {20'b0, dataQ};
	assign ctrl_ALUopcode3 = 5'b0; 
	assign ctrl_shiftamt3 = 5'b0;
	 alu
	 alu3	(data_operandA3, data_operandB3, ctrl_ALUopcode3,
			ctrl_shiftamt3, data_result3, isNotEqual3, isLessThan3, overflow3);
assign PC_next = data_result3[11:0];
			endmodule
