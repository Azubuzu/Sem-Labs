ARCHITECTURE studentVersion OF pipelineAdder IS

  constant stageBitNb : positive := sum'length/stageNb;
  subtype stageOperandType is signed(stageBitNb-1 downto 0);
  type stageOperandArrayType is array(stageNb-1 downto 0) of stageOperandType;
  type stageOperandArrayArrayType is array(stageNb-1 downto 0) of stageOperandArrayType;
  
  subtype carryType is std_ulogic_vector(stageNb downto 0);

  signal a_int, b_int, sum_int : stageOperandArrayArrayType;
  signal carryIn : carryType;

  COMPONENT parallelAdder
  GENERIC (
    bitNb : positive := 32
  );
  PORT (
    sum  : OUT    signed (bitNb-1 DOWNTO 0);
    cIn  : IN     std_ulogic ;
    cOut : OUT    std_ulogic ;
    a    : IN     signed (bitNb-1 DOWNTO 0);
    b    : IN     signed (bitNb-1 DOWNTO 0)
  );
  END COMPONENT;

BEGIN

	carryIn(0) <= cIn;

	pipelineI: for i in stageOperandArrayType'range generate
		pipelineJ: for j in stageOperandArrayType'range generate
			a_int(i)(j) <= a(i*stageBitNb+stageBitNb-1 downto i*stageBitNb);
			b_int(i)(j) <= b(i*stageBitNb+stageBitNb-1 downto i*stageBitNb);
			
			-- Add both numbers
			addition : if i = j generate
				partialAdder: parallelAdder
				  GENERIC MAP (bitNb => stageBitNb)
				  PORT MAP (
					 a    => a_int(i)(j),
					 b    => b_int(i)(j),
					 sum  => sum_int(i)(j),
					 cIn  => carryIn(i),
					 cOut => carryIn(i+1)
				  );
				sum(i*stageBitNb+stageBitNb-1 downto i*stageBitNb) <= sum_int(i)(j);
			end generate addition;
			
			-- Buffer both numbers
			inBuffer : if j<i generate
				registerD: process(clock,reset)
				begin
					if reset = '1' then
						a_int(i)(j) <= (others => '0');
						b_int(i)(j) <= (others => '0');
					elsif rising_edge(clock) then
						a_int(i)(j+1) <= a_int(i)(j);
						b_int(i)(j+1) <= b_int(i)(j);
					end if;
				end process registerD;
			end generate inBuffer;
		
		
		end generate pipelineJ;
	end generate pipelineI;
  
	cOut <= carryIn(carryIn'high);
END ARCHITECTURE studentVersion;
