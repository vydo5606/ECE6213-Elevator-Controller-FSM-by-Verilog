`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Matthew LaRue 
// Elevator buttons
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module elevator_button(
    input wire clk,
    input wire rst_n,
    input wire button_pressed,
    input wire clear,		       
    output reg button_out
    );

   reg	       button_out_next;
   
    // clock in registers, asynch active-low reset    
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0) begin
	   button_out <= 1'b0;
        end else begin
           button_out <= button_out_next; 
        end   
    end

    // combinational logic
    always @(*)
      begin
	 // default value, button holds previous output
	 button_out_next = button_out;

	 // button pressed and clear logic
	 if ( clear == 1'b1 ) begin
	    button_out_next = 1'b0;
	 end else if (button_pressed == 1'b1) begin
	    button_out_next = 1'b1;
	 end
	 
      end 
     
endmodule
