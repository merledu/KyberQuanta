`timescale 1ns / 1ps

module tb_inverse_ntt;

    // Parameters
    parameter N = 256;
    parameter Q = 3329;
    parameter F = 3303;

    // DUT signals
    logic clk;
    logic rst;
    logic start_ntt;
    logic done_ntt;
    logic signed [31:0] f_in [0:N-1];
    logic signed [31:0] f_out [0:N-1];

    // Instantiate your Inverse NTT module (with counters/ state machine)
    inverse_ntt #(.N(N), .Q(Q), .F(F)) dut (
        .clk       (clk),
        .rst       (rst),
        .f         (f_in),
        .start_ntt (start_ntt),
        .done_ntt  (done_ntt),
        .f_hat     (f_out)
    );

    // Generate clock (period = 10 ns)
    initial clk = 0;
    always #5 clk = ~clk; 

    // Initialize input array with the 256 values from Python's f_ntt
    initial begin
        f_in[0]   = 2877;
        f_in[1]   = 239;
        f_in[2]   = 752;
        f_in[3]   = 1623;
        f_in[4]   = 488;
        f_in[5]   = 886;
        f_in[6]   = 2299;
        f_in[7]   = 1991;
        f_in[8]   = 835;
        f_in[9]   = 1621;
        f_in[10]  = 838;
        f_in[11]  = 2650;
        f_in[12]  = 516;
        f_in[13]  = 197;
        f_in[14]  = 1678;
        f_in[15]  = 1784;
        f_in[16]  = 2172;
        f_in[17]  = 2139;
        f_in[18]  = 1545;
        f_in[19]  = 1098;
        f_in[20]  = 1669;
        f_in[21]  = 2226;
        f_in[22]  = 996;
        f_in[23]  = 1610;
        f_in[24]  = 2720;
        f_in[25]  = 1037;
        f_in[26]  = 2551;
        f_in[27]  = 800;
        f_in[28]  = 3;
        f_in[29]  = 1574;
        f_in[30]  = 639;
        f_in[31]  = 748;
        f_in[32]  = 385;
        f_in[33]  = 244;
        f_in[34]  = 497;
        f_in[35]  = 2501;
        f_in[36]  = 57;
        f_in[37]  = 824;
        f_in[38]  = 119;
        f_in[39]  = 2243;
        f_in[40]  = 3229;
        f_in[41]  = 1372;
        f_in[42]  = 2449;
        f_in[43]  = 1436;
        f_in[44]  = 2723;
        f_in[45]  = 3276;
        f_in[46]  = 1940;
        f_in[47]  = 1994;
        f_in[48]  = 3227;
        f_in[49]  = 312;
        f_in[50]  = 2537;
        f_in[51]  = 3251;
        f_in[52]  = 3191;
        f_in[53]  = 483;
        f_in[54]  = 1597;
        f_in[55]  = 1224;
        f_in[56]  = 2598;
        f_in[57]  = 3214;
        f_in[58]  = 1192;
        f_in[59]  = 355;
        f_in[60]  = 2369;
        f_in[61]  = 1945;
        f_in[62]  = 1279;
        f_in[63]  = 341;
        f_in[64]  = 1713;
        f_in[65]  = 1723;
        f_in[66]  = 1259;
        f_in[67]  = 1492;
        f_in[68]  = 516;
        f_in[69]  = 1567;
        f_in[70]  = 721;
        f_in[71]  = 57;
        f_in[72]  = 2821;
        f_in[73]  = 1635;
        f_in[74]  = 2659;
        f_in[75]  = 2364;
        f_in[76]  = 690;
        f_in[77]  = 1751;
        f_in[78]  = 2494;
        f_in[79]  = 1354;
        f_in[80]  = 2600;
        f_in[81]  = 3166;
        f_in[82]  = 2532;
        f_in[83]  = 17;
        f_in[84]  = 2931;
        f_in[85]  = 388;
        f_in[86]  = 1309;
        f_in[87]  = 2495;
        f_in[88]  = 2669;
        f_in[89]  = 1523;
        f_in[90]  = 3107;
        f_in[91]  = 3066;
        f_in[92]  = 204;
        f_in[93]  = 717;
        f_in[94]  = 1701;
        f_in[95]  = 1314;
        f_in[96]  = 1705;
        f_in[97]  = 1926;
        f_in[98]  = 2233;
        f_in[99]  = 2436;
        f_in[100] = 1099;
        f_in[101] = 55;
        f_in[102] = 2610;
        f_in[103] = 1872;
        f_in[104] = 1096;
        f_in[105] = 878;
        f_in[106] = 2095;
        f_in[107] = 2770;
        f_in[108] = 3047;
        f_in[109] = 1026;
        f_in[110] = 1405;
        f_in[111] = 1180;
        f_in[112] = 771;
        f_in[113] = 750;
        f_in[114] = 2920;
        f_in[115] = 2074;
        f_in[116] = 376;
        f_in[117] = 3260;
        f_in[118] = 1610;
        f_in[119] = 2763;
        f_in[120] = 1325;
        f_in[121] = 1573;
        f_in[122] = 1167;
        f_in[123] = 647;
        f_in[124] = 1582;
        f_in[125] = 995;
        f_in[126] = 329;
        f_in[127] = 3063;
        f_in[128] = 2655;
        f_in[129] = 2924;
        f_in[130] = 1861;
        f_in[131] = 2662;
        f_in[132] = 1386;
        f_in[133] = 1751;
        f_in[134] = 2490;
        f_in[135] = 1269;
        f_in[136] = 1152;
        f_in[137] = 2783;
        f_in[138] = 568;
        f_in[139] = 1237;
        f_in[140] = 1562;
        f_in[141] = 2915;
        f_in[142] = 518;
        f_in[143] = 1653;
        f_in[144] = 3157;
        f_in[145] = 3101;
        f_in[146] = 2546;
        f_in[147] = 3304;
        f_in[148] = 165;
        f_in[149] = 841;
        f_in[150] = 1273;
        f_in[151] = 1169;
        f_in[152] = 2742;
        f_in[153] = 1880;
        f_in[154] = 2986;
        f_in[155] = 2945;
        f_in[156] = 3228;
        f_in[157] = 1056;
        f_in[158] = 169;
        f_in[159] = 1594;
        f_in[160] = 2436;
        f_in[161] = 1455;
        f_in[162] = 327;
        f_in[163] = 3093;
        f_in[164] = 643;
        f_in[165] = 1077;
        f_in[166] = 1576;
        f_in[167] = 1528;
        f_in[168] = 1769;
        f_in[169] = 860;
        f_in[170] = 808;
        f_in[171] = 1004;
        f_in[172] = 1700;
        f_in[173] = 2030;
        f_in[174] = 183;
        f_in[175] = 1557;
        f_in[176] = 1784;
        f_in[177] = 1412;
        f_in[178] = 2176;
        f_in[179] = 2815;
        f_in[180] = 210;
        f_in[181] = 2088;
        f_in[182] = 2586;
        f_in[183] = 1959;
        f_in[184] = 2374;
        f_in[185] = 878;
        f_in[186] = 2950;
        f_in[187] = 183;
        f_in[188] = 2267;
        f_in[189] = 1757;
        f_in[190] = 2250;
        f_in[191] = 629;
        f_in[192] = 2849;
        f_in[193] = 1405;
        f_in[194] = 3117;
        f_in[195] = 944;
        f_in[196] = 1722;
        f_in[197] = 1446;
        f_in[198] = 1645;
        f_in[199] = 209;
        f_in[200] = 2320;
        f_in[201] = 1758;
        f_in[202] = 454;
        f_in[203] = 415;
        f_in[204] = 205;
        f_in[205] = 1075;
        f_in[206] = 1666;
        f_in[207] = 979;
        f_in[208] = 3012;
        f_in[209] = 319;
        f_in[210] = 3057;
        f_in[211] = 3055;
        f_in[212] = 274;
        f_in[213] = 1975;
        f_in[214] = 1096;
        f_in[215] = 1949;
        f_in[216] = 1046;
        f_in[217] = 1879;
        f_in[218] = 1766;
        f_in[219] = 1165;
        f_in[220] = 437;
        f_in[221] = 495;
        f_in[222] = 1691;
        f_in[223] = 2753;
        f_in[224] = 2645;
        f_in[225] = 1850;
        f_in[226] = 2816;
        f_in[227] = 2997;
        f_in[228] = 1585;
        f_in[229] = 2288;
        f_in[230] = 1027;
        f_in[231] = 897;
        f_in[232] = 1625;
        f_in[233] = 2803;
        f_in[234] = 2927;
        f_in[235] = 249;
        f_in[236] = 1172;
        f_in[237] = 1171;
        f_in[238] = 2236;
        f_in[239] = 2938;
        f_in[240] = 2035;
        f_in[241] = 1512;
        f_in[242] = 2185;
        f_in[243] = 1314;
        f_in[244] = 474;
        f_in[245] = 301;
        f_in[246] = 3250;
        f_in[247] = 1407;
        f_in[248] = 2433;
        f_in[249] = 99;
        f_in[250] = 2887;
        f_in[251] = 349;
        f_in[252] = 1977;
        f_in[253] = 2785;
        f_in[254] = 195;
        f_in[255] = 1872;
    end

    // Test sequence
    initial begin
        integer k;  // Declare k here, before the statements
    
        // 1) Reset
        rst = 1'b1;
        start_ntt = 1'b0;
        #20;
        rst = 1'b0;
    
        // 2) Start inverse NTT
        #10;
        start_ntt = 1'b1;
        #10;
        start_ntt = 1'b0;
    
        // 3) Wait until done
        wait (done_ntt == 1'b1);
        #10;
    
        // 4) Print results
        $display("Inverse NTT outputs:");
    
        for (k = 0; k < N; k++) begin
            $display("f_out[%0d] = %0d", k, f_out[k]);
        end
    
        // End simulation
        #100;
        $stop;
    end

endmodule
