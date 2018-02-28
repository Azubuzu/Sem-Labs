ARCHITECTURE studentVersion OF lowpass IS
	SIGNAL add_out :  unsigned(lowpassIn'high + shiftBitNb downto 0); 
	SIGNAL regD_output : unsigned(lowpassIn'high + shiftBitNb downto 0);
	SIGNAL shift_output : unsigned(lowpassIn'range);
BEGIN
	add: process(lowpassIn,regD_output,shift_output)
	begin
		add_out <= (lowpassIn + regD_output) - shift_output;
	end process add;

	registerD: process(clock,reset)
	begin
		if reset = '1' then
			regD_output <= (others => '0');
		elsif rising_edge(clock) then
			regD_output <= add_out;
		end if;
	end process registerD;
	
	shift: process(regD_output)
	begin
		shift_output <= resize(SHIFT_RIGHT(regD_output,shiftBitNb),shift_output'length);
	end process shift;
	
	lowpassOut <= shift_output;
	
END ARCHITECTURE studentVersion;