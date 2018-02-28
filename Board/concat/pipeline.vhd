-- VHDL Entity Board.FPGA_pipeline.symbol
--
-- Created:
--          by - francois.UNKNOWN (WE3673)
--          at - 11:55:30 14.07.2015
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY FPGA_pipeline IS
   GENERIC( 
      generatorBitNb : positive := 16
   );
   PORT( 
      clock   : IN     std_ulogic;
      reset_N : IN     std_ulogic;
      cosine  : OUT    signed (generatorBitNb-1 DOWNTO 0);
      sine    : OUT    signed (generatorBitNb-1 DOWNTO 0)
   );

-- Declarations

END FPGA_pipeline ;





-- VHDL Entity Board.inverterIn.symbol
--
-- Created:
--          by - francois.UNKNOWN (WE3673)
--          at - 11:55:30 14.07.2015
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
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





-- VHDL Entity pipelinedOperators.sinewaveGenerator.symbol
--
-- Created:
--          by - francois.UNKNOWN (WE3673)
--          at - 11:55:30 14.07.2015
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY sinewaveGenerator IS
   GENERIC( 
      bitNb : positive := 32
   );
   PORT( 
      cosine : OUT    signed (bitNb-1 DOWNTO 0);
      sine   : OUT    signed (bitNb-1 DOWNTO 0);
      clock  : IN     std_ulogic;
      reset  : IN     std_ulogic
   );

-- Declarations

END sinewaveGenerator ;





library ieee;
  use ieee.math_real.all;

ARCHITECTURE RTL OF sinewaveGenerator IS

  constant pointsPerPeriod: real := 20.0;
  constant phaseStep: real := 2.0*math_pi/pointsPerPeriod;
  constant maxAmplitude: signed(sine'range) := shift_left(resize("01", sine'length), sine'length-1)-1;
  constant deltaReal: signed(cosine'range) := to_signed(integer(cos(phaseStep)*real(to_integer(maxAmplitude))+0.5), cosine'length);
  constant deltaImag: signed(sine'range) := to_signed(integer(sin(phaseStep)*real(to_integer(maxAmplitude))+0.5), sine'length);

  signal realPart1, realPart: signed(cosine'high+1 downto 0);
  signal imagPart1, imagPart: signed(sine'high+1 downto 0);
  signal realProduct: signed(2*cosine'length-1 downto 0);
  signal imagProduct: signed(2*sine'length-1 downto 0);

BEGIN

  realProduct <= resize(deltaReal*realPart - deltaImag*imagPart, realProduct'length);
  imagProduct <= resize(deltaReal*imagPart + deltaImag*realPart, imagProduct'length);
  realPart1 <= resize(
--    shift_right(realProduct, cosine'length-1) + shift_right(realProduct, 2*cosine'length-3),
    shift_right(realProduct, cosine'length-1),
    realPart1'length
  );
  imagPart1 <= resize(
--    shift_right(imagProduct, sine'length-1) + shift_right(imagProduct, 2*sine'length-3),
    shift_right(imagProduct, sine'length-1),
    imagPart1'length
  );

  simulateOscillator: process(reset, clock)
  begin
    if reset = '1' then
      realPart <= resize(maxAmplitude, realPart'length);
      imagPart <= (others => '0');
    elsif rising_edge(clock) then
      if realPart1 > maxAmplitude then
        realPart <= resize(maxAmplitude, realPart'length);
      elsif realPart1 < -maxAmplitude then
        realPart <= resize(-maxAmplitude, realPart'length);
      else
        realPart <= realPart1;
      end if;
      if imagPart1 > maxAmplitude then
        imagPart <= resize(maxAmplitude, imagPart'length);
      elsif imagPart1 < -maxAmplitude then
        imagPart <= resize(-maxAmplitude, imagPart'length);
      else
        imagPart <= imagPart1;
      end if;
    end if;
  end process simulateOscillator;

  -- sine <= resize(imagPart, sine'length);
  -- cosine <= resize(realPart, cosine'length);
  sine <= imagPart(sine'range);
  cosine <= realPart(cosine'range);

END ARCHITECTURE RTL;




-- VHDL Entity Board.DFF.symbol
--
-- Created:
--          by - francois.UNKNOWN (WE3673)
--          at - 11:55:30 14.07.2015
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
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
-- VHDL Architecture Board.FPGA_pipeline.struct
--
-- Created:
--          by - francois.UNKNOWN (WE3673)
--          at - 12:00:34 14.07.2015
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

-- LIBRARY Board;
-- LIBRARY pipelinedOperators;

ARCHITECTURE struct OF FPGA_pipeline IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL logic1      : std_uLogic;
   SIGNAL reset       : std_ulogic;
   SIGNAL resetSnch_N : std_ulogic;
   SIGNAL resetSynch  : std_ulogic;


   -- Component Declarations
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
   COMPONENT sinewaveGenerator
   GENERIC (
      bitNb : positive := 32
   );
   PORT (
      cosine : OUT    signed (bitNb-1 DOWNTO 0);
      sine   : OUT    signed (bitNb-1 DOWNTO 0);
      clock  : IN     std_ulogic ;
      reset  : IN     std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
--    FOR ALL : DFF USE ENTITY Board.DFF;
--    FOR ALL : inverterIn USE ENTITY Board.inverterIn;
--    FOR ALL : sinewaveGenerator USE ENTITY pipelinedOperators.sinewaveGenerator;
   -- pragma synthesis_on


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 4 eb4
   logic1 <= '1';


   -- Instance port mappings.
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
   I2 : sinewaveGenerator
      GENERIC MAP (
         bitNb => generatorBitNb
      )
      PORT MAP (
         cosine => cosine,
         sine   => sine,
         clock  => clock,
         reset  => resetSynch
      );

END struct;



