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

// ----   FSM alto nível com Case
module statem(clk, reset, a, saida);

input clk, reset, a;
output [2:0] saida;
reg [2:0] state;
parameter dois=3'd2, seis=3'd6, quatro=3'd4, cinco=3'd5, sete=3'd7;

assign saida = state;

always @(posedge clk or negedge reset)
    begin
        if (reset==0)
            state = dois;
        else
            case (state)
                dois: state = quatro;
                seis: state = cinco;
                quatro: if(a) state = sete;
                        else state = seis;
                cinco: if(a) state = quatro;
                       else state = dois;
                sete: state = seis;
            endcase
     end
endmodule

// FSM com portas logicas
module statePorta(input clk, input res, input a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;
assign s = e;  // saida = estado atual
assign p[0] =  ~e[0]&(a&~e[1] | e[1]&e[2]); //6 operacoes
assign p[1] =  e[0]&e[1] | ~e[1]&(~e[0] | ~a); //7 operacoes
assign p[2] =  ~e[0] | a&~e[1]; //4 operacoes
//Total: 17 operacoes
ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);
endmodule 




module stateMem(input clk,input res, input a, input[2:0] entrada, output [2:0] saida);
reg [5:0] StateMachine [0:15]; // 16 linhas e 6 bits de largura
initial
begin
StateMachine[0] = 6'o42;  StateMachine[8] = 6'o42;
StateMachine[1] = 6'o42;  StateMachine[9] = 6'o42;
StateMachine[3] = 6'o42;  StateMachine[11] = 6'o42;  
StateMachine[2] = 6'o42;  StateMachine[10] = 6'o42;
StateMachine[6] = 6'o56;  StateMachine[14] = 6'o56;
StateMachine[7] = 6'o67;  StateMachine[15] = 6'o67;
StateMachine[5] = 6'o25;  StateMachine[13] = 6'o45;
StateMachine[4] = 6'o64;  StateMachine[12] = 6'o74;
end
wire [3:0] address;  // 16 linhas = 4 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida
assign address[3] = a;
assign dout = StateMachine[address];
assign saida = dout[2:0];
ff st0(dout[3],clk,res,address[0]);
ff st1(dout[4],clk,res,address[1]);
ff st2(dout[5],clk,res,address[2]);
endmodule

module main;
reg c,res,a;
wire [2:0] saida;
wire [2:0] saida1;
wire [2:0] saida2;

statem FSM(c,res,a,saida);
stateMem FSM1(c,res,a,saida1,saida1);
statePorta FSM2(c,res,a,saida2);


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
     $monitor($time," c %b res %b a %b s %d smem %d sporta %d",c,res,a,saida,saida1,saida2);
      #1 res=0; a=0;
      #1 res=1;
      #8 a=1;
      #16 a=0;
      #12 a=1;
      #4;
      $finish ;
    end
endmodule

