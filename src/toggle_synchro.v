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


module toggle_synchro

    (
    input wire  aclk_i,
    input wire  arstn_i,
    input wire  aclk_o,
    input wire  arstn_o,
    input wire  data_i,
    output wire data_o
    );

    reg toggle_mux;

    always @ (posedge aclk_i or negedge arstn_i) begin

        if (arstn_i == 1'b0) begin
            toggle_mux <= 1'b0;
        end
        else begin
            if (data_i == 1'b1)
                toggle_mux <= ~toggle_mux;
            else
                toggle_mux <= toggle_mux;
        end
    end


endmodule

`resetall

