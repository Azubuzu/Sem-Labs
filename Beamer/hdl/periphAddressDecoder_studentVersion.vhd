--
-- VHDL Architecture Beamer.periphAddressDecoder.arch_name
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 15:26:53 16.04.2018
--
-- using Mentor Graphics HDL Designer(TM) 2015.2 (Build 5)
--
ARCHITECTURE studentVersion OF periphAddressDecoder IS
	constant regCommand: natural := 0;
	constant regSpeed: natural := 1;
	constant regX: natural := 2;
	constant regY: natural := 3;

BEGIN

	-- Register selection in i over m
	selection : process(addr)
	begin
		
		-- All signals initially set to 0
		selControl  <= '0';
		--selSize     <= '0';
		selSpeed    <= '0';
		selX        <= '0';
		selY        <= '0';
		selZ        <= '0';
		
		-- Set the necessary signal to 1
		if addr = regCommand then
			selControl  <= '1';	
		elsif addr = regSpeed then
			selSpeed <= '1';	
		elsif addr = regX then
			selX <= '1';	
		elsif addr = regY then
			selY <= '1';	
		end if;
	end process selection;
  
END ARCHITECTURE studentVersion;

