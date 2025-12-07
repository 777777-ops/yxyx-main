module top(
  input [7:0] in,
  input       en,
  output      sign,
  output [2:0] binary_out,
  output [7:0] led
);

  p_encoder pri(in, en ,sign, binary_out);
  bcd7seg bcd({1'b0, binary_out}, led);

endmodule
