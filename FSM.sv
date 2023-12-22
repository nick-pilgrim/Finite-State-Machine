//This File contains the phyical validation module, the module that creates the FSM, and the testbench for the FSM, and the debouncer
module FSM(input clk, reset, SW1, SW2, SW3, SW4, output logic [2:0] state, output logic [1:0] Z); //Finite State Machine Module
localparam S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100; //STATEs DECLARED
logic [2:0] nextQ; //NEXT STATE
logic [2:0] H7seg;
always_ff @(posedge clk or posedge reset) //SYNCHRONOS PART
	if(reset) begin
		state <= S0;
	end
	//This allows so two switches that are up can't affect the output
	else if(((reset&SW1)|(reset&SW2)|(reset&SW3)|(reset&SW4)|(SW1&SW2)|(SW1&SW3)|(SW1&SW4)|(SW2&SW3)|(SW2&SW4)|(SW3&SW4)) == 1'b0) begin
		state <= nextQ;
	end

always_comb begin //COMBINATORIAL PART
	nextQ = state;
	case(state)
		S0: begin //STATE ZERO
		Z = 2'b01; //output for state 0
		if(SW1)
			nextQ = S1;
		else if(SW3)
			nextQ = S3;
		else if (reset)
			nextQ = S0;
		else if(SW2 | SW4)
			nextQ = S0;
		end
		S1: begin //STATE ONE
		Z = 2'b01; //output
		if(SW2)
			nextQ = S2;
		else if (reset)
			nextQ = S0;
		else if(SW1 | SW3 | SW4)
			nextQ = S1;
		end
		S2: begin //STATE TWO
		Z = 2'b10; //ouput
		if(SW2)
			nextQ = S1;
		else if(SW3)
			nextQ = S3;
		else if (reset)
			nextQ = S0;
		else if(SW1 | SW4)
			nextQ = S2;
		end
		S3: begin
		Z = 2'b11; //STATE 3
		if(SW2)
			nextQ = S1;
		else if (SW1)
			nextQ = S4;
		else if (reset)
			nextQ = S0;
		else if(SW3 | SW4)
			nextQ = S3;
		end
		S4: begin
		Z = 2'b10; //STATE 4
		if(SW2)
			nextQ = S1;
		else if (reset)
			nextQ = S0;
		else if(SW1 | SW3 | SW4)
			nextQ = S4;
		end
		default: begin nextQ = S0; Z <= 2'b01; end
	endcase
end
//seven segment display
always_comb begin
	if(reset)
		H7seg = 3'b000;
	else
		H7seg = state;
	end
endmodule 

module FSM_tb(); //TEST BENCH FOR THE FSM
reg SW1,SW2,SW3,SW4, clk, reset;
wire [1:0] Z;
wire [2:0] state;
FSM tb(clk, reset,SW1,SW2,SW3,SW4,state, Z); // MOORE FSM instantiation
initial begin
	//CASE 1
	$display("This is testbench for CASE 1");
	//reset = 1
	clk =0; reset=1; SW1 =0; SW2=0; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);
	
	//SW1 =1 
	clk =0; reset=0; SW1 =1; SW2=0; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW2 =1
	clk =0; reset=0; SW1 =0; SW2=1; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW2 =1 
	clk =0; reset=0; SW1 =0; SW2=1; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW2 =1
	clk =0; reset=0; SW1 =0; SW2=1; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW4 =1
	clk =0; reset=0; SW1 =0; SW2=0; SW3 =0; SW4=1; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW3 =1 
	clk =0; reset=0; SW1 =0; SW2=0; SW3 =1; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW1 =1
	clk =0; reset=0; SW1 =1; SW2=0; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW2 =1 
	clk =0; reset=0; SW1 =0; SW2=1; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW2 =1
	clk =0; reset=0; SW1 =0; SW2=1; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW3 =1 
	clk =0; reset=0; SW1 =0; SW2=0; SW3 =1; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW2 =1 
	clk =0; reset=0; SW1 =0; SW2=1; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);
	
	//CASE 2
	$display("This is testbench for CASE 2");
	//reset = 1
	clk =0; reset=1; SW1 =0; SW2=0; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);
	
	//SW1 =1 
	clk =0; reset=0; SW1 =1; SW2=0; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW2 =1
	clk =0; reset=0; SW1 =0; SW2=1; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW3 =1 
	clk =0; reset=0; SW1 =0; SW2=0; SW3 =1; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW1 =1
	clk =0; reset=0; SW1 =1; SW2=0; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

	//SW0 =1
	clk =0; reset=1; SW1 =0; SW2=0; SW3 =0; SW4=0; #10;
	clk=1; #10;
	$display("clk= %b, reset= %b, SW1= %b, SW2= %b, SW3= %b, SW4= %b, state= %b, Z= %b", clk, reset, SW1,SW2,SW3,SW4,state, Z);

end
endmodule

