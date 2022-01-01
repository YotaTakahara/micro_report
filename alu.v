// `timescale 1ns / 1ps
// `include "define.vh"
// module alu(
//     input wire[5:0] alucode,
//     input wire[31:0] op1,
//     input wire [31:0] op2,
//     output wire [31:0]alu_result,
//     output wire br_taken


//     );
//     wire[4:0]shift=op2[4:0];
//     wire[31:0]op1_abs;
//     wire[31:0]op2_abs;
//   //ss  wire[31:0]abs_ans;

//  function [31:0]calc;
//    input [5:0]alucode;
//    input [31:0]op1,op2;
//    input[4:0]shift;
//    input [31:0]op1_abs;
//    input [31:0]op2_abs;

//    reg[64:0]mul_ans;
    


//    case(alucode)
//     `ALU_ADD:calc=op1+op2;
//     `ALU_SUB:calc=op1-op2;
//     `ALU_SLT:calc=($signed({op1})<$signed({op2}))?1:0;
//     `ALU_SLTU:calc=(op1<op2)?1:0;
//     `ALU_XOR:calc=op1^op2;
//     `ALU_OR:calc=op1|op2;
//     `ALU_AND:calc=op1&op2;
//     `ALU_SLL:calc=(op1<<shift);
//     `ALU_SRL:calc=op1>>shift;
//     `ALU_SRA:calc=$signed({op1})>>>$signed({shift});
//     `ALU_JAL,`ALU_JALR:calc=op2+32'd4;
//     `ALU_LB, `ALU_LH,`ALU_LW,`ALU_LBU, `ALU_LHU,`ALU_SB,`ALU_SH, `ALU_SW:calc=op1+op2;
//     `ALU_LUI:calc=op2;
//     //mul meirei
//     `ALU_MUL:begin
//         mul_ans=op1*op2;
//         calc=mul_ans[31:0];
//     end
//     `ALU_MULH:begin
//         mul_ans=$signed({op1})*$signed({op2});
//         calc=mul_ans[63:32];
//     end
//     `ALU_MULHSU:begin
//         mul_ans= $signed({op1})*op2;
//         calc=mul_ans[63:32];
//     end
//     `ALU_MULHU:begin
//         mul_ans=  op1*op2;
//         calc=mul_ans[63:32];
//     end
//     `ALU_DIV:begin
//       if(op2==32'd0)calc=`MINUS1;
//       else if(op2==`MINUS1 && op1==$signed({32'hf0000000}))calc=32'hf0000000;
//       else calc=$signed({$signed({op1})/$signed({op2})}) ;  
//     end
//     `ALU_DIVU:calc=(op2==32'd0)?32'hffffffff:op1/op2;
//     `ALU_REM:begin
//       if(op2==32'd0)calc=op1;
//       else if(op2==`MINUS1 && op1==`MINUS231)calc=32'd0;
//       else if(op1[31]==1'b1)calc=-(op1_abs%op2_abs);
//       else calc=op1%op2_abs;
//     end
//     `ALU_REMU:begin
//       if(op2==32'd0)calc=op1;
//       else if(op2==`MINUS1 &&op1==`MINUS231)calc=32'd0;
//       else calc=op1%op2;
//     end
//     default:calc=32'd0;
//    endcase

//  endfunction

//  function jump;
//      input[5:0]alucode;
//      input [31:0]op1,op2;
//      case(alucode)
//      `ALU_JAL,`ALU_JALR:jump=`ENABLE;
//      `ALU_BEQ:jump=(op1==op2)?`ENABLE:`DISABLE;
//      `ALU_BNE:jump=(op1!=op2)?`ENABLE:`DISABLE;
//      `ALU_BLT:jump=($signed({op1})<$signed({op2}))?`ENABLE:`DISABLE;
//      `ALU_BLTU:jump=(op1<op2)?`ENABLE:`DISABLE;
//      `ALU_BGE:jump=($signed({op2})<=$signed({op1}))?`ENABLE:`DISABLE;
//      `ALU_BGEU:jump=(op2<=op1)?`ENABLE:`DISABLE;

//      default:jump=`DISABLE;
//      endcase

     
//  endfunction

//  function [31:0]abs;
//       input signed [31:0]tmp  ;

//       if(tmp<0)abs=-tmp;
//       else abs=tmp;
      
//     endfunction
//   assign op1_abs=abs(op1);
//   assign op2_abs=abs(op2);


// assign alu_result=calc(alucode,op1,op2,shift,op1_abs,op2_abs);
// assign br_taken=jump(alucode,op1,op2);



// endmodule















