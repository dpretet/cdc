// Mandatory file to be able to launch SVUT flow
`include "svut_h.sv"

// Specify here the module to load or setup the path in files.f
//`include "../src/pulse_synchro.v"

`timescale 1 ns / 1 ps

module pulse_synchro_unit_test;

    `SVUT_SETUP

    reg   aclk_i;
    reg   arstn_i;
    reg   aclk_o;
    reg   arstn_o;
    reg   data_i;
    reg   data_o;

    pulse_synchro
    dut
    (
    aclk_i,
    arstn_i,
    aclk_o,
    arstn_o,
    data_i,
    data_o
    );

    // An example to create a clock
    initial aclk_i = 0;
    initial aclk_o = 0;
    always #2 aclk_i <= ~aclk_i;
    always #20 aclk_o <= ~aclk_o;

    // An example to dump data for visualization
    initial $dumpvars(0,pulse_synchro_unit_test);

    task setup();
    begin
        // setup() runs when a test begins
        arstn_i = 1'b0;
        arstn_o = 1'b0;
        data_i = 1'b0;
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

        `INFO("Check output state");

        `FAIL_IF(data_o);

        `INFO("End test");

    `UNIT_TEST_END

    `UNIT_TEST(SINGLE_TOGGLE)

        `INFO("Start SINGLE_TOGGLE test");

        @(posedge aclk_i);
        data_i = 1'b1;
        @(posedge aclk_i);
        data_i = 1'b0;

        #100;

        `INFO("End test");

    `UNIT_TEST_END

    `UNIT_TESTS_END

endmodule

