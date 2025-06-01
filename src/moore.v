module moore_fsm (
    input clk,
    input reset,
    input [1:0] moneda,
    input comprarA,
    input comprarB,
    output reg listoA,
    output reg listoB,
    output reg [3:0] total,
    output reg vendA,
    output reg vendB
);

    reg [2:0] estado, siguiente;
    reg [3:0] acumulado;

    localparam IDLE = 3'd0,
               WAIT = 3'd1;

    always @(posedge clk or posedge reset) begin
        if (reset)
            estado <= IDLE;
        else
            estado <= siguiente;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            acumulado <= 4'd0;
        else if ((estado == IDLE || estado == WAIT) && moneda != 2'b00) begin
            case (moneda)
                2'b01: acumulado <= acumulado + 2;
                2'b10: acumulado <= acumulado + 3;
                2'b11: acumulado <= acumulado + 4;
                default: acumulado <= acumulado;
            endcase
        end
    end

    always @(*) begin
        siguiente = estado;
        listoA = 0;
        listoB = 0;
        vendA = 0;
        vendB = 0;

        case (estado)
            IDLE: begin
                if (acumulado >= 2)
                    siguiente = WAIT;
            end
            WAIT: begin
                if (acumulado >= 3 && comprarB) begin
                    vendB = 1;
                    listoB = 1;
                    siguiente = IDLE;
                end else if (acumulado >= 2 && comprarA) begin
                    vendA = 1;
                    listoA = 1;
                    siguiente = IDLE;
                end
            end
        endcase
    end

    always @(*) begin
        total = acumulado;
    end

endmodule
