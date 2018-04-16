--==============================================================================
-- DOS REIS Léo - TRUE Adam
--==============================================================================
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
	
	----------------------------------
	--			 AHB
	----------------------------------
	type reg_write_type is array (0 to reg_write_number-1) of std_ulogic_vector(hwData'range);
	type reg_read_type is array (0 to reg_read_number-1) of std_ulogic_vector(hwData'range);
	
	signal reg_write : reg_write_type;
	signal reg_read : reg_read_type;	

	-- Enable signals for register writing
	type en_write_type is array (0 to reg_write_number-1) of std_ulogic;
	signal ens_write : en_write_type;

	-- Enable signals for register reading
	type en_read_type is array (0 to reg_read_number-1) of std_ulogic;
	signal ens_read : en_read_type;
	
	----------------------------------
	--			 TX
	----------------------------------
	signal tx_bit_array: unsigned(8 downto 0); 		
	signal tx_count : unsigned(hwData'range);	-- for the uart speed
	signal tx_en : std_ulogic := '0';
	signal tx_start_send : std_ulogic := '0';
	signal tx_bit_count : unsigned(3 downto 0);
	
	----------------------------------
	--			 RX
	----------------------------------
	signal rx_bit_array: unsigned(7 downto 0); 
	signal rx_count : unsigned(hwData'range);
	signal rx_en : std_ulogic := '0';
	signal rx_bit_count : unsigned(3 downto 0);


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
			tx_bit_array <= (others=>'0');
			TxD <= '1';
			tx_count <= (others => '0');
			tx_en <= '0';
			tx_start_send <= '0';
			tx_bit_count <= (others => '0');
			
			-- ----------------------------
			--		  RX processing
			-- ----------------------------
			-- Set all regs to 0 at start	
			rx_bit_array <= (others=>'0');
			rx_count <= (others => '0');
			rx_en <= '0';
			rx_bit_count <= (others => '0');
		
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
					
					-- If uart rx value has been read, reset flag
					if i = readValAddr then
						reg_read(readStatusAddr)(statNewRx) <= '0';
					end if;
					
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
						tx_start_send <= '1';
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
					-- Count that only 8 bits are sent
					tx_bit_count <= tx_bit_count+1;
					
					-- Start bit + 8 bits
					if tx_bit_count = 9 then
						tx_bit_count <= (others=>'0');
						reg_read(readStatusAddr)(statTx) <= '0';
						TxD <= '1';
					else
						-- Send bit to line
						TxD <= tx_bit_array(0);
						tx_bit_array <= shift_right(tx_bit_array, 1);
					end if;
				end if;		
			end if;
			
			-- Allows start of transmission
			if tx_start_send = '1' then
				tx_start_send <= '0';
				-- Store write value bits
				tx_bit_array(8 downto 1) <= unsigned(reg_write(writeValAddr)(7 downto 0));
				tx_bit_array(0) <= '0';	-- start bit
			end if;
			
			-- Tx speed counter
			if reg_read(readStatusAddr)(statTx) = '1' then
				-- Every time counter overflows, reset count value
				if tx_count = unsigned(reg_write(writeSpeedAddr))-1 then
					tx_count <= (others => '0');
					tx_en <= '1';
				else
					tx_count <= tx_count + 1;
				end if;
			-- reset counter when not sending
			else 
				tx_count <= (others => '0');
			end if;
			
			-- ----------------------------
			--		  Rx processing
			-- ----------------------------
			-- If receiveing is taking place
			if reg_read(readStatusAddr)(statRxIncoming) = '1' then		
				if rx_en = '1' then
					-- Just an impulse
					rx_en <= '0';
					-- Count that only 8 bits are sent
					rx_bit_count <= rx_bit_count+1;
										
					-- Start bit + 8 bits
					if rx_bit_count = 8 then
						rx_bit_count <= (others=>'0');
						reg_read(readStatusAddr)(statRxIncoming) <= '0';
						reg_read(readStatusAddr)(statNewRx) <= '1';	-- value is ready to be read
						reg_read(readValAddr)(7 downto 0) <= std_ulogic_vector(rx_bit_array);
						reg_read(readValAddr)(reg_read(readValAddr)'high downto 8) <= (others => '0');
						TxD <= '1';						
					else 
						-- Send line to registers
						rx_bit_array(7) <= RxD;
						rx_bit_array(6 downto 0) <= resize(shift_right(rx_bit_array, 1), rx_bit_array'length-1);
					end if;
				end if;		
			end if;

			-- Detect start bit and allow recpetion
			if reg_read(readStatusAddr)(statRxIncoming) = '0' and RxD = '0' then
				reg_read(readStatusAddr)(statRxIncoming) <= '1';
			end if;
			
			-- Rx speed counter
			if reg_read(readStatusAddr)(statRxIncoming) = '1' then
				-- Every time counter overflows, reset count value
				if rx_count = unsigned(reg_write(writeSpeedAddr))-1 then
					rx_count <= (others => '0');
					rx_en <= '1';
				else
					rx_count <= rx_count + 1;
				end if;
			else	
				rx_count <= (others=>'0');
			
			end if;
		end if;
	end process d_ff;
	
END ARCHITECTURE studentVersion;

