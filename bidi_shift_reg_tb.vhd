LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
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
	
		data_in <= X"0000";
		ctrl <= "00";
		shift_in <= '0';
		rst <= '1';
      wait for clk_period;
		rst <= '0';
		wait for clk_period;

      --start with load mode
		ctrl <= "11";
		data_in <= X"b13f";
		wait for clk_period;
		
		assert data_out = X"b13f"
		report "Load failed"
		severity error;
		
		--Now test hold mode
		ctrl <= "00";
		data_in <= X"af34";
		wait for clk_period;
		
		assert data_out = X"b13f"
		report "Load failed"
		severity error;
		
		--Now test shift left mode
		ctrl <= "11";
		data_in <= "0100101001010100";
		wait for clk_period;
		ctrl <= "10";
		data_in <= "0101101010010110";
		shift_in <= '1';
		wait for clk_period;
		
		assert data_out = "1001010010101001"
		report "Left shift failed"
		severity error;
		
		--Now test shift right mode
		ctrl <= "11";
		data_in <= "0100101001010100";
		wait for clk_period;
		ctrl <= "01";
		data_in <= "0101101010010110";
		shift_in <= '0';
		wait for clk_period;
		
		assert data_out = "0010010100101010"
		report "Right shift failed"
		severity error;

      wait;
   end process;

END;
