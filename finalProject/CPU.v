/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module CPU(clock, reset, write1, write2, outReg3, outReg4);
output [31:0]outReg3,outReg4;
	input [31:0]write1, write2;
    input clock, reset;
	 wire twof_clk, fourf_clk;
	 wire clk_PC, clk_imem, clk_dmem, clk_regfile;
	 my_dffe 
	 two_divider(clock,reset, twof_clk),
	 four_divider(twof_clk, reset, fourf_clk);
	 assign clk_imem = clock;
	 assign clk_dmem = ~twof_clk;
	 assign clk_PC = ~fourf_clk;
	 assign clk_regfile = ~fourf_clk;
	 //clock_freq clock_div(clock, reset, en, clk_imem, clk_dmem, clk_regfile, clk_PC);
    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem2 my_imem(
        .address    (address_imem),            // address of data
        .clock      (clk_imem),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem2 my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (clk_dmem),                  // may need to invert the clock
        .data	    (data),    // data you want to write
        .wren	    (wren),      // write enable
        .q          (q_dmem)    // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
      clk_regfile, ctrl_writeEnable, reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB, write1, write2, outReg3, outReg4);

    /** PROCESSOR **/
    myprocessor my_processor(
        // Control signals
		  clk_PC,                          // I: The master clock
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
	  //Rwe, ALUinB, DMwe, Rwd, JP, BR, JAL, JR, SETX, BEX, BLT, ctrl_ALUopcode,Addi,
	 //problem when testing
	 //imme_sx, data_result, overflow, isoverflow);

endmodule
