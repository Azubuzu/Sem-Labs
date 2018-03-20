ARCHITECTURE studentVersion OF offsetToUnsigned IS
	constant offset : signed(bitNb-1 downto 0) := shift_left(to_signed(1,bitNb),bitNb-1);
	--((bitNb-1)=>'1', others=>'0');
BEGIN
	unsignedOut <= unsigned(signedIn+offset);
END ARCHITECTURE studentVersion;