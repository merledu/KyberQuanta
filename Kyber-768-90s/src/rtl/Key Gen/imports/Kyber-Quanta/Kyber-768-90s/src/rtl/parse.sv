`timescale 1ns/1ps
module parse (
  input  logic         clk,
  input  logic         rst,    // active high reset
  input  logic         start,  // pulse to start processing
  input  logic [7:0] B [767:0],  // input array (768 words, 10-bit each)
  output logic         done,   // high when 256 outputs have been produced
  output logic [15:0]  a  [255:0]  // output array (256 words, 12-bit each)
);

  // Local parameter for modulus Q
  localparam int Q = 3329;

  // Define FSM states
  typedef enum logic [2:0] {
    IDLE,
    PROC_D1,
    CHECK_DONE1,
    PROC_D2,
    CHECK_DONE2,
    DONE
  } state_t;
  
  state_t state;

  // Index registers:
  logic [9:0] i;         // index over B (needs to count up to 767)
  logic [8:0] j;         // output count (need to count up to 256)
  
  // Flag to ensure we print the output only once (simulation only)
  logic printed;

  // Combinational computation of candidates:
  // d1 = B[i] + 256 * (B[i+1] mod 16)
  // d2 = (B[i+1] >> 4) + 16 * B[i+2]
  wire [12:0] d1 = B[i] + ((B[i+1] & 10'hF) << 8);
  wire [13:0] d2 = (B[i+1] >> 4) + (B[i+2] << 4);

  // FSM: sequential process
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      state   <= IDLE;
      i       <= 0;
      j       <= 0;
      done    <= 1'b0;
      printed <= 1'b0;
    end else begin
//    $display("check",B[765]);
 $display(B);
      case (state)
        IDLE: begin
          if (start) begin
            i       <= 0;
            j       <= 0;
            done    <= 1'b0;
            printed <= 1'b0;
            state   <= PROC_D1;
          end
        end

        // Process candidate d1 (from B[i] and B[i+1])
        PROC_D1: begin
          if (d1 < Q) begin
            a[j] <= d1[11:0];
            j    <= j + 1;
          end
          state <= CHECK_DONE1;
        end

        // Check if we've filled 256 outputs after d1 processing
        CHECK_DONE1: begin
          if (j == 9'd256)
            state <= DONE;
          else
            state <= PROC_D2;
        end

        // Process candidate d2 (from B[i+1] and B[i+2]) and update pointer
        PROC_D2: begin
          if ((d2 < Q) && (j < 9'd256)) begin
            a[j] <= d2[11:0];
            j    <= j + 1;
          end
          i <= i + 3;
          state <= CHECK_DONE2;
        end
       
        // Check if we've filled 256 outputs after d2 processing
        CHECK_DONE2: begin
          if (j == 9'd256)
            state <= DONE;
          else
            state <= PROC_D1;
        end

        DONE: begin
          done <= 1'b1;
          $display("DONEEEEEE");
          // Simulation-only print-out when first entering DONE state.
          if (!printed) begin
            // Use a for loop to display each element of the output array.
            for (int idx = 0; idx < 256; idx++) begin
              $display("a[%0d] = %0d", idx, a[idx]);
            end
            printed <= 1'b1;
          end
          state <= DONE;  // Remain in DONE state.
          
        end

        default: state <= IDLE;
        
      endcase
      
    end
    
  end

endmodule