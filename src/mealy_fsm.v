module mealy_fsm (
    input clk,
    input reset,
    input [3:0] total,
    input vendA,
    input vendB,
    output reg [3:0] cambio
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            cambio <= 0;
        else if (vendA) 
            cambio <= total - 2;
        else if (vendB)
            cambio <= total - 3;
        else
            cambio <= 0;
    end

endmodule
