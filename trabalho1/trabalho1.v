//Rodrigo Eduardo de Oliveira Bauer Chichorro - 92535
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

input clk, reset;
input [1:0] a;
output [2:0] saida;
reg [2:0] state;
parameter zero=3'd0, um=3'd1, dois=3'd2, tresA=3'd3, quatro=3'd4, cinco=3'd5, seis=3'd6, tresB=3'd7;

/*
                     +-------------------------+
                     |                         |
 +-------------------+--------------------+    |
 |         0         |          1         |    |
 v                   |                    v    |
+-+   0   +-+   0   +-+  1/2  +--+       +-+   |     
|0|------>|1|------>|2|<------|3a|<------|4|   |
+-+       +-+       +-+       +--+       +-+   |
          ^ |             2     ^              |
         2| +-------------------+             2|
      	  |                                    |
          ++--------------------+              |
      	   |3                   |              |
           v                    |              |
          +-+        +-+       +--+            |
          |5|------->|6|------>|3b|<-----------+
          +-+   3    +-+   3   +--+

Para estados nao exibidos: Se a=0, va para 0; 
se a=1, va para 3; se a=2, va para 1; se a=3, va para 5. 
*/

assign saida[0] = state[0];
assign saida[1] = state[1];
assign saida[2] = state[2]&~(state[1]&state[0]);


always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = zero;
          else
               case (state)
                    zero: if(a == 0) state = um;
                          else if(a == 1) state = tresA;
                          else if(a == 2) state = um;
                          else state = cinco;
                    um: if(a == 0) state = dois;
                          else if(a == 1) state = tresA;
                          else if(a == 2) state = tresA;
                          else state = cinco;
                    dois: if(a == 0) state = zero;
                          else if(a == 1) state = quatro;
                          else if(a == 2) state = tresB;
                          else state = cinco;
                    tresA: if(a == 0) state = zero;
                          else if(a == 1) state = dois;
                          else if(a == 2) state = dois;
                          else state = cinco;
                    quatro: if(a == 0) state = zero;
                            else if(a == 1) state = tresA;
                            else if(a == 2) state = um;
                            else state = cinco;
                    cinco: if(a == 0) state = zero;
                          else if(a == 1) state = tresA;
                          else if(a == 2) state = um;
                          else state = seis;
                    seis: if(a == 0) state = zero;
                          else if(a == 1) state = tresA;
                          else if(a == 2) state = um;
                          else state = tresB;
                    tresB: if(a == 0) state = zero;
                           else if(a == 1) state = tresA;
                           else if(a == 2) state = um;
                           else state = tresA;
               endcase
     end
endmodule

// FSM com portas logicas
module statePorta(input clk, input res, input [1:0] a, output [2:0] s);
wire [2:0] e;
wire [2:0] p;

assign s[0] = e[0];
assign s[1] = e[1];  // saida = estado atual, exceto
assign s[2] = e[2]&~(e[1]&e[0]); // sete, que e' igual a tres.

assign p[0] =  (~e[1]&~e[2]&(~e[0]|a[0]|a[1])) | (e[2]&(a[0]^a[1])) | (a[1]&((e[1]&a[0])|~e[0])); //15 operacoes
assign p[1] =  ( a[0]& ( (~a[1]&(~e[1]|e[0])) | (e[2]&(e[0]|e[1])) ) ) | (~e[2]&~a[0]&((~e[1]&e[0])|(e[1]&a[1]))); //17 operacoes
assign p[2] =  (a[1]&a[0]&~(e[2]&e[1]&e[0])) | (~e[2]&e[1]&~e[0]&(a[0]|a[1])); //12 operacoes
//Total: 44 operacoes
ff  e0(p[0],clk,res,e[0]);
ff  e1(p[1],clk,res,e[1]);
ff  e2(p[2],clk,res,e[2]);
endmodule 




module stateMem(input clk,input res, input [1:0] a, output [2:0] saida);
reg [5:0] StateMachine [0:31]; // 32 linhas e 6 bits de largura
initial
begin
StateMachine[0] = 6'o10;  StateMachine[8] = 6'o02;
StateMachine[1] = 6'o30;  StateMachine[9] = 6'o42;
StateMachine[2] = 6'o10;  StateMachine[10] = 6'o72;
StateMachine[3] = 6'o50;  StateMachine[11] = 6'o52;  
StateMachine[4] = 6'o21;  StateMachine[12] = 6'o03;
StateMachine[5] = 6'o31;  StateMachine[13] = 6'o23;
StateMachine[6] = 6'o31;  StateMachine[14] = 6'o23;
StateMachine[7] = 6'o51;  StateMachine[15] = 6'o53;

StateMachine[16] = 6'o04;  StateMachine[24] = 6'o06;
StateMachine[17] = 6'o34;  StateMachine[25] = 6'o36;
StateMachine[18] = 6'o14;  StateMachine[26] = 6'o16;
StateMachine[19] = 6'o54;  StateMachine[27] = 6'o76;  
StateMachine[20] = 6'o05;  StateMachine[28] = 6'o07;
StateMachine[21] = 6'o35;  StateMachine[29] = 6'o37;
StateMachine[22] = 6'o15;  StateMachine[30] = 6'o17;
StateMachine[23] = 6'o65;  StateMachine[31] = 6'o37;
end
wire [4:0] address;  // 32 linhas = 5 bits de endereco
wire [5:0] dout; // 6 bits de largura 3+3 = proximo estado + saida
assign address[1] = a[1];
assign address[0] = a[0];
assign dout = StateMachine[address];

assign saida[1:0] = dout[1:0];
assign saida[2] = dout[2]&~(dout[1]&dout[0]);

ff st0(dout[3],clk,res,address[2]);
ff st1(dout[4],clk,res,address[3]);
ff st2(dout[5],clk,res,address[4]);
endmodule

module main;
reg c,res;
reg [1:0] a;
wire [2:0] saida;
wire [2:0] saida1;
wire [2:0] saida2;

statem FSM(c,res,a,saida);
stateMem FSM1(c,res,a,saida1);
statePorta FSM2(c,res,a,saida2);


initial
    c = 1'b0;
  always
    c= #(1) ~c;

  initial
    begin
     $monitor($time," c %b res %b a %b s %d smem %d sporta %d",c,res,a,saida,saida1,saida2);
      //Matricula: 92535 -> 1 01 10 10 01 01 11 01 11 -> 1 1 2 2 1 1 3 1 3
      #1 res=0; a=0; 
      #1 res=1;
      #4 a=1;
      #4 a=2;
      #4 a=2;
      #4 a=1;
      #4 a=1;
      #4 a=3;
      #4 a=1;
      #4 a=3;
      #3;
      $finish;
    end
endmodule

