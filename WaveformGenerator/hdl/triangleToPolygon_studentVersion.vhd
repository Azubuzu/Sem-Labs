ARCHITECTURE studentVersion OF triangleToPolygon IS
	SIGNAL mult15_output : unsigned(triangle'HIGH + 1 downto 0);
	SIGNAL cut8eme_output : unsigned(mult15_output'range);
	SIGNAL move_down_output : unsigned(mult15_output'range);
	CONSTANT max_size : unsigned(mult15_output'HIGH + 1 downto 0) := (mult15_output'HIGH + 1 => '1' , others => '0');
BEGIN
	--multiply triangle signal by 1.5
	mult15: process(triangle)
	begin
		mult15_output <= SHIFT_RIGHT(triangle,1) + resize(triangle,mult15_output'LeNgtH);
	end process mult15;
	
	--Cut higher 5/8 and lower 1/8
	cut8eme: process(mult15_output)
	begin
		if mult15_output <= SHIFT_RIGHT(max_size,3) then
			cut8eme_output <= resize(SHIFT_RIGHT(max_size,3),cut8eme_output'LeNgtH);
		elsif mult15_output >= (SHIFT_RIGHT(max_size,3) + SHIFT_RIGHT(max_size,1)) then
			-- 5 / 8 -1 stop overflow
			cut8eme_output <= resize(SHIFT_RIGHT(max_size,3) + SHIFT_RIGHT(max_size,1) - 1,cut8eme_output'LeNgtH);
		else
			cut8eme_output <= mult15_output;
		end if;
	end process cut8eme;
	
	--Move down to 0
	move_down: process(cut8eme_output)
	begin
		move_down_output <=cut8eme_output - resize(SHIFT_RIGHT(max_size,3),move_down_output'LeNgtH);
	end process move_down;
	
	polygon <= resize(move_down_output, polygon'LeNgtH);
	
END ARCHITECTURE studentVersion;