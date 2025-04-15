`timescale 1ns / 1ps

module top_bits_to_bytes (
    input logic clk,   
    input logic rst,      
    input logic btn,      
    output logic led     
);

    localparam BIT_LENGTH = 2048;
    localparam BYTE_LENGTH = BIT_LENGTH / 8;

    logic [BIT_LENGTH-1:0] bit_array;        
    logic [7:0] byte_array [0:BYTE_LENGTH-1];
    logic byte_match;                        

    assign bit_array = 2048'b00000001000000100000001100000100000001010000011000000111000010000000100100001010000010110000110000001101000011100000111100010000000100010001001000010011000101000001010100010110000101110001100000011001000110100001101100011100000111010001111000011111001000000010000100100010001000110010010000100101001001100010011100101000001010010010101000101011001011000010110100101110001011110011000000110001001100100011001100110100001101010011011000110111001110000011100100111010001110110011110000111101001111100011111101000000010000010100001001000011010001000100010101000110010001110100100001001001010010100100101101001100010011010100111001001111010100000101000101010010010100110101010001010101010101100101011101011000010110010101101001011011010111000101110101011110010111110110000001100001011000100110001101100100011001010110011001100111011010000110100101101010011010110110110001101101011011100110111101110000011100010111001001110011011101000111010101110110011101110111100001111001011110100111101101111100011111010111111001111111100000001000000110000010100000111000010010000101100001101000011110001000100010011000101010001011100011001000110110001110100011111001000010010001100100101001001110010100100101011001011010010111100110001001100110011010100110111001110010011101100111101001111110100000101000011010001010100011101001001010010110100110101001111010100010101001101010101010101110101100101011011010111010101111101100001011000110110010101100111011010010110101101101101011011110111000101110011011101010111011101111001011110110111110101111111100000011000001110000101100001111000100110001011100011011000111110010001100100111001010110010111100110011001101110011101100111111010000110100011101001011010011110101001101010111010110110101111101100011011001110110101101101111011100110111011101111011011111111000001110000111100010111000111110010011100101111001101110011111101000111010011110101011101011111011001110110111101110111011111111000011110001111100101111001111110100111101011111011011110111111110001111100111111010111110111111110011111101111111101111111100000000;

    bits_to_bytes #(
        .BIT_LENGTH(BIT_LENGTH),
        .BYTE_LENGTH(BYTE_LENGTH)
    ) bits_to_bytes_inst (
        .bit_array(bit_array),
        .byte_array(byte_array)
    );

    always_comb begin
        byte_match = (byte_array[0] == 8'd128) &&
                     (byte_array[1] == 8'd64)  &&
                     (byte_array[2] == 8'd192) &&
                     (byte_array[3] == 8'd32)  &&
                     (byte_array[4] == 8'd160) &&
                     (byte_array[5] == 8'd96)  &&
                     (byte_array[6] == 8'd224) &&
                     (byte_array[7] == 8'd16)  &&
                     (byte_array[8] == 8'd144) &&
                     (byte_array[9] == 8'd80)  &&
                     (byte_array[10] == 8'd208) &&
                     (byte_array[11] == 8'd48)  &&
                     (byte_array[12] == 8'd176) &&
                     (byte_array[13] == 8'd112) &&
                     (byte_array[14] == 8'd240) &&
                     (byte_array[15] == 8'd8)   &&
                     (byte_array[16] == 8'd136) &&
                     (byte_array[17] == 8'd72)  &&
                     (byte_array[18] == 8'd200) &&
                     (byte_array[19] == 8'd40)  &&
                     (byte_array[20] == 8'd168) &&
                     (byte_array[21] == 8'd104) &&
                     (byte_array[22] == 8'd232) &&
                     (byte_array[23] == 8'd24)  &&
                     (byte_array[24] == 8'd152) &&
                     (byte_array[25] == 8'd88)  &&
                     (byte_array[26] == 8'd216) &&
                     (byte_array[27] == 8'd56)  &&
                     (byte_array[28] == 8'd184) &&
                     (byte_array[29] == 8'd120) &&
                     (byte_array[30] == 8'd248) &&
                     (byte_array[31] == 8'd4)   &&
                     (byte_array[32] == 8'd132) &&
                     (byte_array[33] == 8'd68)  &&
                     (byte_array[34] == 8'd196) &&
                     (byte_array[35] == 8'd36)  &&
                     (byte_array[36] == 8'd164) &&
                     (byte_array[37] == 8'd100) &&
                     (byte_array[38] == 8'd228) &&
                     (byte_array[39] == 8'd20)  &&
                     (byte_array[40] == 8'd148) &&
                     (byte_array[41] == 8'd84)  &&
                     (byte_array[42] == 8'd212) &&
                     (byte_array[43] == 8'd52)  &&
                     (byte_array[44] == 8'd180) &&
                     (byte_array[45] == 8'd116) &&
                     (byte_array[46] == 8'd244) &&
                     (byte_array[47] == 8'd12)  &&
                     (byte_array[48] == 8'd140) &&
                     (byte_array[49] == 8'd76)  &&
                     (byte_array[50] == 8'd204) &&
                     (byte_array[51] == 8'd44)  &&
                     (byte_array[52] == 8'd172) &&
                     (byte_array[53] == 8'd108) &&
                     (byte_array[54] == 8'd236) &&
                     (byte_array[55] == 8'd28)  &&
                     (byte_array[56] == 8'd156) &&
                     (byte_array[57] == 8'd92)  &&
                     (byte_array[58] == 8'd220) &&
                     (byte_array[59] == 8'd60)  &&
                     (byte_array[60] == 8'd188) &&
                     (byte_array[61] == 8'd124) &&
                     (byte_array[62] == 8'd252) &&
                     (byte_array[63] == 8'd2)   &&
                     (byte_array[64] == 8'd130) &&
                     (byte_array[65] == 8'd66)  &&
                     (byte_array[66] == 8'd194) &&
                     (byte_array[67] == 8'd34)  &&
                     (byte_array[68] == 8'd162) &&
                     (byte_array[69] == 8'd98)  &&
                     (byte_array[70] == 8'd226) &&
                     (byte_array[71] == 8'd18)  &&
                     (byte_array[72] == 8'd146) &&
                     (byte_array[73] == 8'd82)  &&
                     (byte_array[74] == 8'd210) &&
                     (byte_array[75] == 8'd50)  &&
                     (byte_array[76] == 8'd178) &&
                     (byte_array[77] == 8'd114) &&
                     (byte_array[78] == 8'd242) &&
                     (byte_array[79] == 8'd10)  &&
                     (byte_array[80] == 8'd138) &&
                     (byte_array[81] == 8'd74)  &&
                     (byte_array[82] == 8'd202) &&
                     (byte_array[83] == 8'd42)  &&
                     (byte_array[84] == 8'd170) &&
                     (byte_array[85] == 8'd106) &&
                     (byte_array[86] == 8'd234) &&
                     (byte_array[87] == 8'd26)  &&
                     (byte_array[88] == 8'd154) &&
                     (byte_array[89] == 8'd90)  &&
                     (byte_array[90] == 8'd218) &&
                     (byte_array[91] == 8'd58)  &&
                     (byte_array[92] == 8'd186) &&
                     (byte_array[93] == 8'd122) &&
                     (byte_array[94] == 8'd250) &&
                     (byte_array[95] == 8'd6)   &&
                     (byte_array[96] == 8'd134) &&
                     (byte_array[97] == 8'd70)  &&
                     (byte_array[98] == 8'd198) &&
                     (byte_array[99] == 8'd38)  &&
                     (byte_array[100] == 8'd166) &&
                     (byte_array[101] == 8'd102) &&
                     (byte_array[102] == 8'd230) &&
                     (byte_array[103] == 8'd22)  &&
                     (byte_array[104] == 8'd150) &&
                     (byte_array[105] == 8'd86)  &&
                     (byte_array[106] == 8'd214) &&
                     (byte_array[107] == 8'd54)  &&
                     (byte_array[108] == 8'd182) &&
                     (byte_array[109] == 8'd118) &&
                     (byte_array[110] == 8'd246) &&
                     (byte_array[111] == 8'd14)  &&
                     (byte_array[112] == 8'd142) &&
                     (byte_array[113] == 8'd78)  &&
                     (byte_array[114] == 8'd206) &&
                     (byte_array[115] == 8'd46)  &&
                     (byte_array[116] == 8'd174) &&
                     (byte_array[117] == 8'd110) &&
                     (byte_array[118] == 8'd238) &&
                     (byte_array[119] == 8'd30)  &&
                     (byte_array[120] == 8'd158) &&
                     (byte_array[121] == 8'd94)  &&
                     (byte_array[122] == 8'd222) &&
                     (byte_array[123] == 8'd62)  &&
                     (byte_array[124] == 8'd190) &&
                     (byte_array[125] == 8'd126) &&
                     (byte_array[126] == 8'd254) &&
                     (byte_array[127] == 8'd1)   &&
                     (byte_array[128] == 8'd129) &&
                     (byte_array[129] == 8'd65)  &&
                     (byte_array[130] == 8'd193) &&
                     (byte_array[131] == 8'd33)  &&
                     (byte_array[132] == 8'd161) &&
                     (byte_array[133] == 8'd97)  &&
                     (byte_array[134] == 8'd225) &&
                     (byte_array[135] == 8'd17)  &&
                     (byte_array[136] == 8'd145) &&
                     (byte_array[137] == 8'd81)  &&
                     (byte_array[138] == 8'd209) &&
                     (byte_array[139] == 8'd49)  &&
                     (byte_array[140] == 8'd177) &&
                     (byte_array[141] == 8'd113) &&
                     (byte_array[142] == 8'd241) &&
                     (byte_array[143] == 8'd9)   &&
                     (byte_array[144] == 8'd137) &&
                     (byte_array[145] == 8'd73)  &&
                     (byte_array[146] == 8'd201) &&
                     (byte_array[147] == 8'd41)  &&
                     (byte_array[148] == 8'd169) &&
                     (byte_array[149] == 8'd105) &&
                     (byte_array[150] == 8'd233) &&
                     (byte_array[151] == 8'd25)  &&
                     (byte_array[152] == 8'd153) &&
                     (byte_array[153] == 8'd89)  &&
                     (byte_array[154] == 8'd217) &&
                     (byte_array[155] == 8'd57)  &&
                     (byte_array[156] == 8'd185) &&
                     (byte_array[157] == 8'd121) &&
                     (byte_array[158] == 8'd249) &&
                     (byte_array[159] == 8'd5)   &&
                     (byte_array[160] == 8'd133) &&
                     (byte_array[161] == 8'd69)  &&
                     (byte_array[162] == 8'd197) &&
                     (byte_array[163] == 8'd37)  &&
                     (byte_array[164] == 8'd165) &&
                     (byte_array[165] == 8'd101) &&
                     (byte_array[166] == 8'd229) &&
                     (byte_array[167] == 8'd21)  &&
                     (byte_array[168] == 8'd149) &&
                     (byte_array[169] == 8'd85)  &&
                     (byte_array[170] == 8'd213) &&
                     (byte_array[171] == 8'd53)  &&
                     (byte_array[172] == 8'd181) &&
                     (byte_array[173] == 8'd117) &&
                     (byte_array[174] == 8'd245) &&
                     (byte_array[175] == 8'd13)  &&
                     (byte_array[176] == 8'd141) &&
                     (byte_array[177] == 8'd77)  &&
                     (byte_array[178] == 8'd205) &&
                     (byte_array[179] == 8'd45)  &&
                     (byte_array[180] == 8'd173) &&
                     (byte_array[181] == 8'd109) &&
                     (byte_array[182] == 8'd237) &&
                     (byte_array[183] == 8'd29)  &&
                     (byte_array[184] == 8'd157) &&
                     (byte_array[185] == 8'd93)  &&
                     (byte_array[186] == 8'd221) &&
                     (byte_array[187] == 8'd61)  &&
                     (byte_array[188] == 8'd189) &&
                     (byte_array[189] == 8'd125) &&
                     (byte_array[190] == 8'd253) &&
                     (byte_array[191] == 8'd3)   &&
                     (byte_array[192] == 8'd131) &&
                     (byte_array[193] == 8'd67)  &&
                     (byte_array[194] == 8'd195) &&
                     (byte_array[195] == 8'd35)  &&
                     (byte_array[196] == 8'd163) &&
                     (byte_array[197] == 8'd99)  &&
                     (byte_array[198] == 8'd227) &&
                     (byte_array[199] == 8'd19)  &&
                     (byte_array[200] == 8'd147) &&
                     (byte_array[201] == 8'd83)  &&
                     (byte_array[202] == 8'd211) &&
                     (byte_array[203] == 8'd51)  &&
                     (byte_array[204] == 8'd179) &&
                     (byte_array[205] == 8'd115) &&
                     (byte_array[206] == 8'd243) &&
                     (byte_array[207] == 8'd11)  &&
                     (byte_array[208] == 8'd139) &&
                     (byte_array[209] == 8'd75)  &&
                     (byte_array[210] == 8'd203) &&
                     (byte_array[211] == 8'd43)  &&
                     (byte_array[212] == 8'd171) &&
                     (byte_array[213] == 8'd107) &&
                     (byte_array[214] == 8'd235) &&
                     (byte_array[215] == 8'd27)  &&
                     (byte_array[216] == 8'd155) &&
                     (byte_array[217] == 8'd91)  &&
                     (byte_array[218] == 8'd219) &&
                     (byte_array[219] == 8'd59)  &&
                     (byte_array[220] == 8'd187) &&
                     (byte_array[221] == 8'd123) &&
                     (byte_array[222] == 8'd251) &&
                     (byte_array[223] == 8'd7)   &&
                     (byte_array[224] == 8'd135) &&
                     (byte_array[225] == 8'd71)  &&
                     (byte_array[226] == 8'd199) &&
                     (byte_array[227] == 8'd39)  &&
                     (byte_array[228] == 8'd167) &&
                     (byte_array[229] == 8'd103) &&
                     (byte_array[230] == 8'd231) &&
                     (byte_array[231] == 8'd23)  &&
                     (byte_array[232] == 8'd151) &&
                     (byte_array[233] == 8'd87)  &&
                     (byte_array[234] == 8'd215) &&
                     (byte_array[235] == 8'd55)  &&
                     (byte_array[236] == 8'd183) &&
                     (byte_array[237] == 8'd119) &&
                     (byte_array[238] == 8'd247) &&
                     (byte_array[239] == 8'd15)  &&
                     (byte_array[240] == 8'd143) &&
                     (byte_array[241] == 8'd79)  &&
                     (byte_array[242] == 8'd207) &&
                     (byte_array[243] == 8'd47)  &&
                     (byte_array[244] == 8'd175) &&
                     (byte_array[245] == 8'd111) &&
                     (byte_array[246] == 8'd239) &&
                     (byte_array[247] == 8'd31)  &&
                     (byte_array[248] == 8'd159) &&
                     (byte_array[249] == 8'd95)  &&
                     (byte_array[250] == 8'd223) &&
                     (byte_array[251] == 8'd63)  &&
                     (byte_array[252] == 8'd191) &&
                     (byte_array[253] == 8'd127) &&
                     (byte_array[254] == 8'd255) &&
                     (byte_array[255] == 8'd0);
    end

    always_comb begin
        if (rst) begin
            led = 1'b0;
        end else if (btn) begin
            led = byte_match ? 1'b1 : 1'b0;
        end else begin
            led = 1'b0;
        end
    end

endmodule