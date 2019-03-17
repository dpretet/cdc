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
    Synchronize pulse signal from a fast domain to a slow clock domain.
    It can handle only pulse at low frequency, meaning it absorbs and
    transfers pulses only according destination domain capability.
*/

module pulse_synchro

    (
    input wire  aclk_i,
    input wire  arstn_i,
    input wire  aclk_o,
    input wire  arstn_o,
    input wire  data_i,
    output reg  data_o
    );

    reg pulse_mux;
    reg pulse_mux_sync;

    always @ (posedge aclk_i or negedge arstn_i) begin

        if (arstn_i == 1'b0) begin
            pulse_mux <= 1'b0;
        end
        else begin
            if (data_i == 1'b1)
                pulse_mux <= ~pulse_mux;
            else
                pulse_mux <= pulse_mux;
        end
    end

    // Resynchronize the pulse into destination domain
    ffd_synchro pulse_resync(aclk_o, arstn_o, pulse_mux, pulse_mux_sync);

    // Recreate a new pulse matching the destination domain speed
    always @ (posedge aclk_o or negedge arstn_o) begin: destination

        reg ffd;

        if (arstn_o == 1'b0) begin
            ffd <= 1'b0;
            data_o <= 1'b0;
        end
        else begin
            ffd <= pulse_mux_sync;
            data_o <= pulse_mux_sync ^ ffd;
        end

    end


endmodule

`resetall

