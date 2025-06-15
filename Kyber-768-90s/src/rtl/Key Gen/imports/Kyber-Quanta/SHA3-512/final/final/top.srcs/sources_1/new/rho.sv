`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2024 08:08:11 PM
// Design Name: 
// Module Name: Rho
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Rho_(
    input logic[63:0] theta_in [0:4][0:4],
    output logic [63:0] rho [0:4][0:4]
    );
    
    always_comb begin 
   //ROW_1
                   rho[0][0] =   theta_in[0][0];                                 //0
                   rho[0][1] = { theta_in[0][1][27:0] , theta_in[0][1][63:28] }; //36
                   rho[0][2] = { theta_in[0][2][60:0]  , theta_in[0][2][63:61]  }; //3
                   rho[0][3] = { theta_in[0][3][22:0] , theta_in[0][3][63:23] }; //41
                   rho[0][4] = { theta_in[0][4][45:0] , theta_in[0][4][63:46] }; //18
                   
               //ROW_2
                   rho[1][0] = { theta_in[1][0][62:0]    , theta_in[1][0][63]  }; //1
                   rho[1][1] = { theta_in[1][1][19:0] , theta_in[1][1][63:20] }; //44 //10
                   rho[1][2] = { theta_in[1][2][53:0]  , theta_in[1][2][63:54] }; //10 //44
                   rho[1][3] = { theta_in[1][3][18:0] , theta_in[1][3][63:19] }; //45
                   rho[1][4] = { theta_in[1][4][61:0]  , theta_in[1][4][63:62]  }; //2
                   
               //ROW_3
                   rho[2][0] = { theta_in[2][0][1:0]  , theta_in[2][0][63:2]  }; //62
                   rho[2][1] = { theta_in[2][1][57:0]   , theta_in[2][1][63:58]   }; //6
                   rho[2][2] = { theta_in[2][2][20:0]  , theta_in[2][2][63:21]  }; //43
                   rho[2][3] = { theta_in[2][3][48:0]  , theta_in[2][3][63:49]  }; //15
                   rho[2][4] = { theta_in[2][4][2:0]  , theta_in[2][4][63:3]  }; //61
                   
               //ROW_4
                   rho[3][0] = { theta_in[3][0][35:0]  , theta_in[3][0][63:36]  }; //28
                   rho[3][1] = { theta_in[3][1][8:0]  , theta_in[3][1][63:9]  }; //55
                   rho[3][2] = { theta_in[3][2][38:0]  , theta_in[3][2][63:39]  }; //25
                   rho[3][3] = { theta_in[3][3][42:0]  , theta_in[3][3][63:43]  }; //21
                   rho[3][4] = { theta_in[3][4][7:0]  , theta_in[3][4][63:8]  }; //56
                   
               //ROW_5
                   rho[4][0] = { theta_in[4][0][36:0]  , theta_in[4][0][63:37]  }; //27
                   rho[4][1] = { theta_in[4][1][43:0]  , theta_in[4][1][63:44]  }; //20
                   rho[4][2] = { theta_in[4][2][24:0]  , theta_in[4][2][63:25]  }; //39
                   rho[4][3] = { theta_in[4][3][55:0]   , theta_in[4][3][63:56]   }; //8
                   rho[4][4] = { theta_in[4][4][49:0]  , theta_in[4][4][63:50]  }; //14
    end
    
endmodule
