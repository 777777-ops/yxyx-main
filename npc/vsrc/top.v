module top(
  input clk,
  output [15:0] num,
  output [7:0] led
);

  reg [7:0] state;
  reg [7:0] next_state;

  always@(*)begin
    if(state == 8'b0)
      next_state = 8'b1;
    else begin
      next_state = {(state[0] ^ state[2] ^ state[3] ^ state[4]), state[7:1]};
    end
  end

  always@(posedge clk)begin
    state <= next_state;
  end

  assign led = state;
  bcd7seg bcd1(state[7:4], num[15:8]);
  bcd7seg bcd2(state[3:0], num[7:0]);
endmodule
