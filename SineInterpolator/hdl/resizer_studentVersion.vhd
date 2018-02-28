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
