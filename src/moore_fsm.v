`timescale 1ns / 1ps

module moore_fsm (
  input wire clk,
  input wire rst,
  input wire [1:0] moneda,      // monedas codificadas
  input wire [1:0] seleccion,   // A=01, B=10, C=11
  output reg [1:0] producto,
  output reg listo,
  output reg [1:0] cambio
);

  // Estados posibles
  parameter IDLE    = 3'b000;
  parameter SUMA    = 3'b001;
  parameter CHEQUEA = 3'b010;
  parameter ENTREGA = 3'b011;

  reg [2:0] state, next_state;
  reg [4:0] total;  // total de monedas acumuladas (hasta 31)

  // Costos de productos
  parameter COSTO_A = 5'd4;
  parameter COSTO_B = 5'd7;
  parameter COSTO_C = 5'd9;

  // Suma monedas codificadas
  wire [4:0] moneda_val;
  assign moneda_val = (moneda == 2'b10) ? 5'd2 :
                      (moneda == 2'b11) ? 5'd3 :
                      (moneda == 2'b00) ? 5'd4 : 5'd0;

  // Máquina de estados Moore (registro de estado y lógica secuencial)
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state    <= IDLE;
      total    <= 5'd0;
      producto <= 2'b00;
      listo    <= 1'b0;
      cambio   <= 2'b00;
    end else begin
      state <= next_state;

      // Solo sumar monedas en estado SUMA
      if (state == SUMA) begin
        total <= total + moneda_val;
      end

      // En ENTREGA: entregar producto y cambio
      if (state == ENTREGA) begin
        listo <= 1'b1;
        case (seleccion)
          2'b01: begin // Producto A
            producto <= 2'b01;
            cambio <= total - COSTO_A;
          end
          2'b10: begin // Producto B
            producto <= 2'b10;
            cambio <= total - COSTO_B;
          end
          2'b11: begin // Producto C
            producto <= 2'b11;
            cambio <= total - COSTO_C;
          end
          default: begin
            producto <= 2'b00;
            cambio   <= 2'b00;
          end
        endcase
      end else begin
        // Si no está en ENTREGA, no hay producto ni cambio listos
        listo    <= 1'b0;
        producto <= 2'b00;
        cambio   <= 2'b00;
      end
    end
  end

  // Lógica de transición de estados (combinacional)
  always @(*) begin
    case (state)
      IDLE: next_state = SUMA;

      SUMA: begin
        if ((seleccion == 2'b01 && total >= COSTO_A) ||
            (seleccion == 2'b10 && total >= COSTO_B) ||
            (seleccion == 2'b11 && total >= COSTO_C))
          next_state = CHEQUEA;
        else
          next_state = SUMA;
      end

      CHEQUEA: next_state = ENTREGA;

      ENTREGA: next_state = IDLE;

      default: next_state = IDLE;
    endcase
  end

endmodule


