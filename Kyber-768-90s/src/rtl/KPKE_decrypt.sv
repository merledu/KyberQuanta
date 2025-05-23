`timescale 1ns / 1ps

module K_PKE_Decrypt #(
    parameter DK_BYTES = 1152,
    parameter C_BYTES  = 1088,
    parameter MSG_BYTES = 32,
    parameter DU = 10,
    parameter DV = 4,
    parameter DK_ELL = 12,
    parameter POLY_LEN = 256
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [7:0] dk_PKE [0:DK_BYTES-1],
    input  logic [7:0] c      [0:C_BYTES-1],
    output logic done,
    output logic [7:0] m      [0:MSG_BYTES-1]
);

    typedef enum logic [3:0] {
        S_IDLE,
        S_DECODE_U,
        S_DECOMPRESS_U,
        S_DECODE_V,
        S_DECOMPRESS_V,
        S_DECODE_SK,
        S_DECOMPRESS_SK,
        S_NTT_U,
        S_MULT_S,
        S_INV_NTT,
        S_SUB_V,
        S_COMPRESS,
        S_ENCODE,
        S_DONE
    } state_t;

    state_t state, next_state;

    // Internal signals
    logic [7:0] c1 [0:C_BYTES-1];
    logic [7:0] c2 [0:C_BYTES-1];

    // u, v, s arrays
    logic [DU-1:0] u_coeffs [0:POLY_LEN-1];
    logic [15:0]   u_poly   [0:POLY_LEN-1];
    logic [DV-1:0] v_coeffs [0:POLY_LEN-1];
    logic [15:0]   v_poly   [0:POLY_LEN-1];
    logic [DK_ELL-1:0] s_coeffs [0:POLY_LEN-1];
    logic [15:0]   s_poly   [0:POLY_LEN-1];

    // ntt input/output widths for ntt module
    logic [15:0] u_poly_2bit [0:255];
    logic signed [15:0] ntt_u [0:255];
    logic signed [31:0] mult_s  [0:255];
    logic signed [31:0] inv_ntt [0:255];
    logic [15:0] w_poly  [0:POLY_LEN-1];
    logic [15:0] compressed [0:POLY_LEN-1];
    logic [7:0]  encoded    [0:MSG_BYTES-1];

    logic done_ntt, done_invntt, done_compress, done_encode;

    // FSM
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE:         if (start) next_state = S_DECODE_U;
            S_DECODE_U:     next_state = S_DECOMPRESS_U;
            S_DECOMPRESS_U: next_state = S_DECODE_V;
            S_DECODE_V:     next_state = S_DECOMPRESS_V;
            S_DECOMPRESS_V: next_state = S_DECODE_SK;
            S_DECODE_SK:    next_state = S_DECOMPRESS_SK;
            S_DECOMPRESS_SK:next_state = S_NTT_U;
            S_NTT_U:        if (done_ntt) next_state = S_MULT_S;
            S_MULT_S:       next_state = S_INV_NTT;
            S_INV_NTT:      if (done_invntt) next_state = S_SUB_V;
            S_SUB_V:        next_state = S_COMPRESS;
            S_COMPRESS:     if (done_compress) next_state = S_ENCODE;
            S_ENCODE:       if (done_encode) next_state = S_DONE;
            S_DONE:         next_state = S_IDLE;
            default:        next_state = S_IDLE;
        endcase
    end

    // Split c into c1 and c2
    always_ff @(posedge clk) begin
        if (state == S_IDLE && start) begin
            for (int i = 0; i < C_BYTES; i++) c1[i] <= c[i];
            for (int i = 0; i < C_BYTES; i++) c2[i] <= c[C_BYTES + i];
        end
    end

    // 1. u' = Decompress_du(decode(c1))
    decode #(
        .ELL(DU),
        .NUM_COEFFS(POLY_LEN),
        .BYTE_COUNT(C_BYTES)
    ) decode_u (
        .byte_array(c1),
        .len(C_BYTES),
        .coeffs(u_coeffs)
    );
    // Unrolled decompress_module for u
    decompress_module decompress_u_0 (.x({6'd0, u_coeffs[0]}), .d(16'(DU)), .result(u_poly[0]));
    decompress_module decompress_u_1 (.x({6'd0, u_coeffs[1]}), .d(16'(DU)), .result(u_poly[1]));
    decompress_module decompress_u_2 (.x({6'd0, u_coeffs[2]}), .d(16'(DU)), .result(u_poly[2]));
    decompress_module decompress_u_3 (.x({6'd0, u_coeffs[3]}), .d(16'(DU)), .result(u_poly[3]));
    decompress_module decompress_u_4 (.x({6'd0, u_coeffs[4]}), .d(16'(DU)), .result(u_poly[4]));
    decompress_module decompress_u_5 (.x({6'd0, u_coeffs[5]}), .d(16'(DU)), .result(u_poly[5]));
    decompress_module decompress_u_6 (.x({6'd0, u_coeffs[6]}), .d(16'(DU)), .result(u_poly[6]));
    decompress_module decompress_u_7 (.x({6'd0, u_coeffs[7]}), .d(16'(DU)), .result(u_poly[7]));
    decompress_module decompress_u_8 (.x({6'd0, u_coeffs[8]}), .d(16'(DU)), .result(u_poly[8]));
    decompress_module decompress_u_9 (.x({6'd0, u_coeffs[9]}), .d(16'(DU)), .result(u_poly[9]));
    decompress_module decompress_u_10 (.x({6'd0, u_coeffs[10]}), .d(16'(DU)), .result(u_poly[10]));
    decompress_module decompress_u_11 (.x({6'd0, u_coeffs[11]}), .d(16'(DU)), .result(u_poly[11]));
    decompress_module decompress_u_12 (.x({6'd0, u_coeffs[12]}), .d(16'(DU)), .result(u_poly[12]));
    decompress_module decompress_u_13 (.x({6'd0, u_coeffs[13]}), .d(16'(DU)), .result(u_poly[13]));
    decompress_module decompress_u_14 (.x({6'd0, u_coeffs[14]}), .d(16'(DU)), .result(u_poly[14]));
    decompress_module decompress_u_15 (.x({6'd0, u_coeffs[15]}), .d(16'(DU)), .result(u_poly[15]));
    decompress_module decompress_u_16 (.x({6'd0, u_coeffs[16]}), .d(16'(DU)), .result(u_poly[16]));
    decompress_module decompress_u_17 (.x({6'd0, u_coeffs[17]}), .d(16'(DU)), .result(u_poly[17]));
    decompress_module decompress_u_18 (.x({6'd0, u_coeffs[18]}), .d(16'(DU)), .result(u_poly[18]));
    decompress_module decompress_u_19 (.x({6'd0, u_coeffs[19]}), .d(16'(DU)), .result(u_poly[19]));
    decompress_module decompress_u_20 (.x({6'd0, u_coeffs[20]}), .d(16'(DU)), .result(u_poly[20]));
    decompress_module decompress_u_21 (.x({6'd0, u_coeffs[21]}), .d(16'(DU)), .result(u_poly[21]));
    decompress_module decompress_u_22 (.x({6'd0, u_coeffs[22]}), .d(16'(DU)), .result(u_poly[22]));
    decompress_module decompress_u_23 (.x({6'd0, u_coeffs[23]}), .d(16'(DU)), .result(u_poly[23]));
    decompress_module decompress_u_24 (.x({6'd0, u_coeffs[24]}), .d(16'(DU)), .result(u_poly[24]));
    decompress_module decompress_u_25 (.x({6'd0, u_coeffs[25]}), .d(16'(DU)), .result(u_poly[25]));
    decompress_module decompress_u_26 (.x({6'd0, u_coeffs[26]}), .d(16'(DU)), .result(u_poly[26]));
    decompress_module decompress_u_27 (.x({6'd0, u_coeffs[27]}), .d(16'(DU)), .result(u_poly[27]));
    decompress_module decompress_u_28 (.x({6'd0, u_coeffs[28]}), .d(16'(DU)), .result(u_poly[28]));
    decompress_module decompress_u_29 (.x({6'd0, u_coeffs[29]}), .d(16'(DU)), .result(u_poly[29]));
    decompress_module decompress_u_30 (.x({6'd0, u_coeffs[30]}), .d(16'(DU)), .result(u_poly[30]));
    decompress_module decompress_u_31 (.x({6'd0, u_coeffs[31]}), .d(16'(DU)), .result(u_poly[31]));
    decompress_module decompress_u_32 (.x({6'd0, u_coeffs[32]}), .d(16'(DU)), .result(u_poly[32]));
    decompress_module decompress_u_33 (.x({6'd0, u_coeffs[33]}), .d(16'(DU)), .result(u_poly[33]));
    decompress_module decompress_u_34 (.x({6'd0, u_coeffs[34]}), .d(16'(DU)), .result(u_poly[34]));
    decompress_module decompress_u_35 (.x({6'd0, u_coeffs[35]}), .d(16'(DU)), .result(u_poly[35]));
    decompress_module decompress_u_36 (.x({6'd0, u_coeffs[36]}), .d(16'(DU)), .result(u_poly[36]));
    decompress_module decompress_u_37 (.x({6'd0, u_coeffs[37]}), .d(16'(DU)), .result(u_poly[37]));
    decompress_module decompress_u_38 (.x({6'd0, u_coeffs[38]}), .d(16'(DU)), .result(u_poly[38]));
    decompress_module decompress_u_39 (.x({6'd0, u_coeffs[39]}), .d(16'(DU)), .result(u_poly[39]));
    decompress_module decompress_u_40 (.x({6'd0, u_coeffs[40]}), .d(16'(DU)), .result(u_poly[40]));
    decompress_module decompress_u_41 (.x({6'd0, u_coeffs[41]}), .d(16'(DU)), .result(u_poly[41]));
    decompress_module decompress_u_42 (.x({6'd0, u_coeffs[42]}), .d(16'(DU)), .result(u_poly[42]));
    decompress_module decompress_u_43 (.x({6'd0, u_coeffs[43]}), .d(16'(DU)), .result(u_poly[43]));
    decompress_module decompress_u_44 (.x({6'd0, u_coeffs[44]}), .d(16'(DU)), .result(u_poly[44]));
    decompress_module decompress_u_45 (.x({6'd0, u_coeffs[45]}), .d(16'(DU)), .result(u_poly[45]));
    decompress_module decompress_u_46 (.x({6'd0, u_coeffs[46]}), .d(16'(DU)), .result(u_poly[46]));
    decompress_module decompress_u_47 (.x({6'd0, u_coeffs[47]}), .d(16'(DU)), .result(u_poly[47]));
    decompress_module decompress_u_48 (.x({6'd0, u_coeffs[48]}), .d(16'(DU)), .result(u_poly[48]));
    decompress_module decompress_u_49 (.x({6'd0, u_coeffs[49]}), .d(16'(DU)), .result(u_poly[49]));
    decompress_module decompress_u_50 (.x({6'd0, u_coeffs[50]}), .d(16'(DU)), .result(u_poly[50]));
    decompress_module decompress_u_51 (.x({6'd0, u_coeffs[51]}), .d(16'(DU)), .result(u_poly[51]));
    decompress_module decompress_u_52 (.x({6'd0, u_coeffs[52]}), .d(16'(DU)), .result(u_poly[52]));
    decompress_module decompress_u_53 (.x({6'd0, u_coeffs[53]}), .d(16'(DU)), .result(u_poly[53]));
    decompress_module decompress_u_54 (.x({6'd0, u_coeffs[54]}), .d(16'(DU)), .result(u_poly[54]));
    decompress_module decompress_u_55 (.x({6'd0, u_coeffs[55]}), .d(16'(DU)), .result(u_poly[55]));
    decompress_module decompress_u_56 (.x({6'd0, u_coeffs[56]}), .d(16'(DU)), .result(u_poly[56]));
    decompress_module decompress_u_57 (.x({6'd0, u_coeffs[57]}), .d(16'(DU)), .result(u_poly[57]));
    decompress_module decompress_u_58 (.x({6'd0, u_coeffs[58]}), .d(16'(DU)), .result(u_poly[58]));
    decompress_module decompress_u_59 (.x({6'd0, u_coeffs[59]}), .d(16'(DU)), .result(u_poly[59]));
    decompress_module decompress_u_60 (.x({6'd0, u_coeffs[60]}), .d(16'(DU)), .result(u_poly[60]));
    decompress_module decompress_u_61 (.x({6'd0, u_coeffs[61]}), .d(16'(DU)), .result(u_poly[61]));
    decompress_module decompress_u_62 (.x({6'd0, u_coeffs[62]}), .d(16'(DU)), .result(u_poly[62]));
    decompress_module decompress_u_63 (.x({6'd0, u_coeffs[63]}), .d(16'(DU)), .result(u_poly[63]));
    decompress_module decompress_u_64 (.x({6'd0, u_coeffs[64]}), .d(16'(DU)), .result(u_poly[64]));
    decompress_module decompress_u_65 (.x({6'd0, u_coeffs[65]}), .d(16'(DU)), .result(u_poly[65]));
    decompress_module decompress_u_66 (.x({6'd0, u_coeffs[66]}), .d(16'(DU)), .result(u_poly[66]));
    decompress_module decompress_u_67 (.x({6'd0, u_coeffs[67]}), .d(16'(DU)), .result(u_poly[67]));
    decompress_module decompress_u_68 (.x({6'd0, u_coeffs[68]}), .d(16'(DU)), .result(u_poly[68]));
    decompress_module decompress_u_69 (.x({6'd0, u_coeffs[69]}), .d(16'(DU)), .result(u_poly[69]));
    decompress_module decompress_u_70 (.x({6'd0, u_coeffs[70]}), .d(16'(DU)), .result(u_poly[70]));
    decompress_module decompress_u_71 (.x({6'd0, u_coeffs[71]}), .d(16'(DU)), .result(u_poly[71]));
    decompress_module decompress_u_72 (.x({6'd0, u_coeffs[72]}), .d(16'(DU)), .result(u_poly[72]));
    decompress_module decompress_u_73 (.x({6'd0, u_coeffs[73]}), .d(16'(DU)), .result(u_poly[73]));
    decompress_module decompress_u_74 (.x({6'd0, u_coeffs[74]}), .d(16'(DU)), .result(u_poly[74]));
    decompress_module decompress_u_75 (.x({6'd0, u_coeffs[75]}), .d(16'(DU)), .result(u_poly[75]));
    decompress_module decompress_u_76 (.x({6'd0, u_coeffs[76]}), .d(16'(DU)), .result(u_poly[76]));
    decompress_module decompress_u_77 (.x({6'd0, u_coeffs[77]}), .d(16'(DU)), .result(u_poly[77]));
    decompress_module decompress_u_78 (.x({6'd0, u_coeffs[78]}), .d(16'(DU)), .result(u_poly[78]));
    decompress_module decompress_u_79 (.x({6'd0, u_coeffs[79]}), .d(16'(DU)), .result(u_poly[79]));
    decompress_module decompress_u_80 (.x({6'd0, u_coeffs[80]}), .d(16'(DU)), .result(u_poly[80]));
    decompress_module decompress_u_81 (.x({6'd0, u_coeffs[81]}), .d(16'(DU)), .result(u_poly[81]));
    decompress_module decompress_u_82 (.x({6'd0, u_coeffs[82]}), .d(16'(DU)), .result(u_poly[82]));
    decompress_module decompress_u_83 (.x({6'd0, u_coeffs[83]}), .d(16'(DU)), .result(u_poly[83]));
    decompress_module decompress_u_84 (.x({6'd0, u_coeffs[84]}), .d(16'(DU)), .result(u_poly[84]));
    decompress_module decompress_u_85 (.x({6'd0, u_coeffs[85]}), .d(16'(DU)), .result(u_poly[85]));
    decompress_module decompress_u_86 (.x({6'd0, u_coeffs[86]}), .d(16'(DU)), .result(u_poly[86]));
    decompress_module decompress_u_87 (.x({6'd0, u_coeffs[87]}), .d(16'(DU)), .result(u_poly[87]));
    decompress_module decompress_u_88 (.x({6'd0, u_coeffs[88]}), .d(16'(DU)), .result(u_poly[88]));
    decompress_module decompress_u_89 (.x({6'd0, u_coeffs[89]}), .d(16'(DU)), .result(u_poly[89]));
    decompress_module decompress_u_90 (.x({6'd0, u_coeffs[90]}), .d(16'(DU)), .result(u_poly[90]));
    decompress_module decompress_u_91 (.x({6'd0, u_coeffs[91]}), .d(16'(DU)), .result(u_poly[91]));
    decompress_module decompress_u_92 (.x({6'd0, u_coeffs[92]}), .d(16'(DU)), .result(u_poly[92]));
    decompress_module decompress_u_93 (.x({6'd0, u_coeffs[93]}), .d(16'(DU)), .result(u_poly[93]));
    decompress_module decompress_u_94 (.x({6'd0, u_coeffs[94]}), .d(16'(DU)), .result(u_poly[94]));
    decompress_module decompress_u_95 (.x({6'd0, u_coeffs[95]}), .d(16'(DU)), .result(u_poly[95]));
    decompress_module decompress_u_96 (.x({6'd0, u_coeffs[96]}), .d(16'(DU)), .result(u_poly[96]));
    decompress_module decompress_u_97 (.x({6'd0, u_coeffs[97]}), .d(16'(DU)), .result(u_poly[97]));
    decompress_module decompress_u_98 (.x({6'd0, u_coeffs[98]}), .d(16'(DU)), .result(u_poly[98]));
    decompress_module decompress_u_99 (.x({6'd0, u_coeffs[99]}), .d(16'(DU)), .result(u_poly[99]));
    decompress_module decompress_u_100 (.x({6'd0, u_coeffs[100]}), .d(16'(DU)), .result(u_poly[100]));
    decompress_module decompress_u_101 (.x({6'd0, u_coeffs[101]}), .d(16'(DU)), .result(u_poly[101]));
    decompress_module decompress_u_102 (.x({6'd0, u_coeffs[102]}), .d(16'(DU)), .result(u_poly[102]));
    decompress_module decompress_u_103 (.x({6'd0, u_coeffs[103]}), .d(16'(DU)), .result(u_poly[103]));
    decompress_module decompress_u_104 (.x({6'd0, u_coeffs[104]}), .d(16'(DU)), .result(u_poly[104]));
    decompress_module decompress_u_105 (.x({6'd0, u_coeffs[105]}), .d(16'(DU)), .result(u_poly[105]));
    decompress_module decompress_u_106 (.x({6'd0, u_coeffs[106]}), .d(16'(DU)), .result(u_poly[106]));
    decompress_module decompress_u_107 (.x({6'd0, u_coeffs[107]}), .d(16'(DU)), .result(u_poly[107]));
    decompress_module decompress_u_108 (.x({6'd0, u_coeffs[108]}), .d(16'(DU)), .result(u_poly[108]));
    decompress_module decompress_u_109 (.x({6'd0, u_coeffs[109]}), .d(16'(DU)), .result(u_poly[109]));
    decompress_module decompress_u_110 (.x({6'd0, u_coeffs[110]}), .d(16'(DU)), .result(u_poly[110]));
    decompress_module decompress_u_111 (.x({6'd0, u_coeffs[111]}), .d(16'(DU)), .result(u_poly[111]));
    decompress_module decompress_u_112 (.x({6'd0, u_coeffs[112]}), .d(16'(DU)), .result(u_poly[112]));
    decompress_module decompress_u_113 (.x({6'd0, u_coeffs[113]}), .d(16'(DU)), .result(u_poly[113]));
    decompress_module decompress_u_114 (.x({6'd0, u_coeffs[114]}), .d(16'(DU)), .result(u_poly[114]));
    decompress_module decompress_u_115 (.x({6'd0, u_coeffs[115]}), .d(16'(DU)), .result(u_poly[115]));
    decompress_module decompress_u_116 (.x({6'd0, u_coeffs[116]}), .d(16'(DU)), .result(u_poly[116]));
    decompress_module decompress_u_117 (.x({6'd0, u_coeffs[117]}), .d(16'(DU)), .result(u_poly[117]));
    decompress_module decompress_u_118 (.x({6'd0, u_coeffs[118]}), .d(16'(DU)), .result(u_poly[118]));
    decompress_module decompress_u_119 (.x({6'd0, u_coeffs[119]}), .d(16'(DU)), .result(u_poly[119]));
    decompress_module decompress_u_120 (.x({6'd0, u_coeffs[120]}), .d(16'(DU)), .result(u_poly[120]));
    decompress_module decompress_u_121 (.x({6'd0, u_coeffs[121]}), .d(16'(DU)), .result(u_poly[121]));
    decompress_module decompress_u_122 (.x({6'd0, u_coeffs[122]}), .d(16'(DU)), .result(u_poly[122]));
    decompress_module decompress_u_123 (.x({6'd0, u_coeffs[123]}), .d(16'(DU)), .result(u_poly[123]));
    decompress_module decompress_u_124 (.x({6'd0, u_coeffs[124]}), .d(16'(DU)), .result(u_poly[124]));
    decompress_module decompress_u_125 (.x({6'd0, u_coeffs[125]}), .d(16'(DU)), .result(u_poly[125]));
    decompress_module decompress_u_126 (.x({6'd0, u_coeffs[126]}), .d(16'(DU)), .result(u_poly[126]));
    decompress_module decompress_u_127 (.x({6'd0, u_coeffs[127]}), .d(16'(DU)), .result(u_poly[127]));
    decompress_module decompress_u_128 (.x({6'd0, u_coeffs[128]}), .d(16'(DU)), .result(u_poly[128]));
    decompress_module decompress_u_129 (.x({6'd0, u_coeffs[129]}), .d(16'(DU)), .result(u_poly[129]));
    decompress_module decompress_u_130 (.x({6'd0, u_coeffs[130]}), .d(16'(DU)), .result(u_poly[130]));
    decompress_module decompress_u_131 (.x({6'd0, u_coeffs[131]}), .d(16'(DU)), .result(u_poly[131]));
    decompress_module decompress_u_132 (.x({6'd0, u_coeffs[132]}), .d(16'(DU)), .result(u_poly[132]));
    decompress_module decompress_u_133 (.x({6'd0, u_coeffs[133]}), .d(16'(DU)), .result(u_poly[133]));
    decompress_module decompress_u_134 (.x({6'd0, u_coeffs[134]}), .d(16'(DU)), .result(u_poly[134]));
    decompress_module decompress_u_135 (.x({6'd0, u_coeffs[135]}), .d(16'(DU)), .result(u_poly[135]));
    decompress_module decompress_u_136 (.x({6'd0, u_coeffs[136]}), .d(16'(DU)), .result(u_poly[136]));
    decompress_module decompress_u_137 (.x({6'd0, u_coeffs[137]}), .d(16'(DU)), .result(u_poly[137]));
    decompress_module decompress_u_138 (.x({6'd0, u_coeffs[138]}), .d(16'(DU)), .result(u_poly[138]));
    decompress_module decompress_u_139 (.x({6'd0, u_coeffs[139]}), .d(16'(DU)), .result(u_poly[139]));
    decompress_module decompress_u_140 (.x({6'd0, u_coeffs[140]}), .d(16'(DU)), .result(u_poly[140]));
    decompress_module decompress_u_141 (.x({6'd0, u_coeffs[141]}), .d(16'(DU)), .result(u_poly[141]));
    decompress_module decompress_u_142 (.x({6'd0, u_coeffs[142]}), .d(16'(DU)), .result(u_poly[142]));
    decompress_module decompress_u_143 (.x({6'd0, u_coeffs[143]}), .d(16'(DU)), .result(u_poly[143]));
    decompress_module decompress_u_144 (.x({6'd0, u_coeffs[144]}), .d(16'(DU)), .result(u_poly[144]));
    decompress_module decompress_u_145 (.x({6'd0, u_coeffs[145]}), .d(16'(DU)), .result(u_poly[145]));
    decompress_module decompress_u_146 (.x({6'd0, u_coeffs[146]}), .d(16'(DU)), .result(u_poly[146]));
    decompress_module decompress_u_147 (.x({6'd0, u_coeffs[147]}), .d(16'(DU)), .result(u_poly[147]));
    decompress_module decompress_u_148 (.x({6'd0, u_coeffs[148]}), .d(16'(DU)), .result(u_poly[148]));
    decompress_module decompress_u_149 (.x({6'd0, u_coeffs[149]}), .d(16'(DU)), .result(u_poly[149]));
    decompress_module decompress_u_150 (.x({6'd0, u_coeffs[150]}), .d(16'(DU)), .result(u_poly[150]));
    decompress_module decompress_u_151 (.x({6'd0, u_coeffs[151]}), .d(16'(DU)), .result(u_poly[151]));
    decompress_module decompress_u_152 (.x({6'd0, u_coeffs[152]}), .d(16'(DU)), .result(u_poly[152]));
    decompress_module decompress_u_153 (.x({6'd0, u_coeffs[153]}), .d(16'(DU)), .result(u_poly[153]));
    decompress_module decompress_u_154 (.x({6'd0, u_coeffs[154]}), .d(16'(DU)), .result(u_poly[154]));
    decompress_module decompress_u_155 (.x({6'd0, u_coeffs[155]}), .d(16'(DU)), .result(u_poly[155]));
    decompress_module decompress_u_156 (.x({6'd0, u_coeffs[156]}), .d(16'(DU)), .result(u_poly[156]));
    decompress_module decompress_u_157 (.x({6'd0, u_coeffs[157]}), .d(16'(DU)), .result(u_poly[157]));
    decompress_module decompress_u_158 (.x({6'd0, u_coeffs[158]}), .d(16'(DU)), .result(u_poly[158]));
    decompress_module decompress_u_159 (.x({6'd0, u_coeffs[159]}), .d(16'(DU)), .result(u_poly[159]));
    decompress_module decompress_u_160 (.x({6'd0, u_coeffs[160]}), .d(16'(DU)), .result(u_poly[160]));
    decompress_module decompress_u_161 (.x({6'd0, u_coeffs[161]}), .d(16'(DU)), .result(u_poly[161]));
    decompress_module decompress_u_162 (.x({6'd0, u_coeffs[162]}), .d(16'(DU)), .result(u_poly[162]));
    decompress_module decompress_u_163 (.x({6'd0, u_coeffs[163]}), .d(16'(DU)), .result(u_poly[163]));
    decompress_module decompress_u_164 (.x({6'd0, u_coeffs[164]}), .d(16'(DU)), .result(u_poly[164]));
    decompress_module decompress_u_165 (.x({6'd0, u_coeffs[165]}), .d(16'(DU)), .result(u_poly[165]));
    decompress_module decompress_u_166 (.x({6'd0, u_coeffs[166]}), .d(16'(DU)), .result(u_poly[166]));
    decompress_module decompress_u_167 (.x({6'd0, u_coeffs[167]}), .d(16'(DU)), .result(u_poly[167]));
    decompress_module decompress_u_168 (.x({6'd0, u_coeffs[168]}), .d(16'(DU)), .result(u_poly[168]));
    decompress_module decompress_u_169 (.x({6'd0, u_coeffs[169]}), .d(16'(DU)), .result(u_poly[169]));
    decompress_module decompress_u_170 (.x({6'd0, u_coeffs[170]}), .d(16'(DU)), .result(u_poly[170]));
    decompress_module decompress_u_171 (.x({6'd0, u_coeffs[171]}), .d(16'(DU)), .result(u_poly[171]));
    decompress_module decompress_u_172 (.x({6'd0, u_coeffs[172]}), .d(16'(DU)), .result(u_poly[172]));
    decompress_module decompress_u_173 (.x({6'd0, u_coeffs[173]}), .d(16'(DU)), .result(u_poly[173]));
    decompress_module decompress_u_174 (.x({6'd0, u_coeffs[174]}), .d(16'(DU)), .result(u_poly[174]));
    decompress_module decompress_u_175 (.x({6'd0, u_coeffs[175]}), .d(16'(DU)), .result(u_poly[175]));
    decompress_module decompress_u_176 (.x({6'd0, u_coeffs[176]}), .d(16'(DU)), .result(u_poly[176]));
    decompress_module decompress_u_177 (.x({6'd0, u_coeffs[177]}), .d(16'(DU)), .result(u_poly[177]));
    decompress_module decompress_u_178 (.x({6'd0, u_coeffs[178]}), .d(16'(DU)), .result(u_poly[178]));
    decompress_module decompress_u_179 (.x({6'd0, u_coeffs[179]}), .d(16'(DU)), .result(u_poly[179]));
    decompress_module decompress_u_180 (.x({6'd0, u_coeffs[180]}), .d(16'(DU)), .result(u_poly[180]));
    decompress_module decompress_u_181 (.x({6'd0, u_coeffs[181]}), .d(16'(DU)), .result(u_poly[181]));
    decompress_module decompress_u_182 (.x({6'd0, u_coeffs[182]}), .d(16'(DU)), .result(u_poly[182]));
    decompress_module decompress_u_183 (.x({6'd0, u_coeffs[183]}), .d(16'(DU)), .result(u_poly[183]));
    decompress_module decompress_u_184 (.x({6'd0, u_coeffs[184]}), .d(16'(DU)), .result(u_poly[184]));
    decompress_module decompress_u_185 (.x({6'd0, u_coeffs[185]}), .d(16'(DU)), .result(u_poly[185]));
    decompress_module decompress_u_186 (.x({6'd0, u_coeffs[186]}), .d(16'(DU)), .result(u_poly[186]));
    decompress_module decompress_u_187 (.x({6'd0, u_coeffs[187]}), .d(16'(DU)), .result(u_poly[187]));
    decompress_module decompress_u_188 (.x({6'd0, u_coeffs[188]}), .d(16'(DU)), .result(u_poly[188]));
    decompress_module decompress_u_189 (.x({6'd0, u_coeffs[189]}), .d(16'(DU)), .result(u_poly[189]));
    decompress_module decompress_u_190 (.x({6'd0, u_coeffs[190]}), .d(16'(DU)), .result(u_poly[190]));
    decompress_module decompress_u_191 (.x({6'd0, u_coeffs[191]}), .d(16'(DU)), .result(u_poly[191]));
    decompress_module decompress_u_192 (.x({6'd0, u_coeffs[192]}), .d(16'(DU)), .result(u_poly[192]));
    decompress_module decompress_u_193 (.x({6'd0, u_coeffs[193]}), .d(16'(DU)), .result(u_poly[193]));
    decompress_module decompress_u_194 (.x({6'd0, u_coeffs[194]}), .d(16'(DU)), .result(u_poly[194]));
    decompress_module decompress_u_195 (.x({6'd0, u_coeffs[195]}), .d(16'(DU)), .result(u_poly[195]));
    decompress_module decompress_u_196 (.x({6'd0, u_coeffs[196]}), .d(16'(DU)), .result(u_poly[196]));
    decompress_module decompress_u_197 (.x({6'd0, u_coeffs[197]}), .d(16'(DU)), .result(u_poly[197]));
    decompress_module decompress_u_198 (.x({6'd0, u_coeffs[198]}), .d(16'(DU)), .result(u_poly[198]));
    decompress_module decompress_u_199 (.x({6'd0, u_coeffs[199]}), .d(16'(DU)), .result(u_poly[199]));
    decompress_module decompress_u_200 (.x({6'd0, u_coeffs[200]}), .d(16'(DU)), .result(u_poly[200]));
    decompress_module decompress_u_201 (.x({6'd0, u_coeffs[201]}), .d(16'(DU)), .result(u_poly[201]));
    decompress_module decompress_u_202 (.x({6'd0, u_coeffs[202]}), .d(16'(DU)), .result(u_poly[202]));
    decompress_module decompress_u_203 (.x({6'd0, u_coeffs[203]}), .d(16'(DU)), .result(u_poly[203]));
    decompress_module decompress_u_204 (.x({6'd0, u_coeffs[204]}), .d(16'(DU)), .result(u_poly[204]));
    decompress_module decompress_u_205 (.x({6'd0, u_coeffs[205]}), .d(16'(DU)), .result(u_poly[205]));
    decompress_module decompress_u_206 (.x({6'd0, u_coeffs[206]}), .d(16'(DU)), .result(u_poly[206]));
    decompress_module decompress_u_207 (.x({6'd0, u_coeffs[207]}), .d(16'(DU)), .result(u_poly[207]));
    decompress_module decompress_u_208 (.x({6'd0, u_coeffs[208]}), .d(16'(DU)), .result(u_poly[208]));
    decompress_module decompress_u_209 (.x({6'd0, u_coeffs[209]}), .d(16'(DU)), .result(u_poly[209]));
    decompress_module decompress_u_210 (.x({6'd0, u_coeffs[210]}), .d(16'(DU)), .result(u_poly[210]));
    decompress_module decompress_u_211 (.x({6'd0, u_coeffs[211]}), .d(16'(DU)), .result(u_poly[211]));
    decompress_module decompress_u_212 (.x({6'd0, u_coeffs[212]}), .d(16'(DU)), .result(u_poly[212]));
    decompress_module decompress_u_213 (.x({6'd0, u_coeffs[213]}), .d(16'(DU)), .result(u_poly[213]));
    decompress_module decompress_u_214 (.x({6'd0, u_coeffs[214]}), .d(16'(DU)), .result(u_poly[214]));
    decompress_module decompress_u_215 (.x({6'd0, u_coeffs[215]}), .d(16'(DU)), .result(u_poly[215]));
    decompress_module decompress_u_216 (.x({6'd0, u_coeffs[216]}), .d(16'(DU)), .result(u_poly[216]));
    decompress_module decompress_u_217 (.x({6'd0, u_coeffs[217]}), .d(16'(DU)), .result(u_poly[217]));
    decompress_module decompress_u_218 (.x({6'd0, u_coeffs[218]}), .d(16'(DU)), .result(u_poly[218]));
    decompress_module decompress_u_219 (.x({6'd0, u_coeffs[219]}), .d(16'(DU)), .result(u_poly[219]));
    decompress_module decompress_u_220 (.x({6'd0, u_coeffs[220]}), .d(16'(DU)), .result(u_poly[220]));
    decompress_module decompress_u_221 (.x({6'd0, u_coeffs[221]}), .d(16'(DU)), .result(u_poly[221]));
    decompress_module decompress_u_222 (.x({6'd0, u_coeffs[222]}), .d(16'(DU)), .result(u_poly[222]));
    decompress_module decompress_u_223 (.x({6'd0, u_coeffs[223]}), .d(16'(DU)), .result(u_poly[223]));
    decompress_module decompress_u_224 (.x({6'd0, u_coeffs[224]}), .d(16'(DU)), .result(u_poly[224]));
    decompress_module decompress_u_225 (.x({6'd0, u_coeffs[225]}), .d(16'(DU)), .result(u_poly[225]));
    decompress_module decompress_u_226 (.x({6'd0, u_coeffs[226]}), .d(16'(DU)), .result(u_poly[226]));
    decompress_module decompress_u_227 (.x({6'd0, u_coeffs[227]}), .d(16'(DU)), .result(u_poly[227]));
    decompress_module decompress_u_228 (.x({6'd0, u_coeffs[228]}), .d(16'(DU)), .result(u_poly[228]));
    decompress_module decompress_u_229 (.x({6'd0, u_coeffs[229]}), .d(16'(DU)), .result(u_poly[229]));
    decompress_module decompress_u_230 (.x({6'd0, u_coeffs[230]}), .d(16'(DU)), .result(u_poly[230]));
    decompress_module decompress_u_231 (.x({6'd0, u_coeffs[231]}), .d(16'(DU)), .result(u_poly[231]));
    decompress_module decompress_u_232 (.x({6'd0, u_coeffs[232]}), .d(16'(DU)), .result(u_poly[232]));
    decompress_module decompress_u_233 (.x({6'd0, u_coeffs[233]}), .d(16'(DU)), .result(u_poly[233]));
    decompress_module decompress_u_234 (.x({6'd0, u_coeffs[234]}), .d(16'(DU)), .result(u_poly[234]));
    decompress_module decompress_u_235 (.x({6'd0, u_coeffs[235]}), .d(16'(DU)), .result(u_poly[235]));
    decompress_module decompress_u_236 (.x({6'd0, u_coeffs[236]}), .d(16'(DU)), .result(u_poly[236]));
    decompress_module decompress_u_237 (.x({6'd0, u_coeffs[237]}), .d(16'(DU)), .result(u_poly[237]));
    decompress_module decompress_u_238 (.x({6'd0, u_coeffs[238]}), .d(16'(DU)), .result(u_poly[238]));
    decompress_module decompress_u_239 (.x({6'd0, u_coeffs[239]}), .d(16'(DU)), .result(u_poly[239]));
    decompress_module decompress_u_240 (.x({6'd0, u_coeffs[240]}), .d(16'(DU)), .result(u_poly[240]));
    decompress_module decompress_u_241 (.x({6'd0, u_coeffs[241]}), .d(16'(DU)), .result(u_poly[241]));
    decompress_module decompress_u_242 (.x({6'd0, u_coeffs[242]}), .d(16'(DU)), .result(u_poly[242]));
    decompress_module decompress_u_243 (.x({6'd0, u_coeffs[243]}), .d(16'(DU)), .result(u_poly[243]));
    decompress_module decompress_u_244 (.x({6'd0, u_coeffs[244]}), .d(16'(DU)), .result(u_poly[244]));
    decompress_module decompress_u_245 (.x({6'd0, u_coeffs[245]}), .d(16'(DU)), .result(u_poly[245]));
    decompress_module decompress_u_246 (.x({6'd0, u_coeffs[246]}), .d(16'(DU)), .result(u_poly[246]));
    decompress_module decompress_u_247 (.x({6'd0, u_coeffs[247]}), .d(16'(DU)), .result(u_poly[247]));
    decompress_module decompress_u_248 (.x({6'd0, u_coeffs[248]}), .d(16'(DU)), .result(u_poly[248]));
    decompress_module decompress_u_249 (.x({6'd0, u_coeffs[249]}), .d(16'(DU)), .result(u_poly[249]));
    decompress_module decompress_u_250 (.x({6'd0, u_coeffs[250]}), .d(16'(DU)), .result(u_poly[250]));
    decompress_module decompress_u_251 (.x({6'd0, u_coeffs[251]}), .d(16'(DU)), .result(u_poly[251]));
    decompress_module decompress_u_252 (.x({6'd0, u_coeffs[252]}), .d(16'(DU)), .result(u_poly[252]));
    decompress_module decompress_u_253 (.x({6'd0, u_coeffs[253]}), .d(16'(DU)), .result(u_poly[253]));
    decompress_module decompress_u_254 (.x({6'd0, u_coeffs[254]}), .d(16'(DU)), .result(u_poly[254]));
    decompress_module decompress_u_255 (.x({6'd0, u_coeffs[255]}), .d(16'(DU)), .result(u_poly[255]));

    // 2. v' = Decompress_dv(decode(c2))
    decode #(
        .ELL(DV),
        .NUM_COEFFS(POLY_LEN),
        .BYTE_COUNT(C_BYTES)
    ) decode_v (
        .byte_array(c2),
        .len(C_BYTES),
        .coeffs(v_coeffs)
    );
    decompress_module decompress_v_0 (.x({12'd0, v_coeffs[0]}), .d(DV[15:0]), .result(v_poly[0]));
    decompress_module decompress_v_1 (.x({12'd0, v_coeffs[1]}), .d(DV[15:0]), .result(v_poly[1]));
    decompress_module decompress_v_2 (.x({12'd0, v_coeffs[2]}), .d(DV[15:0]), .result(v_poly[2]));
    decompress_module decompress_v_3 (.x({12'd0, v_coeffs[3]}), .d(DV[15:0]), .result(v_poly[3]));
    decompress_module decompress_v_4 (.x({12'd0, v_coeffs[4]}), .d(DV[15:0]), .result(v_poly[4]));
    decompress_module decompress_v_5 (.x({12'd0, v_coeffs[5]}), .d(DV[15:0]), .result(v_poly[5]));
    decompress_module decompress_v_6 (.x({12'd0, v_coeffs[6]}), .d(DV[15:0]), .result(v_poly[6]));
    decompress_module decompress_v_7 (.x({12'd0, v_coeffs[7]}), .d(DV[15:0]), .result(v_poly[7]));
    decompress_module decompress_v_8 (.x({12'd0, v_coeffs[8]}), .d(DV[15:0]), .result(v_poly[8]));
    decompress_module decompress_v_9 (.x({12'd0, v_coeffs[9]}), .d(DV[15:0]), .result(v_poly[9]));
    decompress_module decompress_v_10 (.x({12'd0, v_coeffs[10]}), .d(DV[15:0]), .result(v_poly[10]));
    decompress_module decompress_v_11 (.x({12'd0, v_coeffs[11]}), .d(DV[15:0]), .result(v_poly[11]));
    decompress_module decompress_v_12 (.x({12'd0, v_coeffs[12]}), .d(DV[15:0]), .result(v_poly[12]));
    decompress_module decompress_v_13 (.x({12'd0, v_coeffs[13]}), .d(DV[15:0]), .result(v_poly[13]));
    decompress_module decompress_v_14 (.x({12'd0, v_coeffs[14]}), .d(DV[15:0]), .result(v_poly[14]));
    decompress_module decompress_v_15 (.x({12'd0, v_coeffs[15]}), .d(DV[15:0]), .result(v_poly[15]));
    decompress_module decompress_v_16 (.x({12'd0, v_coeffs[16]}), .d(DV[15:0]), .result(v_poly[16]));
    decompress_module decompress_v_17 (.x({12'd0, v_coeffs[17]}), .d(DV[15:0]), .result(v_poly[17]));
    decompress_module decompress_v_18 (.x({12'd0, v_coeffs[18]}), .d(DV[15:0]), .result(v_poly[18]));
    decompress_module decompress_v_19 (.x({12'd0, v_coeffs[19]}), .d(DV[15:0]), .result(v_poly[19]));
    decompress_module decompress_v_20 (.x({12'd0, v_coeffs[20]}), .d(DV[15:0]), .result(v_poly[20]));
    decompress_module decompress_v_21 (.x({12'd0, v_coeffs[21]}), .d(DV[15:0]), .result(v_poly[21]));
    decompress_module decompress_v_22 (.x({12'd0, v_coeffs[22]}), .d(DV[15:0]), .result(v_poly[22]));
    decompress_module decompress_v_23 (.x({12'd0, v_coeffs[23]}), .d(DV[15:0]), .result(v_poly[23]));
    decompress_module decompress_v_24 (.x({12'd0, v_coeffs[24]}), .d(DV[15:0]), .result(v_poly[24]));
    decompress_module decompress_v_25 (.x({12'd0, v_coeffs[25]}), .d(DV[15:0]), .result(v_poly[25]));
    decompress_module decompress_v_26 (.x({12'd0, v_coeffs[26]}), .d(DV[15:0]), .result(v_poly[26]));
    decompress_module decompress_v_27 (.x({12'd0, v_coeffs[27]}), .d(DV[15:0]), .result(v_poly[27]));
    decompress_module decompress_v_28 (.x({12'd0, v_coeffs[28]}), .d(DV[15:0]), .result(v_poly[28]));
    decompress_module decompress_v_29 (.x({12'd0, v_coeffs[29]}), .d(DV[15:0]), .result(v_poly[29]));
    decompress_module decompress_v_30 (.x({12'd0, v_coeffs[30]}), .d(DV[15:0]), .result(v_poly[30]));
    decompress_module decompress_v_31 (.x({12'd0, v_coeffs[31]}), .d(DV[15:0]), .result(v_poly[31]));
    decompress_module decompress_v_32 (.x({12'd0, v_coeffs[32]}), .d(DV[15:0]), .result(v_poly[32]));
    decompress_module decompress_v_33 (.x({12'd0, v_coeffs[33]}), .d(DV[15:0]), .result(v_poly[33]));
    decompress_module decompress_v_34 (.x({12'd0, v_coeffs[34]}), .d(DV[15:0]), .result(v_poly[34]));
    decompress_module decompress_v_35 (.x({12'd0, v_coeffs[35]}), .d(DV[15:0]), .result(v_poly[35]));
    decompress_module decompress_v_36 (.x({12'd0, v_coeffs[36]}), .d(DV[15:0]), .result(v_poly[36]));
    decompress_module decompress_v_37 (.x({12'd0, v_coeffs[37]}), .d(DV[15:0]), .result(v_poly[37]));
    decompress_module decompress_v_38 (.x({12'd0, v_coeffs[38]}), .d(DV[15:0]), .result(v_poly[38]));
    decompress_module decompress_v_39 (.x({12'd0, v_coeffs[39]}), .d(DV[15:0]), .result(v_poly[39]));
    decompress_module decompress_v_40 (.x({12'd0, v_coeffs[40]}), .d(DV[15:0]), .result(v_poly[40]));
    decompress_module decompress_v_41 (.x({12'd0, v_coeffs[41]}), .d(DV[15:0]), .result(v_poly[41]));
    decompress_module decompress_v_42 (.x({12'd0, v_coeffs[42]}), .d(DV[15:0]), .result(v_poly[42]));
    decompress_module decompress_v_43 (.x({12'd0, v_coeffs[43]}), .d(DV[15:0]), .result(v_poly[43]));
    decompress_module decompress_v_44 (.x({12'd0, v_coeffs[44]}), .d(DV[15:0]), .result(v_poly[44]));
    decompress_module decompress_v_45 (.x({12'd0, v_coeffs[45]}), .d(DV[15:0]), .result(v_poly[45]));
    decompress_module decompress_v_46 (.x({12'd0, v_coeffs[46]}), .d(DV[15:0]), .result(v_poly[46]));
    decompress_module decompress_v_47 (.x({12'd0, v_coeffs[47]}), .d(DV[15:0]), .result(v_poly[47]));
    decompress_module decompress_v_48 (.x({12'd0, v_coeffs[48]}), .d(DV[15:0]), .result(v_poly[48]));
    decompress_module decompress_v_49 (.x({12'd0, v_coeffs[49]}), .d(DV[15:0]), .result(v_poly[49]));
    decompress_module decompress_v_50 (.x({12'd0, v_coeffs[50]}), .d(DV[15:0]), .result(v_poly[50]));
    decompress_module decompress_v_51 (.x({12'd0, v_coeffs[51]}), .d(DV[15:0]), .result(v_poly[51]));
    decompress_module decompress_v_52 (.x({12'd0, v_coeffs[52]}), .d(DV[15:0]), .result(v_poly[52]));
    decompress_module decompress_v_53 (.x({12'd0, v_coeffs[53]}), .d(DV[15:0]), .result(v_poly[53]));
    decompress_module decompress_v_54 (.x({12'd0, v_coeffs[54]}), .d(DV[15:0]), .result(v_poly[54]));
    decompress_module decompress_v_55 (.x({12'd0, v_coeffs[55]}), .d(DV[15:0]), .result(v_poly[55]));
    decompress_module decompress_v_56 (.x({12'd0, v_coeffs[56]}), .d(DV[15:0]), .result(v_poly[56]));
    decompress_module decompress_v_57 (.x({12'd0, v_coeffs[57]}), .d(DV[15:0]), .result(v_poly[57]));
    decompress_module decompress_v_58 (.x({12'd0, v_coeffs[58]}), .d(DV[15:0]), .result(v_poly[58]));
    decompress_module decompress_v_59 (.x({12'd0, v_coeffs[59]}), .d(DV[15:0]), .result(v_poly[59]));
    decompress_module decompress_v_60 (.x({12'd0, v_coeffs[60]}), .d(DV[15:0]), .result(v_poly[60]));
    decompress_module decompress_v_61 (.x({12'd0, v_coeffs[61]}), .d(DV[15:0]), .result(v_poly[61]));
    decompress_module decompress_v_62 (.x({12'd0, v_coeffs[62]}), .d(DV[15:0]), .result(v_poly[62]));
    decompress_module decompress_v_63 (.x({12'd0, v_coeffs[63]}), .d(DV[15:0]), .result(v_poly[63]));
    decompress_module decompress_v_64 (.x({12'd0, v_coeffs[64]}), .d(DV[15:0]), .result(v_poly[64]));
    decompress_module decompress_v_65 (.x({12'd0, v_coeffs[65]}), .d(DV[15:0]), .result(v_poly[65]));
    decompress_module decompress_v_66 (.x({12'd0, v_coeffs[66]}), .d(DV[15:0]), .result(v_poly[66]));
    decompress_module decompress_v_67 (.x({12'd0, v_coeffs[67]}), .d(DV[15:0]), .result(v_poly[67]));
    decompress_module decompress_v_68 (.x({12'd0, v_coeffs[68]}), .d(DV[15:0]), .result(v_poly[68]));
    decompress_module decompress_v_69 (.x({12'd0, v_coeffs[69]}), .d(DV[15:0]), .result(v_poly[69]));
    decompress_module decompress_v_70 (.x({12'd0, v_coeffs[70]}), .d(DV[15:0]), .result(v_poly[70]));
    decompress_module decompress_v_71 (.x({12'd0, v_coeffs[71]}), .d(DV[15:0]), .result(v_poly[71]));
    decompress_module decompress_v_72 (.x({12'd0, v_coeffs[72]}), .d(DV[15:0]), .result(v_poly[72]));
    decompress_module decompress_v_73 (.x({12'd0, v_coeffs[73]}), .d(DV[15:0]), .result(v_poly[73]));
    decompress_module decompress_v_74 (.x({12'd0, v_coeffs[74]}), .d(DV[15:0]), .result(v_poly[74]));
    decompress_module decompress_v_75 (.x({12'd0, v_coeffs[75]}), .d(DV[15:0]), .result(v_poly[75]));
    decompress_module decompress_v_76 (.x({12'd0, v_coeffs[76]}), .d(DV[15:0]), .result(v_poly[76]));
    decompress_module decompress_v_77 (.x({12'd0, v_coeffs[77]}), .d(DV[15:0]), .result(v_poly[77]));
    decompress_module decompress_v_78 (.x({12'd0, v_coeffs[78]}), .d(DV[15:0]), .result(v_poly[78]));
    decompress_module decompress_v_79 (.x({12'd0, v_coeffs[79]}), .d(DV[15:0]), .result(v_poly[79]));
    decompress_module decompress_v_80 (.x({12'd0, v_coeffs[80]}), .d(DV[15:0]), .result(v_poly[80]));
    decompress_module decompress_v_81 (.x({12'd0, v_coeffs[81]}), .d(DV[15:0]), .result(v_poly[81]));
    decompress_module decompress_v_82 (.x({12'd0, v_coeffs[82]}), .d(DV[15:0]), .result(v_poly[82]));
    decompress_module decompress_v_83 (.x({12'd0, v_coeffs[83]}), .d(DV[15:0]), .result(v_poly[83]));
    decompress_module decompress_v_84 (.x({12'd0, v_coeffs[84]}), .d(DV[15:0]), .result(v_poly[84]));
    decompress_module decompress_v_85 (.x({12'd0, v_coeffs[85]}), .d(DV[15:0]), .result(v_poly[85]));
    decompress_module decompress_v_86 (.x({12'd0, v_coeffs[86]}), .d(DV[15:0]), .result(v_poly[86]));
    decompress_module decompress_v_87 (.x({12'd0, v_coeffs[87]}), .d(DV[15:0]), .result(v_poly[87]));
    decompress_module decompress_v_88 (.x({12'd0, v_coeffs[88]}), .d(DV[15:0]), .result(v_poly[88]));
    decompress_module decompress_v_89 (.x({12'd0, v_coeffs[89]}), .d(DV[15:0]), .result(v_poly[89]));
    decompress_module decompress_v_90 (.x({12'd0, v_coeffs[90]}), .d(DV[15:0]), .result(v_poly[90]));
    decompress_module decompress_v_91 (.x({12'd0, v_coeffs[91]}), .d(DV[15:0]), .result(v_poly[91]));
    decompress_module decompress_v_92 (.x({12'd0, v_coeffs[92]}), .d(DV[15:0]), .result(v_poly[92]));
    decompress_module decompress_v_93 (.x({12'd0, v_coeffs[93]}), .d(DV[15:0]), .result(v_poly[93]));
    decompress_module decompress_v_94 (.x({12'd0, v_coeffs[94]}), .d(DV[15:0]), .result(v_poly[94]));
    decompress_module decompress_v_95 (.x({12'd0, v_coeffs[95]}), .d(DV[15:0]), .result(v_poly[95]));
    decompress_module decompress_v_96 (.x({12'd0, v_coeffs[96]}), .d(DV[15:0]), .result(v_poly[96]));
    decompress_module decompress_v_97 (.x({12'd0, v_coeffs[97]}), .d(DV[15:0]), .result(v_poly[97]));
    decompress_module decompress_v_98 (.x({12'd0, v_coeffs[98]}), .d(DV[15:0]), .result(v_poly[98]));
    decompress_module decompress_v_99 (.x({12'd0, v_coeffs[99]}), .d(DV[15:0]), .result(v_poly[99]));
    decompress_module decompress_v_100 (.x({12'd0, v_coeffs[100]}), .d(DV[15:0]), .result(v_poly[100]));
    decompress_module decompress_v_101 (.x({12'd0, v_coeffs[101]}), .d(DV[15:0]), .result(v_poly[101]));
    decompress_module decompress_v_102 (.x({12'd0, v_coeffs[102]}), .d(DV[15:0]), .result(v_poly[102]));
    decompress_module decompress_v_103 (.x({12'd0, v_coeffs[103]}), .d(DV[15:0]), .result(v_poly[103]));
    decompress_module decompress_v_104 (.x({12'd0, v_coeffs[104]}), .d(DV[15:0]), .result(v_poly[104]));
    decompress_module decompress_v_105 (.x({12'd0, v_coeffs[105]}), .d(DV[15:0]), .result(v_poly[105]));
    decompress_module decompress_v_106 (.x({12'd0, v_coeffs[106]}), .d(DV[15:0]), .result(v_poly[106]));
    decompress_module decompress_v_107 (.x({12'd0, v_coeffs[107]}), .d(DV[15:0]), .result(v_poly[107]));
    decompress_module decompress_v_108 (.x({12'd0, v_coeffs[108]}), .d(DV[15:0]), .result(v_poly[108]));
    decompress_module decompress_v_109 (.x({12'd0, v_coeffs[109]}), .d(DV[15:0]), .result(v_poly[109]));
    decompress_module decompress_v_110 (.x({12'd0, v_coeffs[110]}), .d(DV[15:0]), .result(v_poly[110]));
    decompress_module decompress_v_111 (.x({12'd0, v_coeffs[111]}), .d(DV[15:0]), .result(v_poly[111]));
    decompress_module decompress_v_112 (.x({12'd0, v_coeffs[112]}), .d(DV[15:0]), .result(v_poly[112]));
    decompress_module decompress_v_113 (.x({12'd0, v_coeffs[113]}), .d(DV[15:0]), .result(v_poly[113]));
    decompress_module decompress_v_114 (.x({12'd0, v_coeffs[114]}), .d(DV[15:0]), .result(v_poly[114]));
    decompress_module decompress_v_115 (.x({12'd0, v_coeffs[115]}), .d(DV[15:0]), .result(v_poly[115]));
    decompress_module decompress_v_116 (.x({12'd0, v_coeffs[116]}), .d(DV[15:0]), .result(v_poly[116]));
    decompress_module decompress_v_117 (.x({12'd0, v_coeffs[117]}), .d(DV[15:0]), .result(v_poly[117]));
    decompress_module decompress_v_118 (.x({12'd0, v_coeffs[118]}), .d(DV[15:0]), .result(v_poly[118]));
    decompress_module decompress_v_119 (.x({12'd0, v_coeffs[119]}), .d(DV[15:0]), .result(v_poly[119]));
    decompress_module decompress_v_120 (.x({12'd0, v_coeffs[120]}), .d(DV[15:0]), .result(v_poly[120]));
    decompress_module decompress_v_121 (.x({12'd0, v_coeffs[121]}), .d(DV[15:0]), .result(v_poly[121]));
    decompress_module decompress_v_122 (.x({12'd0, v_coeffs[122]}), .d(DV[15:0]), .result(v_poly[122]));
    decompress_module decompress_v_123 (.x({12'd0, v_coeffs[123]}), .d(DV[15:0]), .result(v_poly[123]));
    decompress_module decompress_v_124 (.x({12'd0, v_coeffs[124]}), .d(DV[15:0]), .result(v_poly[124]));
    decompress_module decompress_v_125 (.x({12'd0, v_coeffs[125]}), .d(DV[15:0]), .result(v_poly[125]));
    decompress_module decompress_v_126 (.x({12'd0, v_coeffs[126]}), .d(DV[15:0]), .result(v_poly[126]));
    decompress_module decompress_v_127 (.x({12'd0, v_coeffs[127]}), .d(DV[15:0]), .result(v_poly[127]));
    decompress_module decompress_v_128 (.x({12'd0, v_coeffs[128]}), .d(DV[15:0]), .result(v_poly[128]));
    decompress_module decompress_v_129 (.x({12'd0, v_coeffs[129]}), .d(DV[15:0]), .result(v_poly[129]));
    decompress_module decompress_v_130 (.x({12'd0, v_coeffs[130]}), .d(DV[15:0]), .result(v_poly[130]));
    decompress_module decompress_v_131 (.x({12'd0, v_coeffs[131]}), .d(DV[15:0]), .result(v_poly[131]));
    decompress_module decompress_v_132 (.x({12'd0, v_coeffs[132]}), .d(DV[15:0]), .result(v_poly[132]));
    decompress_module decompress_v_133 (.x({12'd0, v_coeffs[133]}), .d(DV[15:0]), .result(v_poly[133]));
    decompress_module decompress_v_134 (.x({12'd0, v_coeffs[134]}), .d(DV[15:0]), .result(v_poly[134]));
    decompress_module decompress_v_135 (.x({12'd0, v_coeffs[135]}), .d(DV[15:0]), .result(v_poly[135]));
    decompress_module decompress_v_136 (.x({12'd0, v_coeffs[136]}), .d(DV[15:0]), .result(v_poly[136]));
    decompress_module decompress_v_137 (.x({12'd0, v_coeffs[137]}), .d(DV[15:0]), .result(v_poly[137]));
    decompress_module decompress_v_138 (.x({12'd0, v_coeffs[138]}), .d(DV[15:0]), .result(v_poly[138]));
    decompress_module decompress_v_139 (.x({12'd0, v_coeffs[139]}), .d(DV[15:0]), .result(v_poly[139]));
    decompress_module decompress_v_140 (.x({12'd0, v_coeffs[140]}), .d(DV[15:0]), .result(v_poly[140]));
    decompress_module decompress_v_141 (.x({12'd0, v_coeffs[141]}), .d(DV[15:0]), .result(v_poly[141]));
    decompress_module decompress_v_142 (.x({12'd0, v_coeffs[142]}), .d(DV[15:0]), .result(v_poly[142]));
    decompress_module decompress_v_143 (.x({12'd0, v_coeffs[143]}), .d(DV[15:0]), .result(v_poly[143]));
    decompress_module decompress_v_144 (.x({12'd0, v_coeffs[144]}), .d(DV[15:0]), .result(v_poly[144]));
    decompress_module decompress_v_145 (.x({12'd0, v_coeffs[145]}), .d(DV[15:0]), .result(v_poly[145]));
    decompress_module decompress_v_146 (.x({12'd0, v_coeffs[146]}), .d(DV[15:0]), .result(v_poly[146]));
    decompress_module decompress_v_147 (.x({12'd0, v_coeffs[147]}), .d(DV[15:0]), .result(v_poly[147]));
    decompress_module decompress_v_148 (.x({12'd0, v_coeffs[148]}), .d(DV[15:0]), .result(v_poly[148]));
    decompress_module decompress_v_149 (.x({12'd0, v_coeffs[149]}), .d(DV[15:0]), .result(v_poly[149]));
    decompress_module decompress_v_150 (.x({12'd0, v_coeffs[150]}), .d(DV[15:0]), .result(v_poly[150]));
    decompress_module decompress_v_151 (.x({12'd0, v_coeffs[151]}), .d(DV[15:0]), .result(v_poly[151]));
    decompress_module decompress_v_152 (.x({12'd0, v_coeffs[152]}), .d(DV[15:0]), .result(v_poly[152]));
    decompress_module decompress_v_153 (.x({12'd0, v_coeffs[153]}), .d(DV[15:0]), .result(v_poly[153]));
    decompress_module decompress_v_154 (.x({12'd0, v_coeffs[154]}), .d(DV[15:0]), .result(v_poly[154]));
    decompress_module decompress_v_155 (.x({12'd0, v_coeffs[155]}), .d(DV[15:0]), .result(v_poly[155]));
    decompress_module decompress_v_156 (.x({12'd0, v_coeffs[156]}), .d(DV[15:0]), .result(v_poly[156]));
    decompress_module decompress_v_157 (.x({12'd0, v_coeffs[157]}), .d(DV[15:0]), .result(v_poly[157]));
    decompress_module decompress_v_158 (.x({12'd0, v_coeffs[158]}), .d(DV[15:0]), .result(v_poly[158]));
    decompress_module decompress_v_159 (.x({12'd0, v_coeffs[159]}), .d(DV[15:0]), .result(v_poly[159]));
    decompress_module decompress_v_160 (.x({12'd0, v_coeffs[160]}), .d(DV[15:0]), .result(v_poly[160]));
    decompress_module decompress_v_161 (.x({12'd0, v_coeffs[161]}), .d(DV[15:0]), .result(v_poly[161]));
    decompress_module decompress_v_162 (.x({12'd0, v_coeffs[162]}), .d(DV[15:0]), .result(v_poly[162]));
    decompress_module decompress_v_163 (.x({12'd0, v_coeffs[163]}), .d(DV[15:0]), .result(v_poly[163]));
    decompress_module decompress_v_164 (.x({12'd0, v_coeffs[164]}), .d(DV[15:0]), .result(v_poly[164]));
    decompress_module decompress_v_165 (.x({12'd0, v_coeffs[165]}), .d(DV[15:0]), .result(v_poly[165]));
    decompress_module decompress_v_166 (.x({12'd0, v_coeffs[166]}), .d(DV[15:0]), .result(v_poly[166]));
    decompress_module decompress_v_167 (.x({12'd0, v_coeffs[167]}), .d(DV[15:0]), .result(v_poly[167]));
    decompress_module decompress_v_168 (.x({12'd0, v_coeffs[168]}), .d(DV[15:0]), .result(v_poly[168]));
    decompress_module decompress_v_169 (.x({12'd0, v_coeffs[169]}), .d(DV[15:0]), .result(v_poly[169]));
    decompress_module decompress_v_170 (.x({12'd0, v_coeffs[170]}), .d(DV[15:0]), .result(v_poly[170]));
    decompress_module decompress_v_171 (.x({12'd0, v_coeffs[171]}), .d(DV[15:0]), .result(v_poly[171]));
    decompress_module decompress_v_172 (.x({12'd0, v_coeffs[172]}), .d(DV[15:0]), .result(v_poly[172]));
    decompress_module decompress_v_173 (.x({12'd0, v_coeffs[173]}), .d(DV[15:0]), .result(v_poly[173]));
    decompress_module decompress_v_174 (.x({12'd0, v_coeffs[174]}), .d(DV[15:0]), .result(v_poly[174]));
    decompress_module decompress_v_175 (.x({12'd0, v_coeffs[175]}), .d(DV[15:0]), .result(v_poly[175]));
    decompress_module decompress_v_176 (.x({12'd0, v_coeffs[176]}), .d(DV[15:0]), .result(v_poly[176]));
    decompress_module decompress_v_177 (.x({12'd0, v_coeffs[177]}), .d(DV[15:0]), .result(v_poly[177]));
    decompress_module decompress_v_178 (.x({12'd0, v_coeffs[178]}), .d(DV[15:0]), .result(v_poly[178]));
    decompress_module decompress_v_179 (.x({12'd0, v_coeffs[179]}), .d(DV[15:0]), .result(v_poly[179]));
    decompress_module decompress_v_180 (.x({12'd0, v_coeffs[180]}), .d(DV[15:0]), .result(v_poly[180]));
    decompress_module decompress_v_181 (.x({12'd0, v_coeffs[181]}), .d(DV[15:0]), .result(v_poly[181]));
    decompress_module decompress_v_182 (.x({12'd0, v_coeffs[182]}), .d(DV[15:0]), .result(v_poly[182]));
    decompress_module decompress_v_183 (.x({12'd0, v_coeffs[183]}), .d(DV[15:0]), .result(v_poly[183]));
    decompress_module decompress_v_184 (.x({12'd0, v_coeffs[184]}), .d(DV[15:0]), .result(v_poly[184]));
    decompress_module decompress_v_185 (.x({12'd0, v_coeffs[185]}), .d(DV[15:0]), .result(v_poly[185]));
    decompress_module decompress_v_186 (.x({12'd0, v_coeffs[186]}), .d(DV[15:0]), .result(v_poly[186]));
    decompress_module decompress_v_187 (.x({12'd0, v_coeffs[187]}), .d(DV[15:0]), .result(v_poly[187]));
    decompress_module decompress_v_188 (.x({12'd0, v_coeffs[188]}), .d(DV[15:0]), .result(v_poly[188]));
    decompress_module decompress_v_189 (.x({12'd0, v_coeffs[189]}), .d(DV[15:0]), .result(v_poly[189]));
    decompress_module decompress_v_190 (.x({12'd0, v_coeffs[190]}), .d(DV[15:0]), .result(v_poly[190]));
    decompress_module decompress_v_191 (.x({12'd0, v_coeffs[191]}), .d(DV[15:0]), .result(v_poly[191]));
    decompress_module decompress_v_192 (.x({12'd0, v_coeffs[192]}), .d(DV[15:0]), .result(v_poly[192]));
    decompress_module decompress_v_193 (.x({12'd0, v_coeffs[193]}), .d(DV[15:0]), .result(v_poly[193]));
    decompress_module decompress_v_194 (.x({12'd0, v_coeffs[194]}), .d(DV[15:0]), .result(v_poly[194]));
    decompress_module decompress_v_195 (.x({12'd0, v_coeffs[195]}), .d(DV[15:0]), .result(v_poly[195]));
    decompress_module decompress_v_196 (.x({12'd0, v_coeffs[196]}), .d(DV[15:0]), .result(v_poly[196]));
    decompress_module decompress_v_197 (.x({12'd0, v_coeffs[197]}), .d(DV[15:0]), .result(v_poly[197]));
    decompress_module decompress_v_198 (.x({12'd0, v_coeffs[198]}), .d(DV[15:0]), .result(v_poly[198]));
    decompress_module decompress_v_199 (.x({12'd0, v_coeffs[199]}), .d(DV[15:0]), .result(v_poly[199]));
    decompress_module decompress_v_200 (.x({12'd0, v_coeffs[200]}), .d(DV[15:0]), .result(v_poly[200]));
    decompress_module decompress_v_201 (.x({12'd0, v_coeffs[201]}), .d(DV[15:0]), .result(v_poly[201]));
    decompress_module decompress_v_202 (.x({12'd0, v_coeffs[202]}), .d(DV[15:0]), .result(v_poly[202]));
    decompress_module decompress_v_203 (.x({12'd0, v_coeffs[203]}), .d(DV[15:0]), .result(v_poly[203]));
    decompress_module decompress_v_204 (.x({12'd0, v_coeffs[204]}), .d(DV[15:0]), .result(v_poly[204]));
    decompress_module decompress_v_205 (.x({12'd0, v_coeffs[205]}), .d(DV[15:0]), .result(v_poly[205]));
    decompress_module decompress_v_206 (.x({12'd0, v_coeffs[206]}), .d(DV[15:0]), .result(v_poly[206]));
    decompress_module decompress_v_207 (.x({12'd0, v_coeffs[207]}), .d(DV[15:0]), .result(v_poly[207]));
    decompress_module decompress_v_208 (.x({12'd0, v_coeffs[208]}), .d(DV[15:0]), .result(v_poly[208]));
    decompress_module decompress_v_209 (.x({12'd0, v_coeffs[209]}), .d(DV[15:0]), .result(v_poly[209]));
    decompress_module decompress_v_210 (.x({12'd0, v_coeffs[210]}), .d(DV[15:0]), .result(v_poly[210]));
    decompress_module decompress_v_211 (.x({12'd0, v_coeffs[211]}), .d(DV[15:0]), .result(v_poly[211]));
    decompress_module decompress_v_212 (.x({12'd0, v_coeffs[212]}), .d(DV[15:0]), .result(v_poly[212]));
    decompress_module decompress_v_213 (.x({12'd0, v_coeffs[213]}), .d(DV[15:0]), .result(v_poly[213]));
    decompress_module decompress_v_214 (.x({12'd0, v_coeffs[214]}), .d(DV[15:0]), .result(v_poly[214]));
    decompress_module decompress_v_215 (.x({12'd0, v_coeffs[215]}), .d(DV[15:0]), .result(v_poly[215]));
    decompress_module decompress_v_216 (.x({12'd0, v_coeffs[216]}), .d(DV[15:0]), .result(v_poly[216]));
    decompress_module decompress_v_217 (.x({12'd0, v_coeffs[217]}), .d(DV[15:0]), .result(v_poly[217]));
    decompress_module decompress_v_218 (.x({12'd0, v_coeffs[218]}), .d(DV[15:0]), .result(v_poly[218]));
    decompress_module decompress_v_219 (.x({12'd0, v_coeffs[219]}), .d(DV[15:0]), .result(v_poly[219]));
    decompress_module decompress_v_220 (.x({12'd0, v_coeffs[220]}), .d(DV[15:0]), .result(v_poly[220]));
    decompress_module decompress_v_221 (.x({12'd0, v_coeffs[221]}), .d(DV[15:0]), .result(v_poly[221]));
    decompress_module decompress_v_222 (.x({12'd0, v_coeffs[222]}), .d(DV[15:0]), .result(v_poly[222]));
    decompress_module decompress_v_223 (.x({12'd0, v_coeffs[223]}), .d(DV[15:0]), .result(v_poly[223]));
    decompress_module decompress_v_224 (.x({12'd0, v_coeffs[224]}), .d(DV[15:0]), .result(v_poly[224]));
    decompress_module decompress_v_225 (.x({12'd0, v_coeffs[225]}), .d(DV[15:0]), .result(v_poly[225]));
    decompress_module decompress_v_226 (.x({12'd0, v_coeffs[226]}), .d(DV[15:0]), .result(v_poly[226]));
    decompress_module decompress_v_227 (.x({12'd0, v_coeffs[227]}), .d(DV[15:0]), .result(v_poly[227]));
    decompress_module decompress_v_228 (.x({12'd0, v_coeffs[228]}), .d(DV[15:0]), .result(v_poly[228]));
    decompress_module decompress_v_229 (.x({12'd0, v_coeffs[229]}), .d(DV[15:0]), .result(v_poly[229]));
    decompress_module decompress_v_230 (.x({12'd0, v_coeffs[230]}), .d(DV[15:0]), .result(v_poly[230]));
    decompress_module decompress_v_231 (.x({12'd0, v_coeffs[231]}), .d(DV[15:0]), .result(v_poly[231]));
    decompress_module decompress_v_232 (.x({12'd0, v_coeffs[232]}), .d(DV[15:0]), .result(v_poly[232]));
    decompress_module decompress_v_233 (.x({12'd0, v_coeffs[233]}), .d(DV[15:0]), .result(v_poly[233]));
    decompress_module decompress_v_234 (.x({12'd0, v_coeffs[234]}), .d(DV[15:0]), .result(v_poly[234]));
    decompress_module decompress_v_235 (.x({12'd0, v_coeffs[235]}), .d(DV[15:0]), .result(v_poly[235]));
    decompress_module decompress_v_236 (.x({12'd0, v_coeffs[236]}), .d(DV[15:0]), .result(v_poly[236]));
    decompress_module decompress_v_237 (.x({12'd0, v_coeffs[237]}), .d(DV[15:0]), .result(v_poly[237]));
    decompress_module decompress_v_238 (.x({12'd0, v_coeffs[238]}), .d(DV[15:0]), .result(v_poly[238]));
    decompress_module decompress_v_239 (.x({12'd0, v_coeffs[239]}), .d(DV[15:0]), .result(v_poly[239]));
    decompress_module decompress_v_240 (.x({12'd0, v_coeffs[240]}), .d(DV[15:0]), .result(v_poly[240]));
    decompress_module decompress_v_241 (.x({12'd0, v_coeffs[241]}), .d(DV[15:0]), .result(v_poly[241]));
    decompress_module decompress_v_242 (.x({12'd0, v_coeffs[242]}), .d(DV[15:0]), .result(v_poly[242]));
    decompress_module decompress_v_243 (.x({12'd0, v_coeffs[243]}), .d(DV[15:0]), .result(v_poly[243]));
    decompress_module decompress_v_244 (.x({12'd0, v_coeffs[244]}), .d(DV[15:0]), .result(v_poly[244]));
    decompress_module decompress_v_245 (.x({12'd0, v_coeffs[245]}), .d(DV[15:0]), .result(v_poly[245]));
    decompress_module decompress_v_246 (.x({12'd0, v_coeffs[246]}), .d(DV[15:0]), .result(v_poly[246]));
    decompress_module decompress_v_247 (.x({12'd0, v_coeffs[247]}), .d(DV[15:0]), .result(v_poly[247]));
    decompress_module decompress_v_248 (.x({12'd0, v_coeffs[248]}), .d(DV[15:0]), .result(v_poly[248]));
    decompress_module decompress_v_249 (.x({12'd0, v_coeffs[249]}), .d(DV[15:0]), .result(v_poly[249]));
    decompress_module decompress_v_250 (.x({12'd0, v_coeffs[250]}), .d(DV[15:0]), .result(v_poly[250]));
    decompress_module decompress_v_251 (.x({12'd0, v_coeffs[251]}), .d(DV[15:0]), .result(v_poly[251]));
    decompress_module decompress_v_252 (.x({12'd0, v_coeffs[252]}), .d(DV[15:0]), .result(v_poly[252]));
    decompress_module decompress_v_253 (.x({12'd0, v_coeffs[253]}), .d(DV[15:0]), .result(v_poly[253]));
    decompress_module decompress_v_254 (.x({12'd0, v_coeffs[254]}), .d(DV[15:0]), .result(v_poly[254]));
    decompress_module decompress_v_255 (.x({12'd0, v_coeffs[255]}), .d(DV[15:0]), .result(v_poly[255]));    //        for (int i = 0; i < 256; i++)
//            u_poly_2bit[i] = u_poly[i][1:0];
//    end

    // 4. NTT(u')
    ntt ntt_u_inst (
        .clk(clk),
        .reset(rst),
        .start(state == S_NTT_U),
        .f(u_poly_2bit),
        .f_hat(ntt_u),
        .done(done_ntt)
    );

    // 5. Element-wise multiplication: ntt_u * s_poly
    always_ff @(posedge clk) begin
        if (state == S_MULT_S) begin
            for (int i = 0; i < 256; i++)
                mult_s[i] <= $signed(ntt_u[i]) * $signed(s_poly[i]);
        end
    end

    // 6. Inverse NTT
    inverse_ntt invntt_inst (
        .clk(clk),
        .rst(rst),
        .f(mult_s),
        .start_ntt(state == S_INV_NTT),
        .done_ntt(done_invntt),
        .f_hat(inv_ntt)
    );

    // 7. w = v_poly - inv_ntt
    always_ff @(posedge clk) begin
        if (state == S_SUB_V) begin
        w_poly[0] <= v_poly[0] - inv_ntt[0][15:0];
        w_poly[1] <= v_poly[1] - inv_ntt[1][15:0];
        w_poly[2] <= v_poly[2] - inv_ntt[2][15:0];
        w_poly[3] <= v_poly[3] - inv_ntt[3][15:0];
        w_poly[4] <= v_poly[4] - inv_ntt[4][15:0];
        w_poly[5] <= v_poly[5] - inv_ntt[5][15:0];
        w_poly[6] <= v_poly[6] - inv_ntt[6][15:0];
        w_poly[7] <= v_poly[7] - inv_ntt[7][15:0];
        w_poly[8] <= v_poly[8] - inv_ntt[8][15:0];
        w_poly[9] <= v_poly[9] - inv_ntt[9][15:0];
        w_poly[10] <= v_poly[10] - inv_ntt[10][15:0];
        w_poly[11] <= v_poly[11] - inv_ntt[11][15:0];
        w_poly[12] <= v_poly[12] - inv_ntt[12][15:0];
        w_poly[13] <= v_poly[13] - inv_ntt[13][15:0];
        w_poly[14] <= v_poly[14] - inv_ntt[14][15:0];
        w_poly[15] <= v_poly[15] - inv_ntt[15][15:0];
        w_poly[16] <= v_poly[16] - inv_ntt[16][15:0];
        w_poly[17] <= v_poly[17] - inv_ntt[17][15:0];
        w_poly[18] <= v_poly[18] - inv_ntt[18][15:0];
        w_poly[19] <= v_poly[19] - inv_ntt[19][15:0];
        w_poly[20] <= v_poly[20] - inv_ntt[20][15:0];
        w_poly[21] <= v_poly[21] - inv_ntt[21][15:0];
        w_poly[22] <= v_poly[22] - inv_ntt[22][15:0];
        w_poly[23] <= v_poly[23] - inv_ntt[23][15:0];
        w_poly[24] <= v_poly[24] - inv_ntt[24][15:0];
        w_poly[25] <= v_poly[25] - inv_ntt[25][15:0];
        w_poly[26] <= v_poly[26] - inv_ntt[26][15:0];
        w_poly[27] <= v_poly[27] - inv_ntt[27][15:0];
        w_poly[28] <= v_poly[28] - inv_ntt[28][15:0];
        w_poly[29] <= v_poly[29] - inv_ntt[29][15:0];
        w_poly[30] <= v_poly[30] - inv_ntt[30][15:0];
        w_poly[31] <= v_poly[31] - inv_ntt[31][15:0];
        w_poly[32] <= v_poly[32] - inv_ntt[32][15:0];
        w_poly[33] <= v_poly[33] - inv_ntt[33][15:0];
        w_poly[34] <= v_poly[34] - inv_ntt[34][15:0];
        w_poly[35] <= v_poly[35] - inv_ntt[35][15:0];
        w_poly[36] <= v_poly[36] - inv_ntt[36][15:0];
        w_poly[37] <= v_poly[37] - inv_ntt[37][15:0];
        w_poly[38] <= v_poly[38] - inv_ntt[38][15:0];
        w_poly[39] <= v_poly[39] - inv_ntt[39][15:0];
        w_poly[40] <= v_poly[40] - inv_ntt[40][15:0];
        w_poly[41] <= v_poly[41] - inv_ntt[41][15:0];
        w_poly[42] <= v_poly[42] - inv_ntt[42][15:0];
        w_poly[43] <= v_poly[43] - inv_ntt[43][15:0];
        w_poly[44] <= v_poly[44] - inv_ntt[44][15:0];
        w_poly[45] <= v_poly[45] - inv_ntt[45][15:0];
        w_poly[46] <= v_poly[46] - inv_ntt[46][15:0];
        w_poly[47] <= v_poly[47] - inv_ntt[47][15:0];
        w_poly[48] <= v_poly[48] - inv_ntt[48][15:0];
        w_poly[49] <= v_poly[49] - inv_ntt[49][15:0];
        w_poly[50] <= v_poly[50] - inv_ntt[50][15:0];
        w_poly[51] <= v_poly[51] - inv_ntt[51][15:0];
        w_poly[52] <= v_poly[52] - inv_ntt[52][15:0];
        w_poly[53] <= v_poly[53] - inv_ntt[53][15:0];
        w_poly[54] <= v_poly[54] - inv_ntt[54][15:0];
        w_poly[55] <= v_poly[55] - inv_ntt[55][15:0];
        w_poly[56] <= v_poly[56] - inv_ntt[56][15:0];
        w_poly[57] <= v_poly[57] - inv_ntt[57][15:0];
        w_poly[58] <= v_poly[58] - inv_ntt[58][15:0];
        w_poly[59] <= v_poly[59] - inv_ntt[59][15:0];
        w_poly[60] <= v_poly[60] - inv_ntt[60][15:0];
        w_poly[61] <= v_poly[61] - inv_ntt[61][15:0];
        w_poly[62] <= v_poly[62] - inv_ntt[62][15:0];
        w_poly[63] <= v_poly[63] - inv_ntt[63][15:0];
        w_poly[64] <= v_poly[64] - inv_ntt[64][15:0];
        w_poly[65] <= v_poly[65] - inv_ntt[65][15:0];
        w_poly[66] <= v_poly[66] - inv_ntt[66][15:0];
        w_poly[67] <= v_poly[67] - inv_ntt[67][15:0];
        w_poly[68] <= v_poly[68] - inv_ntt[68][15:0];
        w_poly[69] <= v_poly[69] - inv_ntt[69][15:0];
        w_poly[70] <= v_poly[70] - inv_ntt[70][15:0];
        w_poly[71] <= v_poly[71] - inv_ntt[71][15:0];
        w_poly[72] <= v_poly[72] - inv_ntt[72][15:0];
        w_poly[73] <= v_poly[73] - inv_ntt[73][15:0];
        w_poly[74] <= v_poly[74] - inv_ntt[74][15:0];
        w_poly[75] <= v_poly[75] - inv_ntt[75][15:0];
        w_poly[76] <= v_poly[76] - inv_ntt[76][15:0];
        w_poly[77] <= v_poly[77] - inv_ntt[77][15:0];
        w_poly[78] <= v_poly[78] - inv_ntt[78][15:0];
        w_poly[79] <= v_poly[79] - inv_ntt[79][15:0];
        w_poly[80] <= v_poly[80] - inv_ntt[80][15:0];
        w_poly[81] <= v_poly[81] - inv_ntt[81][15:0];
        w_poly[82] <= v_poly[82] - inv_ntt[82][15:0];
        w_poly[83] <= v_poly[83] - inv_ntt[83][15:0];
        w_poly[84] <= v_poly[84] - inv_ntt[84][15:0];
        w_poly[85] <= v_poly[85] - inv_ntt[85][15:0];
        w_poly[86] <= v_poly[86] - inv_ntt[86][15:0];
        w_poly[87] <= v_poly[87] - inv_ntt[87][15:0];
        w_poly[88] <= v_poly[88] - inv_ntt[88][15:0];
        w_poly[89] <= v_poly[89] - inv_ntt[89][15:0];
        w_poly[90] <= v_poly[90] - inv_ntt[90][15:0];
        w_poly[91] <= v_poly[91] - inv_ntt[91][15:0];
        w_poly[92] <= v_poly[92] - inv_ntt[92][15:0];
        w_poly[93] <= v_poly[93] - inv_ntt[93][15:0];
        w_poly[94] <= v_poly[94] - inv_ntt[94][15:0];
        w_poly[95] <= v_poly[95] - inv_ntt[95][15:0];
        w_poly[96] <= v_poly[96] - inv_ntt[96][15:0];
        w_poly[97] <= v_poly[97] - inv_ntt[97][15:0];
        w_poly[98] <= v_poly[98] - inv_ntt[98][15:0];
        w_poly[99] <= v_poly[99] - inv_ntt[99][15:0];
        w_poly[100] <= v_poly[100] - inv_ntt[100][15:0];
        w_poly[101] <= v_poly[101] - inv_ntt[101][15:0];
        w_poly[102] <= v_poly[102] - inv_ntt[102][15:0];
        w_poly[103] <= v_poly[103] - inv_ntt[103][15:0];
        w_poly[104] <= v_poly[104] - inv_ntt[104][15:0];
        w_poly[105] <= v_poly[105] - inv_ntt[105][15:0];
        w_poly[106] <= v_poly[106] - inv_ntt[106][15:0];
        w_poly[107] <= v_poly[107] - inv_ntt[107][15:0];
        w_poly[108] <= v_poly[108] - inv_ntt[108][15:0];
        w_poly[109] <= v_poly[109] - inv_ntt[109][15:0];
        w_poly[110] <= v_poly[110] - inv_ntt[110][15:0];
        w_poly[111] <= v_poly[111] - inv_ntt[111][15:0];
        w_poly[112] <= v_poly[112] - inv_ntt[112][15:0];
        w_poly[113] <= v_poly[113] - inv_ntt[113][15:0];
        w_poly[114] <= v_poly[114] - inv_ntt[114][15:0];
        w_poly[115] <= v_poly[115] - inv_ntt[115][15:0];
        w_poly[116] <= v_poly[116] - inv_ntt[116][15:0];
        w_poly[117] <= v_poly[117] - inv_ntt[117][15:0];
        w_poly[118] <= v_poly[118] - inv_ntt[118][15:0];
        w_poly[119] <= v_poly[119] - inv_ntt[119][15:0];
        w_poly[120] <= v_poly[120] - inv_ntt[120][15:0];
        w_poly[121] <= v_poly[121] - inv_ntt[121][15:0];
        w_poly[122] <= v_poly[122] - inv_ntt[122][15:0];
        w_poly[123] <= v_poly[123] - inv_ntt[123][15:0];
        w_poly[124] <= v_poly[124] - inv_ntt[124][15:0];
        w_poly[125] <= v_poly[125] - inv_ntt[125][15:0];
        w_poly[126] <= v_poly[126] - inv_ntt[126][15:0];
        w_poly[127] <= v_poly[127] - inv_ntt[127][15:0];
        w_poly[128] <= v_poly[128] - inv_ntt[128][15:0];
        w_poly[129] <= v_poly[129] - inv_ntt[129][15:0];
        w_poly[130] <= v_poly[130] - inv_ntt[130][15:0];
        w_poly[131] <= v_poly[131] - inv_ntt[131][15:0];
        w_poly[132] <= v_poly[132] - inv_ntt[132][15:0];
        w_poly[133] <= v_poly[133] - inv_ntt[133][15:0];
        w_poly[134] <= v_poly[134] - inv_ntt[134][15:0];
        w_poly[135] <= v_poly[135] - inv_ntt[135][15:0];
        w_poly[136] <= v_poly[136] - inv_ntt[136][15:0];
        w_poly[137] <= v_poly[137] - inv_ntt[137][15:0];
        w_poly[138] <= v_poly[138] - inv_ntt[138][15:0];
        w_poly[139] <= v_poly[139] - inv_ntt[139][15:0];
        w_poly[140] <= v_poly[140] - inv_ntt[140][15:0];
        w_poly[141] <= v_poly[141] - inv_ntt[141][15:0];
        w_poly[142] <= v_poly[142] - inv_ntt[142][15:0];
        w_poly[143] <= v_poly[143] - inv_ntt[143][15:0];
        w_poly[144] <= v_poly[144] - inv_ntt[144][15:0];
        w_poly[145] <= v_poly[145] - inv_ntt[145][15:0];
        w_poly[146] <= v_poly[146] - inv_ntt[146][15:0];
        w_poly[147] <= v_poly[147] - inv_ntt[147][15:0];
        w_poly[148] <= v_poly[148] - inv_ntt[148][15:0];
        w_poly[149] <= v_poly[149] - inv_ntt[149][15:0];
        w_poly[150] <= v_poly[150] - inv_ntt[150][15:0];
        w_poly[151] <= v_poly[151] - inv_ntt[151][15:0];
        w_poly[152] <= v_poly[152] - inv_ntt[152][15:0];
        w_poly[153] <= v_poly[153] - inv_ntt[153][15:0];
        w_poly[154] <= v_poly[154] - inv_ntt[154][15:0];
        w_poly[155] <= v_poly[155] - inv_ntt[155][15:0];
        w_poly[156] <= v_poly[156] - inv_ntt[156][15:0];
        w_poly[157] <= v_poly[157] - inv_ntt[157][15:0];
        w_poly[158] <= v_poly[158] - inv_ntt[158][15:0];
        w_poly[159] <= v_poly[159] - inv_ntt[159][15:0];
        w_poly[160] <= v_poly[160] - inv_ntt[160][15:0];
        w_poly[161] <= v_poly[161] - inv_ntt[161][15:0];
        w_poly[162] <= v_poly[162] - inv_ntt[162][15:0];
        w_poly[163] <= v_poly[163] - inv_ntt[163][15:0];
        w_poly[164] <= v_poly[164] - inv_ntt[164][15:0];
        w_poly[165] <= v_poly[165] - inv_ntt[165][15:0];
        w_poly[166] <= v_poly[166] - inv_ntt[166][15:0];
        w_poly[167] <= v_poly[167] - inv_ntt[167][15:0];
        w_poly[168] <= v_poly[168] - inv_ntt[168][15:0];
        w_poly[169] <= v_poly[169] - inv_ntt[169][15:0];
        w_poly[170] <= v_poly[170] - inv_ntt[170][15:0];
        w_poly[171] <= v_poly[171] - inv_ntt[171][15:0];
        w_poly[172] <= v_poly[172] - inv_ntt[172][15:0];
        w_poly[173] <= v_poly[173] - inv_ntt[173][15:0];
        w_poly[174] <= v_poly[174] - inv_ntt[174][15:0];
        w_poly[175] <= v_poly[175] - inv_ntt[175][15:0];
        w_poly[176] <= v_poly[176] - inv_ntt[176][15:0];
        w_poly[177] <= v_poly[177] - inv_ntt[177][15:0];
        w_poly[178] <= v_poly[178] - inv_ntt[178][15:0];
        w_poly[179] <= v_poly[179] - inv_ntt[179][15:0];
        w_poly[180] <= v_poly[180] - inv_ntt[180][15:0];
        w_poly[181] <= v_poly[181] - inv_ntt[181][15:0];
        w_poly[182] <= v_poly[182] - inv_ntt[182][15:0];
        w_poly[183] <= v_poly[183] - inv_ntt[183][15:0];
        w_poly[184] <= v_poly[184] - inv_ntt[184][15:0];
        w_poly[185] <= v_poly[185] - inv_ntt[185][15:0];
        w_poly[186] <= v_poly[186] - inv_ntt[186][15:0];
        w_poly[187] <= v_poly[187] - inv_ntt[187][15:0];
        w_poly[188] <= v_poly[188] - inv_ntt[188][15:0];
        w_poly[189] <= v_poly[189] - inv_ntt[189][15:0];
        w_poly[190] <= v_poly[190] - inv_ntt[190][15:0];
        w_poly[191] <= v_poly[191] - inv_ntt[191][15:0];
        w_poly[192] <= v_poly[192] - inv_ntt[192][15:0];
        w_poly[193] <= v_poly[193] - inv_ntt[193][15:0];
        w_poly[194] <= v_poly[194] - inv_ntt[194][15:0];
        w_poly[195] <= v_poly[195] - inv_ntt[195][15:0];
        w_poly[196] <= v_poly[196] - inv_ntt[196][15:0];
        w_poly[197] <= v_poly[197] - inv_ntt[197][15:0];
        w_poly[198] <= v_poly[198] - inv_ntt[198][15:0];
        w_poly[199] <= v_poly[199] - inv_ntt[199][15:0];
        w_poly[200] <= v_poly[200] - inv_ntt[200][15:0];
        w_poly[201] <= v_poly[201] - inv_ntt[201][15:0];
        w_poly[202] <= v_poly[202] - inv_ntt[202][15:0];
        w_poly[203] <= v_poly[203] - inv_ntt[203][15:0];
        w_poly[204] <= v_poly[204] - inv_ntt[204][15:0];
        w_poly[205] <= v_poly[205] - inv_ntt[205][15:0];
        w_poly[206] <= v_poly[206] - inv_ntt[206][15:0];
        w_poly[207] <= v_poly[207] - inv_ntt[207][15:0];
        w_poly[208] <= v_poly[208] - inv_ntt[208][15:0];
        w_poly[209] <= v_poly[209] - inv_ntt[209][15:0];
        w_poly[210] <= v_poly[210] - inv_ntt[210][15:0];
        w_poly[211] <= v_poly[211] - inv_ntt[211][15:0];
        w_poly[212] <= v_poly[212] - inv_ntt[212][15:0];
        w_poly[213] <= v_poly[213] - inv_ntt[213][15:0];
        w_poly[214] <= v_poly[214] - inv_ntt[214][15:0];
        w_poly[215] <= v_poly[215] - inv_ntt[215][15:0];
        w_poly[216] <= v_poly[216] - inv_ntt[216][15:0];
        w_poly[217] <= v_poly[217] - inv_ntt[217][15:0];
        w_poly[218] <= v_poly[218] - inv_ntt[218][15:0];
        w_poly[219] <= v_poly[219] - inv_ntt[219][15:0];
        w_poly[220] <= v_poly[220] - inv_ntt[220][15:0];
        w_poly[221] <= v_poly[221] - inv_ntt[221][15:0];
        w_poly[222] <= v_poly[222] - inv_ntt[222][15:0];
        w_poly[223] <= v_poly[223] - inv_ntt[223][15:0];
        w_poly[224] <= v_poly[224] - inv_ntt[224][15:0];
        w_poly[225] <= v_poly[225] - inv_ntt[225][15:0];
        w_poly[226] <= v_poly[226] - inv_ntt[226][15:0];
        w_poly[227] <= v_poly[227] - inv_ntt[227][15:0];
        w_poly[228] <= v_poly[228] - inv_ntt[228][15:0];
        w_poly[229] <= v_poly[229] - inv_ntt[229][15:0];
        w_poly[230] <= v_poly[230] - inv_ntt[230][15:0];
        w_poly[231] <= v_poly[231] - inv_ntt[231][15:0];
        w_poly[232] <= v_poly[232] - inv_ntt[232][15:0];
        w_poly[233] <= v_poly[233] - inv_ntt[233][15:0];
        w_poly[234] <= v_poly[234] - inv_ntt[234][15:0];
        w_poly[235] <= v_poly[235] - inv_ntt[235][15:0];
        w_poly[236] <= v_poly[236] - inv_ntt[236][15:0];
        w_poly[237] <= v_poly[237] - inv_ntt[237][15:0];
        w_poly[238] <= v_poly[238] - inv_ntt[238][15:0];
        w_poly[239] <= v_poly[239] - inv_ntt[239][15:0];
        w_poly[240] <= v_poly[240] - inv_ntt[240][15:0];
        w_poly[241] <= v_poly[241] - inv_ntt[241][15:0];
        w_poly[242] <= v_poly[242] - inv_ntt[242][15:0];
        w_poly[243] <= v_poly[243] - inv_ntt[243][15:0];
        w_poly[244] <= v_poly[244] - inv_ntt[244][15:0];
        w_poly[245] <= v_poly[245] - inv_ntt[245][15:0];
        w_poly[246] <= v_poly[246] - inv_ntt[246][15:0];
        w_poly[247] <= v_poly[247] - inv_ntt[247][15:0];
        w_poly[248] <= v_poly[248] - inv_ntt[248][15:0];
        w_poly[249] <= v_poly[249] - inv_ntt[249][15:0];
        w_poly[250] <= v_poly[250] - inv_ntt[250][15:0];
        w_poly[251] <= v_poly[251] - inv_ntt[251][15:0];
        w_poly[252] <= v_poly[252] - inv_ntt[252][15:0];
        w_poly[253] <= v_poly[253] - inv_ntt[253][15:0];
        w_poly[254] <= v_poly[254] - inv_ntt[254][15:0];
        w_poly[255] <= v_poly[255] - inv_ntt[255][15:0];
        end
    end

    // 8. Compress
    compress_module compress_0 (.x(w_poly[0]), .d(16'd1), .result(compressed[0]));
    compress_module compress_1 (.x(w_poly[1]), .d(16'd1), .result(compressed[1]));
    compress_module compress_2 (.x(w_poly[2]), .d(16'd1), .result(compressed[2]));
    compress_module compress_3 (.x(w_poly[3]), .d(16'd1), .result(compressed[3]));
    compress_module compress_4 (.x(w_poly[4]), .d(16'd1), .result(compressed[4]));
    compress_module compress_5 (.x(w_poly[5]), .d(16'd1), .result(compressed[5]));
    compress_module compress_6 (.x(w_poly[6]), .d(16'd1), .result(compressed[6]));
    compress_module compress_7 (.x(w_poly[7]), .d(16'd1), .result(compressed[7]));
    compress_module compress_8 (.x(w_poly[8]), .d(16'd1), .result(compressed[8]));
    compress_module compress_9 (.x(w_poly[9]), .d(16'd1), .result(compressed[9]));
    compress_module compress_10 (.x(w_poly[10]), .d(16'd1), .result(compressed[10]));
    compress_module compress_11 (.x(w_poly[11]), .d(16'd1), .result(compressed[11]));
    compress_module compress_12 (.x(w_poly[12]), .d(16'd1), .result(compressed[12]));
    compress_module compress_13 (.x(w_poly[13]), .d(16'd1), .result(compressed[13]));
    compress_module compress_14 (.x(w_poly[14]), .d(16'd1), .result(compressed[14]));
    compress_module compress_15 (.x(w_poly[15]), .d(16'd1), .result(compressed[15]));
    compress_module compress_16 (.x(w_poly[16]), .d(16'd1), .result(compressed[16]));
    compress_module compress_17 (.x(w_poly[17]), .d(16'd1), .result(compressed[17]));
    compress_module compress_18 (.x(w_poly[18]), .d(16'd1), .result(compressed[18]));
    compress_module compress_19 (.x(w_poly[19]), .d(16'd1), .result(compressed[19]));
    compress_module compress_20 (.x(w_poly[20]), .d(16'd1), .result(compressed[20]));
    compress_module compress_21 (.x(w_poly[21]), .d(16'd1), .result(compressed[21]));
    compress_module compress_22 (.x(w_poly[22]), .d(16'd1), .result(compressed[22]));
    compress_module compress_23 (.x(w_poly[23]), .d(16'd1), .result(compressed[23]));
    compress_module compress_24 (.x(w_poly[24]), .d(16'd1), .result(compressed[24]));
    compress_module compress_25 (.x(w_poly[25]), .d(16'd1), .result(compressed[25]));
    compress_module compress_26 (.x(w_poly[26]), .d(16'd1), .result(compressed[26]));
    compress_module compress_27 (.x(w_poly[27]), .d(16'd1), .result(compressed[27]));
    compress_module compress_28 (.x(w_poly[28]), .d(16'd1), .result(compressed[28]));
    compress_module compress_29 (.x(w_poly[29]), .d(16'd1), .result(compressed[29]));
    compress_module compress_30 (.x(w_poly[30]), .d(16'd1), .result(compressed[30]));
    compress_module compress_31 (.x(w_poly[31]), .d(16'd1), .result(compressed[31]));
    compress_module compress_32 (.x(w_poly[32]), .d(16'd1), .result(compressed[32]));
    compress_module compress_33 (.x(w_poly[33]), .d(16'd1), .result(compressed[33]));
    compress_module compress_34 (.x(w_poly[34]), .d(16'd1), .result(compressed[34]));
    compress_module compress_35 (.x(w_poly[35]), .d(16'd1), .result(compressed[35]));
    compress_module compress_36 (.x(w_poly[36]), .d(16'd1), .result(compressed[36]));
    compress_module compress_37 (.x(w_poly[37]), .d(16'd1), .result(compressed[37]));
    compress_module compress_38 (.x(w_poly[38]), .d(16'd1), .result(compressed[38]));
    compress_module compress_39 (.x(w_poly[39]), .d(16'd1), .result(compressed[39]));
    compress_module compress_40 (.x(w_poly[40]), .d(16'd1), .result(compressed[40]));
    compress_module compress_41 (.x(w_poly[41]), .d(16'd1), .result(compressed[41]));
    compress_module compress_42 (.x(w_poly[42]), .d(16'd1), .result(compressed[42]));
    compress_module compress_43 (.x(w_poly[43]), .d(16'd1), .result(compressed[43]));
    compress_module compress_44 (.x(w_poly[44]), .d(16'd1), .result(compressed[44]));
    compress_module compress_45 (.x(w_poly[45]), .d(16'd1), .result(compressed[45]));
    compress_module compress_46 (.x(w_poly[46]), .d(16'd1), .result(compressed[46]));
    compress_module compress_47 (.x(w_poly[47]), .d(16'd1), .result(compressed[47]));
    compress_module compress_48 (.x(w_poly[48]), .d(16'd1), .result(compressed[48]));
    compress_module compress_49 (.x(w_poly[49]), .d(16'd1), .result(compressed[49]));
    compress_module compress_50 (.x(w_poly[50]), .d(16'd1), .result(compressed[50]));
    compress_module compress_51 (.x(w_poly[51]), .d(16'd1), .result(compressed[51]));
    compress_module compress_52 (.x(w_poly[52]), .d(16'd1), .result(compressed[52]));
    compress_module compress_53 (.x(w_poly[53]), .d(16'd1), .result(compressed[53]));
    compress_module compress_54 (.x(w_poly[54]), .d(16'd1), .result(compressed[54]));
    compress_module compress_55 (.x(w_poly[55]), .d(16'd1), .result(compressed[55]));
    compress_module compress_56 (.x(w_poly[56]), .d(16'd1), .result(compressed[56]));
    compress_module compress_57 (.x(w_poly[57]), .d(16'd1), .result(compressed[57]));
    compress_module compress_58 (.x(w_poly[58]), .d(16'd1), .result(compressed[58]));
    compress_module compress_59 (.x(w_poly[59]), .d(16'd1), .result(compressed[59]));
    compress_module compress_60 (.x(w_poly[60]), .d(16'd1), .result(compressed[60]));
    compress_module compress_61 (.x(w_poly[61]), .d(16'd1), .result(compressed[61]));
    compress_module compress_62 (.x(w_poly[62]), .d(16'd1), .result(compressed[62]));
    compress_module compress_63 (.x(w_poly[63]), .d(16'd1), .result(compressed[63]));
    compress_module compress_64 (.x(w_poly[64]), .d(16'd1), .result(compressed[64]));
    compress_module compress_65 (.x(w_poly[65]), .d(16'd1), .result(compressed[65]));
    compress_module compress_66 (.x(w_poly[66]), .d(16'd1), .result(compressed[66]));
    compress_module compress_67 (.x(w_poly[67]), .d(16'd1), .result(compressed[67]));
    compress_module compress_68 (.x(w_poly[68]), .d(16'd1), .result(compressed[68]));
    compress_module compress_69 (.x(w_poly[69]), .d(16'd1), .result(compressed[69]));
    compress_module compress_70 (.x(w_poly[70]), .d(16'd1), .result(compressed[70]));
    compress_module compress_71 (.x(w_poly[71]), .d(16'd1), .result(compressed[71]));
    compress_module compress_72 (.x(w_poly[72]), .d(16'd1), .result(compressed[72]));
    compress_module compress_73 (.x(w_poly[73]), .d(16'd1), .result(compressed[73]));
    compress_module compress_74 (.x(w_poly[74]), .d(16'd1), .result(compressed[74]));
    compress_module compress_75 (.x(w_poly[75]), .d(16'd1), .result(compressed[75]));
    compress_module compress_76 (.x(w_poly[76]), .d(16'd1), .result(compressed[76]));
    compress_module compress_77 (.x(w_poly[77]), .d(16'd1), .result(compressed[77]));
    compress_module compress_78 (.x(w_poly[78]), .d(16'd1), .result(compressed[78]));
    compress_module compress_79 (.x(w_poly[79]), .d(16'd1), .result(compressed[79]));
    compress_module compress_80 (.x(w_poly[80]), .d(16'd1), .result(compressed[80]));
    compress_module compress_81 (.x(w_poly[81]), .d(16'd1), .result(compressed[81]));
    compress_module compress_82 (.x(w_poly[82]), .d(16'd1), .result(compressed[82]));
    compress_module compress_83 (.x(w_poly[83]), .d(16'd1), .result(compressed[83]));
    compress_module compress_84 (.x(w_poly[84]), .d(16'd1), .result(compressed[84]));
    compress_module compress_85 (.x(w_poly[85]), .d(16'd1), .result(compressed[85]));
    compress_module compress_86 (.x(w_poly[86]), .d(16'd1), .result(compressed[86]));
    compress_module compress_87 (.x(w_poly[87]), .d(16'd1), .result(compressed[87]));
    compress_module compress_88 (.x(w_poly[88]), .d(16'd1), .result(compressed[88]));
    compress_module compress_89 (.x(w_poly[89]), .d(16'd1), .result(compressed[89]));
    compress_module compress_90 (.x(w_poly[90]), .d(16'd1), .result(compressed[90]));
    compress_module compress_91 (.x(w_poly[91]), .d(16'd1), .result(compressed[91]));
    compress_module compress_92 (.x(w_poly[92]), .d(16'd1), .result(compressed[92]));
    compress_module compress_93 (.x(w_poly[93]), .d(16'd1), .result(compressed[93]));
    compress_module compress_94 (.x(w_poly[94]), .d(16'd1), .result(compressed[94]));
    compress_module compress_95 (.x(w_poly[95]), .d(16'd1), .result(compressed[95]));
    compress_module compress_96 (.x(w_poly[96]), .d(16'd1), .result(compressed[96]));
    compress_module compress_97 (.x(w_poly[97]), .d(16'd1), .result(compressed[97]));
    compress_module compress_98 (.x(w_poly[98]), .d(16'd1), .result(compressed[98]));
    compress_module compress_99 (.x(w_poly[99]), .d(16'd1), .result(compressed[99]));
    compress_module compress_100 (.x(w_poly[100]), .d(16'd1), .result(compressed[100]));
    compress_module compress_101 (.x(w_poly[101]), .d(16'd1), .result(compressed[101]));
    compress_module compress_102 (.x(w_poly[102]), .d(16'd1), .result(compressed[102]));
    compress_module compress_103 (.x(w_poly[103]), .d(16'd1), .result(compressed[103]));
    compress_module compress_104 (.x(w_poly[104]), .d(16'd1), .result(compressed[104]));
    compress_module compress_105 (.x(w_poly[105]), .d(16'd1), .result(compressed[105]));
    compress_module compress_106 (.x(w_poly[106]), .d(16'd1), .result(compressed[106]));
    compress_module compress_107 (.x(w_poly[107]), .d(16'd1), .result(compressed[107]));
    compress_module compress_108 (.x(w_poly[108]), .d(16'd1), .result(compressed[108]));
    compress_module compress_109 (.x(w_poly[109]), .d(16'd1), .result(compressed[109]));
    compress_module compress_110 (.x(w_poly[110]), .d(16'd1), .result(compressed[110]));
    compress_module compress_111 (.x(w_poly[111]), .d(16'd1), .result(compressed[111]));
    compress_module compress_112 (.x(w_poly[112]), .d(16'd1), .result(compressed[112]));
    compress_module compress_113 (.x(w_poly[113]), .d(16'd1), .result(compressed[113]));
    compress_module compress_114 (.x(w_poly[114]), .d(16'd1), .result(compressed[114]));
    compress_module compress_115 (.x(w_poly[115]), .d(16'd1), .result(compressed[115]));
    compress_module compress_116 (.x(w_poly[116]), .d(16'd1), .result(compressed[116]));
    compress_module compress_117 (.x(w_poly[117]), .d(16'd1), .result(compressed[117]));
    compress_module compress_118 (.x(w_poly[118]), .d(16'd1), .result(compressed[118]));
    compress_module compress_119 (.x(w_poly[119]), .d(16'd1), .result(compressed[119]));
    compress_module compress_120 (.x(w_poly[120]), .d(16'd1), .result(compressed[120]));
    compress_module compress_121 (.x(w_poly[121]), .d(16'd1), .result(compressed[121]));
    compress_module compress_122 (.x(w_poly[122]), .d(16'd1), .result(compressed[122]));
    compress_module compress_123 (.x(w_poly[123]), .d(16'd1), .result(compressed[123]));
    compress_module compress_124 (.x(w_poly[124]), .d(16'd1), .result(compressed[124]));
    compress_module compress_125 (.x(w_poly[125]), .d(16'd1), .result(compressed[125]));
    compress_module compress_126 (.x(w_poly[126]), .d(16'd1), .result(compressed[126]));
    compress_module compress_127 (.x(w_poly[127]), .d(16'd1), .result(compressed[127]));
    compress_module compress_128 (.x(w_poly[128]), .d(16'd1), .result(compressed[128]));
    compress_module compress_129 (.x(w_poly[129]), .d(16'd1), .result(compressed[129]));
    compress_module compress_130 (.x(w_poly[130]), .d(16'd1), .result(compressed[130]));
    compress_module compress_131 (.x(w_poly[131]), .d(16'd1), .result(compressed[131]));
    compress_module compress_132 (.x(w_poly[132]), .d(16'd1), .result(compressed[132]));
    compress_module compress_133 (.x(w_poly[133]), .d(16'd1), .result(compressed[133]));
    compress_module compress_134 (.x(w_poly[134]), .d(16'd1), .result(compressed[134]));
    compress_module compress_135 (.x(w_poly[135]), .d(16'd1), .result(compressed[135]));
    compress_module compress_136 (.x(w_poly[136]), .d(16'd1), .result(compressed[136]));
    compress_module compress_137 (.x(w_poly[137]), .d(16'd1), .result(compressed[137]));
    compress_module compress_138 (.x(w_poly[138]), .d(16'd1), .result(compressed[138]));
    compress_module compress_139 (.x(w_poly[139]), .d(16'd1), .result(compressed[139]));
    compress_module compress_140 (.x(w_poly[140]), .d(16'd1), .result(compressed[140]));
    compress_module compress_141 (.x(w_poly[141]), .d(16'd1), .result(compressed[141]));
    compress_module compress_142 (.x(w_poly[142]), .d(16'd1), .result(compressed[142]));
    compress_module compress_143 (.x(w_poly[143]), .d(16'd1), .result(compressed[143]));
    compress_module compress_144 (.x(w_poly[144]), .d(16'd1), .result(compressed[144]));
    compress_module compress_145 (.x(w_poly[145]), .d(16'd1), .result(compressed[145]));
    compress_module compress_146 (.x(w_poly[146]), .d(16'd1), .result(compressed[146]));
    compress_module compress_147 (.x(w_poly[147]), .d(16'd1), .result(compressed[147]));
    compress_module compress_148 (.x(w_poly[148]), .d(16'd1), .result(compressed[148]));
    compress_module compress_149 (.x(w_poly[149]), .d(16'd1), .result(compressed[149]));
    compress_module compress_150 (.x(w_poly[150]), .d(16'd1), .result(compressed[150]));
    compress_module compress_151 (.x(w_poly[151]), .d(16'd1), .result(compressed[151]));
    compress_module compress_152 (.x(w_poly[152]), .d(16'd1), .result(compressed[152]));
    compress_module compress_153 (.x(w_poly[153]), .d(16'd1), .result(compressed[153]));
    compress_module compress_154 (.x(w_poly[154]), .d(16'd1), .result(compressed[154]));
    compress_module compress_155 (.x(w_poly[155]), .d(16'd1), .result(compressed[155]));
    compress_module compress_156 (.x(w_poly[156]), .d(16'd1), .result(compressed[156]));
    compress_module compress_157 (.x(w_poly[157]), .d(16'd1), .result(compressed[157]));
    compress_module compress_158 (.x(w_poly[158]), .d(16'd1), .result(compressed[158]));
    compress_module compress_159 (.x(w_poly[159]), .d(16'd1), .result(compressed[159]));
    compress_module compress_160 (.x(w_poly[160]), .d(16'd1), .result(compressed[160]));
    compress_module compress_161 (.x(w_poly[161]), .d(16'd1), .result(compressed[161]));
    compress_module compress_162 (.x(w_poly[162]), .d(16'd1), .result(compressed[162]));
    compress_module compress_163 (.x(w_poly[163]), .d(16'd1), .result(compressed[163]));
    compress_module compress_164 (.x(w_poly[164]), .d(16'd1), .result(compressed[164]));
    compress_module compress_165 (.x(w_poly[165]), .d(16'd1), .result(compressed[165]));
    compress_module compress_166 (.x(w_poly[166]), .d(16'd1), .result(compressed[166]));
    compress_module compress_167 (.x(w_poly[167]), .d(16'd1), .result(compressed[167]));
    compress_module compress_168 (.x(w_poly[168]), .d(16'd1), .result(compressed[168]));
    compress_module compress_169 (.x(w_poly[169]), .d(16'd1), .result(compressed[169]));
    compress_module compress_170 (.x(w_poly[170]), .d(16'd1), .result(compressed[170]));
    compress_module compress_171 (.x(w_poly[171]), .d(16'd1), .result(compressed[171]));
    compress_module compress_172 (.x(w_poly[172]), .d(16'd1), .result(compressed[172]));
    compress_module compress_173 (.x(w_poly[173]), .d(16'd1), .result(compressed[173]));
    compress_module compress_174 (.x(w_poly[174]), .d(16'd1), .result(compressed[174]));
    compress_module compress_175 (.x(w_poly[175]), .d(16'd1), .result(compressed[175]));
    compress_module compress_176 (.x(w_poly[176]), .d(16'd1), .result(compressed[176]));
    compress_module compress_177 (.x(w_poly[177]), .d(16'd1), .result(compressed[177]));
    compress_module compress_178 (.x(w_poly[178]), .d(16'd1), .result(compressed[178]));
    compress_module compress_179 (.x(w_poly[179]), .d(16'd1), .result(compressed[179]));
    compress_module compress_180 (.x(w_poly[180]), .d(16'd1), .result(compressed[180]));
    compress_module compress_181 (.x(w_poly[181]), .d(16'd1), .result(compressed[181]));
    compress_module compress_182 (.x(w_poly[182]), .d(16'd1), .result(compressed[182]));
    compress_module compress_183 (.x(w_poly[183]), .d(16'd1), .result(compressed[183]));
    compress_module compress_184 (.x(w_poly[184]), .d(16'd1), .result(compressed[184]));
    compress_module compress_185 (.x(w_poly[185]), .d(16'd1), .result(compressed[185]));
    compress_module compress_186 (.x(w_poly[186]), .d(16'd1), .result(compressed[186]));
    compress_module compress_187 (.x(w_poly[187]), .d(16'd1), .result(compressed[187]));
    compress_module compress_188 (.x(w_poly[188]), .d(16'd1), .result(compressed[188]));
    compress_module compress_189 (.x(w_poly[189]), .d(16'd1), .result(compressed[189]));
    compress_module compress_190 (.x(w_poly[190]), .d(16'd1), .result(compressed[190]));
    compress_module compress_191 (.x(w_poly[191]), .d(16'd1), .result(compressed[191]));
    compress_module compress_192 (.x(w_poly[192]), .d(16'd1), .result(compressed[192]));
    compress_module compress_193 (.x(w_poly[193]), .d(16'd1), .result(compressed[193]));
    compress_module compress_194 (.x(w_poly[194]), .d(16'd1), .result(compressed[194]));
    compress_module compress_195 (.x(w_poly[195]), .d(16'd1), .result(compressed[195]));
    compress_module compress_196 (.x(w_poly[196]), .d(16'd1), .result(compressed[196]));
    compress_module compress_197 (.x(w_poly[197]), .d(16'd1), .result(compressed[197]));
    compress_module compress_198 (.x(w_poly[198]), .d(16'd1), .result(compressed[198]));
    compress_module compress_199 (.x(w_poly[199]), .d(16'd1), .result(compressed[199]));
    compress_module compress_200 (.x(w_poly[200]), .d(16'd1), .result(compressed[200]));
    compress_module compress_201 (.x(w_poly[201]), .d(16'd1), .result(compressed[201]));
    compress_module compress_202 (.x(w_poly[202]), .d(16'd1), .result(compressed[202]));
    compress_module compress_203 (.x(w_poly[203]), .d(16'd1), .result(compressed[203]));
    compress_module compress_204 (.x(w_poly[204]), .d(16'd1), .result(compressed[204]));
    compress_module compress_205 (.x(w_poly[205]), .d(16'd1), .result(compressed[205]));
    compress_module compress_206 (.x(w_poly[206]), .d(16'd1), .result(compressed[206]));
    compress_module compress_207 (.x(w_poly[207]), .d(16'd1), .result(compressed[207]));
    compress_module compress_208 (.x(w_poly[208]), .d(16'd1), .result(compressed[208]));
    compress_module compress_209 (.x(w_poly[209]), .d(16'd1), .result(compressed[209]));
    compress_module compress_210 (.x(w_poly[210]), .d(16'd1), .result(compressed[210]));
    compress_module compress_211 (.x(w_poly[211]), .d(16'd1), .result(compressed[211]));
    compress_module compress_212 (.x(w_poly[212]), .d(16'd1), .result(compressed[212]));
    compress_module compress_213 (.x(w_poly[213]), .d(16'd1), .result(compressed[213]));
    compress_module compress_214 (.x(w_poly[214]), .d(16'd1), .result(compressed[214]));
    compress_module compress_215 (.x(w_poly[215]), .d(16'd1), .result(compressed[215]));
    compress_module compress_216 (.x(w_poly[216]), .d(16'd1), .result(compressed[216]));
    compress_module compress_217 (.x(w_poly[217]), .d(16'd1), .result(compressed[217]));
    compress_module compress_218 (.x(w_poly[218]), .d(16'd1), .result(compressed[218]));
    compress_module compress_219 (.x(w_poly[219]), .d(16'd1), .result(compressed[219]));
    compress_module compress_220 (.x(w_poly[220]), .d(16'd1), .result(compressed[220]));
    compress_module compress_221 (.x(w_poly[221]), .d(16'd1), .result(compressed[221]));
    compress_module compress_222 (.x(w_poly[222]), .d(16'd1), .result(compressed[222]));
    compress_module compress_223 (.x(w_poly[223]), .d(16'd1), .result(compressed[223]));
    compress_module compress_224 (.x(w_poly[224]), .d(16'd1), .result(compressed[224]));
    compress_module compress_225 (.x(w_poly[225]), .d(16'd1), .result(compressed[225]));
    compress_module compress_226 (.x(w_poly[226]), .d(16'd1), .result(compressed[226]));
    compress_module compress_227 (.x(w_poly[227]), .d(16'd1), .result(compressed[227]));
    compress_module compress_228 (.x(w_poly[228]), .d(16'd1), .result(compressed[228]));
    compress_module compress_229 (.x(w_poly[229]), .d(16'd1), .result(compressed[229]));
    compress_module compress_230 (.x(w_poly[230]), .d(16'd1), .result(compressed[230]));
    compress_module compress_231 (.x(w_poly[231]), .d(16'd1), .result(compressed[231]));
    compress_module compress_232 (.x(w_poly[232]), .d(16'd1), .result(compressed[232]));
    compress_module compress_233 (.x(w_poly[233]), .d(16'd1), .result(compressed[233]));
    compress_module compress_234 (.x(w_poly[234]), .d(16'd1), .result(compressed[234]));
    compress_module compress_235 (.x(w_poly[235]), .d(16'd1), .result(compressed[235]));
    compress_module compress_236 (.x(w_poly[236]), .d(16'd1), .result(compressed[236]));
    compress_module compress_237 (.x(w_poly[237]), .d(16'd1), .result(compressed[237]));
    compress_module compress_238 (.x(w_poly[238]), .d(16'd1), .result(compressed[238]));
    compress_module compress_239 (.x(w_poly[239]), .d(16'd1), .result(compressed[239]));
    compress_module compress_240 (.x(w_poly[240]), .d(16'd1), .result(compressed[240]));
    compress_module compress_241 (.x(w_poly[241]), .d(16'd1), .result(compressed[241]));
    compress_module compress_242 (.x(w_poly[242]), .d(16'd1), .result(compressed[242]));
    compress_module compress_243 (.x(w_poly[243]), .d(16'd1), .result(compressed[243]));
    compress_module compress_244 (.x(w_poly[244]), .d(16'd1), .result(compressed[244]));
    compress_module compress_245 (.x(w_poly[245]), .d(16'd1), .result(compressed[245]));
    compress_module compress_246 (.x(w_poly[246]), .d(16'd1), .result(compressed[246]));
    compress_module compress_247 (.x(w_poly[247]), .d(16'd1), .result(compressed[247]));
    compress_module compress_248 (.x(w_poly[248]), .d(16'd1), .result(compressed[248]));
    compress_module compress_249 (.x(w_poly[249]), .d(16'd1), .result(compressed[249]));
    compress_module compress_250 (.x(w_poly[250]), .d(16'd1), .result(compressed[250]));
    compress_module compress_251 (.x(w_poly[251]), .d(16'd1), .result(compressed[251]));
    compress_module compress_252 (.x(w_poly[252]), .d(16'd1), .result(compressed[252]));
    compress_module compress_253 (.x(w_poly[253]), .d(16'd1), .result(compressed[253]));
    compress_module compress_254 (.x(w_poly[254]), .d(16'd1), .result(compressed[254]));
    compress_module compress_255 (.x(w_poly[255]), .d(16'd1), .result(compressed[255]));


    // 9. Encode
    encode #(
        .D(1),
        .BYTE_LEN(MSG_BYTES)
    ) encode_inst (
        .F(compressed),
        .B(encoded)
    );

    // 10. Output assignment
    always_ff @(posedge clk) begin
        if (state == S_DONE) begin
            for (int i = 0; i < MSG_BYTES; i++) m[i] <= encoded[i];
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule