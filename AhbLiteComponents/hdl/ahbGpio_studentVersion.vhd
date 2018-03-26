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
	constant ioOutAddress : natural := 0;
	constant ioEnAddress : natural := 1;
	constant regLength : natural := 2;
	
--	signal enableReg0 : std_ulogic <= '0';
--	signal enableReg1 : std_ulogic <= '0';
	
	-- Enable signals for register writing
	type en_type is array (0 to regLength-1) of std_ulogic;
	signal ens : en_type;
	
	-- Register table
	type reg_type is array (0 to regLength-1) of std_ulogic_vector(ioEn'range);
	signal regs : reg_type;
	
BEGIN
	
	-- Enable definitions
	enables: process(hAddr, hWrite, hSel)
	begin
		if hTrans(hTrans'left) = '1' and hSel='1' then
			-- If write is activated
			if hWrite='1' then
				-- Got through enables and activate only the right one
				for i in 0 to regLength-1 loop
					if hAddr = i then
						ens(i) <= '1';
					else
						ens(i) <= '0';
					end if;
				end loop;
			end if;
		end if;
	end process enables;
	
	
	-- Register flip flops
	d_reg0: process(hReset_n, hClk)
	begin
		-- Reset
		if hReset_n = '1' then
			-- Set all regs to 0 at start	
		
			for i in 0 to regLength-1 loop
				regs(i) <= (others=>'0');
			end loop;
			
		-- Every clock 
		elsif rising_edge(hClk) then

			-- Go through registers to see if it is selected
			for i in 0 to regLength-1 loop
				if ens(i)='1' then 
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

