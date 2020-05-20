module Wheels(GPIO_0, SW, CLOCK_50, KEY);
	input [9:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	wire [31:0] d;
	output wire [1:0] GPIO_0;
	
	wire wheel_left;
	wire wheel_right;
	
	assign d_left = 32'd1 << SW[9:5];
	assign d_right = 32'd1 << SW[4:0];

	RateDivider rd_left(
		//.enable(GPIO_0[0]),
		.enable(wheel_left),
		.d(d_left),
		.clock(CLOCK_50),
		.reset_n(KEY[0])
	);
	
	RateDivider rd_right(
		.enable(wheel_right),
		.d(d_right),
		.clock(CLOCK_50),
		.reset_n(KEY[0])
	);
	
	assign GPIO_0[0] = KEY[1]? wheel_left: 0;
	assign GPIO_0[1] = KEY[1]? wheel_right: 0;
	
endmodule

module RateDivider(enable, d, clock, reset_n);
	input clock;
	input reset_n;
	input [31:0] d;
	reg [31:0] q;
	
	output enable;
	assign enable = (q == 0) ? 1 : 0;

	always @(posedge clock)
		begin
			if (reset_n == 1'b0) //This reset_n is actually par_load
				q <= d - 1;
			else
				begin
					if (q == 1'b0)
						q <= d - 1;
					else
						q <= q - 1'b1;
				end
		end
endmodule
