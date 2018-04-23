ARCHITECTURE studentVersion OF parallelAdder IS
	signal add : signed(bitNb DOWNTO 0);	
BEGIN

	add <= resize(a,add'length)+resize(b,add'length)+resize('0'&cIn,add'length);
	sum(sum'high downto 0) <= add(add'high-1 downto 0);
	cOut <= add(add'high);

END ARCHITECTURE studentVersion;
