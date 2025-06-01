module tt_um_KDCastilloR_FSMVENDING (
    input  [7:0] ui,
    output [7:0] uo,
    inout  [7:0] uio
);
    wire clk       = ui[0];
    wire reset     = ui[1];
    wire [1:0] moneda = ui[3:2];
    wire comprarA  = ui[4];
    wire comprarB  = ui[5];

    wire listoA, listoB;
    wire [3:0] total;
    wire [3:0] cambio;

    wire vendA, vendB;

    assign uo[0] = listoA;
    assign uo[1] = listoB;
    assign uo[5:2] = total; // bits 2 a 5 muestran el total acumulado
    // uo[6], uo[7] libres

    assign uio = 8'bz; // no se usan pines bidireccionales

    moore_fsm moore_inst (
        .clk(clk),
        .reset(reset),
        .moneda(moneda),
        .comprarA(comprarA),
        .comprarB(comprarB),
        .listoA(listoA),
        .listoB(listoB),
        .total(total),
        .vendA(vendA),
        .vendB(vendB)
    );

    mealy_fsm mealy_inst (
        .clk(clk),
        .reset(reset),
        .total(total),
        .vendA(vendA),
        .vendB(vendB),
        .cambio(cambio)
    );

endmodule
