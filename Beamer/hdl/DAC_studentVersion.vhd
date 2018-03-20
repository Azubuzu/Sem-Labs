ARCHITECTURE studentVersion OF DAC IS
	signal accu1 : signed(parallelIn'high + 5 downto 0);
	signal accu2 : signed(parallelIn'high + 5 downto 0);
	
	signal parallelInResized : signed(parallelIn'high + 5 downto 0);
	
	constant two_pow_n : signed(parallelIn'high + 5 downto 0) := shift_left(to_signed(1,parallelIn'length+5),parallelIn'high+1);
	--((parallelIn'high + 1)=>'1', others=>'0'); -- 2^n
	constant c1 : signed(parallelIn'high + 5 downto 0) := shift_right(two_pow_n, 1); -- 2^(n-1)
	constant c2 : signed(parallelIn'high + 5 downto 0) := shift_left(two_pow_n, 3); -- 2^(n+3)
	
BEGIN
	bassin: process(reset, clock)
	begin
		if reset = '1' then
			accu1 <= (others => '0');
			accu2 <= (others => '0');
		elsif rising_edge(clock) then
			if accu2(accu2'high) = '0' then		-- accu2 >= 0
				accu1 <= accu1 + parallelInResized - c1;
				accu2 <= accu2 + accu1 - c2;
			else 								-- accu2 < 0			
				accu1 <= accu1 + parallelInResized + c1;
				accu2 <= accu2 + accu1 + c2;
			end if;
		end if; -- reset
	end process bassin;
	
	parallelInResized <= signed(shift_right(resize(parallelIn, parallelInResized'length), 1)) - shift_right(two_pow_n, 2); -- recenter to zero
	
	serialOut <= not(accu2(accu2'high)); -- outside of the process to avoid X state
	
END ARCHITECTURE studentVersion;
