//  A testbench for sbc_2_program1_single_step_tb
`timescale 1us/1ns

module sbc_2_program1_single_step_tb;
    reg clk;
    reg s1_n;
    reg s2_n;
    reg enter_n;
    reg back_n;
    reg run_n;
    reg [7:0] dip_n;
    wire [5:0] addr;
    wire [13:0] instr;
    wire [3:0] out;
    wire [2:0] led_n;

  sbc sbc0 (
    .clk(clk),
    .s1_n(s1_n),
    .s2_n(s2_n),
    .enter_n(enter_n),
    .back_n(back_n),
    .run_n(run_n),
    .dip_n(dip_n),
    .addr(addr),
    .instr(instr),
    .out(out),
    .led_n(led_n)
  );

    reg [40:0] patterns[0:413];
    integer i;

    initial begin
      patterns[0] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[1] = 41'b1_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[2] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[3] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[4] = 41'b1_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[5] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[6] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[7] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[8] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[9] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[10] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[11] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[12] = 41'b0_1_1_0_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[13] = 41'b1_1_1_0_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[14] = 41'b0_1_1_0_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[15] = 41'b0_1_1_0_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[16] = 41'b1_1_1_0_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[17] = 41'b0_1_1_0_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[18] = 41'b0_1_1_1_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[19] = 41'b1_1_1_1_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[20] = 41'b0_1_1_1_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[21] = 41'b0_1_1_1_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[22] = 41'b1_1_1_1_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[23] = 41'b0_1_1_1_1_1_11010111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[24] = 41'b0_1_1_1_1_1_11010111_000000_xxxxxxxxxxxxxx_xxxx_101;
      patterns[25] = 41'b0_1_1_0_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[26] = 41'b1_1_1_0_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[27] = 41'b0_1_1_0_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[28] = 41'b0_1_1_0_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[29] = 41'b1_1_1_0_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[30] = 41'b0_1_1_0_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[31] = 41'b0_1_1_1_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[32] = 41'b1_1_1_1_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[33] = 41'b0_1_1_1_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[34] = 41'b0_1_1_1_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[35] = 41'b1_1_1_1_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[36] = 41'b0_1_1_1_1_1_01111100_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[37] = 41'b0_1_1_1_1_1_01111100_000001_xxxxxxxxxxxxxx_xxxx_111;
      patterns[38] = 41'b0_1_1_0_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[39] = 41'b1_1_1_0_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[40] = 41'b0_1_1_0_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[41] = 41'b0_1_1_0_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[42] = 41'b1_1_1_0_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[43] = 41'b0_1_1_0_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[44] = 41'b0_1_1_1_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[45] = 41'b1_1_1_1_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[46] = 41'b0_1_1_1_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[47] = 41'b0_1_1_1_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[48] = 41'b1_1_1_1_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[49] = 41'b0_1_1_1_1_1_11010110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[50] = 41'b0_1_1_1_1_1_11010110_000001_xxxxxxxxxxxxxx_xxxx_101;
      patterns[51] = 41'b0_1_1_0_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[52] = 41'b1_1_1_0_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[53] = 41'b0_1_1_0_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[54] = 41'b0_1_1_0_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[55] = 41'b1_1_1_0_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[56] = 41'b0_1_1_0_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[57] = 41'b0_1_1_1_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[58] = 41'b1_1_1_1_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[59] = 41'b0_1_1_1_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[60] = 41'b0_1_1_1_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[61] = 41'b1_1_1_1_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[62] = 41'b0_1_1_1_1_1_11111110_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[63] = 41'b0_1_1_1_1_1_11111110_000010_xxxxxxxxxxxxxx_xxxx_111;
      patterns[64] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[65] = 41'b1_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[66] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[67] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[68] = 41'b1_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[69] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[70] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[71] = 41'b1_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[72] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[73] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[74] = 41'b1_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[75] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[76] = 41'b0_1_1_1_1_1_11110111_000010_xxxxxxxxxxxxxx_xxxx_101;
      patterns[77] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[78] = 41'b1_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[79] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[80] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[81] = 41'b1_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[82] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[83] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[84] = 41'b1_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[85] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[86] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[87] = 41'b1_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[88] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[89] = 41'b0_1_1_1_1_1_01110001_000011_xxxxxxxxxxxxxx_xxxx_111;
      patterns[90] = 41'b0_1_1_0_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[91] = 41'b1_1_1_0_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[92] = 41'b0_1_1_0_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[93] = 41'b0_1_1_0_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[94] = 41'b1_1_1_0_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[95] = 41'b0_1_1_0_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[96] = 41'b0_1_1_1_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[97] = 41'b1_1_1_1_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[98] = 41'b0_1_1_1_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[99] = 41'b0_1_1_1_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[100] = 41'b1_1_1_1_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[101] = 41'b0_1_1_1_1_1_11101011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[102] = 41'b0_1_1_1_1_1_11101011_000011_xxxxxxxxxxxxxx_xxxx_101;
      patterns[103] = 41'b0_1_1_0_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[104] = 41'b1_1_1_0_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[105] = 41'b0_1_1_0_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[106] = 41'b0_1_1_0_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[107] = 41'b1_1_1_0_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[108] = 41'b0_1_1_0_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[109] = 41'b0_1_1_1_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[110] = 41'b1_1_1_1_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[111] = 41'b0_1_1_1_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[112] = 41'b0_1_1_1_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[113] = 41'b1_1_1_1_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[114] = 41'b0_1_1_1_1_1_01011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[115] = 41'b0_1_1_1_1_1_01011111_000100_xxxxxxxxxxxxxx_xxxx_111;
      patterns[116] = 41'b0_1_1_0_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[117] = 41'b1_1_1_0_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[118] = 41'b0_1_1_0_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[119] = 41'b0_1_1_0_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[120] = 41'b1_1_1_0_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[121] = 41'b0_1_1_0_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[122] = 41'b0_1_1_1_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[123] = 41'b1_1_1_1_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[124] = 41'b0_1_1_1_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[125] = 41'b0_1_1_1_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[126] = 41'b1_1_1_1_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[127] = 41'b0_1_1_1_1_1_11100011_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[128] = 41'b0_1_1_1_1_1_11100011_000100_xxxxxxxxxxxxxx_xxxx_101;
      patterns[129] = 41'b0_1_1_0_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[130] = 41'b1_1_1_0_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[131] = 41'b0_1_1_0_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[132] = 41'b0_1_1_0_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[133] = 41'b1_1_1_0_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[134] = 41'b0_1_1_0_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[135] = 41'b0_1_1_1_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[136] = 41'b1_1_1_1_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[137] = 41'b0_1_1_1_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[138] = 41'b0_1_1_1_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[139] = 41'b1_1_1_1_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[140] = 41'b0_1_1_1_1_1_11111101_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[141] = 41'b0_1_1_1_1_1_11111101_000101_xxxxxxxxxxxxxx_xxxx_111;
      patterns[142] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[143] = 41'b1_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[144] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[145] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[146] = 41'b1_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[147] = 41'b0_1_1_0_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[148] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[149] = 41'b1_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[150] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[151] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[152] = 41'b1_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[153] = 41'b0_1_1_1_1_1_11110111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[154] = 41'b0_1_1_1_1_1_11110111_000101_xxxxxxxxxxxxxx_xxxx_101;
      patterns[155] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[156] = 41'b1_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[157] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[158] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[159] = 41'b1_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[160] = 41'b0_1_1_0_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[161] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[162] = 41'b1_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[163] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[164] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[165] = 41'b1_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[166] = 41'b0_1_1_1_1_1_01110001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[167] = 41'b0_1_1_1_1_1_01110001_000110_xxxxxxxxxxxxxx_xxxx_111;
      patterns[168] = 41'b0_1_1_0_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[169] = 41'b1_1_1_0_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[170] = 41'b0_1_1_0_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[171] = 41'b0_1_1_0_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[172] = 41'b1_1_1_0_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[173] = 41'b0_1_1_0_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[174] = 41'b0_1_1_1_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[175] = 41'b1_1_1_1_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[176] = 41'b0_1_1_1_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[177] = 41'b0_1_1_1_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[178] = 41'b1_1_1_1_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[179] = 41'b0_1_1_1_1_1_11011111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[180] = 41'b0_1_1_1_1_1_11011111_000110_xxxxxxxxxxxxxx_xxxx_101;
      patterns[181] = 41'b0_1_1_0_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[182] = 41'b1_1_1_0_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[183] = 41'b0_1_1_0_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[184] = 41'b0_1_1_0_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[185] = 41'b1_1_1_0_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[186] = 41'b0_1_1_0_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[187] = 41'b0_1_1_1_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[188] = 41'b1_1_1_1_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[189] = 41'b0_1_1_1_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[190] = 41'b0_1_1_1_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[191] = 41'b1_1_1_1_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[192] = 41'b0_1_1_1_1_1_11111001_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[193] = 41'b0_1_1_1_1_1_11111001_000111_xxxxxxxxxxxxxx_xxxx_111;
      patterns[194] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[195] = 41'b1_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[196] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[197] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[198] = 41'b1_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[199] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[200] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[201] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[202] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[203] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[204] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[205] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[206] = 41'b0_0_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[207] = 41'b1_0_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[208] = 41'b0_0_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[209] = 41'b0_0_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[210] = 41'b1_0_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[211] = 41'b0_0_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[212] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[213] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[214] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[215] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[216] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[217] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[218] = 41'b0_1_1_1_1_1_11111111_000000_10100010000011_xxxx_110;
      patterns[219] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[220] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[221] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[222] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[223] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[224] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[225] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[226] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[227] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[228] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[229] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[230] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[231] = 41'b0_1_1_1_1_1_11111111_000001_10100100000001_xxxx_110;
      patterns[232] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[233] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[234] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[235] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[236] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[237] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[238] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[239] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[240] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[241] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[242] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[243] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[244] = 41'b0_1_1_1_1_1_11111111_000010_00100010001110_xxxx_110;
      patterns[245] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[246] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[247] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[248] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[249] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[250] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[251] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[252] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[253] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[254] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[255] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[256] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[257] = 41'b0_1_1_1_1_1_11111111_000011_01010010100000_0011_110;
      patterns[258] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[259] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[260] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[261] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[262] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[263] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[264] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[265] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[266] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[267] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[268] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[269] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[270] = 41'b0_1_1_1_1_1_11111111_000100_01110000000010_0011_110;
      patterns[271] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[272] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[273] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[274] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[275] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[276] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[277] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[278] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[279] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[280] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[281] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[282] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[283] = 41'b0_1_1_1_1_1_11111111_000010_00100010001110_0011_110;
      patterns[284] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[285] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[286] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[287] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[288] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[289] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[290] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[291] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[292] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[293] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[294] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[295] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[296] = 41'b0_1_1_1_1_1_11111111_000011_01010010100000_0010_110;
      patterns[297] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[298] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[299] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[300] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[301] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[302] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[303] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[304] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[305] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[306] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[307] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[308] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[309] = 41'b0_1_1_1_1_1_11111111_000100_01110000000010_0010_110;
      patterns[310] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[311] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[312] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[313] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[314] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[315] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[316] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[317] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[318] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[319] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[320] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[321] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[322] = 41'b0_1_1_1_1_1_11111111_000010_00100010001110_0010_110;
      patterns[323] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[324] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[325] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[326] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[327] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[328] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[329] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[330] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[331] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[332] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[333] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[334] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[335] = 41'b0_1_1_1_1_1_11111111_000011_01010010100000_0001_110;
      patterns[336] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[337] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[338] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[339] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[340] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[341] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[342] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[343] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[344] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[345] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[346] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[347] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[348] = 41'b0_1_1_1_1_1_11111111_000100_01110000000010_0001_110;
      patterns[349] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[350] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[351] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[352] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[353] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[354] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[355] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[356] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[357] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[358] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[359] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[360] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[361] = 41'b0_1_1_1_1_1_11111111_000101_00100010001110_0001_110;
      patterns[362] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[363] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[364] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[365] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[366] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[367] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[368] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[369] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[370] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[371] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[372] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[373] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[374] = 41'b0_1_1_1_1_1_11111111_000110_10000000000110_0000_110;
      patterns[375] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[376] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[377] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[378] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[379] = 41'b1_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[380] = 41'b0_1_1_0_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[381] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[382] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[383] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[384] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[385] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[386] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[387] = 41'b0_1_1_1_1_1_11111111_000110_10000000000110_0000_110;
      patterns[388] = 41'b0_1_1_1_1_0_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[389] = 41'b1_1_1_1_1_0_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[390] = 41'b0_1_1_1_1_0_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[391] = 41'b0_1_1_1_1_0_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[392] = 41'b1_1_1_1_1_0_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[393] = 41'b0_1_1_1_1_0_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[394] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[395] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[396] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[397] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[398] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[399] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[400] = 41'b0_1_1_1_1_1_11111111_000110_xxxxxxxxxxxxxx_xxxx_110;
      patterns[401] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[402] = 41'b1_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[403] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[404] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[405] = 41'b1_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[406] = 41'b0_1_0_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[407] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[408] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[409] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[410] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[411] = 41'b1_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[412] = 41'b0_1_1_1_1_1_11111111_xxxxxx_xxxxxxxxxxxxxx_xxxx_xxx;
      patterns[413] = 41'b0_1_1_1_1_1_11111111_000000_10100010000011_xxxx_111;

      for (i = 0; i < 414; i = i + 1)
      begin
        clk = patterns[i][40];
        s1_n = patterns[i][39];
        s2_n = patterns[i][38];
        enter_n = patterns[i][37];
        back_n = patterns[i][36];
        run_n = patterns[i][35];
        dip_n = patterns[i][34:27];
        #10;
        if (patterns[i][26:21] !== 6'hx)
        begin
          if (addr !== patterns[i][26:21])
          begin
            $display("%d:addr: (assertion error). Expected %h, found %h", i, patterns[i][26:21], addr);
            $finish;
          end
        end
        if (patterns[i][20:7] !== 14'hx)
        begin
          if (instr !== patterns[i][20:7])
          begin
            $display("%d:instr: (assertion error). Expected %h, found %h", i, patterns[i][20:7], instr);
            $finish;
          end
        end
        if (patterns[i][6:3] !== 4'hx)
        begin
          if (out !== patterns[i][6:3])
          begin
            $display("%d:out: (assertion error). Expected %h, found %h", i, patterns[i][6:3], out);
            $finish;
          end
        end
        if (patterns[i][2:0] !== 3'hx)
        begin
          if (led_n !== patterns[i][2:0])
          begin
            $display("%d:led_n: (assertion error). Expected %h, found %h", i, patterns[i][2:0], led_n);
            $finish;
          end
        end
      end

      $display("All tests passed.");
    end
    endmodule
