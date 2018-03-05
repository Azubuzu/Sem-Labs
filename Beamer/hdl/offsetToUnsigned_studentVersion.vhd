ARCHITECTURE studentVersion OF offsetToUnsigned IS
	constant offset : signed(bitNb-1 downto 0) := ((bitNb-1)=>'1', others=>'0');
BEGIN
	unsignedOut <= unsigned(signedIn+offset);
END ARCHITECTURE studentVersion;