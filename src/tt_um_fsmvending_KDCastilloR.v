`default_nettype none
`timescale 1ns / 1ps

module tt_um_fsmvending_KDCastilloR (
  input        clk,
  input        rst_n,
  input        ena,
  input  [7:0] ui_in,
  output [7:0] uo_out,
  input  [7:0] uio_in,
  output [7:0] uio_out,
  output [7:0] uio_oe
);

  wire reset = ~rst_n;

  reg [24:0] clk_div;
  always @(posedge clk) clk_div <= clk_div + 1;
  wire clk_slow = clk_div[24];

  wire [1:0] moneda = ui_in[1:0];
  wire [1:0] seleccion = ui_in[3:2];

  wire [1:0] producto;
  wire listo;
  wire [1:0] cambio;

  top_maquina maquina (
    .clk(clk_slow),
    .rst(reset),
    .moneda(moneda),
    .seleccion(seleccion),
    .producto(producto),
    .listo(listo),
    .cambio(cambio)
  );

  // Empaquetar salida 8 bits:
  // [7:5]=0, [4]=listo, [3:2]=cambio, [1:0]=producto
  assign uo_out = {3'b000, listo, cambio, producto};
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

endmodule


