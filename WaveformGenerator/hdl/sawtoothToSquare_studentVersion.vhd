ARCHITECTURE studentVersion OF sawtoothToSquare IS
BEGIN
	square <= (others => sawtooth(sawtooth'HIGH));
END ARCHITECTURE studentVersion;
