LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY bidi_shift_reg_tb IS
END bidi_shift_reg_tb;
 
ARCHITECTURE behavior OF bidi_shift_reg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bidi_shift_reg
    PORT(
         clk : IN  std_logic;
         shift_in : IN  std_logic;
         data_in : IN  std_logic_vector(15 downto 0);
         data_out : OUT  std_logic_vector(15 downto 0);
         ctrl : IN  std_logic_vector(1 downto 0);
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal shift_in : std_logic := '0';
   signal data_in : std_logic_vector(15 downto 0) := (others => '0');
   signal ctrl : std_logic_vector(1 downto 0) := (others => '0');
   signal rst : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bidi_shift_reg PORT MAP (
          clk => clk,
          shift_in => shift_in,
          data_in => data_in,
          data_out => data_out,
          ctrl => ctrl,
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
	
		--initial input values
		data_in <= X"0000";
		ctrl <= "00";
		shift_in <= '0';
		
		--reset
		rst <= '1';
      wait for clk_period;
		rst <= '0';
		wait for clk_period;

      --start with load mode test
		ctrl <= "11";
		data_in <= X"b13f";
		wait for clk_period;
		
		--Self test that load worked
		assert data_out = X"b13f"
		report "Load failed"
		severity error;
		
		--Now hold for some clock cycles
		ctrl <= "00";
		data_in <= X"af34";
		wait for clk_period*4;
		
		--self test that loaded value is still present
		assert data_out = X"b13f"
		report "Hold failed"
		severity error;
		
		--Reset for left shift test
		data_in <= X"0000";
		ctrl <= "00";
		shift_in <= '0';
		rst <= '1';
      wait for clk_period;
		rst <= '0';
		wait for clk_period;
		
		--Self check that second reset worked
		assert data_out = X"0000"
		report "Reset failed"
		severity error;
		
		--Now test shift left mode, start by shifting one in
		ctrl <= "10";
		shift_in <= '1';
		wait for clk_period;
		shift_in <= '0';
		
		--Check that the first bit is shifted in correctly
		assert data_out = "0000000000000001"
		report "Shift left failed."
		severity error;
		
		--shift left and check another 16 times
		for i in 1 to 16 loop
			wait for clk_period;
			--expected output pattern is generated using "sll" operator (logical shift left)
			assert unsigned(data_out) = (unsigned'(X"0001") sll i)
			report 	"Shift left test failed. Expected " & integer'image(to_integer(unsigned'(X"0001") sll i)) 
						& " but got " & integer'image(to_integer(unsigned(data_out)))
						& "."
			severity error;
		end loop;
		
		--Reset for right shift test
		data_in <= X"0000";
		ctrl <= "00";
		shift_in <= '0';
		rst <= '1';
      wait for clk_period;
		rst <= '0';
		wait for clk_period;
		
		--Check reset again
		assert data_out = X"0000"
		report "Reset failed"
		severity error;
		
		--Now test shift right mode, start by shifting one in
		ctrl <= "01";
		shift_in <= '1';
		wait for clk_period;
		shift_in <= '0';
		
		--Check that the first bit is shifted in correctly
		assert data_out = "1000000000000000"
		report "Shift right failed."
		severity error;
		
		--shift left and check another 16 times
		for i in 1 to 16 loop
			wait for clk_period;
			--expected output pattern is generated using "srl" operator (logical shift right)
			assert unsigned(data_out) = (unsigned'(X"8000") srl i)
			report 	"Shift right test failed. Expected " & integer'image(to_integer(unsigned'(X"0001") sll i)) 
						& " but got " & integer'image(to_integer(unsigned(data_out)))
						& "."
			severity error;
		end loop;

      wait;
   end process;

END;
