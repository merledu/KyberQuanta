`timescale 1ns / 1ps


module topmodule(
  input logic clk,
  input logic rst,
  input logic btn,
  output logic led  
    
);
  logic [1023:0] plaintext_in;
logic encryptedtext;
logic [127:0] cipher;
logic [1023:0] plaintext_in;
logic [1023:0] plain =1024'hD22DB0709729E679160A8B41285F0779766D7F6D7AF9298265CFE7239554C5742E9B36F62EEBA8CF8148597270872E742C092A14554C32013C451BC4D2F314F5BA9CC254A8B36753E1D0E2B3E63AC718069956E26F5E22BDD8D18DB4F434120103A531E7EA1C4A0F30E808271BCC00F6506322B84BECADAD642CDAC8DBF1D806;;
logic [255:0]   key_i= 256'h1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
logic  [127:0]  iv = 128'hffeeddccbbaa99887766554433221100;
logic [1:0] state;
logic [255:0]   key;
logic [1023:0] Check=1024'h29e41b63f65ec80aa71739040dd4bf6b90c300cacdf1e6c174e18efca4bd2edae05e970d4ce449fe7fa449400389a31084e0980edc89760a17cf81eb9cd65d1c03e389364e54829b9961222aa0ee974ea9d79e7634b53dce1d448406a43b430e0f68f3199b9460024357306645b1ae77d9036bf3dba55147db69bd9911467a88;
  encryptedctr uut (
      .plaintext_in(plaintext_in),
      .key(key),
      .iv(iv),
      .clk(clk),
      .rst(rst),
      .encryptedtext(encryptedtext)
  );
    always @(*) begin
       
        plaintext_in = 1024'h0;
        key = 256'h0;
        led = 1'b0;
    
        if (rst) begin
            plaintext_in= 1024'h0;
            key = 256'h0;
            led = 1'b0;
        end else begin
            
             if(btn) begin
             
                    plaintext_in = plain;
                    key= key_i;
    
                    if (encryptedtext == Check) begin
                        led = 1'b1;
                    end else begin
                        led = 1'b0;
                    end
                end
             
              else begin      
                   plaintext_in = 1024'h0;
                    key = 256'h0;
                    led = 1'b0;
                end
           
        end
    end


  endmodule
//plaiintext =d22db0709729e679160a8b41285f0779766d7f6d7af9298265cfe7239554c5742e9b36f62eeba8cf8148597270872e742c092a14554c32013c451bc4d2f314f5ba9cc254a8b36753e1d0e2b3e63ac718069956e26f5e22bdd8d18db4f434120103a531e7ea1c4a0f30e808271bcc00f6506322b84becadad642cdac8dbf1d806
  //encryptedtext=29e41b63f65ec80aa71739040dd4bf6b90c300cacdf1e6c174e18efca4bd2edae05e970d4ce449fe7fa449400389a31084e0980edc89760a17cf81eb9cd65d1c03e389364e54829b9961222aa0ee974ea9d79e7634b53dce1d448406a43b430e0f68f3199b9460024357306645b1ae77d9036bf3dba55147db69bd9911467a88