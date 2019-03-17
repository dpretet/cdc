`include "svut_h.sv"
`timescale 1 ns / 1 ps

module debouncer_unit_test;

    `SVUT_SETUP

    parameter DEB_TIME = 100;

    reg  aclk;
    reg  arstn;
    reg  button;
    reg  button_debounced;

    debouncer
    #(
    DEB_TIME
    )
    dut
    (
    aclk,
    arstn,
    button,
    button_debounced
    );

    // An example to create a clock
    initial aclk = 0;
    always #2 aclk <= ~aclk;

    // An example to dump data for visualization
    initial $dumpvars(0,debouncer_unit_test);

    task setup();
    begin
        // setup() runs when a test begins
        button = 1'b0;
        arstn = 1'b0;
        #100;
        `INFO("Deassert arstn");
        arstn = 1'b1;
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

        `INFO("Start test RESET_DEASSERTION");

        #10;
        `FAIL_IF_NOT_EQUAL(button_debounced, 1'b0);
        `INFO("Debounced output is 0 after initialization");

        `INFO("End test");

    `UNIT_TEST_END

    `UNIT_TEST(SIMPLE_BUTTON_PRESSURE)

        `INFO("Start test SIMPLE_BUTTON_PRESSURE");

        #100;

        `INFO("Apply pressure on button");
        button = 1'b1;
        #500;
        `FAIL_IF_NOT_EQUAL(button_debounced, 1'b1);
        `INFO("Button polarity has been properly debounced by the circuit");

        `INFO("End test");

    `UNIT_TEST_END

    `UNIT_TEST(SIMPLE_BUTTON_PRESSURE_THEN_RELEASE)

        `INFO("Start test SIMPLE_BUTTON_PRESSURE_THEN_RELEASE");

        #100;

        `INFO("Apply pressure on button");
        button = 1'b1;
        #500;
        `FAIL_IF_NOT_EQUAL(button_debounced, 1'b1);
        `INFO("Button polarity has been properly debounced by the circuit");

        `INFO("Release pressure on button");
        button = 1'b0;
        #9;
        `FAIL_IF_NOT_EQUAL(button_debounced, 1'b1);
        #500;
        `FAIL_IF_NOT_EQUAL(button_debounced, 1'b0);
        `INFO("Button polarity has been properly debounced by the circuit");

        `INFO("End test");

    `UNIT_TEST_END
    `UNIT_TESTS_END

endmodule

