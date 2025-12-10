module top(
  input clk,
  input ps2_clk,
  input ps2_data,
  output [15:0] data_v,
  output [15:0] ascii_v,
  output [15:0] count_v
);

  reg [7:0] data;
  reg flag;
  reg [7:0] count;

  wire ready;
  wire nextdata_n;
  wire overflow;
  wire [7:0] data_w;
  wire [7:0] ascii;

  always @(posedge clk) begin
    if(ready)begin
      
      if(data_w == 8'b11110000)begin
        data <= 8'b0;
        flag <= 1'b1;
        count <= count + 1;  
      end
      else begin
        flag <= 1'b0;
        data <= flag ? 8'b0 : data_w;
      end

      $display("receive %x", data_w);
    end


    if(overflow) begin
      $display("[%0t] PS/2 Keyboard Buffer Overflow!", $time);
      $warning("Keyboard buffer overflow detected!");
    end
  end

  pc2_keyboard pk(clk, 1'b1, ps2_clk, ps2_data, 
                data_w, ready, nextdata_n, overflow);
  assign nextdata_n = ~ready;






  keycode_to_ascii kta(data,ascii);

  bcd7seg b1(data[7:4],data_v[15:8]);
  bcd7seg b2(data[3:0],data_v[7:0]);
  bcd7seg b3(ascii[7:4],ascii_v[15:8]);
  bcd7seg b4(ascii[3:0],ascii_v[7:0]);
  bcd7seg b5(count[7:4],count_v[15:8]);
  bcd7seg b6(count[3:0],count_v[7:0]);

endmodule
