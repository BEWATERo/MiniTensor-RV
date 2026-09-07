module accumulator #(
    parameter int WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             en,
    input  logic [WIDTH-1:0] x,
    output logic [WIDTH-1:0] acc
);

    always_ff @(posedge clk) begin
        if (rst) begin
            acc <= '0;
        end else if (en) begin
            acc <= acc + x;
        end
    end

endmodule
