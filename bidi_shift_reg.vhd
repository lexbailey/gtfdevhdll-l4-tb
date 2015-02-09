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

	shift_reg: for i in 0 to size-1 generate
		one_dff: entity work.dff
			port map (
				clk => clk,
				rst => rst,
				d => data_d(i),
				q => data_q(i+1)
			);
			
		with ctrl select	
			data_d(i) <= data_q(i+1) when "00", --hold
								data_in(i) when "11", --load
								data_q(i) when "10", --shift left
								data_q(i+2) when "01", --shift right
								'U' when others;
						
	end generate;

	data_q(0) <= shift_in;
	data_q(size+1) <= shift_in;
	data_out <= data_q(size downto 1);

end Behavioral;

