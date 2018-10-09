module ff ( input data, input c, input r, output q);
  reg q;
  always @(posedge c or negedge r) 
  begin
  if(r==1'b0)
    q <= 1'b0; 
  else 
    q <= data; 
  end 
endmodule //End 

module reg6 ( input [5:0] data, input clk, input rst, input en, output [5:0] q);
  reg [5:0] q; 
  always @(posedge clk or negedge rst) 
  begin
  if(rst==1'b0)
    q <= 6'b0; 
  else if ( en  == 1'b1 ) // enable
    q <= data; 
  end 
endmodule //End 

module reg5 ( input [4:0] data, input clk, input rst, input en, output [4:0] q);
  reg [4:0] q; 
  always @(posedge clk or negedge rst) 
  begin
  if(rst==1'b0)
    q <= 5'b0; 
  else if ( en  == 1'b1 ) // enable
    q <= data; 
  end 
endmodule //End 

// ----   FSM alto nível com Case
/*                                 +---------+
                                   |0 5 10 20|
                                   +------+--+
  +----------+--------> +------+          |
  |          |     +----+saldo +-------+  |
  |          |   +-v-+  |      |     +-v--v--+
  |          |   |cmp|  +------+     |       |
  |maquina   |   +-+-+     ^         |   add |
  |          |     |       |         +---+---+
  |          |<----+       |             |
  |          |             +-------------+
  +----------+
*/
module statem(clk, reset, moedas, next, vend);//, sald, sta);
  input [4:0] moedas;
  input clk, reset;
  output next;
  output vend;
  //output [5:0] sald;
  //output [1:0] sta;

  reg [1:0] state;
  parameter zero=2'd0, contando=2'd1, contou=2'd2, vendeu=2'd3;
  wire cmp, sreset;
  reg [5:0] saldo;

  assign sreset = (state == zero)?0:1;
  assign cmp = (saldo >= 6'd40);
  assign vend = (state == vendeu)?1:0;
  assign next = (state==contou || state==zero)?1:0;// & clk==0)?1:0;
  //assign sald = saldo;
  //assign sta = state;
  //maquina
  always @(posedge clk or negedge reset)
      begin
            if (reset==0)
                state = zero;
            else
                case (state)
                      zero:
                          state = contando;
                      contando:
                          if (cmp == 1) state = vendeu;
                      contou:
                          if(cmp == 1) state = vendeu;
                          else state=contando;
                      vendeu:
                          state = zero;
                endcase
      end
  
  always @(posedge clk or negedge reset or negedge sreset)
      begin
        if(reset==0 || sreset ==0)
          saldo = 6'd0;
        else
          saldo = saldo + {1'b0, moedas};
          if(state==contando) state = contou;
      end
endmodule

module compra (clk, rst, next, vendeu, moedas);
  input clk;
  input rst;
  input next;
  input vendeu;
  output [4:0] moedas;
  reg [2:0] state;

  // estados 
  parameter init=3'd0, readmem=3'd1, incrPtr=3'd2;

  wire [4:0] min;
  wire enN,inc;
  wire [4:0] ptrIN;
  wire [4:0] ptrOUT;

  reg5 m(min, clk, rstM, enN, moedas); // moedas
  memoria mem(ptrOUT, min, rst);
  reg5 PTR(ptrIN, clk, rst, inc, ptrOUT); // moedas
  assign ptrIN = ptrOUT + 1;

  assign rstM = (state == init)?0:1;
  assign enN = (state == readmem)?1:0;
  assign inc = (state == incrPtr)?1:0;

  // maquina
  always @(posedge clk or negedge rst or posedge vendeu)
      begin
            if (rst==0 || vendeu ==1)
                state = init;
            else
                case (state)
                      init:
                          if(next) state = readmem;
                      readmem:
                          state = incrPtr;
                      incrPtr:
                          state = init;
                endcase
      end
endmodule

module memoria (line, dout, reset);
  input [4:0] line; // 32 linhas
  output [4:0] dout;
  input reset;
  reg [4:0] memory[0:31]; // 32 linhas com 5 bits 
  reg [4:0] dout;

  always @ (*)
    begin 
      dout <= memory[line];
    end

  always @(posedge reset) 
        if(reset) // inicia  para testes
          begin
            memory[0] <= 5'd5;
            memory[1] <= 5'd20;
            memory[2] <= 5'd5;
            memory[3] <= 5'd10;
            memory[4] <= 5'd5;
            memory[5] <= 5'd20;
            memory[6] <= 5'd10;
            memory[7] <= 5'd5;
            memory[8] <= 5'd5;
            memory[9] <= 5'd5;
            memory[10] <= 5'd5;
            memory[11] <= 5'd5;
            memory[12] <= 5'd5;
            memory[13] <= 5'd5;
            memory[14] <= 5'd5;
            memory[15] <= 5'd5;
            memory[16] <= 5'd5;
            memory[17] <= 5'd20;
            memory[18] <= 5'd5;
            memory[19] <= 5'd10;
            memory[20] <= 5'd20;
            memory[21] <= 5'd20;
            memory[22] <= 5'd10;
            memory[23] <= 5'd5;
            memory[24] <= 5'd5;
            memory[25] <= 5'd5;
            memory[26] <= 5'd5;
            memory[27] <= 5'd5;
            memory[28] <= 5'd5;
            memory[29] <= 5'd5;
            memory[30] <= 5'd5;
            memory[31] <= 5'd5;
          end
endmodule


module main;
  reg c,res;
  wire [4:0] moedas;
  wire next, vend;
  //wire [5:0] sald;
  //wire [1:0] sta;

  compra comp(c,res,next,vend,moedas);
  statem FSM(c,res,moedas,next,vend/*,sald,sta*/);

  initial
      c = 1'b0;
    always
      c= #(1) ~c;

  // visualizar formas de onda usar gtkwave out.vcd
  initial  begin
      $dumpfile ("out.vcd"); 
      $dumpvars; 
    end 

    initial 
      begin
      $monitor($time," c %b res %b moedas %d next %b vend %b",c,res,moedas,next,vend); //saldo %d stateV %d",c,res,moedas,next,vend,sald,sta);
        #1 res=0;
        #1 res=1;
        #20;
        #20;
        $finish ;
      end
endmodule

