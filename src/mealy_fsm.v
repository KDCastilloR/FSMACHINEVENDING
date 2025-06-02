`timescale 1ns / 1ps

module mealy_fsm (
  input wire clk,
  input wire rst,
  input wire [3:0] total,
  input wire vendA,
  input wire vendB,
  output reg [3:0] cambio
);

  reg [3:0] saldo;

  parameter COSTO_A = 4'd2;
  parameter COSTO_B = 4'd3;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      saldo <= 4'd0;
      cambio <= 4'd0;
    end else begin
      if (vendA) begin
        saldo <= total - COSTO_A;
        cambio <= total - COSTO_A;
      end else if (vendB) begin
        saldo <= total - COSTO_B;
        cambio <= total - COSTO_B;
      end else begin
        saldo <= total;
        cambio <= 4'd0;
      end
    end
  end

endmodule
