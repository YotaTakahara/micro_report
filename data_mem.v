`timescale 1ns / 1ps
`include "define.vh"

module data_mem(clk,reg_we,alucode,we,r_addr,w_addr,r_data,w_data,is_store);//,uart_IN_data,uart_we,uart_tx,uart_OUT_data,hc_OUT_data);
    input clk,reg_we;
    input [31:0] r_addr,w_addr;
    input [31:0]w_data;
    output  [31:0]r_data;
// input [5:0]alucode;
    input[5:0]alucode;
    input [3:0]we;
    input is_store;
    reg [31:0] mem[0:32767];
   // initial $readmemb("code.hex",mem);


  initial $readmemh("/home/denjo/b3exp-master/benchmarks/Coremark_for_Synthesis/data.hex",mem);

/*分散RAMにしているのはそれでないと、*/
 //initial $readmem[r_addr>>2]b 

function [31:0]read;
     input [5:0]alucode;
     input [31:0]r_addr;
     //input[31:0]mem[0:32767];
     case(alucode)
      `ALU_LB:begin
        case(r_addr[1:0])
        0:read={{24{mem[r_addr>>2][7]}},mem[r_addr>>2][7:0]};   
        1:read={{24{mem[r_addr>>2][15]}},mem[r_addr>>2][15:8]};
        2:read={{24{mem[r_addr>>2][23]}},mem[r_addr>>2][23:16]};
        default:read={{24{mem[r_addr>>2][31]}},mem[r_addr>>2][31:24]};
        endcase
      end
       `ALU_LBU:begin
         case(r_addr[1:0])
         0:read={24'd0,mem[r_addr>>2][7:0]};
          1:read={24'd0,mem[r_addr>>2][15:8]};
         2:read={24'd0,mem[r_addr>>2][23:16]};
         default:read={24'd0,mem[r_addr>>2][31:24]};
         endcase
       end
       `ALU_LH:begin
         case(r_addr[1:0])
         2'b0:read={{16{mem[r_addr>>2][15]}},mem[r_addr>>2][15:0]};
         2'b1:read={{16{mem[r_addr>>2][23]}},mem[r_addr>>2][23:8]};
         default:read={{16{mem[r_addr>>2][31]}},mem[r_addr>>2][31:16]};
         endcase
       end
       `ALU_LHU:begin
         case(r_addr[1:0])
         2'b0:read={16'd0,mem[r_addr>>2][15:0]};
         2'b1:read={16'd0,mem[r_addr>>2][23:8]};
         default:read={16'd0,mem[r_addr>>2][31:16]};
         endcase
       end
      
     default: read=mem[r_addr>>2];
     endcase
  endfunction


assign r_data=read(alucode,r_addr);


  always @(negedge clk) begin
    case (w_addr[1:0])
    0 : begin 
        if(we[0]) mem[w_addr>>2][7:0]=w_data[7:0];
        if(we[1]) mem[w_addr>>2][15:8]=w_data[15:8];
        if(we[2]) mem[w_addr>>2][23:16]=w_data[23:16];
        if(we[3]) mem[w_addr>>2][31:24]=w_data[31:24];
    end
     1 : begin
        if(we[0]) mem[w_addr>>2][15:8]=w_data[7:0];
        if(we[1]) mem[w_addr>>2][23:16]=w_data[15:8];
        if(we[2]) mem[w_addr>>2][31:24]=w_data[23:16];
    end
     2 : begin 
        
        if(we[0]) mem[w_addr>>2][23:16]=w_data[7:0];
        if(we[1]) mem[w_addr>>2][31:24]=w_data[15:8];
    end
     3 : begin
       
        if(we[0]) mem[w_addr>>2][31:24]=w_data[7:0];
    end
    
endcase      
    end

endmodule