
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
  wire clk_slow;

  always @(posedge clk) begin
    clk_div <= clk_div + 1;
  end

  assign clk_slow = clk_div[24];

  wire [1:0] moneda     = ui_in[1:0];
  wire [1:0] seleccion  = ui_in[3:2];

  wire [1:0] producto;
  wire listo;
  wire [1:0] cambio;

  top_maquina vending (
    .clk(clk_slow),
    .rst(reset),
    .moneda(moneda),
    .seleccion(seleccion),
    .producto(producto),
    .listo(listo),
    .cambio(cambio)
  );

  assign uo_out = {3'b000, listo, cambio, producto};
  assign uio_out = 8'b00000000;
  assign uio_oe  = 8'b00000000;

endmodule

