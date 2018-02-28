ARCHITECTURE studentVersion OF interpolatorShiftRegister IS
	type reg_type is array(1 to 4) of signed(sampleIn'range);
	signal reg : reg_type;
BEGIN

	init: process(reset, clock)
	begin
		if reset = '1' then
			for i in reg'low to reg'high loop
				reg(i) <= to_signed(0, sampleIn'length);
			end loop;
			--reg <= (others => (others => '0'));
		elsif rising_edge(clock) THEN
			IF shiftSamples = '1' THEN
				for i in reg'low to (reg'high-1) loop
					reg(i) <= reg(i+1);
				end loop;	
				reg(reg'high) <= sampleIn;
			end if;
		end if;
	end process init;
	
	sample1 <= reg(1);
	sample2 <= reg(2);
	sample3 <= reg(3);
	sample4 <= reg(4);  
END ARCHITECTURE studentVersion;
