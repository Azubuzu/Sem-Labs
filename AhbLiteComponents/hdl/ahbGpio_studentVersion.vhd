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
	-- Constants
	constant ioOutAddress natural := 0;
	constant ioEnAddress natural := 1;
	constant regLength natural := 2;
	
--	signal enableReg0 : std_ulogic <= '0';
--	signal enableReg1 : std_ulogic <= '0';
	
	-- Enable signals for register writing
	type en_type is array (0 to regLength-1) of std_ulogic;
	signal ens : en_type;
	
	-- Register table
	type reg_type is array (0 to regLength-1) of std_ulogic_vector(hWData'range);
	signal regs : reg_type;
	
BEGIN
	
	-- Enable definitions
	enables: process(hAddr, hWrite, hSel)
	begin
		-- If write is activated and this peripheral is selected
		if hWrite='1' and hSel='1' then
			-- Got through enablesand activate only the right one
			for i in range regs'low to regs'high loop
				if hAddr = i then
					ens(i) <= '1';
				else
					ens(i) <= '0';
				end if;
			end loop;
	end process enables;
	
	
	-- Register flip flops
	d_reg0: process(hReset_n, hClk)
	begin
		-- Reset
		if hReset_n = '1' then
			-- Set all regs to 0 at start
			for i in regs'low to regs'high loop
				regs(i) <= (others=>'0');
			end loop;
		
		-- Every clock 
		elsif rising_edge(hClk) then
			-- Go through registers to see if it is selected
			for i in regs'low to regs'high loop
				if ens(i)='1' then 
					-- If so, write to this register
					regs(i) <= hWData;
				end if;
			end loop;
		end if;
	end process d_reg0;
	
  -- AHB-Lite
  hReady  <=	'0';	
  hResp	  <=	'0';	

  -- Out
  ioOut <= reg(ioOutAddress);
  ioEn  <= reg(ioEnAddress); 
  
  hRData  <=	ioIn; 
  
  

END ARCHITECTURE studentVersion;

