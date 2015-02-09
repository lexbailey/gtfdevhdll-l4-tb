LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY dff_tb IS
END dff_tb;
 
ARCHITECTURE behavior OF dff_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dff
    PORT(
         clk : IN  std_logic;
         d : IN  std_logic;
         q : OUT  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal d : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal q : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dff PORT MAP (
          clk => clk,
          d => d,
          q => q,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		--reset
		rst <= '1';
      wait for clk_period;
		rst <= '0';

		wait for clk_period*3;
		
		assert q = '0'
		report "Flipflop reset failed."
		severity error;

      d <= '1';
		wait for clk_period*3;
		
		assert q = '1'
		report "Flipflop test failed."
		severity error;
		
		rst <= '1';

		wait for clk_period*3;
		
		assert q = '0'
		report "Flipflop reset failed."
		severity error;

      wait;
   end process;

END;
