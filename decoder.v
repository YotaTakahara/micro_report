// `timescale 1ns / 1ps
// `include "define.vh"

// module decoder(
//     input wire[31:0] ir,     
//     output wire[4:0] srcreg1_num,
//     output wire[4:0] srcreg2_num,
//     output wire[4:0] dstreg_num,
//     output wire[31:0] imm,
//     output wire [5:0] alucode,
//     output wire[1:0] aluop1_type,
//     output wire [1:0] aluop2_type,
//     output wire reg_we,
//     output wire is_load,
//     output wire is_store,
//     output wire is_halt,
//     output  wire[6:0]op

//     );
// wire[2:0]opcode;  
  

// function reg_en;
//     input [6:0]op;
//     input [4:0]dstreg_num;

//     case(op)
//    // `OPIMM,`OP,`LUI,`AUIPC,`LOAD:reg=`ENABLE;
//     `BRANCH,`STORE:reg_en=`DISABLE;
//     `JAL,`JALR:begin
//       case(dstreg_num)
//       5'b0:reg_en=`DISABLE;
//       default:reg_en=`ENABLE;
//       endcase
//     end
//     default:reg_en=`ENABLE;
//     endcase
// endfunction

// function load;
//     input[6:0]op;
//     case(op)
//     `LOAD:load=`ENABLE;
//     default:load=`DISABLE;
//     endcase
// endfunction
// function store;
//     input[6:0]op;
//     case(op)
//     `STORE:store=`ENABLE;
//     default:store=`DISABLE;
//     endcase
// endfunction

// function [31:0]immediate;
//     input[31:0]ir;
//     input [6:0]op;
//     input[2:0]opcode;
//     case(op)
//     `OPIMM:begin
//             case(opcode)
//                 3'b001,3'b101:immediate={{27{ir[24]}},ir[24:20]};
//                 default:immediate={{20{ir[31]}},ir[31:20]};
//             endcase
//         end
//     `LUI,`AUIPC:immediate={ir[31:12],12'd0};
//     `JAL:immediate={{11{ir[31]}},ir[31],ir[19:12],ir[20],ir[30:21],{1'b0}};
//     `JALR:immediate={{20{ir[31]}},ir[31:20]};
//     `BRANCH:immediate={{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
//     `STORE:immediate={{20{ir[31]}},ir[31:25],ir[11:7]};
//     `LOAD:immediate={{20{ir[31]}},ir[31:20]};
//     default:immediate=32'd0;
//     endcase

// endfunction

// function [5:0]alu;
//     input[31:0]ir;
//     input[6:0]op;
//     input[2:0]opcode;
//     case(op)
  
//     `OPIMM,`OP:begin
//       case(opcode)
//       3'b000:begin
//         if(op==`OP&&ir[30]==1'b1)alu=`ALU_SUB;
//         else if(op==`OP&&ir[25]==1'b1)alu=`ALU_MUL;
//         else alu=`ALU_ADD;
//       end//alu=(op==`OPIMM)?`ALU_ADD: (ir[30]==1'b1)?`ALU_SUB:`ALU_ADD;
//       3'b010:alu=(op==`OP && ir[25]==1'b1)?`ALU_MULHSU:`ALU_SLT;
//       3'b011:alu=(op==`OP && ir[25]==1'b1)?`ALU_MULHU:`ALU_SLTU;
//       3'b100:alu=(op==`OP && ir[25]==1'b1)?`ALU_DIV:`ALU_XOR;
//       3'b110:alu=(op==`OP && ir[25]==1'b1)?`ALU_REM:`ALU_OR;
//       3'b111:alu=(op==`OP && ir[25]==1'b1)?`ALU_REMU:`ALU_AND;
//       3'b001:alu=(op==`OP && ir[25]==1'b1)?`ALU_MULH:`ALU_SLL;
//       3'b101:begin
//          if(ir[30]==1'b1)alu=`ALU_SRA;
//          else if(ir[25]==1'b1)alu=`ALU_DIVU;
//          else alu=`ALU_SRL;
//       end
     
//       default:alu=6'b0;
//       endcase
//     end

//     `LUI:alu=`ALU_LUI;
//     `AUIPC:alu=`ALU_ADD;
//     `JAL:alu=`ALU_JAL;
//     `JALR:alu=`ALU_JALR;

