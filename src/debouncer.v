//-----------------------------------------------------------------------
// Copyright 2019 Damien Pretet
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------------

`timescale 1 ns / 1 ps
`default_nettype none

/*
    Button debouncer
*/

module debouncer

    #(
    parameter DEB_TIME = 100        // Setup the time to detect correct button pressure
    )(
    input  wire aclk,               // clk and reset distributed
    input  wire arstn,              // by the clock management
    input  wire button,             // button to debounce
    output reg  button_debounced    // Debounced button
    );


    reg [1:0] button_2ffd;
    wire      button_xnored;
    reg ffd;

    localparam TIMER_WIDTH = $clog2(DEB_TIME);
    reg [TIMER_WIDTH-1:0] timer;

    // First, resynchronize the button with the module's clock
    // to avoid metastability in the circuit
    always @ (posedge aclk or negedge arstn) begin

        if (arstn == 1'b0) begin
            button_2ffd <= 2'b0;
        end
        else begin
            button_2ffd <= {button_2ffd[0], button};
        end

    end

    // Now detect button polarity change with a simple XNOR gate
    // button_xnored will be active when the button polarity doesn't value
    always @ (posedge aclk or negedge arstn) begin
        if (arstn == 1'b0)
            ffd <= 1'b0;
        else
            ffd <= button_2ffd[1];
    end

    assign button_xnored = button_2ffd[1] ~^ ffd;

    // Finally assert the button
    always @ (posedge aclk or negedge arstn) begin

        if (arstn == 1'b0) begin
            timer <= {TIMER_WIDTH{1'b0}};
            button_debounced <= 1'b0;
        end
        else begin

            // The counter is active as long the button is stable
            // Else it is cleared and will restart once stable
            if (button_xnored) begin

                // Prevent to overflow the counter by
                // checking the timer is not at max value
                if (~&timer)
                    timer <= timer + 1'b1;

                // Now can properly assert the button into the system
                if (timer >= DEB_TIME)
                    button_debounced <= button_2ffd[1];

            end
            else
                timer <= {TIMER_WIDTH{1'b0}};

        end

    end

endmodule

`resetall

