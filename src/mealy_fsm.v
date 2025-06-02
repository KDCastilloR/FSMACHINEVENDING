`default_nettype none
`timescale 1ns / 1ps

module mealy_fsm (
  input wire clk,
  input wire rst,
  input wire [1:0] moneda,
  input wire [1:0] seleccion,
  output reg [1:0] producto,
  output reg listo,
  output reg [1:0] cambio
);

  reg [4:0] total;

  localparam COSTO_A = 5'd4;
  localparam COSTO_B = 5'd7;
  localparam COSTO_C = 5'd9;

  wire [4:0] moneda_val;
  assign moneda_val = (moneda == 2) ? 5'd2 :
                      (moneda == 3) ? 5'd3 :
                      (moneda == 4) ? 5'd4 : 5'd0;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      total <= 0;
      producto <= 0;
      listo <= 0;
      cambio <= 0;
    end else begin
      total <= total + moneda_val;

      if (seleccion == 2'b01 && total >= COSTO_A) begin
        producto <= 2'b01;
        listo <= 1;
        cambio <= total - COSTO_A;
        total <= 0;
      end else if (seleccion == 2'b10 && total >= COSTO_B) begin
        producto <= 2'b10;
        listo <= 1;
        cambio <= total - COSTO_B;
        total <= 0;
      end else if (seleccion == 2'b11 && total >= COSTO_C) begin
        producto <= 2'b11;
        listo <= 1;
        cambio <= total - COSTO_C;
        total <= 0;
      end else begin
        producto <= 0;
        listo <= 0;
        cambio <= 0;
      end
    end
  end

endmodule