//     `BRANCH:begin
//       case(opcode)
//        3'b000: alu=`ALU_BEQ;
//       3'b001: alu=`ALU_BNE;
//       3'b100: alu=`ALU_BLT;
//       3'b101: alu=`ALU_BGE;
//       3'b110: alu=`ALU_BLTU;
//       3'b111: alu=`ALU_BGEU;
//        default:alu=6'b0;
//       endcase
//     end

//     `STORE:begin
//       case(opcode)
//       3'b000:alu=`ALU_SB;
//       3'b001:alu=`ALU_SH;
//       3'b010:alu=`ALU_SW;
//        default:alu=6'b0;
//       endcase
//     end

//     `LOAD:begin
//       case(opcode)
//       3'b000:alu=`ALU_LB;
//       3'b001:alu=`ALU_LH;
//       3'b010:alu=`ALU_LW;
//       3'b100:alu=`ALU_LBU;
//       3'b101:alu=`ALU_LHU;
//        default:alu=6'b0;
//       endcase
//     end

//     default:alu=6'b0;
//     endcase   
// endfunction

// function [1:0]aluop1;
//     input [6:0]op;
//     case(op)
//     `OPIMM,`OP,`JALR,`BRANCH,`STORE,`LOAD:aluop1=`OP_TYPE_REG;
//     `AUIPC:aluop1=`OP_TYPE_IMM;
//     default:aluop1=`OP_TYPE_NONE;
//     endcase
// endfunction


// function [1:0]aluop2;
//     input[6:0]op;
//     case(op)
//     `OPIMM,`LUI,`STORE,`LOAD:aluop2=`OP_TYPE_IMM;
//     `OP,`BRANCH:aluop2= `OP_TYPE_REG;
//     `AUIPC,`JAL,`JALR:aluop2= `OP_TYPE_PC;
//     default:aluop2=`OP_TYPE_NONE;
//     endcase
// endfunction


// assign op=ir[6:0];
// assign opcode=ir[14:12];

// assign srcreg1_num=(op==`OPIMM||op==`OP||op==`JALR||op==`BRANCH||op==`STORE||op==`LOAD)?ir[19:15]:5'b0;
// assign srcreg2_num=(op==`OP||op==`BRANCH||op==`STORE)?ir[24:20]:5'b0;
// assign dstreg_num=(op==`OPIMM||op==`OP||op==`LUI||op==`AUIPC||op==`JAL||op==`JALR||op==`LOAD)?ir[11:7]:5'b0;
// assign imm=immediate(ir,op,opcode);
// assign alucode=alu(ir,op,opcode);
// assign aluop1_type=aluop1(op);
// assign aluop2_type=aluop2(op);
// assign reg_we=reg_en(op,dstreg_num);
// assign is_load=load(op);  
// assign is_store=store(op);  
// assign is_halt=`DISABLE;
// endmodule



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


module decoder(
    input wire[31:0] ir,     //
    output reg[4:0] srcreg1_num,//
    output reg[4:0] srcreg2_num,//
    output reg[4:0] dstreg_num,//
    output reg[31:0] imm,//
    output reg [5:0] alucode,//
    output reg[1:0] aluop1_type,//
    output reg [1:0] aluop2_type,//
    output reg reg_we,//
    output reg is_load,//
    output reg is_store,//
    output reg is_halt,
    output  wire[6:0]op
 //   output wire [6:0]op;
    

    );
  // wire [6:0]op;
 assign  op=ir[6:0];
   wire [2:0]opcode;
 assign opcode=ir[14:12];
 reg[31:0]temp;
    

    
        
