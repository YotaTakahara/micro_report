`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/29 09:44:00
// Design Name: 
// Module Name: decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.vh"


module npc(br_taken,pc,imm,nextPc,op2,alucode,rs1_data);
input  br_taken;
input  [31:0]pc;
input [31:0]imm;
input [31:0]op2;
input [5:0]alucode;
input [31:0]rs1_data;
output reg [31:0]nextPc;






always @(*)begin
  if(br_taken)begin
    case(alucode)
    `ALU_JAL:nextPc=pc+imm;
    `ALU_JALR:nextPc=rs1_data+imm;
    default: nextPc=pc+imm;
    endcase
    // nextPc=pc+imm;
   
  
  end else begin
    nextPc=pc+4;
  end
end


endmodule