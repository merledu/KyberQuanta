module sponge
#(parameter msg_len = 9, parameter d_len = 7000, capacity = 256, parameter r = 1600 - capacity)
(
    input logic clk,
    input logic reset,
    input logic [msg_len - 1: 0] message,
    input logic start,
    output logic [d_len - 1: 0] z,
    output logic done
);
logic [(msg_len+4) - 1: 0] msg_use;
logic [1599:0] str;
logic [1599:0] strr;
logic [1599:0] strrr;
logic [1599:0] strrrr;
logic [1599:0] str2;
logic [1599:0] str3;
logic [1599:0] str4;
logic [1599:0] str5;
logic [1599:0] s1;
logic [1599:0] s2;
logic [1599:0] Keccak_in;
logic don;
logic don1;
logic don2;
logic don3;
logic [capacity - 1:0] zeros = '0;
logic [((-msg_len - 2) % r + r) % r + 1:0] pad;
logic [(r * 7):0] h;
logic chk;
logic [31:0] len = r + msg_len;
(* keep = "true" *) logic [((-msg_len - 2) % r + r) % r + 1 + msg_len:0] k;
(* keep = "true" *) logic [31:0] n;
logic [1599:0] strng;
//-------------------------------------------
logic [1599:0] strEx1;
logic [1599:0] strEx2;
logic [1599:0] strEx3;

logic [1599:0] str2Ex1;
logic [1599:0] str2Ex2;
logic [1599:0] str2Ex3;

logic don6;
logic don7;
logic don8;




//-------------------------------------------

always_comb begin
//    msg_use = {4'b1111,message};
    $display("str1: %h",str);
    k = {pad, message};
    $display("zeros: %h",zeros);
    $display("k: %h",k);
    n = $bits(k) / r;
    str = 1600'b0 ^ {zeros, k[r - 1:0]};

    if (d_len > r && n == 1) begin
        strr = str2;
    end else if (d_len > r && n == 2) begin
        strr = s2;
    end

    if (d_len > (r * 2) - 1) begin
        strrr = str3;
    end

    if (d_len > (r * 3) - 1) begin
        strrrr = str4;
    end
    if(d_len > (r*4)-1)begin
         strEx1=str5;
    
    end
        if(d_len > (r*5)-1)begin
         strEx2=str2Ex1;
    
    end
        if(d_len > (r*6)-1)begin
         strEx3=str2Ex2;
    
    end
    if(d_len > (r*7)-1)begin
             z=0;
        
        end
        

    if (don && n == 2) begin
        s1 = str2 ^ {zeros, k[(r * 2) - 1:r]};
    end else begin
        s1 = 0;
    end
end

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        h <= '0;
        z <= '0;
    end else if (reset == 0 && start == 1) begin
        //k = {pad, message};
        z <= h[d_len - 1:0];
        if (don5 && n==2) begin
            h[r - 1:0] <= s2[r - 1:0];
        end else begin
            h[r - 1:0] <= str2[r - 1:0];
        end

        if (don1 == 1'b1) begin
            h[(r * 2) - 1:r] <= str3[r - 1:0];
        end else begin
            h[(r * 2) - 1:r] <= '0;
        end

        if (don2 == 1'b1) begin
            h[(r * 3) - 1:r * 2] <= str4[r - 1:0];
        end else begin
            h[(r * 3) - 1:r * 2] <= '0;
        end

        if (don3 == 1'b1) begin
            h[(r * 4) - 1:r * 3] <= str5[r - 1:0];
        end else begin
            h[(r * 4) - 1:r * 3] <= '0;
        end
        
        if (don6 ==1'b1)begin
             h[(r * 5) - 1:r * 4] <= str2Ex1[r - 1:0];
              end else begin
                  h[(r * 5) - 1:r * 4] <= '0;
              end
         if (don7 ==1'b1)begin
                          h[(r * 6) - 1:r * 5] <= str2Ex2[r - 1:0];
                           end else begin
                               h[(r * 6) - 1:r * 5] <= '0;
                           end  
          if (don8 ==1'b1)begin
                       h[(r * 7) - 1:r * 6] <= str2Ex3[r - 1:0];
                          end else begin
                                    h[(r * 7) - 1:r * 6] <= '0;
                                        end                    
          if (z[d_len-1] == 1'b1 ||z[d_len-2] == 1'b1 || z[d_len-3] == 1'b1 || z[d_len-4] == 1'b1  ) begin
          done<=1;
          end                     
              $display("h :%0h",h);
        $display("message :%0h",message);
        $display("z :%0h", z);
    end
   // done=1;
end

keccak kp (
    .clk(clk),
    .rst(reset),
    .round_start(1'b1),
    .AB(str),
    .X(str2),
    .round_done(don)
);

keccak kp4 (
    .clk(clk),
    .rst(reset),
    .round_start(don),
    .AB(s1),
    .X(s2),
    .round_done(don5)
);

keccak kp1 (
    .clk(clk),
    .rst(reset),
    .round_start(don5),
    .AB(strr),
    .X(str3),
    .round_done(don1)
);

keccak kp2 (
    .clk(clk),
    .rst(reset),
    .round_start(don1),
    .AB(strrr),
    .X(str4),
    .round_done(don2)
);

keccak kp3 (
    .clk(clk),
    .rst(reset),
    .round_start(don2),
    .AB(strrrr),
    .X(str5),
    .round_done(don3)
);
//--------------------------------------------------------------
keccak kp5 (
    .clk(clk),
    .rst(reset),
    .round_start(don3),
    .AB(strEx1),
    .X(str2Ex1),
    .round_done(don6)
);
keccak kp6 (
    .clk(clk),
    .rst(reset),
    .round_start(don6),
    .AB(strEx2),
    .X(str2Ex2),
    .round_done(don7)
);
keccak kp7 (
    .clk(clk),
    .rst(reset),
    .round_start(don7),
    .AB(strEx3),
    .X(str2Ex3),
    .round_done(don8)
);
//-----------------------------------------------------------

pad10_1 #(.x(r), .m(msg_len)) pd (
    .p(pad)
);

endmodule
