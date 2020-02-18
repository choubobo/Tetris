module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data, up, down, left, right, ADDR,ps2_key_pressed,ps2_out, write1, outReg3);
output reg[31:0] write1;
input[31:0] outReg3;
input ps2_key_pressed;
input [7:0]ps2_out;
input iRST_n;
input iVGA_CLK;
input up, down, left, right;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;  
reg[191:0] bg;  
reg[191:0] static;
reg[3:0] x, y;
reg[3:0] x1, y1, x2, y2, x3, y3, x4, y4;
reg over;
reg[31:0]score;
///////// ////                     
output reg [18:0] ADDR;
reg [23:0] bgr_data;
reg[23:0] count;
reg[23:0] count2;
reg[2:0] shape;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
reg[1:0] direction;
reg[7:0] ps2_out_helper;
reg[4:0] newScore;

//PS2_Interface ps2(iVGA_CLK, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, last_data_received);
 

initial begin
static = 192'b0;
score = 5'b00000;
x =4'b0110;
y = 4'b0001;
x1 = 4'b0101;
y1 = 4'b0001;
x2 = 4'b0110;
y2 = 4'b0001;;
x3 = 4'b0101;
y3 = 4'b0010;
x4 = 4'b0110;
y4 = 4'b0010;
count = 0;
count2 = 0;
over = 0;
shape = 3'b000;
direction = 0;
ps2_out_helper = 8'h0;
end

always@(posedge iVGA_CLK) begin
if(cBLANK_n == 1'b1 && count == 23'd100000) begin
count<=0;
end
if (cBLANK_n == 1'b1 && count2 == 23'd100) begin
count2<=0;
end
else begin
count <= count + 1;
count2 <= count2 + 1;
end
end


integer i;
integer j;
integer m, n;
integer right_sig, left_sig;


 
 always@(negedge iVGA_CLK) begin

if(cBLANK_n == 1'b1 && count == 23'd100000) begin
	
   y=y+1;
	y1=y1+1;y2=y2+1;y3=y3+1;y4=y4+1;
	over = 0;
