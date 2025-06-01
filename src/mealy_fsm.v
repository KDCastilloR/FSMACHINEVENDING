`timescale 1ns / 1ps

module mealy_fsm (
    input wire clk,
    input wire rst,
    input wire [3:0] total,
    input wire [1:0] seleccion,
    output reg [1:0] producto,
    output reg listo,
    output reg [1:0] cambio
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            producto <= 2'b00;
            listo    <= 1'b0;
            cambio   <= 2'b00;
        end else begin
            listo = 0;
            producto = 2'b00;
            cambio = 2'b00;

            case (seleccion)
                2'b01: begin // Producto A cuesta 5
                    if (total >= 5) begin
                        producto = 2'b01;
                        listo = 1;
                        cambio = total - 5;
                    end
                end
                2'b10: begin // Producto B cuesta 6
                    if (total >= 6) begin
                        producto = 2'b10;
                        listo = 1;
                        cambio = total - 6;
                    end
                end
                default: begin
                    producto = 2'b00;
                    listo = 0;
                    cambio = 2'b00;
                end
            endcase
        end
    end

endmodule
