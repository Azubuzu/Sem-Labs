-- VHDL Entity Board.FPGA_sineGen.symbol
--
-- Created:
--          by - oliver.gubler.UNKNOWN (WE5370)
--          at - 14:29:35 16.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY FPGA_sineGen IS
   GENERIC( 
      bitNb : positive := 16
   );
   PORT( 
      clock      : IN     std_ulogic;
      reset_N    : IN     std_ulogic;
      triggerOut : OUT    std_ulogic;
      xOut       : OUT    std_ulogic;
      yOut       : OUT    std_ulogic
   );

-- Declarations

END FPGA_sineGen ;





-- VHDL Entity Board.inverterIn.symbol
--
-- Created:
--          by - oliver.gubler.UNKNOWN (WE5370)
--          at - 14:29:35 16.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY inverterIn IS
   PORT( 
      in1  : IN     std_uLogic;
      out1 : OUT    std_uLogic
   );

-- Declarations

END inverterIn ;





ARCHITECTURE sim OF inverterIn IS
BEGIN

  out1 <= NOT in1;

END ARCHITECTURE sim;





-- VHDL Entity SineInterpolator.sineGen.symbol
--
-- Created:
--          by - oliver.gubler.UNKNOWN (WE5370)
--          at - 17:03:11 16.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY sineGen IS
   GENERIC( 
      signalBitNb : positive := 16;
      phaseBitNb  : positive := 10
   );
   PORT( 
      clock    : IN     std_ulogic;
      reset    : IN     std_ulogic;
      step     : IN     unsigned (phaseBitNb-1 DOWNTO 0);
      sawtooth : OUT    unsigned (signalBitNb-1 DOWNTO 0);
      sine     : OUT    unsigned (signalBitNb-1 DOWNTO 0);
      square   : OUT    unsigned (signalBitNb-1 DOWNTO 0);
      triangle : OUT    unsigned (signalBitNb-1 DOWNTO 0)
   );

-- Declarations

END sineGen ;





-- VHDL Entity Beamer.interpolatorCoefficients.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 16:49:14 25.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY interpolatorCoefficients IS
   GENERIC( 
      bitNb      : positive := 16;
      coeffBitNb : positive := 16
   );
   PORT( 
      sample1           : IN     signed (bitNb-1 DOWNTO 0);
      sample2           : IN     signed (bitNb-1 DOWNTO 0);
      sample3           : IN     signed (bitNb-1 DOWNTO 0);
      sample4           : IN     signed (bitNb-1 DOWNTO 0);
      a                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      b                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      c                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      d                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      interpolateLinear : IN     std_ulogic
   );

-- Declarations

END interpolatorCoefficients ;





