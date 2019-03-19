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

// Synthesis

module data_bus_synchro

    #(
    parameter BUS_WIDTH = 8
    )(
    input  wire                 aclk_i,
    input  wire                 arstn_i,
    input  wire                 aclk_o,
    input  wire                 arstn_o,
    input  wire                 tvalid_i,
    output wire                 tready_i,
    input  wire [BUS_WIDTH-1:0] tdata_i,
    output wire                 tvalid_o,
    output reg  [BUS_WIDTH-1:0] tdata_o
    );

    hsk_pulse_synchro ctrl (
    .aclk_i     (aclk_i),
    .arstn_i    (arstn_i),
    .aclk_o     (aclk_o),
    .arstn_o    (arstn_o),
    .tvalid_i   (tvalid_i),
    .tready_i   (tready_i),
    .tvalid_o   (tvalid_o)
    );

    always @ (posedge aclk_o or negedge arstn_o) begin

        if (arstn_o == 1'b0) begin
            tdata_o <= {BUS_WIDTH{1'b0}};
        end
        else begin
            if (tvalid_o == 1'b1)
                tdata_o <= tdata_i;
            else
                tdata_o <= tdata_o;
        end

    end

endmodule

`resetall