`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/01 23:44:28
// Design Name: 
// Module Name: alu
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
module alu(
    input wire[5:0] alucode,
    input wire[31:0] op1,
    input wire [31:0] op2,
    output reg [31:0]alu_result,
    output reg br_taken


    );
    wire[4:0]shift=op2[4:0];
    wire[31:0]op1_abs;
    wire[31:0]op2_abs;
    reg [63:0]mul_ans;
    wire[31:0]abs_ans;


   
    always @(*)begin
      case(alucode)
      `ALU_ADD:begin
         alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_SUB:begin
          alu_result=op1-op2;
        br_taken=`DISABLE;
      end
      `ALU_SLT:begin
          //if($signed({1'b0,op1})<$signed({1'b0,op2}) )begin    
         alu_result=($signed({op1})<$signed({op2}))?1:0;
        br_taken=`DISABLE;
      end
      `ALU_SLTU:begin
          alu_result=(op1<op2)?1:0;
        br_taken=`DISABLE;
      end

      `ALU_XOR:begin
          alu_result=op1^op2;
        br_taken=`DISABLE;
      end
      `ALU_OR:begin
          alu_result=op1|op2;
        br_taken=`DISABLE;
      end
      `ALU_AND:begin
          alu_result=op1&op2;
        br_taken=`DISABLE;
      end

      `ALU_SLL:begin
        alu_result=(op1<<shift);
        br_taken=`DISABLE;
      end
      `ALU_SRL:begin
        alu_result=op1>>shift;
        br_taken=`DISABLE;
      end
      `ALU_SRA:begin
        alu_result=$signed({op1})>>>$signed({shift});
        br_taken=`DISABLE;
      end

      `ALU_JAL:begin
        alu_result=op2+32'd4;
        br_taken=`ENABLE;
      end
      `ALU_JALR:begin
        alu_result=op2+32'd4;
        br_taken=`ENABLE;
      end
      `ALU_BEQ:begin
        alu_result=32'd0;
        br_taken=(op1==op2)?`ENABLE:`DISABLE;
       
      end
     
      `ALU_BNE:begin
        alu_result=32'd0;
         br_taken=(op1!=op2)?`ENABLE:`DISABLE;
      end
      `ALU_BLT:begin
        alu_result=32'd0;
        br_taken=($signed({op1})<$signed({op2}))?`ENABLE:`DISABLE;
      end
     
      `ALU_BLTU:begin
         alu_result=32'd0;
        br_taken=(op1<op2)?`ENABLE:`DISABLE;
      end
      `ALU_BGE:begin
        alu_result=32'd0;
        br_taken=($signed({op2})<=$signed({op1}))?`ENABLE:`DISABLE;
      end

     
      
      `ALU_BGEU: begin
        alu_result=32'd0;
        br_taken=(op2<=op1)?`ENABLE:`DISABLE;
      end
     

      `ALU_LB:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_LH:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_LW:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_LBU:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_LHU:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_SB:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_SH:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end
      `ALU_SW:begin
        alu_result=op1+op2;
        br_taken=`DISABLE;
      end

      `ALU_LUI:begin
        alu_result=op2;
        br_taken=`DISABLE;
      end



      `ALU_MUL:begin
        mul_ans=op1*op2;
        alu_result=mul_ans[31:0];
        br_taken=`DISABLE;
      end

      `ALU_MULH:begin
       //  mul_ans= $signed({$signed({op1})*$signed({op2})});
        mul_ans= $signed({op1})*$signed({op2});
        alu_result=mul_ans[63:32];
        br_taken=`DISABLE;     
      end
      `ALU_MULHSU:begin
         mul_ans= $signed({op1})*op2;
        alu_result=mul_ans[63:32];
        br_taken=`DISABLE;   
      end
      `ALU_MULHU:begin
         mul_ans=  op1*op2;
        alu_result=mul_ans[63:32];
        br_taken=`DISABLE;   
      end



      `ALU_DIV:begin
       br_taken=`DISABLE;  
        case(op2)
        32'd0:alu_result=`MINUS1;
        `MINUS1:case(op1)
          $signed({32'hf0000000}):alu_result=32'hf0000000;
       //   default:alu_result= $signed({$rtoi({$signed({op1})/$signed({op2})})}) ;    
       default:alu_result= $signed({$signed({op1})/$signed({op2})}) ;  
        endcase
        default:alu_result= $signed({$signed({op1})/$signed({op2})}) ;  
        endcase
      end


      `ALU_DIVU:begin
       br_taken=`DISABLE;  
        case(op2)
        32'd0:alu_result=32'hffffffff;
        default:alu_result=op1/op2;
         
        endcase
      end



      `ALU_REM:begin
     // $display("nannde");
      case(op2)
      32'd0:alu_result=op1;
      `MINUS1:begin
          case(op1)
            `MINUS231:alu_result=32'd0;
            default:begin
              if(op1[31]==1'b1) alu_result=-(op1_abs%op2_abs);
           //   $display("kokokdesu");
              else  alu_result=op1%op2_abs;
             // $display("iya");
          end
          endcase
        end
      default:begin
      if(op1[31]==1'b1) alu_result=-(op1_abs%op2_abs);//$signed({op1-op1_abs/op2_abs*op2});

       else  alu_result=op1%op2_abs;
      end
     
      endcase
       br_taken=`DISABLE;  
        
      end



      `ALU_REMU:begin
      case(op2)
      32'd0:alu_result=op1;
      `MINUS1:begin
        case(op1)
        `MINUS231:alu_result=32'd0;
        default: alu_result=op1%op2;
        endcase
      end
      default:alu_result=op1%op2;
      endcase
      
       br_taken=`DISABLE;  
        
      end





      default:begin
          alu_result=32'b0;
          br_taken=`DISABLE;
      end
      endcase
    end


    function [31:0]abs;
      input signed [31:0]tmp  ;

      if(tmp<0)abs=-tmp;
      else abs=tmp;
      
    endfunction
  assign op1_abs=abs(op1);
  assign op2_abs=abs(op2);


endmodule