if (static[(y1+1)*12+x1]==1 || static[(y2+1)*12+x2]==1 ||static[(y3+1)*12+x3] == 1||static[(y4+1)*12+x4] == 1||y1>14||y2>14||y3>14||y4>14) begin	
	static[y1*12+x1]=1'b1;
	static[y2*12+x2]=1'b1;
	static[y3*12+x3]=1'b1;
	static[y4*12+x4]=1'b1; 
	
		if (static[11:0] == 12'b111111111111) begin
			static[11:0] = 12'b0;
			score = outReg3;
			write1 = score;
		end
		if (static[23:12] == 12'b111111111111) begin
			static[23:0] = static[23:0] << 12;
			
			score = outReg3;
			write1 = score;
		end
		if (static[35:24] == 12'b111111111111) begin
			static[35:0] = static[35:0] << 12;
			
			score = outReg3;
				write1 = score;
		end
		if (static[47:36] == 12'b111111111111) begin
			static[47:0] = static[47:0] << 12;
				
			score = outReg3;
			write1 = score;
		end
		if (static[59:48] == 12'b111111111111) begin
			static[59:0] = static[59:0] << 12;
			
			score = outReg3;
				write1 = score;
		end
			if (static[71:60] == 12'b111111111111) begin
			static[71:0] = static[71:0] << 12;
			
			score = outReg3;
				write1 = score;
		end
		if (static[83:72] == 12'b111111111111) begin
			static[83:0] = static[83:0] << 12;
				
			score = outReg3;
			write1 = score;
		end
		if (static[95:84] == 12'b111111111111) begin
			static[95:0] = static[95:0] << 12;
				
			score = outReg3;
			write1 = score;
		end
		if (static[107:96] == 12'b111111111111) begin
			static[107:0] = static[107:0] << 12;
			
			score = outReg3;
				write1 = score;
		end
			if (static[119:108] == 12'b111111111111) begin
			static[119:0] = static[119:0] << 12;
			
			score = outReg3;
				write1 = score;
		end
		if (static[131:120] == 12'b111111111111) begin
			static[131:0] = static[131:0] << 12;
			
			score = outReg3;
				write1 = score;
		end
		if (static[143:132] == 12'b111111111111) begin
			static[143:0] = static[143:0] << 12;
				
			score = outReg3;
			write1 = score;
			
		end
		if (static[155:144] == 12'b111111111111) begin
			static[155:0] = static[155:0] << 12;
				
			score = outReg3;
			write1 = score;
		end
			if (static[167:156] == 12'b111111111111) begin
			static[167:0] = static[167:0] << 12;
				
			score = outReg3;
			write1 = score;
		end
		if (static[179:168] == 12'b111111111111) begin
			static[179:0] = static[179:0] << 12;
				
			score = outReg3;
			write1 = score;
		end
		if (static[191:180] == 12'b111111111111) begin
			static[191:0] = static[191:0] << 12;
				
			score = outReg3;
			write1 = score;
		end
	
	direction = 0;
	shape = ((shape * ps2_out)*17)%5;
	//shape=$urandom%4;
case(shape)
3'b000:begin
	x = 4'b0110;
	y = 4'b0001;
	x1 = 4'b0101;
	y1 = 4'b0001;
	x2 = 4'b0110;
	y2 = 4'b0001;;
	x3 = 4'b0101;
	y3 = 4'b0010;
	x4 = 4'b0110;
	y4 = 4'b0010;
end	
3'b001: begin
	x = 4'b0110;
	y = 4'b0001;
	x1 = 4'b0100;
  y1 = 4'b0001;
  x2 = 4'b0101;
  y2 = 4'b0001;
  x3 = 4'b0110;
  y3 = 4'b0001;
  x4 = 4'b0111;
  y4 = 4'b0001;
end
3'b010:begin
	x = 4'b0110;
	y = 4'b0001;
	x1 = 4'b0110;
  y1 = 4'b0001;
  x2 = 4'b0111;
  y2 = 4'b0001;
  x3 = 4'b0101;
  y3 = 4'b0010;
  x4 = 4'b0110;
  y4 = 4'b0010;
end
3'b011:begin
	x = 4'b0110;
	y = 4'b0001;
	x1 = 4'b0101;
  y1 = 4'b0001;
  x2 = 4'b0110;
  y2 = 4'b0001;
  x3 = 4'b0110;
  y3 = 4'b0010;
  x4 = 4'b0111;
  y4 = 4'b0010;
end
3'b100:begin
	x = 4'b0110;
	y = 4'b0001;
	x1 = 4'b0101;
  y1 = 4'b0001;
  x2 = 4'b0110;
  y2 = 4'b0001;
  x3 = 4'b0111;
  y3 = 4'b0001;
  x4 = 4'b0101;
  y4 = 4'b0010;
end
endcase //for case

end //for if


//	static[11:0] = 12'b0;
  end //for count
  
		if(ps2_out==8'hE06B) begin
if(x1>0 && x2>0 && x3>0 && x4>0 && static[y1*12+x1-1]!=1 && static[y2*12+x2-1]!=1 && static[y3*12+x3-1]!=1 && static[y4*12+x4-1]!=1) begin
  x=x-1;
  x1 = x1-1;x2=x2-1;x3=x3-1;x4=x4-1;
  end
  //ps2_out_helper = 8'h0; 
  end

  
//else 
else if(ps2_out==8'hE074) begin
if(x1<11 && x2<11 && x3<11 && x4<11 && static[y1*12+x1+1]!=1 && static[y2*12+x2+1]!=1 && static[y3*12+x3+1]!=1 && static[y4*12+x4+1]!=1) begin 
   x=x+1;
   x1 = x1+1;x2=x2+1;x3=x3+1;x4=x4+1;
  end
  //ps2_out_helper = 8'h0; 
  end
  
if(ps2_out==8'hE075) begin
case(shape)
3'b001: begin
	case(direction)
		0 :begin
			x1 = x;
			x2 = x;
			x4 = x;
			y1 = y - 2;
			y2 = y - 1;
			y4 = y + 1;
			direction = 1;
			end
		1 :begin
			x1 = x - 2;
			x2 = x - 1;
			x4 = x + 1;
			y1 = y;
			y2 = y;
			y4 = y;
			direction = 0;
			end
		endcase
end
3'b010 :begin //right long
	case(direction)
	0: begin
		x2 = x;
		x3 = x + 1;
		x4 = x + 1;
		y2 = y - 1;
		y3 = y + 1;
		y4 = y;
		direction = 1;
		end
	1: begin
		y2 = y;
		y3 = y + 1;
		y4 = y + 1;
		x2 = x + 1;
		x3 = x - 1;
		x4 = x;
		direction = 0;
		end
	endcase
end
3'b011:begin
	case(direction)
	0:begin
		x1 = x;
		x3 = x - 1;
		x4 = x - 1;
		y1 = y - 1;
		y3 = y;
		y4 = y + 1;
		direction = 1;
		end
	1:begin
		x1 = x - 1;
		x3 = x;
		x4 = x + 1;
		y1 = y;
		y3 = y + 1;
		y4 = y + 1;
		direction = 0;
		end
	endcase
end
3'b100:begin
	case(direction)
	0:begin
		x1 = x;
		x3 = x;
		x4 = x - 1;
		y1 = y - 1;
		y3 = y + 1;
		y4 = y + 1;
		direction = 1;
		end
	1:begin
		x1 = x + 1;
		x3 = x - 1;
		x4 = x - 1;
		y1 = y;
		y3 = y;
		y4 = y - 1;
		direction = 2;
		end
	2:begin
		x1 = x;
		x3 = x;
		x4 = x + 1;
		y1 = y + 1;
		y3 = y - 1;
		y4 = y - 1;
		direction = 0;
		end
	endcase
end
endcase
//ps2_out_helper = 8'h0; 

end
end //for always


//end//也可能加在这儿


//Disappear a row if filled full


////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));


////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
//integer x;
// x = ADDR / 480;
//integer y; 
//y = ADDR % 480;

assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	

//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	

//////
//////latch valid data at falling edge;
//output S_test;
//assign S_test= S;
integer row, col;
integer c,r;
always@(posedge iVGA_CLK) begin
	col = (ADDR%640)/30;
	row = ADDR/19200;
	c=ADDR%640;
   r=ADDR/640;
	if (col < 12) begin
	if ((col == x1 && row == y1) ||
		(col == x2 && row == y2) ||
		(col == x3 && row == y3) ||
		(col == x4 && row == y4) ||
		static[col+row*12] == 1) 
		bgr_data <= 24'h666666;
	else bgr_data <= 24'hababab;
   end
	
   else begin
	bgr_data <= 24'hFFFFFF;
	if(score==0)begin
   if(((509<c && c<630)&&((29<r&&r<60)||(179<r&&r<210)))||((59<r&&r<180)&&((509<c&&c<540)||(599<c&&c<630))))
   bgr_data <= 24'hDDDDDD;
 
   end
	
   else if(score==1)begin
   if((539<c&& c<570)&&(29<r&&r<210))
   bgr_data <= 24'hDDDDDD;
   end
 
 else if(score==2)begin
   if(((509<c&&c<630)&&((29<r&&r<60)||(89<r&&r<120)||(179<r&&r<210)))||((59<r&&r<90)&&(599<c&&c<630))||((509<c&&c<540)&&(119<r&&r<180)))
   bgr_data <= 24'hDDDDDD;
   end
	
 else if(score==3)begin
   if(((509<c&&c<630)&&((29<r&&r<60)||(89<r&&r<120)||(179<r&&r<210)))||((59<r&&r<90)&&(599<c&&c<630))||((509<c&&c<540)&&(119<r&&r<180)))
   bgr_data <= 24'hDDDDDD;
 end
 
 else if(score==4)begin
    if(((29<r&&r<120)&&(509<c&&c<540))||((29<r&&r<210)&&(599<c&&c<630))||((89<r&&r<120)&&(539<c&&c<600)))
    bgr_data <= 24'hDDDDDD;
 end
 
 else if(score==5)begin
   if(((509<c&&c<630)&&((29<r&&r<60)||(89<r&&r<120)||(179<r&&r<210)))||((59<r&&r<90)&&(509<c&&c<540))||((599<c&&c<630)&&(119<r&&r<180)))
   bgr_data <= 24'hDDDDDD;
 end
 
 else if(score==6)begin
     if(((509<c&&c<630)&&((29<r&&r<60)||(89<r&&r<120)||(179<r&&r<210)))||((59<r&&r<90)&&(509<c&&c<540))||(((599<c&&c<630)||(509<c&&c<540))&&(119<r&&r<180)))
   bgr_data <= 24'hDDDDDD;
 end
 
 else if(score==7)begin
    if(((509<c&&c<630)&&(29<r&&r<60))||((59<r&&r<210)&&(599<c&&c<630)))
  bgr_data <= 24'hDDDDDD;
 end
 
 else if(score==8)begin
   if(((509<c&&c<630)&&((29<r&&r<60)||(89<r&&r<120)||(179<r&&r<210)))||((59<r&&r<90)&&(509<c&&c<540))||(((599<c&&c<630)||(509<c&&c<540))&&(119<r&&r<180))||((599<c&&c<630)&&(59<r&&r<90)))
   bgr_data <= 24'hDDDDDD;
 end
 
   else if(score==9)begin
   if(((509<c&&c<630)&&((29<r&&r<60)||(89<r&&r<120)||(179<r&&r<210)))||((59<r&&r<90)&&(509<c&&c<540))||((599<c&&c<630)&&(119<r&&r<180))||((599<c&&c<630)&&(59<r&&r<90)))
   bgr_data <= 24'hDDDDDD;
 end
 
   end
end


assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule