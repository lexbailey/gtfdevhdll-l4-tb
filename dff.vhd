library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--D type flipflop
entity dff is
    Port ( clk : in  STD_LOGIC;	--clock signal
           d : in  STD_LOGIC;		--data input
           q : out  STD_LOGIC;	--data output
           rst : in  STD_LOGIC); --reset signal
end dff;

architecture Behavioral of dff is
	signal data : std_logic;
begin

	flip_flop: process (clk)
	begin
		--on a rising edge
		if rising_edge(clk) then
			if rst = '1' then
				--if reset is high then set data to 0
				data <= '0';
			else
				--otherwise, take copy of input
				data <= d;
			end if;
		end if;
	end process flip_flop;

	--connect output
	q <= data;

end Behavioral;