//THIS IS THE PHYSICAL VERIFICATION part
module FSM_pv(input KEY0, SW0, SW1, SW2, SW3, SW4, output logic [6:0] SEG0, SEG1, SEG2, SEG3, output logic [6:0] LED_SW);
wire[2:0] state; //state variable
wire [1:0] Z; //output
reg clk, s0, s1, s2, s3, s4; //temporary regiseters for clock and SWITCHES
FSM f1(clk, s0,s1,s2,s3,s4, state, Z);
always_comb begin
	clk = KEY0; //LOADS SWITCHES AND CLOCKS Into TEMPORARY VALUES
	s0 = SW0;
	s1 = SW1;
	s2 = SW2;
	s3 = SW3;
	s4 = SW4;
end
//THIS IS FOR THE BOARD'S LED DISPLAY
always_comb begin //DEFAULT CASES
	SEG0 = 7'b1111111; //S
	SEG1 = 7'b1111111; //0
	SEG2 = 7'b1111111; //0
	SEG3 = 7'b1111111; //0
	LED_SW[0] = 1'b0;
	LED_SW[1] = 1'b0;
	LED_SW[2] = 1'b0;
	LED_SW[3] = 1'b0;
	LED_SW[4] = 1'b0;
	LED_SW[5] = 1'b0;
	LED_SW[6] = 1'b0;
	case(state)
		3'b000: begin //STATE ZERO
			SEG3 = 7'b0001100; //P
			SEG2 = 7'b1001111; //I
			SEG1 = 7'b1000111; //L
			SEG0 = 7'b0010000; //G
			LED_SW[0] = SW0; //LEDR 's
			LED_SW[1] = SW1;
			LED_SW[2] = SW2;
			LED_SW[3] = SW3;
			LED_SW[4] = SW4;
			LED_SW[5] = Z[0];
			LED_SW[6] = Z[1];
		end
		3'b001: begin //STATE ONE
			SEG3 = 7'b0010010; //S
			SEG2 = 7'b1110111; //_
			SEG1 = 7'b1000000; //0
			SEG0 = 7'b1111001; //1
			LED_SW[0] = SW0; //LEDR's
			LED_SW[1] = SW1;
			LED_SW[2] = SW2;
			LED_SW[3] = SW3;
			LED_SW[4] = SW4;
			LED_SW[5] = Z[0];
			LED_SW[6] = Z[1];
		end
		3'b010: begin //STATE TWO
			SEG3 = 7'b0010010; //S
			SEG2 = 7'b1110111; //_
			SEG1 = 7'b1000000; //0
			SEG0 = 7'b0100100; //2
			LED_SW[0] = SW0; //LEDR's
			LED_SW[1] = SW1;
			LED_SW[2] = SW2;
			LED_SW[3] = SW3;
			LED_SW[4] = SW4;
			LED_SW[5] = Z[0];
			LED_SW[6] = Z[1];
		end
		3'b011: begin  //STATE THREE PHYISCAL DISPLAY
			SEG3 = 7'b0010010; //S
			SEG2 = 7'b1110111; //_
			SEG1 = 7'b1000000; //0
			SEG0 = 7'b0110000; //3
			LED_SW[0] = SW0;
			LED_SW[1] = SW1; //LEDR's
			LED_SW[2] = SW2;
			LED_SW[3] = SW3;
			LED_SW[4] = SW4;
			LED_SW[5] = Z[0];
			LED_SW[6] = Z[1];
		end
		3'b100: begin //STATE FOUR PHYISCAL DISPLAY
			SEG3 = 7'b0010010; //S
			SEG2 = 7'b1110111; //_
			SEG1 = 7'b1000000; //0
			SEG0 = 7'b0011001; //4
			LED_SW[0] = SW0; //LEDR's
			LED_SW[1] = SW1;
			LED_SW[2] = SW2;
			LED_SW[3] = SW3;
			LED_SW[4] = SW4;
			LED_SW[5] = Z[0];
			LED_SW[6] = Z[1];
		end
		default: begin
			SEG0 = 7'b1111111; //0
			SEG1 = 7'b1111111; //0
			SEG2 = 7'b1111111; //0
			SEG3 = 7'b1111111; //0
			LED_SW[0] = 1'b0;
			LED_SW[1] = 1'b0;
			LED_SW[2] = 1'b0;
			LED_SW[3] = 1'b0;
			LED_SW[4] = 1'b0;
			LED_SW[5] = 1'b0;
			LED_SW[6] = 1'b0;
			end
		endcase
	end
endmodule

//DEBOUNCER
module debounce #(parameter size=8) (input reset, clk, pb, output logic pulse);
logic [size-1:0] cnt;
always_ff @(posedge clk) begin
	if(reset) begin 
		cnt <= {size{1'b1}};
		pulse <= 1'b1;
	end
	else begin
		cnt <= {cnt[size-2:0], pb};
		if(&cnt)
			pulse <= 1'b1;
		else if (~|cnt)
			pulse <= 1'b0;
	end
end
endmodule
