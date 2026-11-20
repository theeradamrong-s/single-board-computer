// ============================================================================
// Top: wrapper for the single-board computer (sbc.dig / sbc.v)
// ============================================================================
module top (
    input        clk_27m,   // 27 MHz board clock, pin 52
    input        s1_n,      // S1, pin 4: go to run mode
    input        s2_n,      // S2, pin 3: reset, back to program mode
    input        enter_n,   // external button, pin 51: ENTER / STEP
    input        back_n,    // external button, pin 53: BACK
    input        run_n,     // external button, pin 54: RUN
    input  [7:0] dip_n,     // DIP switch, ON = 0
    output [2:0] led_n,     // LED0-LED2, 0 = LED on
    output       tm1_clk,   // Display 1: address / PC and output port
    inout        tm1_dio,
    output       tm2_clk,   // Display 2: instruction
    inout        tm2_dio
);

    // 27 MHz -> 100 Hz system clock for sbc.dig
    reg [17:0] cnt = 0;
    reg clk_sys = 0;
    always @(posedge clk_27m) begin
        if (cnt == 18'd134_999) begin
            cnt <= 0;
            clk_sys <= ~clk_sys;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // The design exported from Digital
    wire [5:0]  addr;
    wire [13:0] instr;
    wire [3:0]  out;

    sbc u_sbc (
        .clk     (clk_sys),
        .s1_n    (s1_n),
        .s2_n    (s2_n),
        .enter_n (enter_n),
        .back_n  (back_n),
        .run_n   (run_n),
        .dip_n   (dip_n),
        .addr    (addr),
        .instr   (instr),
        .out     (out),
        .led_n   (led_n)
    );

    // hex digit -> segment pattern (bit0=a ... bit6=g)
    function [7:0] hex7;
        input [3:0] h;
        case (h)
            4'h0: hex7 = 8'h3F; 4'h1: hex7 = 8'h06;
            4'h2: hex7 = 8'h5B; 4'h3: hex7 = 8'h4F;
            4'h4: hex7 = 8'h66; 4'h5: hex7 = 8'h6D;
            4'h6: hex7 = 8'h7D; 4'h7: hex7 = 8'h07;
            4'h8: hex7 = 8'h7F; 4'h9: hex7 = 8'h6F;
            4'hA: hex7 = 8'h77; 4'hB: hex7 = 8'h7C;
            4'hC: hex7 = 8'h39; 4'hD: hex7 = 8'h5E;
            4'hE: hex7 = 8'h79; 4'hF: hex7 = 8'h71;
        endcase
    endfunction

    // Display 1: [address/PC high] [address/PC low] [blank] [output port]
    tm1637_display disp1 (
        .clk    (clk_27m),
        .seg0   (hex7({2'b00, addr[5:4]})),
        .seg1   (hex7(addr[3:0])),
        .seg2   (8'h00),
        .seg3   (hex7(out)),
        .tm_clk (tm1_clk),
        .tm_dio (tm1_dio)
    );

    // Display 2: the 14-bit instruction as 4 hex digits
    tm1637_display disp2 (
        .clk    (clk_27m),
        .seg0   (hex7({2'b00, instr[13:12]})),
        .seg1   (hex7(instr[11:8])),
        .seg2   (hex7(instr[7:4])),
        .seg3   (hex7(instr[3:0])),
        .tm_clk (tm2_clk),
        .tm_dio (tm2_dio)
    );

endmodule

// ============================================================================
// TM1637 driver: keeps sending 4 digits
// ============================================================================
module tm1637_display (
    input        clk,                      // 27 MHz
    input  [7:0] seg0, seg1, seg2, seg3,   // segment patterns
    output       tm_clk,
    inout        tm_dio
);

    // quarter-bit tick: 27 MHz / 540 = 50 kHz
    reg [9:0] div = 0;
    wire q = (div == 10'd539);
    always @(posedge clk) div <= q ? 10'd0 : div + 1'b1;

    // the 7 bytes sent in each frame
    reg [2:0] item = 0;
    reg [7:0] data;
    reg       has_stop;
    always @* begin
        has_stop = 0;
        case (item)
            3'd0:    begin data = 8'h40; has_stop = 1; end // write, auto address
            3'd1:          data = 8'hC0;                   // start at digit 0
            3'd2:          data = seg0;
            3'd3:          data = seg1;
            3'd4:          data = seg2;
            3'd5:    begin data = seg3;  has_stop = 1; end
            default: begin data = 8'h8F; has_stop = 1; end // display on, bright
        endcase
    end

    localparam S_START = 2'd0, S_BIT = 2'd1, S_ACK = 2'd2, S_STOP = 2'd3;
    reg [1:0] state = S_START;
    reg [1:0] ph = 0;            // quarter of a bit period
    reg [2:0] bitn = 0;
    reg clk_r = 1, dio_r = 1;    // 1 = release (pulled high), 0 = pull low

    always @(posedge clk) if (q) begin
        ph <= ph + 1'b1;
        case (state)
            S_START: case (ph)
                2'd0: begin clk_r <= 1; dio_r <= 1; end
                2'd1: dio_r <= 0;   // DIO falls while CLK high = START
                2'd2: clk_r <= 0;
                2'd3: begin bitn <= 0; state <= S_BIT; end
            endcase

            S_BIT: case (ph)
                2'd0: dio_r <= data[bitn]; // set data while CLK low, LSB first
                2'd1: clk_r <= 1;          // TM1637 reads on the rising edge
                2'd2: ;
                2'd3: begin
                    clk_r <= 0;
                    if (bitn == 3'd7) state <= S_ACK;
                    else bitn <= bitn + 1'b1;
                end
            endcase

            S_ACK: case (ph)
                2'd0: dio_r <= 1; // release DIO, chip answers ACK
                2'd1: clk_r <= 1;
                2'd2: ;
                2'd3: begin
                    clk_r <= 0;
                    if (has_stop) state <= S_STOP;
                    else begin
                        item <= item + 1'b1;
                        bitn <= 0;
                        state <= S_BIT;
                    end
                end
            endcase

            S_STOP: case (ph)
                2'd0: dio_r <= 0;
                2'd1: clk_r <= 1;
                2'd2: dio_r <= 1; // DIO rises while CLK high = STOP
                2'd3: begin
                    item <= (item == 3'd6) ? 3'd0 : item + 1'b1;
                    state <= S_START;
                end
            endcase
        endcase
    end

    // open-drain outputs: pull low, or let the pull-up make it high
    assign tm_clk = clk_r ? 1'bz : 1'b0;
    assign tm_dio = dio_r ? 1'bz : 1'b0;

endmodule
