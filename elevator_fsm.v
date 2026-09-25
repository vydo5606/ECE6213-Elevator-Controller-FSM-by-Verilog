`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213: Project 3 Elevator Controller FSM
// File Name: elevator_fsm.v
// Author: Vy Do
// Date: September 20th, 2026
//////////////////////////////////////////////////////////////////////////////////


module elevator_fsm
(
    input wire clk,
    input wire rst_n,
    input wire floor_1_up_button,
    input wire floor_2_down_button,
    input wire floor_2_up_button,
    input wire floor_3_down_button,
    input wire elevator_floor_1_button,
    input wire elevator_floor_2_button,
    input wire elevator_floor_3_button,

    output reg floor_1,
    output reg floor_2,
    output reg floor_3,
    output reg elevator_door_open,
    output reg floor_1_up_button_clear,
    output reg floor_2_down_button_clear,
    output reg floor_2_up_button_clear,
    output reg floor_3_down_button_clear,
    output reg elevator_floor_1_button_clear,
    output reg elevator_floor_2_button_clear,
    output reg elevator_floor_3_button_clear
);

    // have 9 states for the elevator
    // need 2^4 = 16 bits 
    // state_current update every clock cycle 
    reg [3:0]   state_current;
    reg [3:0]   state_next;

    // parameter: give a readble name for each state 
    parameter [3:0] S0_IDLE                     = 4'd0;
    parameter [3:0] S1_FLOOR_1_DOOR_OPEN        = 4'd1;
    parameter [3:0] S2_FLOOR_1_DOOR_CLOSE       = 4'd2;
    parameter [3:0] S3_FLOOR_2_DOOR_OPEN        = 4'd3;
    parameter [3:0] S4_FLOOR_2_DOOR_CLOSE       = 4'd4;
    parameter [3:0] S5_FLOOR_3_DOOR_OPEN        = 4'd5;
    parameter [3:0] S6_FLOOR_3_DOOR_CLOSE       = 4'd6;
    parameter [3:0] S7_FLOOR_1_TO_FLOOR_3       = 4'd7;
    parameter [3:0] S8_FLOOR_3_TO_FLOOR_1       = 4'd8;
    parameter [3:0] S9_FLOOR_2_PICK_UP_13       = 4'd9;
    parameter [3:0] S10_FLOOR_2_PICK_UP_31      = 4'd10;



    // update new state every clock cycle or reset cycle
    // elevator is back to IDLE mode when reset is active
    // else, elevator moves to the next stage
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0)
            begin
                state_current <= S0_IDLE;
            end
        else 
            begin
                state_current <= state_next;
            end

    $display("state_current: %s", state_current);

    end // always @(posedge clk or negedge rst_n)

    // logic for updating elevator stage
    // with this logic, no passenger stuck: the elevator destination is determined
    // by the floor buttons inside the elevator, not the up/down button
    always @(*) 
        begin
            state_next = state_current; // stay in the curent stage unless there is new input

            case(state_current)
            S0_IDLE :                           
            begin
                if (floor_1_up_button == 1'd1)
                state_next = S1_FLOOR_1_DOOR_OPEN;

                else if (floor_2_down_button == 1'd1)
                state_next = S3_FLOOR_2_DOOR_OPEN;

                else if (floor_2_up_button == 1'd1)
                state_next = S3_FLOOR_2_DOOR_OPEN;

                else if (floor_3_down_button == 1'd1)
                state_next = S5_FLOOR_3_DOOR_OPEN;
            end

            S1_FLOOR_1_DOOR_OPEN : // floor 1, door open, choose the next floor, door close                        
            begin
                state_next = S2_FLOOR_1_DOOR_CLOSE;                              
            end

            S2_FLOOR_1_DOOR_CLOSE :
            begin

                if (elevator_floor_2_button == 1'd1)
                state_next = S3_FLOOR_2_DOOR_OPEN;

                else if (elevator_floor_3_button == 1'd1)
                state_next = S7_FLOOR_1_TO_FLOOR_3;       // floor 1 to 3, chec for pick up

                else if (elevator_floor_1_button == 1'd1) // in case users confuse
                state_next = S1_FLOOR_1_DOOR_OPEN;

                else
                state_next = S0_IDLE;
            end

            S3_FLOOR_2_DOOR_OPEN :
            begin 
                state_next = S4_FLOOR_2_DOOR_CLOSE;
            end

            S4_FLOOR_2_DOOR_CLOSE :
            begin
                if (elevator_floor_1_button == 1'd1)
                state_next = S1_FLOOR_1_DOOR_OPEN;

                else if (elevator_floor_3_button == 1'd1)
                state_next = S5_FLOOR_3_DOOR_OPEN;

                else if (elevator_floor_2_button == 1'd1)
                state_next = S3_FLOOR_2_DOOR_OPEN;

                else
                state_next = S0_IDLE;
            end

            S5_FLOOR_3_DOOR_OPEN :
            begin
                state_next = S6_FLOOR_3_DOOR_CLOSE;
            end

            S6_FLOOR_3_DOOR_CLOSE :
            begin

                if (elevator_floor_1_button == 1'd1)
                state_next = S8_FLOOR_3_TO_FLOOR_1;

                else if (elevator_floor_2_button == 1'd1)
                state_next = S3_FLOOR_2_DOOR_OPEN;

                else if (elevator_floor_3_button == 1'd1) 
                state_next = S5_FLOOR_3_DOOR_OPEN;

                else //Back to IDLE
                state_next = S0_IDLE;
            end

            // if floor 2 up is pressed when travel from floor 1 to 3
            // open door 2; otherwise, continue floor 3
            S7_FLOOR_1_TO_FLOOR_3:
            begin
                if (floor_2_up_button == 1 || floor_2_down_button == 1) 
                state_next = S9_FLOOR_2_PICK_UP_13;

                else
                state_next = S5_FLOOR_3_DOOR_OPEN;
            end

            // if floor 2 down is pressed when travel from floor 3 to 1
            // open door 2; otherwise, continue floor 1
            S8_FLOOR_3_TO_FLOOR_1:
            begin
                if (floor_2_down_button == 1 || floor_2_up_button == 1)
                state_next = S10_FLOOR_2_PICK_UP_31;

                else
                state_next = S1_FLOOR_1_DOOR_OPEN;
            end

            S9_FLOOR_2_PICK_UP_13:
            begin
                if (elevator_floor_3_button == 1)
                state_next = S5_FLOOR_3_DOOR_OPEN;
            end

            S10_FLOOR_2_PICK_UP_31:
            begin
                if (elevator_floor_1_button == 1)
                state_next = S1_FLOOR_1_DOOR_OPEN;
            end

            endcase
        end // end always @(*) 

// output logic (elevator responses to the input). 
// current floor, door open/close/, elevator button clear, up/down on/clear

always @(*)
    begin
    floor_1 = 0;
    floor_2 = 0;
    floor_3 = 0;
    elevator_door_open = 0;
    floor_1_up_button_clear = 0;
    floor_2_down_button_clear = 0;
    floor_2_up_button_clear = 0;
    floor_3_down_button_clear = 0;
    elevator_floor_1_button_clear = 0;
    elevator_floor_2_button_clear = 0;
    elevator_floor_3_button_clear = 0;
    
        case (state_current)
            S1_FLOOR_1_DOOR_OPEN :
                begin
                    floor_1 = 1;
                    floor_2 = 0;
                    floor_3 = 0;
                    elevator_door_open = 1'd1;

                    if (elevator_floor_1_button == 1'd1)
                    elevator_floor_1_button_clear = 1'd1; // clear button if elevator_floor_1_button is pressed

                    if (floor_1_up_button == 1'd1)
                        floor_1_up_button_clear = 1'd1;
                end

            S2_FLOOR_1_DOOR_CLOSE :
                begin
                    elevator_door_open = 1'd0;
                    floor_1_up_button_clear = 1'd0;
                    elevator_floor_1_button_clear = 1'd0;
                end

            S3_FLOOR_2_DOOR_OPEN :
                begin
                    floor_1 = 0;
                    floor_2 = 1;
                    floor_3 = 0;
                    elevator_door_open = 1'd1;

                    if (elevator_floor_2_button == 1'd1) // clear button if elevator_floor_2_button is pressed
                    elevator_floor_2_button_clear = 1'd1;

                    if (floor_2_up_button == 1'd1)
                        floor_2_up_button_clear = 1'd1;
                        
                    else if (floor_2_down_button == 1'd1)
                        floor_2_down_button_clear = 1'd1;
                end

            S4_FLOOR_2_DOOR_CLOSE :
                begin
                    elevator_door_open = 1'd0;
                    floor_2_down_button_clear = 1'd0;
                    floor_2_up_button_clear = 1'd0;
                    elevator_floor_2_button_clear = 1'd0;
                end

            S5_FLOOR_3_DOOR_OPEN :
                begin
                    floor_1 = 0;
                    floor_2 = 0;
                    floor_3 = 1;
                    elevator_door_open = 1'd1;

                    if (elevator_floor_3_button == 1'd1) // clear button if elevator_floor_3_button is pressed
                    elevator_floor_3_button_clear = 1'd1;


                    if (floor_3_down_button == 1'd1)
                        floor_3_down_button_clear = 1'd1;
                end

            S6_FLOOR_3_DOOR_CLOSE :
                begin
                    elevator_door_open = 1'd0;
                    floor_3_down_button_clear = 1'd0;
                    elevator_floor_3_button_clear = 1'd0;
                end

            S7_FLOOR_1_TO_FLOOR_3 :
            begin
                if (floor_2_down_button == 1 || floor_2_up_button == 1)
                elevator_door_open = 1'd1; //open door at floor 2

                if (floor_2_up_button == 1'd1)
                    floor_2_up_button_clear = 1'd1;
                        
                else if (floor_2_down_button == 1'd1)
                    floor_2_down_button_clear = 1'd1;
            end

            S8_FLOOR_3_TO_FLOOR_1:
            begin
                if (floor_2_down_button == 1 || floor_2_up_button == 1)
                elevator_door_open = 1'd1; //open door at floor 2 if button is pressed

                if (floor_2_up_button == 1'd1)
                    floor_2_up_button_clear = 1'd1;
                        
                else if (floor_2_down_button == 1'd1)
                    floor_2_down_button_clear = 1'd1;
            end

            S9_FLOOR_2_PICK_UP_13:
            begin
                elevator_door_open = 1'd0; // close door for floor 2
            end

            S10_FLOOR_2_PICK_UP_31:
            begin
                elevator_door_open = 1'd0; // close door for floor 2
            end
        endcase        
    end
endmodule
