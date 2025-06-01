`timescale 1ns / 1ps
`default_nettype none

module top_maquina (
    input wire clk,
    input wire rst,
    input wire [1:0] moneda,
    input wire [1:0] seleccion,
    output wire [1:0] producto,
    output wire listo,
    output wire [1:0] cambio
);

    wire [3:0] total;

    moore_fsm moore (
        .clk(clk),
        .rst(rst),
        .moneda(moneda),
        .total(total)
    );

    mealy_fsm mealy (
        .clk(clk),
        .rst(rst),
        .total(total),
        .seleccion(seleccion),
        .producto(producto),
        .listo(listo),
        .cambio(cambio)
    );

endmodule

