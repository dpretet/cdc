// Mandatory file to be able to launch SVUT flow
`include "svut_h.sv"

// Specify here the module to load or setup the path in files.f
//`include "../src/data_bus_synchro.v"

`timescale 1 ns / 1 ps

module data_bus_synchro_unit_test;

    `SVUT_SETUP

    parameter BUS_WIDTH = 8;

    reg                  aclk_i;
    reg                  arstn_i;
    reg                  aclk_o;
    reg                  arstn_o;
    reg                  tvalid_i;
    wire                 tready_i;
    reg  [BUS_WIDTH-1:0] tdata_i;
    wire                 tvalid_o;
    reg  [BUS_WIDTH-1:0] tdata_o;

    data_bus_synchro
    #(
    BUS_WIDTH
    )
    dut
    (
    aclk_i,
    arstn_i,
    aclk_o,
    arstn_o,
    tvalid_i,
    tready_i,
    tdata_i,
    tvalid_o,
    tdata_o
    );

    localparam ACLK_I_PERIOD = 2;
    localparam ACLK_O_PERIOD = 20;

    // An example to create a clock
    initial aclk_i = 0;
    initial aclk_o = 0;
    always #ACLK_I_PERIOD aclk_i <= ~aclk_i;
    always #ACLK_O_PERIOD aclk_o <= ~aclk_o;

    // An example to dump data for visualization
    initial $dumpvars(0, data_bus_synchro_unit_test);

    task setup();
    begin
        // setup() runs when a test begins
        arstn_i = 1'b0;
        arstn_o = 1'b0;
        tvalid_i = 1'b0;
        tdata_i = {BUS_WIDTH{1'b0}};
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
           - `INFO("message"); Print a grey message
           - `SUCCESS("message"); Print a green message
           - `WARNING("message"); Print an orange message and increment warning counter
           - `CRITICAL("message"); Print an pink message and increment critical counter
           - `ERROR("message"); Print a red message and increment error counter
           - `FAIL_IF(aSignal); Increment error counter if evaluaton is positive
           - `FAIL_IF_NOT(aSignal); Increment error coutner if evaluation is false
           - `FAIL_IF_EQUAL(aSignal, 23); Increment error counter if evaluation is equal
           - `FAIL_IF_NOT_EQUAL(aSignal, 45); Increment error counter if evaluation is not equal
        */

    `UNIT_TEST(RESET_DEASSERTION)

        `INFO("Start RESET_DEASSERTION");

        `FAIL_IF_NOT(tready_i);
        `FAIL_IF_NOT_EQUAL(tdata_o, {BUS_WIDTH{1'b0}});

        `INFO("Test finished");

    `UNIT_TEST_END

    `UNIT_TESTS_END

endmodule

