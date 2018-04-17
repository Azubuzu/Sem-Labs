ARCHITECTURE studentVersion OF periphSpeedReg IS

	signal data : unsigned(dataBitNb-1 downto 0);
	
BEGIN

	-- D flip flop controlling register values
	register_flip_flop: process(clock, reset)
	begin
	if reset='0' then

		-- Reset register
		data <= (others=>'0');

	elsif rising_edge(clock) then
		
		-- Only if this device is selected
		if en='1' then

			-- Write / read
			if write='1' then
				data <= unsigned(dataIn);
			else
				dataOut <= std_logic_vector(data);
			end if;
			
		end if;
	end if;
	end process register_flip_flop;

	updatePeriod <= data;
	
END ARCHITECTURE studentVersion;

