library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity bidi_shift_reg is
	
	generic (size: natural := 16);
   Port ( clk : in  STD_LOGIC;
           shift_in : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (size-1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (size-1 downto 0);
           ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
           rst : in  STD_LOGIC);
			  
--	type ctrl_type is (hold, shift_right, shift_left, load);
end bidi_shift_reg;

architecture Behavioral of bidi_shift_reg is
	signal data_d : std_logic_vector (size-1 downto 0);
	signal data_q : std_logic_vector (size+1 downto 0);
begin

	--loop to generate the shift register flipflops and muxes
	shift_reg: for i in 0 to size-1 generate
		one_dff: entity work.dff
			port map (
				clk => clk,
				rst => rst,
				d => data_d(i),	--connect unique data_d line
				q => data_q(i+1)	--connect unique data_q line, leave one spare q at start
			);
			
		--the control input selects the source for the d inputs of the flipflops
		with ctrl select	
			data_d(i) <= data_q(i+1) when "00", --hold: take value from self
							data_in(i) when "11", --load: take value from input bus
							data_q(i) when "10", --shift left: take value from next flipflop right
							data_q(i+2) when "01", --shift right: take value from next flipflop left
							'U' when others;
						
	end generate;
	--first signal in data_q is shift in
	data_q(0) <= shift_in;
	--last signal in data_q is als shift in
	data_q(size+1) <= shift_in;
	--data out is just data_q without the signals at the two ends
	data_out <= data_q(size downto 1);

end Behavioral;

