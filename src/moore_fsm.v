
`timescale 1ns / 1ps

module moore_fsm (
  input wire clk,
  input wire rst,
  input wire [1:0] moneda,      // monedas posibles: 2,3,4 (codificadas)
  input wire [1:0] seleccion,   // producto A=01, B=10, C=11
  output reg [1:0] producto,
  output reg listo,
  output reg [1:0] cambio
);

  // Estados posibles
  typedef enum logic [2:0] {
    IDLE = 3'd0,
    SUMA = 3'd1,  
    CHEQUEA = 3'd2,
    ENTREGA = 3'd3
  } state_t;

  state_t state, next_state;

  reg [4:0] total;  // Total acumulado de monedas (hasta 31)

  // Costos de productos
  localparam COSTO_A = 5'd4;
  localparam COSTO_B = 5'd7;
  localparam COSTO_C = 5'd9;

  // Suma monedas al total si no está en reset
  wire [4:0] moneda_val;
  assign moneda_val = (moneda == 2) ? 5'd2 :
                      (moneda == 3) ? 5'd3 :
                      (moneda == 4) ? 5'd4 : 5'd0;

  // Máquina de estados Moore
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      total <= 0;
      producto <= 0;
      listo <= 0;
      cambio <= 0;
    end else begin
      state <= next_state;

      // Solo sumar monedas en estado SUMA
      if (state == SUMA) begin
        total <= total + moneda_val;
      end

      // En ENTREGA, calcular producto, listo y cambio
      if (state == ENTREGA) begin
        listo <= 1;
        case (seleccion)
          2'b01: begin
            producto <= 2'b01; // Producto A
            cambio <= total - COSTO_A;
          end
          2'b10: begin
            producto <= 2'b10; // Producto B
            cambio <= total - COSTO_B;
          end
          2'b11: begin
            producto <= 2'b11; // Producto C
            cambio <= total - COSTO_C;
          end
          default: begin
            producto <= 0;
            cambio <= 0;
          end
        endcase
      end else begin
        listo <= 0;
        producto <= 0;
        cambio <= 0;
      end
    end
  end

  // Próximo estado
  always @(*) begin
    case (state)
      IDLE: next_state = SUMA;
      SUMA: begin
        // Si el total es suficiente para el producto seleccionado, chequea entrega
        if (seleccion == 2'b01 && total >= COSTO_A) next_state = CHEQUEA;
        else if (seleccion == 2'b10 && total >= COSTO_B) next_state = CHEQUEA;
        else if (seleccion == 2'b11 && total >= COSTO_C) next_state = CHEQUEA;
        else next_state = SUMA;
      end
      CHEQUEA: next_state = ENTREGA;
      ENTREGA: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

endmodule

