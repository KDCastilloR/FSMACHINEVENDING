
`timescale 1ns / 1ps

module top_maquina (
  input wire clk,
  input wire rst,
  input wire [1:0] moneda,
  input wire [1:0] seleccion,
  output wire [1:0] producto,
  output wire listo,
  output wire [1:0] cambio
);

  wire [1:0] producto_moore;
  wire listo_moore;
  wire [1:0] cambio_moore;

  moore_fsm moore (
    .clk(clk),
    .rst(rst),
    .moneda(moneda),
    .seleccion(seleccion),
    .producto(producto_moore),
    .listo(listo_moore),
    .cambio(cambio_moore)
  );

  // Si quieres, puedes instanciar la mealy y alternar con un switch
  // Por simplicidad solo usamos Moore

  assign producto = producto_moore;
  assign listo = listo_moore;
  assign cambio = cambio_moore;

endmodule


