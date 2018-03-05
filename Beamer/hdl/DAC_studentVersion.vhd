ARCHITECTURE studentVersion OF DAC IS
	SIGNAL add_out : unsigned(parallelIn'length downto 0);
	SIGNAL d_out : unsigned(add_out'range);
	SIGNAL compare_out : unsigned(add_out'range);
	constant quarter : unsigned(parallelIn'range) := ((parallelIn'length-3)=>'1', others=>'0');
BEGIN
	bascule_d: process(reset, clock)
	begin
		if reset= '1' then
			d_out <= (others => '0');
		elsif rising_edge(clock) then
			d_out <= add_out;
		end if;
	end process bascule_d;
	
	add_out <= SHIFT_RIGHT(parallelIn,1) + d_out - compare_out + quarter;
		
	compare_out <= (compare_out'high => '1', others => '0') when d_out(d_out'high) = '1' else (others => '0'); 
	
	serialOut <= compare_out(compare_out'HIGH);
	
END ARCHITECTURE studentVersion;