always @(*)begin
    case(op)
    `OPIMM:begin
        srcreg1_num=ir[19:15];
        srcreg2_num=5'b0;
        dstreg_num=ir[11:7];
       
        aluop1_type=`OP_TYPE_REG;
       
        reg_we= `ENABLE;
        is_load=`DISABLE;
        is_store=`DISABLE;
        is_halt=`DISABLE;
        case(opcode)
        3'b000:begin
          alucode=`ALU_ADD; aluop2_type= `OP_TYPE_IMM; imm={{20{ir[31]}},ir[31:20]};
        end      
        3'b010:begin
          
       alucode=`ALU_SLT; aluop2_type= `OP_TYPE_IMM; imm={{20{ir[31]}},ir[31:20]};
        end
        3'b011:begin alucode=`ALU_SLTU; aluop2_type= `OP_TYPE_IMM; imm={{20{ir[31]}},ir[31:20]};end
        3'b100:begin alucode=`ALU_XOR; aluop2_type= `OP_TYPE_IMM; imm={{20{ir[31]}},ir[31:20]};end
        3'b110:begin alucode=`ALU_OR; aluop2_type= `OP_TYPE_IMM; imm={{20{ir[31]}},ir[31:20]};end
        3'b111:begin alucode=`ALU_AND; aluop2_type= `OP_TYPE_IMM; imm={{20{ir[31]}},ir[31:20]};end


        3'b001:begin alucode=`ALU_SLL; aluop2_type= `OP_TYPE_IMM; imm={{27{ir[31]}},ir[24:20]};end
        3'b101:begin
          aluop2_type= `OP_TYPE_IMM; imm={{27{ir[24]}},ir[24:20]};
          case(ir[30])

          0:alucode=`ALU_SRL;
          1:alucode=`ALU_SRA;
           default:
           alucode=6'b0;
          
          endcase           
        end
        default:begin
        alucode=6'b0;
        aluop2_type=2'b0;
        imm=32'd0;
        end
        endcase
    end




    `OP:begin
      srcreg1_num=ir[19:15];
      srcreg2_num=ir[24:20];
      dstreg_num=ir[11:7];
      imm=32'b0;
      aluop1_type=`OP_TYPE_REG;
      aluop2_type= `OP_TYPE_REG;
      reg_we= `ENABLE;
      is_load=`DISABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE;
      case(opcode)
      3'b000:begin
          case(ir[30])
            1'b0:begin
              case(ir[25])
                1'b1:alucode=`ALU_MUL;
                default:alucode=`ALU_ADD;
              endcase
            end
            1'b1:alucode=`ALU_SUB;
          default:alucode=6'b0;
          endcase
      end
      3'b001:begin
        case(ir[25])
          1'b1:alucode=`ALU_MULH;
          default:alucode=`ALU_SLL;
        endcase
      end
      3'b010:begin
        case(ir[25])
          1'b1:alucode=`ALU_MULHSU;
          default:alucode=`ALU_SLT;
        endcase
      end

      3'b011:begin
      case(ir[25])
      1'b1:alucode=`ALU_MULHU;
      default:alucode=`ALU_SLTU;
      endcase
      end

      3'b100:begin
        case(ir[25])
          1'b1:alucode=`ALU_DIV;
          default:alucode=`ALU_XOR;
        endcase
      end

      3'b101:begin
          case(ir[30])
            0:case(ir[25])
              1'b1:alucode=`ALU_DIVU;
              default:alucode=`ALU_SRL;
            endcase

            1:alucode=`ALU_SRA;
            default:alucode=6'b0;        
          endcase     
      end
      3'b110:begin
        case(ir[25])
          1'b1:alucode=`ALU_REM;
          default:alucode=`ALU_OR;
        endcase
      end

      3'b111:begin
        case(ir[25])
          1'b1:alucode=`ALU_REMU;
          default:alucode=`ALU_AND;
           endcase
          end
      default:alucode=6'b0;
      endcase
       
    end





    `LUI:begin
      srcreg1_num=5'b0;
      srcreg2_num=5'b0;
      dstreg_num=ir[11:7];
     
      
      imm={ir[31:12],12'd0};
      
      alucode=`ALU_LUI;
       aluop1_type=`OP_TYPE_NONE;
      aluop2_type= `OP_TYPE_IMM;
      reg_we= `ENABLE;
      is_load=`DISABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE;      
    end

    `AUIPC:begin
      srcreg1_num=5'b0;
      srcreg2_num=5'b0;
      dstreg_num=ir[11:7];
       // imm={{20{ir[31]}},ir[31:20]};
       // imm={ir[31:12],{12{0}}};
        imm={ir[31:12],12'd0};
       alucode=`ALU_ADD;
       aluop1_type=`OP_TYPE_IMM;
      aluop2_type= `OP_TYPE_PC;
      reg_we= `ENABLE;
      is_load=`DISABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE; 
    end
    `JAL:begin
     // reg [31:0]tmp;
      imm={{11{ir[31]}},ir[31],ir[19:12],ir[20],ir[30:21],{1'b0}};
      srcreg1_num=5'b0;
      srcreg2_num=5'b0;
      dstreg_num=ir[11:7];
      //imm={{20{ir[31]}},ir[31:20]};
       alucode=`ALU_JAL;
       aluop1_type=`OP_TYPE_NONE;
      aluop2_type= `OP_TYPE_PC;
      case(dstreg_num)
      5'b0:reg_we= `DISABLE;
      5'b1:reg_we= `ENABLE;
      default:reg_we= `ENABLE;
      endcase
      
      is_load=`DISABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE; 
    end
    `JALR:begin
      srcreg1_num=ir[19:15];
      srcreg2_num=5'b0;
      dstreg_num=ir[11:7];
      imm={{20{ir[31]}},ir[31:20]};
      alucode=`ALU_JALR;
       aluop1_type=`OP_TYPE_REG;
      aluop2_type= `OP_TYPE_PC;
      case(dstreg_num)
      5'b0:reg_we= `DISABLE;
      5'b1:reg_we= `ENABLE;
       default:reg_we=`DISABLE;
    endcase
      
      is_load=`DISABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE; 
    end
    `BRANCH:begin
      imm={{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
       srcreg1_num=ir[19:15];
      srcreg2_num=ir[24:20];
      dstreg_num=5'b0;
      aluop1_type=`OP_TYPE_REG;
      aluop2_type= `OP_TYPE_REG;
      reg_we= `DISABLE;
      is_load=`DISABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE;
      case(opcode)
      3'b0: alucode=`ALU_BEQ;
      3'b001: alucode=`ALU_BNE;
      3'b100: alucode=`ALU_BLT;
      3'b101: alucode=`ALU_BGE;
      3'b110: alucode=`ALU_BLTU;
      3'b111: alucode=`ALU_BGEU;
       default:alucode=6'b0;
      endcase
     //imm={20{tmp[31]},tmp[31:25],tmp[11:7]};

    end
    `STORE:begin
      imm={{20{ir[31]}},ir[31:25],ir[11:7]};
      srcreg1_num=ir[19:15];
      srcreg2_num=ir[24:20];
      dstreg_num=5'b0;
      aluop1_type=`OP_TYPE_REG;
      aluop2_type= `OP_TYPE_IMM;
      reg_we= `DISABLE;
      is_load=`DISABLE;
      is_store=`ENABLE;
      is_halt=`DISABLE;
      case(opcode)
      3'b000:alucode=`ALU_SB;
      3'b001:alucode=`ALU_SH;
      3'b010:alucode=`ALU_SW;
       default:alucode=6'b0;
      endcase
    //  imm={20{tmp[31]},tmp[31:25],tmp[4:0]};
    end
    `LOAD:begin
       
      srcreg1_num=ir[19:15];
      srcreg2_num=5'b0;
      dstreg_num=ir[11:7];
      imm={{20{ir[31]}},ir[31:20]};
      aluop1_type=`OP_TYPE_REG;
      aluop2_type= `OP_TYPE_IMM;
      reg_we= `ENABLE;
      is_load=`ENABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE;
      case(opcode)
      3'b000:alucode=`ALU_LB;
      3'b001:alucode=`ALU_LH;
      3'b010:alucode=`ALU_LW;
      3'b100:alucode=`ALU_LBU;
      3'b101:alucode=`ALU_LHU;
       default:alucode=6'b0;
      endcase
    end
     default:begin
      srcreg1_num=5'b0;
      srcreg2_num=5'b0;
      dstreg_num=5'b0;
      imm=32'd0;
      aluop1_type=`OP_TYPE_NONE;
      aluop2_type= `OP_TYPE_NONE;
      reg_we= `DISABLE;
      is_load=`DISABLE;
      is_store=`DISABLE;
      is_halt=`DISABLE;
     
     end
    endcase
end

    
    
    
endmodule
