`timescale 1ns / 1ps
`include "define.vh"
module alu1(
    input wire[5:0] alucode,
    input wire[31:0] op1,
    input wire [31:0] op2,
    output wire [31:0]alu_result,
    output wire br_taken


    );
    wire[4:0]shift=op2[4:0];
    wire[31:0]op1_abs;
    wire[31:0]op2_abs;
  //ss  wire[31:0]abs_ans;

 function [31:0]calc;
   input [5:0]alucode;
   input [31:0]op1,op2;
   input[4:0]shift;
   input [31:0]op1_abs;
   input [31:0]op2_abs;

   reg[64:0]mul_ans;
    


   case(alucode)
    `ALU_ADD:calc=op1+op2;
    `ALU_SUB:calc=op1-op2;
    `ALU_SLT:calc=($signed({op1})<$signed({op2}))?1:0;
    `ALU_SLTU:calc=(op1<op2)?1:0;
    `ALU_XOR:calc=op1^op2;
    `ALU_OR:calc=op1|op2;
    `ALU_AND:calc=op1&op2;
    `ALU_SLL:calc=(op1<<shift);
    `ALU_SRL:calc=op1>>shift;
    `ALU_SRA:calc=$signed({op1})>>>$signed({shift});
    `ALU_JAL,`ALU_JALR:calc=op2+32'd4;
    `ALU_LB, `ALU_LH,`ALU_LW,`ALU_LBU, `ALU_LHU,`ALU_SB,`ALU_SH, `ALU_SW:calc=op1+op2;
    `ALU_LUI:calc=op2;
    //mul meirei
    `ALU_MUL:begin
        mul_ans=op1*op2;
        calc=mul_ans[31:0];
    end
    `ALU_MULH:begin
        mul_ans=$signed({op1})*$signed({op2});
        calc=mul_ans[63:32];
    end
    `ALU_MULHSU:begin
        mul_ans= $signed({op1})*op2;
        calc=mul_ans[63:32];
    end
    `ALU_MULHU:begin
        mul_ans=  op1*op2;
        calc=mul_ans[63:32];
    end
    `ALU_DIV:begin
      if(op2==32'd0)calc=`MINUS1;
      else if(op2==`MINUS1 && op1==$signed({32'hf0000000}))calc=32'hf0000000;
      else calc=$signed({$signed({op1})/$signed({op2})}) ;  
    end
    `ALU_DIVU:calc=(op2==32'd0)?32'hffffffff:op1/op2;
    `ALU_REM:begin
      if(op2==32'd0)calc=op1;
      else if(op2==`MINUS1 && op1==`MINUS231)calc=32'd0;
      else if(op1[31]==1'b1)calc=-(op1_abs%op2_abs);
      else calc=op1%op2_abs;
    end
    `ALU_REMU:begin
      if(op2==32'd0)calc=op1;
      else if(op2==`MINUS1 &&op1==`MINUS231)calc=32'd0;
      else calc=op1%op2;
    end
    default:calc=32'd0;
   endcase

 endfunction

 function jump;
     input[5:0]alucode;
     input [31:0]op1,op2;
     case(alucode)
     `ALU_JAL,`ALU_JALR:jump=`ENABLE;
     `ALU_BEQ:jump=(op1==op2)?`ENABLE:`DISABLE;
     `ALU_BNE:jump=(op1!=op2)?`ENABLE:`DISABLE;
     `ALU_BLT:jump=($signed({op1})<$signed({op2}))?`ENABLE:`DISABLE;
     `ALU_BLTU:jump=(op1<op2)?`ENABLE:`DISABLE;
     `ALU_BGE:jump=($signed({op2})<=$signed({op1}))?`ENABLE:`DISABLE;
     `ALU_BGEU:jump=(op2<=op1)?`ENABLE:`DISABLE;

     default:jump=`DISABLE;
     endcase

     
 endfunction

 function [31:0]abs;
      input signed [31:0]tmp  ;

      if(tmp<0)abs=-tmp;
      else abs=tmp;
      
    endfunction
  assign op1_abs=abs(op1);
  assign op2_abs=abs(op2);


assign alu_result=calc(alucode,op1,op2,shift,op1_abs,op2_abs);
assign br_taken=jump(alucode,op1,op2);



endmodule
