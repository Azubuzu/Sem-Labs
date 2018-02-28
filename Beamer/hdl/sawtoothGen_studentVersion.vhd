ARCHITECTURE studentVersion OF sawtoothGen IS
	SIGNAL counter_int : unsigned(sawtooth'range);
BEGIN
	count: process(reset, clock)
	begin
		if reset= '1' then
			counter_int <= (others => '0');
		elsif rising_edge(clock) then
			if en = '1' then
				counter_int <= counter_int + step;
			end if;
		end if;
	end process count;
	sawtooth <= counter_int;
END ARCHITECTURE studentVersion;