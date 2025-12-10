
module bcd7segPro(
  input  [3:0] in,
  output reg [15:0] out
);
  reg [7:0]pos;   
  reg [7:0]neg;

  reg [3:0] value;
  bcd7seg seg1(value, out[7:0]);

  always@(*)begin
    pos = ~(8'b11111101);
    neg = 8'b11111101;

    if(in[3])begin   //neg
        value = ~in + 1'b1;
        out[15:8] = neg;
    end
    else begin        //pos
        value = in;
        out[15:8] = pos;
    end

  end
endmodule
