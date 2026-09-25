`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213: Project 3 Elevator Controller FSM
// File Name: elevator_fsm_tb.v
// Author: Vy Do
// Date: September 20th, 2026
//////////////////////////////////////////////////////////////////////////////////

module elevator_fsm_tb();

// controlled by the testbench
    reg clk;
    reg rst_n;

    reg floor_1_up_button_pressed;
    reg floor_2_down_button_pressed;
    reg floor_2_up_button_pressed;
    reg floor_3_down_button_pressed;
    reg elevator_floor_1_button_pressed;
    reg elevator_floor_2_button_pressed;
    reg elevator_floor_3_button_pressed;

// control by the DUT
    wire floor_1_up_button;
    wire floor_2_down_button;
    wire floor_2_up_button;
    wire floor_3_down_button;
    wire elevator_floor_1_button;
    wire elevator_floor_2_button;
    wire elevator_floor_3_button;

// outputs from DUT
    wire  floor_1;
    wire  floor_2;
    wire  floor_3;
    wire  elevator_door_open;
    wire  floor_1_up_button_clear;
    wire  floor_2_down_button_clear;
    wire  floor_2_up_button_clear;
    wire  floor_3_down_button_clear;
    wire  elevator_floor_1_button_clear;
    wire  elevator_floor_2_button_clear;
    wire  elevator_floor_3_button_clear;

// instantiate buttons based on the elevator_button.v module
// button_pressed is control by the testbench, not connecting to DUT
    elevator_button floor_1_up_button_ins
    (
        .clk(clk),
        .rst_n(rst_n),
        .button_pressed(floor_1_up_button_pressed),
        .clear(floor_1_up_button_clear),		       
        .button_out(floor_1_up_button)
    );

    elevator_button floor_2_down_button_ins
    (
        .clk(clk),
        .rst_n(rst_n),
        .button_pressed(floor_2_down_button_pressed),
        .clear(floor_2_down_button_clear),		       
        .button_out(floor_2_down_button)
    );

    elevator_button floor_2_up_button_ins
    (
        .clk(clk),
        .rst_n(rst_n),
        .button_pressed(floor_2_up_button_pressed),
        .clear(floor_2_up_button_clear),		       
        .button_out(floor_2_up_button)
    );
    
    elevator_button floor_3_down_button_ins
    (
        .clk(clk),
        .rst_n(rst_n),
        .button_pressed(floor_3_down_button_pressed),
        .clear(floor_3_down_button_clear),		       
        .button_out(floor_3_down_button)
    );

    elevator_button elevator_floor_1_button_ins
    (
        .clk(clk),
        .rst_n(rst_n),
        .button_pressed(elevator_floor_1_button_pressed),
        .clear(elevator_floor_1_button_clear),		       
        .button_out(elevator_floor_1_button)
    );

    elevator_button elevator_floor_2_button_ins
    (
        .clk(clk),
        .rst_n(rst_n),
        .button_pressed(elevator_floor_2_button_pressed),
        .clear(elevator_floor_2_button_clear),		       
        .button_out(elevator_floor_2_button)
    );

    elevator_button elevator_floor_3_button_ins
    (
        .clk(clk),
        .rst_n(rst_n),
        .button_pressed(elevator_floor_3_button_pressed),
        .clear(elevator_floor_3_button_clear),		       
        .button_out(elevator_floor_3_button)
    );


// instantiate DUT .port_of_DUT(signal_of_testbench)
elevator_fsm DUT
(
    .clk(clk),
    .rst_n(rst_n),
    .floor_1_up_button(floor_1_up_button),
    .floor_2_down_button(floor_2_down_button),
    .floor_2_up_button(floor_2_up_button),
    .floor_3_down_button(floor_3_down_button),
    .elevator_floor_1_button(elevator_floor_1_button),
    .elevator_floor_2_button(elevator_floor_2_button),
    .elevator_floor_3_button(elevator_floor_3_button),

    .floor_1(floor_1),
    .floor_2(floor_2),
    .floor_3(floor_3),
    .elevator_door_open(elevator_door_open),
    .floor_1_up_button_clear(floor_1_up_button_clear),
    .floor_2_down_button_clear(floor_2_down_button_clear),
    .floor_2_up_button_clear(floor_2_up_button_clear),
    .floor_3_down_button_clear(floor_3_down_button_clear),
    .elevator_floor_1_button_clear(elevator_floor_1_button_clear),
    .elevator_floor_2_button_clear(elevator_floor_2_button_clear),
    .elevator_floor_3_button_clear(elevator_floor_3_button_clear)
);

// 100 MHz clock
always #5 clk =~ clk;

// start the test
initial 
    begin
        // initialization
        clk = 0;
        rst_n = 0;
        floor_1_up_button_pressed = 0;
        floor_2_down_button_pressed = 0;
        floor_2_up_button_pressed = 0;
        floor_3_down_button_pressed = 0;
        elevator_floor_1_button_pressed = 0;
        elevator_floor_2_button_pressed = 0;
        elevator_floor_3_button_pressed = 0;

        repeat(1)
        @(negedge clk);
        rst_n = 1;
        $monitor("floor 1 up: %b, floor 2 down: %b, floor 2 up: %b, floor 3 down: %b, floor 1: %b, floor 2: %b, floor 3: %b", 
                    floor_1_up_button_pressed,floor_2_down_button_pressed, floor_2_up_button_pressed, 
                    floor_3_down_button_pressed, elevator_floor_1_button_pressed, 
                    elevator_floor_2_button_pressed, elevator_floor_3_button_pressed);

// test case 1: floor 1 to floor 2
        repeat(1)
        @(negedge clk);
        $display("Test Case 1: Floor 1 to Floor 2, pressed floor 1 up button: %b", floor_1_up_button_pressed);
        floor_1_up_button_pressed = 1;
        
        repeat(1)
        @(negedge clk);
        floor_1_up_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 1: Floor 1 to Floor 2, pressed elevator floor 2 button: %b",elevator_floor_2_button_pressed );
        elevator_floor_2_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_2_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 2: floor 1 to floor 3
        repeat(1)
        @(negedge clk);
        $display("Test Case 2: Floor 1 to Floor 3, pressed floor 1 up button: %b", floor_1_up_button_pressed);
        floor_1_up_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_1_up_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 2: Floor 1 to Floor 3, pressed elevator floor 3 button: %b", elevator_floor_3_button_pressed );
        elevator_floor_3_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_3_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 3: floor 2 to floor 3
        repeat(1)
        @(negedge clk);
        $display("Test Case 3: Floor 2 to Floor 3, pressed floor 2 up button: %b", floor_2_up_button_pressed);
        floor_2_up_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_2_up_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 3: Floor 2 to Floor 3, pressed elevator floor 3 button: %b", elevator_floor_3_button_pressed);
        elevator_floor_3_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_3_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 4: floor 2 to floor 1
        repeat(1)
        @(negedge clk);
        $display("Test Case 4: Floor 2 to Floor 1, pressed floor 2 down button: %b",floor_2_down_button_pressed);
        floor_2_down_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_2_down_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 4: Floor 2 to Floor 1, pressed elevator floor 1 button: %b", elevator_floor_1_button_pressed);
        elevator_floor_1_button_pressed = 1;
        
        repeat(1)
        @(negedge clk);
        elevator_floor_1_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 5: floor 3 to floor 2
        repeat(1)
        @(negedge clk);
        $display("Test Case 5: Floor 3 to Floor 2, pressed floor 3 down button: %b", floor_3_down_button_pressed);
        floor_3_down_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_3_down_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 5: Floor 3 to Floor 2, pressed elevator floor 2 button: %b", elevator_floor_2_button_pressed);
        elevator_floor_2_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_2_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 6: floor 3 to floor 1
        repeat(1)
        @(negedge clk);
        $display("Test Case 6: Floor 3 to Floor 1, pressed floor 3 down button: %b", floor_3_down_button_pressed);
        floor_3_down_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_3_down_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 6: Floor 3 to Floor 1, pressed elevator floor 1 button: %b", elevator_floor_1_button_pressed);
        elevator_floor_1_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_1_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 7: floor 1 to floor 3, pick up floor 2
        repeat(1)
        @(negedge clk);
        $display("Test Case 7: Floor 1 to Floor 3, pick up floor 2, pressed floor 1 up button: %b", floor_1_up_button_pressed);
        floor_1_up_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_1_up_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 7: Floor 1 to Floor 3, pick up floor 2, pressed elevator floor 3 button: %b",elevator_floor_3_button_pressed);
        elevator_floor_3_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_3_button_pressed = 0; // turn off the button
        $display("Test Case 7: Floor 1 to Floor 3, pick up floor 2, pressed floor 2 up button: %b", floor_2_up_button_pressed);
        floor_2_up_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_2_up_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 8: floor 3 to floor 1, pick up floor 2
        repeat(1)
        @(negedge clk);
        $display("Test Case 8: Floor 3 to Floor 1, pick up floor 2, pressed floor 3 down button: %b",floor_3_down_button_pressed );
        floor_3_down_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_3_down_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 8: Floor 3 to Floor 1, pick up floor 2, pressed elevator floor 1 button: %b",elevator_floor_1_button_pressed );
        elevator_floor_1_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_1_button_pressed = 0; // turn off the button
        $display("Test Case 8: Floor 3 to Floor 1, pick up floor 2, pressed floor 2 down button: %b",floor_2_down_button_pressed );
        floor_2_down_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_2_down_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

// test case 9: floor 1 to floor 3, passenger enter at floor 2 and press floor 1
        repeat(1)
        @(negedge clk);
        $display("Test Case 9: Floor 1 to Floor 3, enter at floor 2 and press floor 1, pressed floor 1 up button: %b", floor_1_up_button_pressed);
        floor_1_up_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_1_up_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 9: Floor 1 to Floor 3, enter at floor 2 and press floor 1, pressed elevator floor 3 button: %b", elevator_floor_3_button_pressed);
        elevator_floor_3_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_3_button_pressed = 0; // turn off the button
        $display("Test Case 9: Floor 1 to Floor 3, enter at floor 2 and press floor 1, pressed floor 2 down button: %b", floor_2_down_button_pressed);
        floor_2_down_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        floor_2_down_button_pressed = 0; // turn off the button

        repeat(1)
        @(negedge clk);
        $display("Test Case 9: Floor 1 to Floor 3, enter at floor 2 and press floor 1, pressed elevator floor 1 button: %b", elevator_floor_1_button_pressed);
        elevator_floor_1_button_pressed = 1;

        repeat(1)
        @(negedge clk);
        elevator_floor_1_button_pressed = 0; // turn off the button

        repeat(4)
        @(negedge clk);
        rst_n = 0; // reset the elevator

        repeat(1)
        @(negedge clk);
        rst_n = 1; // reset the elevator

        repeat(1)
        @(negedge clk);
        $finish;
    end // end the test

endmodule



