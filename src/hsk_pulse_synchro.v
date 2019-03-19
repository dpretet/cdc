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
    This module synchronizes a pulse to a destination domain,
    as well for high to low or low to high freq. It provides
    back a ready signal to avoid losing a pulse.
*/

module hsk_pulse_synchro

    (
    input  wire aclk_i,
    input  wire arstn_i,
    input  wire aclk_o,
    input  wire arstn_o,
    input  wire tvalid_i,
    output wire tready_i,
    output reg  tvalid_o
    );

    reg  pulse_mux;
    wire pulse_mux_sync;
    wire pulse_back;
    wire pulse_passed_in_dest;
    reg  pulse_mux_sync_ffd;

    // First stage catching the pulse
    always @ (posedge aclk_i or negedge arstn_i) begin

        if (arstn_i == 1'b0) begin
            pulse_mux <= 1'b0;
        end
        else begin
            if (tvalid_i == 1'b1)
                pulse_mux <= 1'b1;
            else begin
                if (pulse_back == 1'b1)
                    pulse_mux <= 1'b0;
                else
                    pulse_mux <= pulse_mux;
            end
        end
    end

    assign tready_i = ~(pulse_back | pulse_mux);

    // Resynchronize the pulse into destination domain
    ffd_synchro pulse_resync(aclk_o, arstn_o, pulse_mux, pulse_mux_sync);

    // Resynchronize the pulse back into source domain
    ffd_synchro pulse_bck2src(aclk_i, arstn_i, pulse_mux_sync, pulse_back);

    // Recreate a new pulse matching the destination domain speed
    assign pulse_passed_in_dest = pulse_mux_sync & ~pulse_mux_sync_ffd;

    // And synchronize finally the pulse into the destination
    always @ (posedge aclk_o or negedge arstn_o) begin: destination

        if (arstn_o == 1'b0) begin
            pulse_mux_sync_ffd <= 1'b0;
            tvalid_o <= 1'b0;
        end
        else begin
            pulse_mux_sync_ffd <= pulse_mux_sync;
            tvalid_o <= pulse_passed_in_dest;
        end

    end

endmodule

`resetall

