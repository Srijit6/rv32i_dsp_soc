`timescale 1ns / 1ps

module top_tb;

    reg clk;
    reg rst_n;

    soc_top u_soc (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor DSP Execution
    always @(posedge clk) begin
        if (rst_n && u_soc.u_core.dsp_valid_out) begin
            $display("[%0t ns] [DSP ACCELERATOR] MAC Executed! rs1: %0d, rs2: %0d | ACCUMULATOR RESULT: %0d", 
                     $time, u_soc.u_core.rs1_out, u_soc.u_core.rs2_out, u_soc.u_dsp.result_out);
        end
    end

    initial begin
        $display("\n=========================================");
        $display("   Starting SoC Simulation for 24BVD1046 ");
        $display("=========================================\n");

        rst_n = 0;
        $dumpfile("soc_sim.vcd");
        $dumpvars(0, top_tb);

        #20;
        rst_n = 1;
        $display("[%0t ns] System Reset De-asserted. Processor Booting...", $time);

        // Give the processor enough time to fetch and execute the 3 instructions
        #100;
        
        $display("\n[%0t ns] Simulation Finished.", $time);
        $finish;
    end

endmodule
