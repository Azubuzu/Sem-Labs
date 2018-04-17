ARCHITECTURE studentVersion OF periphControlReg IS

	constant runBit : natural := 0; 
	constant updateBit : natural := 1; 
	constant interpolateBit : natural := 2; 
	constant bitsUsed : natural := 3;

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

	-- Set outputs
	run               <= data(runBit);
	updatePattern     <= data(updateBit);
	interpolateLinear <= data(interpolateBit);
	patternSize 	  <= data(data'high downto bitsUsed);
	
  END ARCHITECTURE studentVersion;
