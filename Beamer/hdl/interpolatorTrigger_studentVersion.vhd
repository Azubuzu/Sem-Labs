ARCHITECTURE studentVersion OF interpolatorTrigger IS
	SIGNAL counter : unsigned(counterBitNb - 1 downto 0);
BEGIN
	compute: process(counter)
	begin
		if counter = "0" then
			triggerOut <= '1';
		else
			triggerOut <= '0';-- ☺
		end if;
	end process compute;
	
	count: process(reset, clock)
	begin
		if reset= '1' then
			counter <= (others => '0');
		elsif rising_edge(clock) then
			if en = '1' then
				counter <= counter + 1;
			end if;
		end if;
	end process count;
	
END ARCHITECTURE studentVersion;
