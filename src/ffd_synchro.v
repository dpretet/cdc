//-----------------------------------------------------------------------
// Copyright 2017 Damien Pretet ThotLogic
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

module ffd_synchro

    (
    input wire  aclk,
    input wire  arstn,
    input wire  tvalid_i,
    output wire tvalid_o
    );

    reg [1:0] synchro;

    always @ (posedge aclk or negedge arstn) begin

        if (arstn == 1'b0) begin
            synchro <= 2'b0;
        end
        else begin
            synchro <= {synchro[0], tvalid_i};
        end
    end

    assign tvalid_o = synchro[1];


endmodule

`resetall

