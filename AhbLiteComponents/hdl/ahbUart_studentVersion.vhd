--==============================================================================
--
-- AHB UART
--
-- Implements a serial port.
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- 00, data register receives the word to be sent to the serial port.
-- 01, control register is used to control the peripheral.
-- 02, scaler register is used to set the baud rate.
--
--------------------------------------------------------------------------------
--
-- Read registers
-- 00, data register provides the last word received by the serial port.
-- 01, status register is used to get the peripheral's state.
--     bit 0: data ready for read
--     bit 1: sending in progress
--     bit 2: receiving in progress
--
ARCHITECTURE studentVersion OF ahbUart IS
	-- Number of addresses
	constant reg_write_number : natural := 3;	
	constant reg_read_number : natural := 2;
	
	-- How many bits of the address we actually decode
	constant addressBitsUsedWrite: natural := 2;
	constant addressBitsUsedRead: natural := 1;
	
	-- Address allocations
	constant writeValAddr: natural := 0;
	constant writeCtrlAddr: natural := 1;
	constant writeSpeedAddr: natural := 2;
	
	constant readValAddr : natural := 0;
	constant readStatusAddr : natural := 1;
	constant statNewRx : natural := 0;
	constant statTx : natural := 1;
	constant statRxIncoming : natural := 2;
	
	-- Define array of write/read registers
	type reg_write_type is array (0 to reg_write_number-1) of std_ulogic_vector(hwData'range);
	type reg_read_type is array (0 to reg_read_number-1) of std_ulogic_vector(hwData'range);
	
	signal reg_write : reg_write_type;
	signal reg_read : reg_read_type;	
	
	-- Bit arrays for shift register
--	type bit_array_type is array (0 to 8) of std_ulogic;
	
	signal bit_array_tx: unsigned(8 downto 0); --bit_array_type;
	signal bit_array_rx: unsigned(8 downto 0); --bit_array_type;
	
	-- Enable signals for register writing
	type en_write_type is array (0 to reg_write_number-1) of std_ulogic;
	signal ens_write : en_write_type;

	-- Enable signals for register reading
	type en_read_type is array (0 to reg_read_number-1) of std_ulogic;
	signal ens_read : en_read_type;
		
	signal tx_count : unsigned(hwData'range);
	signal tx_en : std_ulogic := '0';
	signal tx_bit_count : unsigned(3 downto 0);
	
--	signal tx_send : std_ulogic <= '0';

BEGIN

	-- AHB-Lite
	hReady  <=	'1';	
	hResp	<=	'0';

	d_ff: process(hReset_n, hClk)
	begin
		if hReset_n = '0' then
			-- ----------------------------
			--				AHB
			-- ----------------------------
			ens_read <= (others => '0');
			ens_write <= (others => '0');
			
			-- Set all regs to 0 at start	
			reg_read <= (others=>(others=>'0'));
			reg_write <= (others=>(others=>'0'));
			
			-- ----------------------------
			--		  TX Shift register
			-- ----------------------------
			-- Set all regs to 0 at start	
			bit_array_tx <= (others=>'0');
			TxD <= '1';
			tx_count <= (others => '0');
			tx_en <= '0';
		
		elsif rising_edge(hClk) then
			-- ----------------------------
			--				AHB
			-- ----------------------------
			
			----------- Read ----------
			ens_read <= (others => '0');

			if hTrans = transNonSeq and hSel='1' then
				-- If read is activated
				if hWrite='0' then
					ens_read(to_integer(hAddr(addressBitsUsedRead-1 downto 0))) <= '1';
				end if;
			end if;
			
			-- Go through registers to see if it is selected
			for i in 0 to reg_read_number-1 loop
				if ens_read(i) = '1' then 
					-- If so, write to this register
					hRData <= reg_read(i);
				end if;
			end loop;
			
			---------- Write ----------
			ens_write <= (others => '0');
			if hTrans = transNonSeq and hSel='1' then
				-- If write is activated
				if hWrite='1' then
					ens_write(to_integer(hAddr(addressBitsUsedWrite-1 downto 0))) <= '1';
				end if;
			end if;
			
			-- Go through registers to see if it is selected
			for i in 0 to reg_write_number-1 loop
				if ens_write(i) = '1' then 
					-- If so, write to this register
					reg_write(i) <= hWData;
					
					-- If the microcontroller wishes to write an output
					if i = writeValAddr then
						reg_read(readStatusAddr)(statTx) <= '1';
					end if;
				end if;
			end loop;
			
			-- ----------------------------
			--		  TX Shift register
			-- ----------------------------
			-- If sending is taking place
			if reg_read(readStatusAddr)(statTx) = '1' then		
				if tx_en = '1' then
					-- Just an impulse
					tx_en <= '0';
					-- Send bit to line
					TxD <= bit_array_tx(0);
					bit_array_tx <= shift_right(bit_array_tx, 1);
				end if;		
			else------------------------------------------------------------------------- the error is here
				-- Store write value bits
				bit_array_tx(8 downto 1) <= unsigned(reg_write(writeValAddr)(7 downto 0));
				bit_array_tx(0) <= '0';	-- start bit
			end if;
			
			-- Tx speed counter
			if reg_read(readStatusAddr)(statTx) = '1' then
				-- Every time counter overflows speed is defined
				if tx_count = unsigned(reg_write(writeSpeedAddr)) then
					tx_count <= (others => '0');
					tx_en <= '1';
				else
					tx_count <= tx_count + 1;
				end if;
			end if;
			
		end if;
	end process d_ff;
	
END ARCHITECTURE studentVersion;

