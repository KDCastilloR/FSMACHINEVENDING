
`default_nettype none
`timescale 1ns / 1ps

module tt_um_fsmvending_KDCastilloR (
  input        clk,
  input        rst_n,         // Reset activo bajo
  input        ena,           // Enable del sistema
  input  [7:0] ui_in,         // Entradas dedicadas (monedas y selección)
  output [7:0] uo_out,        // Salidas dedicadas (producto, cambio, listo)
  input  [7:0] uio_in,        // Entradas bidireccionales (no usadas)
  output [7:0] uio_out,       // Salidas bidireccionales (no usadas)
  output [7:0] uio_oe         // Enables bidireccionales (0 = input)
);

  // === Señales internas ===
  wire reset = ~rst_n;        // Convertir rst_n activo bajo a activo alto
  wire clk_slow;
  reg [24:0] clk_div;

  // Entradas del sistema (conectar a FSM)
  wire [1:0] moneda     = ui_in[1:0];   // Bits 1:0 para monedas (2, 3, 4)
  wire [1:0] seleccion  = ui_in[3:2];   // Bits 3:2 para selección de producto

  // Salidas de FSM
  wire [1:0] producto;
  wire listo;
  wire [1:0] cambio;

  // === Divisor de reloj (bajar velocidad para simular) ===
  always @(posedge clk) begin
    clk_div <= clk_div + 1;
  end

  assign clk_slow = clk_div[24]; // Clock lento para FSM

  // === Instancia del top de la FSM ===
  top_maquina maquina_expendedora (
    .clk(clk_slow),
    .rst(reset),
    .moneda(moneda),
    .seleccion(seleccion),
    .producto(producto),
    .listo(listo),
    .cambio(cambio)
  );

  // === Salidas ===
  assign uo_out = {3'b000, listo, cambio, producto}; // 8 bits
  assign uio_out = 8'b00000000; // No se usan
  assign uio_oe  = 8'b00000000; // Todo como input

endmodule