ARCHITECTURE studentVersion OF interpolatorCoefficients IS
BEGIN
  a <= resize(-sample1,a'length) + resize(3*sample2,a'length) - resize(3*sample3,a'length) + resize(sample4,a'length);
  b <= resize(2*sample1,b'length) - resize(5*sample2,b'length) + resize(4*sample3,b'length) - resize(sample4,b'length);
  c <= resize(- sample1,c'length) + resize(sample3,c'length);
  d <= resize(sample2,d'length);
END ARCHITECTURE studentVersion;




-- VHDL Entity Beamer.sawtoothGen.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 12:47:14 22.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY sawtoothGen IS
   GENERIC( 
      bitNb : positive := 16
   );
   PORT( 
      sawtooth : OUT    unsigned (bitNb-1 DOWNTO 0);
      clock    : IN     std_ulogic;
      reset    : IN     std_ulogic;
      step     : IN     unsigned (bitNb-1 DOWNTO 0);
      en       : IN     std_ulogic
   );

-- Declarations

END sawtoothGen ;





ARCHITECTURE studentVersion OF sawtoothGen IS
	SIGNAL counter_int : unsigned(sawtooth'range);
BEGIN
	count: process(reset, clock)
	begin
		if reset= '1' then
			counter_int <= (others => '0');
		elsif rising_edge(clock) then
			if en = '1' then
				counter_int <= counter_int + step;
			end if;
		end if;
	end process count;
	sawtooth <= counter_int;
END ARCHITECTURE studentVersion;



-- VHDL Entity Beamer.interpolatorShiftRegister.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 16:46:12 25.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY interpolatorShiftRegister IS
   GENERIC( 
      signalBitNb : positive := 16
   );
   PORT( 
      clock        : IN     std_ulogic;
      reset        : IN     std_ulogic;
      shiftSamples : IN     std_ulogic;
      sampleIn     : IN     signed (signalBitNb-1 DOWNTO 0);
      sample1      : OUT    signed (signalBitNb-1 DOWNTO 0);
      sample2      : OUT    signed (signalBitNb-1 DOWNTO 0);
      sample3      : OUT    signed (signalBitNb-1 DOWNTO 0);
      sample4      : OUT    signed (signalBitNb-1 DOWNTO 0)
   );

-- Declarations

END interpolatorShiftRegister ;





ARCHITECTURE studentVersion OF interpolatorShiftRegister IS
	type reg_type is array(1 to 4) of signed(sampleIn'range);
	signal reg : reg_type;
BEGIN

	init: process(reset, clock)
	begin
		if reset = '1' then
			for i in reg'low to reg'high loop
				reg(i) <= to_signed(0, sampleIn'length);
			end loop;
			--reg <= (others => (others => '0'));
		elsif rising_edge(clock) THEN
			IF shiftSamples = '1' THEN
				for i in reg'low to (reg'high-1) loop
					reg(i) <= reg(i+1);
				end loop;	
				reg(reg'high) <= sampleIn;
			end if;
		end if;
	end process init;
	
	sample1 <= reg(1);
	sample2 <= reg(2);
	sample3 <= reg(3);
	sample4 <= reg(4);  
END ARCHITECTURE studentVersion;




-- VHDL Entity SineInterpolator.sineTable.symbol
--
-- Created:
--          by - oliver.gubler.UNKNOWN (WE5370)
--          at - 17:03:11 16.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY sineTable IS
   GENERIC( 
      inputBitNb        : positive := 16;
      outputBitNb       : positive := 16;
      tableAddressBitNb : positive := 3
   );
   PORT( 
      sine  : OUT    signed (outputBitNb-1 DOWNTO 0);
      phase : IN     unsigned (inputBitNb-1 DOWNTO 0)
   );

-- Declarations

END sineTable ;





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




-- VHDL Entity SineInterpolator.resizer.symbol
--
-- Created:
--          by - oliver.gubler.UNKNOWN (WE5370)
--          at - 17:03:11 16.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY resizer IS
   GENERIC( 
      inputBitNb  : positive := 16;
      outputBitNb : positive := 16
   );
   PORT( 
      resizeOut : OUT    unsigned (outputBitNb-1 DOWNTO 0);
      resizeIn  : IN     unsigned (inputBitNb-1 DOWNTO 0)
   );

-- Declarations

END resizer ;





ARCHITECTURE studentVersion OF resizer IS
BEGIN
	smaller: if inputBitNb < outputBitNb generate
		resizeOut <= SHIFT_LEFT(resize(resizeIn,resizeOut'length),resizeOut'length-resizeIn'length);
	end generate smaller;
	
	equal: if inputBitNb = outputBitNb generate
		resizeOut <= resizeIn;
	end generate equal;
	
	bigger: if inputBitNb > outputBitNb generate
		resizeOut <= resize(SHIFT_RIGHT(resizeIn,resizeIn'length-resizeOut'length),resizeOut'length);
	end generate bigger;
	
END ARCHITECTURE studentVersion;




-- VHDL Entity Beamer.interpolatorCalculatePolynom.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 16:52:06 25.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY interpolatorCalculatePolynom IS
   GENERIC( 
      signalBitNb       : positive := 16;
      coeffBitNb        : positive := 16;
      oversamplingBitNb : positive := 8
   );
   PORT( 
      clock          : IN     std_ulogic;
      reset          : IN     std_ulogic;
      restartPolynom : IN     std_ulogic;
      d              : IN     signed (coeffBitNb-1 DOWNTO 0);
      sampleOut      : OUT    signed (signalBitNb-1 DOWNTO 0);
      c              : IN     signed (coeffBitNb-1 DOWNTO 0);
      b              : IN     signed (coeffBitNb-1 DOWNTO 0);
      a              : IN     signed (coeffBitNb-1 DOWNTO 0);
      en             : IN     std_ulogic
   );

-- Declarations

END interpolatorCalculatePolynom ;





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




-- VHDL Entity WaveformGenerator.sawtoothToSquare.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 12:52:30 22.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY sawtoothToSquare IS
   GENERIC( 
      bitNb : positive := 16
   );
   PORT( 
      square   : OUT    unsigned (bitNb-1 DOWNTO 0);
      sawtooth : IN     unsigned (bitNb-1 DOWNTO 0)
   );

-- Declarations

END sawtoothToSquare ;





ARCHITECTURE studentVersion OF sawtoothToSquare IS
BEGIN
	square <= (others => sawtooth(sawtooth'HIGH));
END ARCHITECTURE studentVersion;




-- VHDL Entity WaveformGenerator.sawtoothToTriangle.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 12:57:04 22.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY sawtoothToTriangle IS
   GENERIC( 
      bitNb : positive := 16
   );
   PORT( 
      triangle : OUT    unsigned (bitNb-1 DOWNTO 0);
      sawtooth : IN     unsigned (bitNb-1 DOWNTO 0)
   );

-- Declarations

END sawtoothToTriangle ;





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




-- VHDL Entity Beamer.interpolatorTrigger.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 16:56:34 25.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY interpolatorTrigger IS
   GENERIC( 
      counterBitNb : positive := 4
   );
   PORT( 
      triggerOut : OUT    std_ulogic;
      clock      : IN     std_ulogic;
      reset      : IN     std_ulogic;
      en         : IN     std_ulogic
   );

-- Declarations

END interpolatorTrigger ;





ARCHITECTURE studentVersion OF interpolatorTrigger IS
	SIGNAL counter : unsigned(counterBitNb - 1 downto 0);
BEGIN
	compute: process(counter)
	begin
		if counter = "0" then
			triggerOut <= '1';
		else
			triggerOut <= '0';-- ☺
		end if;
	end process compute;
	
	count: process(reset, clock)
	begin
		if reset= '1' then
			counter <= (others => '0');
		elsif rising_edge(clock) then
			if en = '1' then
				counter <= counter + 1;
			end if;
		end if;
	end process count;
	
END ARCHITECTURE studentVersion;




-- VHDL Entity Beamer.offsetToUnsigned.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 16:54:26 25.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY offsetToUnsigned IS
   GENERIC( 
      bitNb : positive := 16
   );
   PORT( 
      unsignedOut : OUT    unsigned (bitNb-1 DOWNTO 0);
      signedIn    : IN     signed (bitNb-1 DOWNTO 0)
   );

-- Declarations

END offsetToUnsigned ;





ARCHITECTURE studentVersion OF offsetToUnsigned IS
	constant offset : signed(bitNb-1 downto 0) := shift_left(to_signed(1,bitNb),bitNb-1);
	--((bitNb-1)=>'1', others=>'0');
BEGIN
	unsignedOut <= unsigned(signedIn+offset);
END ARCHITECTURE studentVersion;



--
-- VHDL Architecture SineInterpolator.sineGen.struct
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 11:11:28 27.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

LIBRARY Beamer;
LIBRARY SineInterpolator;
LIBRARY WaveformGenerator;

ARCHITECTURE struct OF sineGen IS

   -- Architecture declarations
   constant tableAddressBitNb : positive := 3;
   constant sampleCountBitNb : positive := phaseBitNb-2-tableAddressBitNb;
   constant coeffBitNb : positive := signalBitNb+4;

   -- Internal signal declarations
   SIGNAL a           : signed(coeffBitNb-1 DOWNTO 0);
   SIGNAL b           : signed(coeffBitNb-1 DOWNTO 0);
   SIGNAL c           : signed(coeffBitNb-1 DOWNTO 0);
   SIGNAL d           : signed(coeffBitNb-1 DOWNTO 0);
   SIGNAL logic0      : std_ulogic;
   SIGNAL logic1      : std_ulogic;
   SIGNAL newPolynom  : std_ulogic;
   SIGNAL phase       : unsigned(phaseBitNb-1 DOWNTO 0);
   SIGNAL sample1     : signed(signalBitNb-1 DOWNTO 0);
   SIGNAL sample2     : signed(signalBitNb-1 DOWNTO 0);
   SIGNAL sample3     : signed(signalBitNb-1 DOWNTO 0);
   SIGNAL sample4     : signed(signalBitNb-1 DOWNTO 0);
   SIGNAL sineSamples : signed(signalBitNb-1 DOWNTO 0);
   SIGNAL sineSigned  : signed(signalBitNb-1 DOWNTO 0);

   -- Implicit buffer signal declarations
   SIGNAL sawtooth_internal : unsigned (signalBitNb-1 DOWNTO 0);


   -- Component Declarations
   COMPONENT interpolatorCalculatePolynom
   GENERIC (
      signalBitNb       : positive := 16;
      coeffBitNb        : positive := 16;
      oversamplingBitNb : positive := 8
   );
   PORT (
      clock          : IN     std_ulogic ;
      reset          : IN     std_ulogic ;
      restartPolynom : IN     std_ulogic ;
      d              : IN     signed (coeffBitNb-1 DOWNTO 0);
      sampleOut      : OUT    signed (signalBitNb-1 DOWNTO 0);
      c              : IN     signed (coeffBitNb-1 DOWNTO 0);
      b              : IN     signed (coeffBitNb-1 DOWNTO 0);
      a              : IN     signed (coeffBitNb-1 DOWNTO 0);
      en             : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT interpolatorCoefficients
   GENERIC (
      bitNb      : positive := 16;
      coeffBitNb : positive := 16
   );
   PORT (
      sample1           : IN     signed (bitNb-1 DOWNTO 0);
      sample2           : IN     signed (bitNb-1 DOWNTO 0);
      sample3           : IN     signed (bitNb-1 DOWNTO 0);
      sample4           : IN     signed (bitNb-1 DOWNTO 0);
      a                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      b                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      c                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      d                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
      interpolateLinear : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT interpolatorShiftRegister
   GENERIC (
      signalBitNb : positive := 16
   );
   PORT (
      clock        : IN     std_ulogic ;
      reset        : IN     std_ulogic ;
      shiftSamples : IN     std_ulogic ;
      sampleIn     : IN     signed (signalBitNb-1 DOWNTO 0);
      sample1      : OUT    signed (signalBitNb-1 DOWNTO 0);
      sample2      : OUT    signed (signalBitNb-1 DOWNTO 0);
      sample3      : OUT    signed (signalBitNb-1 DOWNTO 0);
      sample4      : OUT    signed (signalBitNb-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT interpolatorTrigger
   GENERIC (
      counterBitNb : positive := 4
   );
   PORT (
      triggerOut : OUT    std_ulogic ;
      clock      : IN     std_ulogic ;
      reset      : IN     std_ulogic ;
      en         : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT offsetToUnsigned
   GENERIC (
      bitNb : positive := 16
   );
   PORT (
      unsignedOut : OUT    unsigned (bitNb-1 DOWNTO 0);
      signedIn    : IN     signed (bitNb-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT sawtoothGen
   GENERIC (
      bitNb : positive := 16
   );
   PORT (
      sawtooth : OUT    unsigned (bitNb-1 DOWNTO 0);
      clock    : IN     std_ulogic ;
      reset    : IN     std_ulogic ;
      step     : IN     unsigned (bitNb-1 DOWNTO 0);
      en       : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT resizer
   GENERIC (
      inputBitNb  : positive := 16;
      outputBitNb : positive := 16
   );
   PORT (
      resizeOut : OUT    unsigned (outputBitNb-1 DOWNTO 0);
      resizeIn  : IN     unsigned (inputBitNb-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT sineTable
   GENERIC (
      inputBitNb        : positive := 16;
      outputBitNb       : positive := 16;
      tableAddressBitNb : positive := 3
   );
   PORT (
      sine  : OUT    signed (outputBitNb-1 DOWNTO 0);
      phase : IN     unsigned (inputBitNb-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT sawtoothToSquare
   GENERIC (
      bitNb : positive := 16
   );
   PORT (
      square   : OUT    unsigned (bitNb-1 DOWNTO 0);
      sawtooth : IN     unsigned (bitNb-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT sawtoothToTriangle
   GENERIC (
      bitNb : positive := 16
   );
   PORT (
      triangle : OUT    unsigned (bitNb-1 DOWNTO 0);
      sawtooth : IN     unsigned (bitNb-1 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : interpolatorCalculatePolynom USE ENTITY Beamer.interpolatorCalculatePolynom;
   FOR ALL : interpolatorCoefficients USE ENTITY Beamer.interpolatorCoefficients;
   FOR ALL : interpolatorShiftRegister USE ENTITY Beamer.interpolatorShiftRegister;
   FOR ALL : interpolatorTrigger USE ENTITY Beamer.interpolatorTrigger;
   FOR ALL : offsetToUnsigned USE ENTITY Beamer.offsetToUnsigned;
   FOR ALL : resizer USE ENTITY SineInterpolator.resizer;
   FOR ALL : sawtoothGen USE ENTITY Beamer.sawtoothGen;
   FOR ALL : sawtoothToSquare USE ENTITY WaveformGenerator.sawtoothToSquare;
   FOR ALL : sawtoothToTriangle USE ENTITY WaveformGenerator.sawtoothToTriangle;
   FOR ALL : sineTable USE ENTITY SineInterpolator.sineTable;
   -- pragma synthesis_on


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 2 eb2
   logic1 <= '1';

   -- HDL Embedded Text Block 3 eb3
   logic0 <= '0';


   -- Instance port mappings.
   I_spline : interpolatorCalculatePolynom
      GENERIC MAP (
         signalBitNb       => signalBitNb,
         coeffBitNb        => coeffBitNb,
         oversamplingBitNb => sampleCountBitNb
      )
      PORT MAP (
         clock          => clock,
         reset          => reset,
         restartPolynom => newPolynom,
         d              => d,
         sampleOut      => sineSigned,
         c              => c,
         b              => b,
         a              => a,
         en             => logic1
      );
   I_coeffs : interpolatorCoefficients
      GENERIC MAP (
         bitNb      => signalBitNb,
         coeffBitNb => coeffBitNb
      )
      PORT MAP (
         sample1           => sample1,
         sample2           => sample2,
         sample3           => sample3,
         sample4           => sample4,
         a                 => a,
         b                 => b,
         c                 => c,
         d                 => d,
         interpolateLinear => logic0
      );
   I_shReg : interpolatorShiftRegister
      GENERIC MAP (
         signalBitNb => signalBitNb
      )
      PORT MAP (
         clock        => clock,
         reset        => reset,
         shiftSamples => newPolynom,
         sampleIn     => sineSamples,
         sample1      => sample1,
         sample2      => sample2,
         sample3      => sample3,
         sample4      => sample4
      );
   I_trig : interpolatorTrigger
      GENERIC MAP (
         counterBitNb => sampleCountBitNb
      )
      PORT MAP (
         triggerOut => newPolynom,
         clock      => clock,
         reset      => reset,
         en         => logic1
      );
   I_unsigned : offsetToUnsigned
      GENERIC MAP (
         bitNb => signalBitNb
      )
      PORT MAP (
         unsignedOut => sine,
         signedIn    => sineSigned
      );
   I_saw : sawtoothGen
      GENERIC MAP (
         bitNb => phaseBitNb
      )
      PORT MAP (
         sawtooth => phase,
         clock    => clock,
         reset    => reset,
         step     => step,
         en       => logic1
      );
   I_size : resizer
      GENERIC MAP (
         inputBitNb  => phaseBitNb,
         outputBitNb => signalBitNb
      )
      PORT MAP (
         resizeOut => sawtooth_internal,
         resizeIn  => phase
      );
   I_sin : sineTable
      GENERIC MAP (
         inputBitNb        => phaseBitNb,
         outputBitNb       => signalBitNb,
         tableAddressBitNb => tableAddressBitNb
      )
      PORT MAP (
         sine  => sineSamples,
         phase => phase
      );
   I_square : sawtoothToSquare
      GENERIC MAP (
         bitNb => signalBitNb
      )
      PORT MAP (
         square   => square,
         sawtooth => sawtooth_internal
      );
   I_tri : sawtoothToTriangle
      GENERIC MAP (
         bitNb => signalBitNb
      )
      PORT MAP (
         triangle => triangle,
         sawtooth => sawtooth_internal
      );

   -- Implicit buffered output assignments
   sawtooth <= sawtooth_internal;

END struct;




-- VHDL Entity Beamer.DAC.symbol
--
-- Created:
--          by - leo.dosreis.UNKNOWN (WE5400)
--          at - 17:32:24 25.01.2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY DAC IS
   GENERIC( 
      signalBitNb : positive := 16
   );
   PORT( 
      serialOut  : OUT    std_ulogic;
      parallelIn : IN     unsigned (signalBitNb-1 DOWNTO 0);
      clock      : IN     std_ulogic;
      reset      : IN     std_ulogic
   );

-- Declarations

END DAC ;





ARCHITECTURE studentVersion OF DAC IS
	signal accu1 : signed(parallelIn'high + 5 downto 0);
	signal accu2 : signed(parallelIn'high + 5 downto 0);
	
	signal parallelInResized : signed(parallelIn'high + 5 downto 0);
	
	constant two_pow_n : signed(parallelIn'high + 5 downto 0) := shift_left(to_signed(1,parallelIn'length+5),parallelIn'high+1);
	--((parallelIn'high + 1)=>'1', others=>'0'); -- 2^n
	constant c1 : signed(parallelIn'high + 5 downto 0) := shift_right(two_pow_n, 1); -- 2^(n-1)
	constant c2 : signed(parallelIn'high + 5 downto 0) := shift_left(two_pow_n, 3); -- 2^(n+3)
	
BEGIN
	bassin: process(reset, clock)
	begin
		if reset = '1' then
			accu1 <= (others => '0');
			accu2 <= (others => '0');
		elsif rising_edge(clock) then
			if accu2(accu2'high) = '0' then		-- accu2 >= 0
				accu1 <= accu1 + parallelInResized - c1;
				accu2 <= accu2 + accu1 - c2;
			else 								-- accu2 < 0			
				accu1 <= accu1 + parallelInResized + c1;
				accu2 <= accu2 + accu1 + c2;
			end if;
		end if; -- reset
	end process bassin;
	
	parallelInResized <= signed(shift_right(resize(parallelIn, parallelInResized'length), 1)) - shift_right(two_pow_n, 2); -- recenter to zero
	
	serialOut <= not(accu2(accu2'high)); -- outside of the process to avoid X state
	
END ARCHITECTURE studentVersion;




-- VHDL Entity Board.DFF.symbol
--
-- Created:
--          by - oliver.gubler.UNKNOWN (WE5370)
--          at - 14:29:35 16.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DFF IS
   PORT( 
      CLK : IN     std_uLogic;
      CLR : IN     std_uLogic;
      D   : IN     std_uLogic;
      Q   : OUT    std_uLogic
   );

-- Declarations

END DFF ;





ARCHITECTURE sim OF DFF IS
BEGIN

  process(clk, clr)
  begin
    if clr = '1' then
      q <= '0';
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;

END ARCHITECTURE sim;





--
-- VHDL Architecture Board.FPGA_sineGen.struct
--
-- Created:
--          by - oliver.gubler.UNKNOWN (WE5370)
--          at - 14:29:35 16.02.2018
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2015.2 (Build 5)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

LIBRARY Beamer;
LIBRARY Board;
LIBRARY SineInterpolator;

ARCHITECTURE struct OF FPGA_sineGen IS

   -- Architecture declarations
   constant signalBitNb: positive := 16;
   constant phaseBitNb: positive := 17;

   -- Internal signal declarations
   SIGNAL logic1      : std_uLogic;
   SIGNAL reset       : std_ulogic;
   SIGNAL resetSnch_N : std_ulogic;
   SIGNAL resetSynch  : std_ulogic;
   SIGNAL sineX       : unsigned(signalBitNb-1 DOWNTO 0);
   SIGNAL sineY       : unsigned(signalBitNb-1 DOWNTO 0);
   SIGNAL squareY     : unsigned(signalBitNb-1 DOWNTO 0);
   SIGNAL stepX       : unsigned(phaseBitNb-1 DOWNTO 0);
   SIGNAL stepY       : unsigned(phaseBitNb-1 DOWNTO 0);


   -- Component Declarations
   COMPONENT DAC
   GENERIC (
      signalBitNb : positive := 16
   );
   PORT (
      serialOut  : OUT    std_ulogic ;
      parallelIn : IN     unsigned (signalBitNb-1 DOWNTO 0);
      clock      : IN     std_ulogic ;
      reset      : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT DFF
   PORT (
      CLK : IN     std_uLogic ;
      CLR : IN     std_uLogic ;
      D   : IN     std_uLogic ;
      Q   : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT inverterIn
   PORT (
      in1  : IN     std_uLogic ;
      out1 : OUT    std_uLogic 
   );
   END COMPONENT;
   COMPONENT sineGen
   GENERIC (
      signalBitNb : positive := 16;
      phaseBitNb  : positive := 10
   );
   PORT (
      clock    : IN     std_ulogic ;
      reset    : IN     std_ulogic ;
      step     : IN     unsigned (phaseBitNb-1 DOWNTO 0);
      sawtooth : OUT    unsigned (signalBitNb-1 DOWNTO 0);
      sine     : OUT    unsigned (signalBitNb-1 DOWNTO 0);
      square   : OUT    unsigned (signalBitNb-1 DOWNTO 0);
      triangle : OUT    unsigned (signalBitNb-1 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : DAC USE ENTITY Beamer.DAC;
   FOR ALL : DFF USE ENTITY Board.DFF;
   FOR ALL : inverterIn USE ENTITY Board.inverterIn;
   FOR ALL : sineGen USE ENTITY SineInterpolator.sineGen;
   -- pragma synthesis_on


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   triggerOut <= squareY(squareY'high);

   -- HDL Embedded Text Block 2 eb2
   stepX <= to_unsigned(2, stepX'length);

   -- HDL Embedded Text Block 3 eb3
   stepY <= to_unsigned(3, stepY'length);

   -- HDL Embedded Text Block 4 eb4
   logic1 <= '1';


   -- Instance port mappings.
   I4 : DAC
      GENERIC MAP (
         signalBitNb => signalBitNb
      )
      PORT MAP (
         serialOut  => xOut,
         parallelIn => sineX,
         clock      => clock,
         reset      => resetSynch
      );
   I8 : DAC
      GENERIC MAP (
         signalBitNb => signalBitNb
      )
      PORT MAP (
         serialOut  => yOut,
         parallelIn => sineY,
         clock      => clock,
         reset      => resetSynch
      );
   I6 : DFF
      PORT MAP (
         CLK => clock,
         CLR => reset,
         D   => logic1,
         Q   => resetSnch_N
      );
   I0 : inverterIn
      PORT MAP (
         in1  => resetSnch_N,
         out1 => resetSynch
      );
   I1 : inverterIn
      PORT MAP (
         in1  => reset_N,
         out1 => reset
      );
   I3 : sineGen
      GENERIC MAP (
         signalBitNb => signalBitNb,
         phaseBitNb  => phaseBitNb
      )
      PORT MAP (
         clock    => clock,
         reset    => resetSynch,
         step     => stepX,
         sawtooth => OPEN,
         sine     => sineX,
         square   => OPEN,
         triangle => OPEN
      );
   I7 : sineGen
      GENERIC MAP (
         signalBitNb => signalBitNb,
         phaseBitNb  => phaseBitNb
      )
      PORT MAP (
         clock    => clock,
         reset    => resetSynch,
         step     => stepY,
         sawtooth => OPEN,
         sine     => sineY,
         square   => squareY,
         triangle => OPEN
      );

END struct;




