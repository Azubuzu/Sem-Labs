ARCHITECTURE studentVersion OF DAC IS
	SIGNAL add1_out : signed(parallelIn'length downto 0);
	SIGNAL add2_out : signed(parallelIn'length downto 0);
	SIGNAL d1_out : signed(add1_out'range);
	SIGNAL d2_out : signed(add1_out'range);
	SIGNAL compare_out : unsigned(add1_out'range);
	constant quarter : unsigned(parallelIn'range) := ((parallelIn'length-3)=>'1', others=>'0');
	signal c1 : unsigned(add1_out'range); --:= ((add1_out'high-1)=>'1', others=>'0');
	signal c2 : unsigned(add1_out'length+3 downto 0);
BEGIN
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
	
	add1_out <= SHIFT_RIGHT(parallelIn,1) + d1_out + quarter + c1;
	
	add2_out <= -- ...
		
	c1 <= (-(c1'high=>'1', others=>'0')) when d2_out(d2_out'high) = '0' else (c1'high=>'1', others=>'0'); 
	c2 <= (-(c2'high=>'1', others=>'0')) when d2_out(d2_out'high) = '0' else (c2'high =>'1', others=>'0'); 
		
	serialOut <= compare_out(compare_out'HIGH);	
	
END ARCHITECTURE studentVersion;
