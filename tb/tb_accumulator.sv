`timescale 1ns/1ps

module tb_accumulator;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic en  = 1'b0;
    logic [31:0] x = '0;
    logic [31:0] acc;

    accumulator dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .x(x),
        .acc(acc)
    );

    always #5 clk = ~clk;

    task automatic check(input logic [31:0] expected, input string name);
        #1;
        if (acc !== expected) begin
            $display("FAIL: %s expected=%0d actual=%0d", name, expected, acc);
            $fatal(1);
        end
        $display("PASS: %s acc=%0d", name, acc);
    endtask

    initial begin
        $dumpfile("results/waveforms/accumulator.vcd");
        $dumpvars(0, tb_accumulator);

        @(posedge clk);
        check(32'd0, "reset");

        rst = 1'b0;
        en  = 1'b1;
        x   = 32'd2;
        @(posedge clk);
        check(32'd2, "add 2");

        x = 32'd4;
        @(posedge clk);
        check(32'd6, "add 4");

        en = 1'b0;
        x  = 32'd99;
        @(posedge clk);
        check(32'd6, "hold when disabled");

        rst = 1'b1;
        @(posedge clk);
        check(32'd0, "second reset");

        $display("All accumulator tests passed.");
        $finish;
    end
endmodule
