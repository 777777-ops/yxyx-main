module keycode_to_ascii(
    input [7:0] keycode,  // 键码输入
    output reg [7:0] ascii  // ASCII输出
);

// 组合逻辑直接转换
always @(*) begin
    case (keycode)
        // ---------- 数字键 (主键盘区) ----------
        8'h45: ascii = 8'h30; // 0 → ASCII '0' (0x30)
        8'h16: ascii = 8'h31; // 1 → ASCII '1'
        8'h1E: ascii = 8'h32; // 2
        8'h26: ascii = 8'h33; // 3
        8'h25: ascii = 8'h34; // 4
        8'h2E: ascii = 8'h35; // 5
        8'h36: ascii = 8'h36; // 6
        8'h3D: ascii = 8'h37; // 7
        8'h3E: ascii = 8'h38; // 8
        8'h46: ascii = 8'h39; // 9
        
        // ---------- 字母键 ----------
        8'h1C: ascii = 8'h61; // A → ASCII 'a'
        8'h32: ascii = 8'h62; // B → 'b'
        8'h21: ascii = 8'h63; // C → 'c'
        8'h23: ascii = 8'h64; // D → 'd'
        8'h24: ascii = 8'h65; // E → 'e'
        8'h2B: ascii = 8'h66; // F → 'f'
        8'h34: ascii = 8'h67; // G → 'g'
        8'h33: ascii = 8'h68; // H → 'h'
        8'h43: ascii = 8'h69; // I → 'i'
        8'h3B: ascii = 8'h6A; // J → 'j'
        8'h42: ascii = 8'h6B; // K → 'k'
        8'h4B: ascii = 8'h6C; // L → 'l'
        8'h3A: ascii = 8'h6D; // M → 'm'
        8'h31: ascii = 8'h6E; // N → 'n'
        8'h44: ascii = 8'h6F; // O → 'o'
        8'h4D: ascii = 8'h70; // P → 'p'
        8'h15: ascii = 8'h71; // Q → 'q'
        8'h2D: ascii = 8'h72; // R → 'r'
        8'h1B: ascii = 8'h73; // S → 's'
        8'h2C: ascii = 8'h74; // T → 't'
        8'h3C: ascii = 8'h75; // U → 'u'
        8'h2A: ascii = 8'h76; // V → 'v'
        8'h1D: ascii = 8'h77; // W → 'w'
        8'h22: ascii = 8'h78; // X → 'x'
        8'h35: ascii = 8'h79; // Y → 'y'
        8'h1A: ascii = 8'h7A; // Z → 'z'
        
        // ---------- 默认值 ----------
        default: ascii = 8'h00; // 非字符数字键输出0
    endcase
end

endmodule

