ARCHITECTURE studentVersion OF interpolatorCalculatePolynom IS
	signal size : unsigned(3*oversamplingBitNb+signalBitNb+8 downto 0);
	signal x : signed(size'range);
	signal u : signed(size'range);
	signal v : signed(size'range);
	signal y : signed(size'range);
	signal w : signed(size'range);
BEGIN
	interpol: process(reset, clock)
	begin
		if reset = '1' then
			x <= (others => '0');
			u <= (others => '0');
			v <= (others => '0');
			y <= (others => '0');
		elsif rising_edge(clock) THEN
			IF restartPolynom = '1' THEN
				x <= SHIFT_LEFT(resize(d,x'length),3*oversamplingBitNb +1);
				u <= a + SHIFT_LEFT(resize(b,u'length),oversamplingBitNb) + SHIFT_LEFT(resize(c,u'length),2 * oversamplingBitNb);
				v <= 6 * a + SHIFT_LEFT(resize(b,v'length),oversamplingBitNb+1);
				w <= resize(6 * a,w'length);
				y <= resize(d,y'length);
			else
				x <= x + u;
				u <= u + v;
				v <= v + w;
				y <= SHIFT_RIGHT(x, 3*oversamplingBitNb +1);
			end if;
		end if;
	end process interpol;
	
	sampleOut <= resize(y,sampleOut'length);
END ARCHITECTURE studentVersion;
