--==============================================================================
--
-- AHB general purpose input/outputs
--
-- Provides "ioNb" input/output signals .
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- 00, data register receives the values to drive the output lines.
-- 01, output enable register defines the signal direction:
--     when '1', the direction is "out".
--
--------------------------------------------------------------------------------
--
-- Read registers
-- 00, data register provides the values detected on the lines.
--
ARCHITECTURE studentVersion OF ahbGpio IS

	-- Defines register address positions 
	constant ioOutAddress : natural := 0;
	constant ioEnAddress : natural := 1;
	
	-- Number of registers
	constant regLength : natural := 2;
	
	-- How many bits of the address we actually decode
	constant addressBitsUsed : natural := 1;
	
	-- Enable signals for register writing
	type en_type is array (0 to regLength-1) of std_ulogic;
	signal ens : en_type;
	
	-- Register table
	type reg_type is array (0 to regLength-1) of std_ulogic_vector(ioEn'range);
	signal regs : reg_type;
	
BEGIN
	
	-- Enable definitions with pipeline
	enables: process(hReset_n, hClk)
	begin
		if hReset_n = '0' then
			ens <= (others => '0');
		elsif rising_edge(hClk) then
			ens <= (others => '0');
			if hTrans = transNonSeq and hSel='1' then
				-- If write is activated
				if hWrite='1' then
					--ens(to_integer(hAddr))<='1;
					ens(to_integer(hAddr(addressBitsUsed-1 downto 0))) <= '1';
				end if;
			end if;
		end if;
	end process enables;
	
	
	-- Register flip flops
	d_reg0: process(hReset_n, hClk)
	begin
		-- Reset
		if hReset_n = '0' then
			-- Set all regs to 0 at start	
			regs <= (others=>(others=>'0'));
			
		-- Every clock 
		elsif rising_edge(hClk) then
			-- Go through registers to see if it is selected
			for i in 0 to regLength-1 loop
				if ens(i) = '1' then 
					-- If so, write to this register
					regs(i) <= hWData(ioOut'range);
				end if;
			end loop;
		end if;
	end process d_reg0;
	
  -- AHB-Lite
  hReady  <=	'1';	
  hResp	  <=	'0';	

  -- Out
  ioOut <= regs(ioOutAddress);
  ioEn  <= regs(ioEnAddress);
  
  --hRData  <= resize(unsigned(ioIn),hRData'length); 
  hRData(ioIn'range) <= ioIn;
  hRData(hRData'high downto ioIn'length) <= (others=>'0');

END ARCHITECTURE studentVersion;

