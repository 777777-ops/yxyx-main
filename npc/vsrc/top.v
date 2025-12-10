module top(
  input [3:0] a,
  input [3:0] b,
  input [2:0] sel,

  output reg [15:0] visual_a,
  output reg [15:0] visual_b,
  output reg [15:0] visual_result,
  output reg overflow,
  output reg zero,
  output reg carry, 
  output reg [3:0] result,
  output reg less,
  output reg equal
);

  bcd7segPro bpa(a, visual_a);
  bcd7segPro bpb(b, visual_b);
  bcd7segPro bpc(result, visual_result);

  wire [3:0] b_neg;
  assign b_neg = ~b + 1'b1;

  always @(*) begin
    result = 4'b0;
    overflow = 1'b0;
    zero = 1'b0;
    carry = 1'b0;
    less = 1'b0;
    equal = 1'b0;

    case (sel)
      3'b000:begin
        result = a + b;
        overflow = (a[3] ~^ b[3]) & (result[3] ^ a[3]);
        zero = !(|result);
      end
      3'b001:begin
        result = a + b_neg;
        overflow = (a[3] ~^ b_neg[3]) & (result[3] ^ a[3]);
        zero = !(|result);
      end
      3'b010:begin
        result = ~a;
      end
      3'b011:begin
        result = a & b;
      end
      3'b100:begin
        result = a | b;
      end
      3'b101:begin
        result = a ^ b;
      end
      3'b110:begin
        result = a + b_neg;
        overflow = (a[3] ~^ b_neg[3]) & (result[3] ^ a[3]);
        less = overflow ^ result[3];
      end
      3'b111:begin
        result = a + b_neg;
        equal = !(|result);
      end
    endcase
  end
endmodule

