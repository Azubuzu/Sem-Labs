ARCHITECTURE studentVersion OF DAC IS
	SIGNAL parallelInSigned : unsigned(parallelIn'length downto 0);
	SIGNAL add1_out : signed(parallelIn'length downto 0);
	SIGNAL add2_out : signed(add1_out'length+3 downto 0);
	SIGNAL d1_out : signed(add1_out'range);
	SIGNAL d2_out : signed(add2_out'range);
	constant quarter : signed(parallelIn'range) := ((parallelIn'length-3)=>'1', others=>'0');
	constant quarter2 : signed(d2_out'range) := ((d2_out'length-3)=>'1', others=>'0');
	constant c1 : signed(parallelIn'length downto 0) := (parallelIn'length-1=>'1', others=>'0'); --:= ((add1_out'high-1)=>'1', others=>'0');
	constant c2 : signed(parallelIn'length+4 downto 0) := (parallelIn'length+3=>'1', others=>'0');
BEGIN

	unsigned_to_signed: process(parallelIn)
	begin
		parallelInSigned <= resize(SHIFt_right(parallelIn,1),parallelInSigned'length);
	end process unsigned_to_signed;
	
	bascule_d1: process(reset, clock)
	begin
		if reset= '1' then
			d1_out <= (others => '0');
		elsif rising_edge(clock) then
			d1_out <= add1_out;
		end if;
	end process bascule_d1;
	
	bascule_d2: process(reset, clock)
	begin
		if reset= '1' then
			d2_out <= (others => '0');
		elsif rising_edge(clock) then
			d2_out <= add2_out;
		end if;
	end process bascule_d2;
	
	part1: process(parallelInSigned,d1_out)
	begin
		if d2_out(d2_out'high) = '0' then
			add1_out <= signed(parallelInSigned) + d1_out + quarter - c1;
		else
			add1_out <= signed(parallelInSigned) + d1_out + quarter + c1;
		end if;
	end process part1;
	
	part2: process(d1_out,d2_out)
	begin
		if d2_out(d2_out'high) = '0' then
			add2_out <= d1_out + d2_out - c2;--SHIFT_RIGHT(d1_out,1) + d2_out - c2 + quarter2;
		else
			add2_out <= d1_out + d2_out + c2;--SHIFT_RIGHT(d1_out,1) + d2_out + c2 + quarter2;
		end if;
	end process part2;
	
	msb: process(d2_out)
	begin
		if d2_out(d2_out'high) = '0' then
			serialOut <= '1';
		else
			serialOut <= '0';
		end if;
	end process msb;
	--compare_out(compare_out'HIGH);	
	
END ARCHITECTURE studentVersion;
