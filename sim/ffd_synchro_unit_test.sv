// Mandatory file to be able to launch SVUT flow
`include "svut_h.sv"

// Specify here the module to load or setup the path in files.f
//`include "../src/ffd_synchro.v"

`timescale 1 ns / 1 ps

module ffd_synchro_unit_test;

    `SVUT_SETUP

    reg   aclk;
    reg   arstn;
    reg   data_i;
    wire data_o;

    ffd_synchro
    dut
    (
    aclk,
    arstn,
    data_i,
    data_o
    );

    // An example to create a clock
    initial aclk = 0;
    always #2 aclk <= ~aclk;

    // An example to dump data for visualization
    initial $dumpvars(0,ffd_synchro_unit_test);

    task setup();
    begin
        // setup() runs when a test begins
        data_i = 1'b0;
        arstn = 1'b0;
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

    `UNIT_TEST(RESET_ASSERTION)

        `INFO("Start test RESET_ASSERTION");

        #100;
        arstn = 1'b1;
        `INFO("Deassert reset");
        #100;

        `FAIL_IF(data_o);

        `INFO("End test");

    `UNIT_TEST_END

    `UNIT_TEST(DATA_IN_ASSERTION)

        `INFO("Start test DATA_IN_ASSERTION");

        #100;
        arstn = 1'b1;
        `INFO("Deassert reset");
        #100;

        `FAIL_IF(data_o);

        data_i = 1'b1;
        #20;

        `FAIL_IF_NOT(data_o);

        `INFO("End test");

    `UNIT_TEST_END

    `UNIT_TESTS_END

endmodule

