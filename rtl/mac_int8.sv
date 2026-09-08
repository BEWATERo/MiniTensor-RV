module mac_int8 #(
    parameter integer DATA_W = 8,
    parameter integer ACC_W  = 32
) (
    input  logic                         clk,
    input  logic                         rst,
    input  logic                         clear,
    input  logic                         valid,
    input  logic signed [DATA_W-1:0]     a,
    input  logic signed [DATA_W-1:0]     b,
    output logic signed [ACC_W-1:0]      acc
);

    localparam integer PRODUCT_W = 2 * DATA_W;

    logic signed [PRODUCT_W-1:0] product;
    logic signed [ACC_W-1:0]     product_ext;

    assign product = a * b;
    assign product_ext = {{(ACC_W-PRODUCT_W){product[PRODUCT_W-1]}}, product};

    always_ff @(posedge clk) begin
        if (rst) begin
            acc <= '0;
        end else if (clear) begin
            acc <= '0;
        end else if (valid) begin
            acc <= acc + product_ext;
        end
    end

endmodule
