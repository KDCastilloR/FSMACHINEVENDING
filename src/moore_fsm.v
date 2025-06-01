`timescale 1ns / 1ps
`default_nettype none

module moore_fsm (
    input wire clk,
    input wire rst,
    input wire [1:0] moneda,
    output reg [3:0] total
);

    typedef enum reg [3:0] {
        IDLE = 4'd0,
        M2   = 4'd2,
        M3   = 4'd3,
        M4   = 4'd4,
        M5   = 4'd5,
        M6   = 4'd6,
        M7   = 4'd7
    } state_t;

    state_t state, next;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                case (moneda)
                    2'd2: next = M2;
                    2'd3: next = M3;
                    2'd4: next = M4;
                    default: next = IDLE;
                endcase
            end
            M2: begin
                case (moneda)
                    2'd2: next = M4;
                    2'd3: next = M5;
                    2'd4: next = M6;
                    default: next = M2;
                endcase
            end
            M3: begin
                case (moneda)
                    2'd2: next = M5;
                    2'd3: next = M6;
                    2'd4: next = M7;
                    default: next = M3;
                endcase
            end
            M4, M5, M6, M7: next = IDLE;
            default: next = IDLE;
        endcase
    end

    always @(*) begin
        total = state;
    end

endmodule

