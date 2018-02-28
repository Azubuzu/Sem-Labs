ARCHITECTURE studentVersion OF sawtoothToTriangle IS
	constant max : unsigned(sawtooth'range) := (others => '1');
	signal output : unsigned(sawtooth'range);
BEGIN
	compute: process(sawtooth)
	begin
		if sawtooth(sawtooth'HIGH) = '1' then
			output <= max - sawtooth;
		else
			output <= sawtooth;
		end if;
	end process compute;
	triangle <= SHIFT_LEFT(output,1);
END ARCHITECTURE studentVersion;
