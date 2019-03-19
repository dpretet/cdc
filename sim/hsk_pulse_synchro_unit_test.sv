// Mandatory file to be able to launch SVUT flow
`include "svut_h.sv"

// Specify here the module to load or setup the path in files.f
//`include "../src/pulse_synchro.v"

`timescale 1 ns / 1 ps

module hsk_pulse_synchro_unit_test;

    `SVUT_SETUP

    reg   aclk_i;
    reg   arstn_i;
    reg   aclk_o;
    reg   arstn_o;
    reg   tvalid_i;
    reg   tready_i;
    reg   tvalid_o;

    hsk_pulse_synchro
    dut
    (
    aclk_i,
    arstn_i,
    aclk_o,
    arstn_o,
    tvalid_i,
    tready_i,
    tvalid_o
    );

    localparam ACLK_I_PERIOD = 2;
    localparam ACLK_O_PERIOD = 20;

    // An example to create a clock
    initial aclk_i = 0;
    initial aclk_o = 0;
    always #ACLK_I_PERIOD aclk_i <= ~aclk_i;
    always #ACLK_O_PERIOD aclk_o <= ~aclk_o;

    // An example to dump data for visualization
    initial $dumpvars(0, hsk_pulse_synchro_unit_test);

    task setup();
    begin
        // setup() runs when a test begins
        arstn_i = 1'b0;
        arstn_o = 1'b0;
        tvalid_i = 1'b0;
        #100;
        arstn_i = 1'b1;
        arstn_o = 1'b1;
    end
    endtask

    task teardown();
    begin
        // teardown() runs when a test ends
    end
    endtask

    `UNIT_TESTS

        /* Available macros:
           - `INFO();
           - `WARNING();
           - `ERROR();
           - `FAIL_IF();
           - `FAIL_IF_NOT();
           - `FAIL_IF_EQUAL();
           - `FAIL_IF_NOT_EQUAL();
        */

    `UNIT_TEST(RESET_DEASSERTION)

        `INFO("Start RESET_DEASSERTION test");

        `INFO("Check output is tied to 0");

        `FAIL_IF(tvalid_o);

        `INFO("Test finished");

    `UNIT_TEST_END

    `UNIT_TEST(SINGLE_PULSE)

        `INFO("Start SINGLE_PULSE test");

        fork

            integer time_start, time_end, pulse_width;

            begin
                `INFO("Generate the pulse");
                @(posedge aclk_i);
                tvalid_i = 1'b1;
                @(posedge aclk_i);
                tvalid_i = 1'b0;
                `FAIL_IF(tready_i);
                `SUCCESS("TREADY signal is correctly asserted after pulse generation");
            end
            begin
                `INFO("Waiting for the resynchronized pulse");
                @(posedge tvalid_o);
                time_start = $time;
                @(negedge tvalid_o);
                time_end = $time;
                pulse_width = time_end-time_start;
                `FAIL_IF_NOT_EQUAL(pulse_width, ACLK_O_PERIOD*2);
                `SUCCESS("Pulse received with correct width!");
            end

        join

        `INFO("Test finished");

    `UNIT_TEST_END

    `UNIT_TESTS_END

endmodule

