ARCHITECTURE studentVersion OF sineTable IS

  signal phaseTableAddress : unsigned(tableAddressBitNb-1 downto 0);
  signal to_hor_output : signed(sine'range);
  signal quarterSine : signed(sine'range);

BEGIN

  quarterTable: process(phaseTableAddress,phase)
  begin
    case to_integer(phaseTableAddress) is
      when 0 => 
		if phase(phase'HIGH - 1) = '0' then
			quarterSine <= to_signed(16#0000#, quarterSine'length);
		else
			quarterSine <= to_signed(16#7FFF#, quarterSine'length);
		end if;
      when 1 => quarterSine <= to_signed(16#18F9#, quarterSine'length);
      when 2 => quarterSine <= to_signed(16#30FB#, quarterSine'length);
      when 3 => quarterSine <= to_signed(16#471C#, quarterSine'length);
      when 4 => quarterSine <= to_signed(16#5A82#, quarterSine'length);
      when 5 => quarterSine <= to_signed(16#6A6D#, quarterSine'length);
      when 6 => quarterSine <= to_signed(16#7641#, quarterSine'length);
      when 7 => quarterSine <= to_signed(16#7D89#, quarterSine'length);
      when others => quarterSine <= (others => '-');
    end case;
  end process quarterTable;

	to_hor: process(phase)
	begin
		if phase(phase'HIGH - 1) = '0' then
			phaseTableAddress <= phase(phase'high-2 downto phase'high-2-tableAddressBitNb+1);
		else
			phaseTableAddress <= resize(8 - phase(phase'high-2 downto phase'high-2-tableAddressBitNb+1),phaseTableAddress'length);
		end if;
	end process to_hor;
	
	to_ver: process(phase,quarterSine)
	begin
		if phase(phase'HIGH) = '1' then
			sine <= -(quarterSine);
		else
			sine <= quarterSine;
		end if;
	end process to_ver;
  
END ARCHITECTURE studentVersion;
