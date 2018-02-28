ARCHITECTURE studentVersion OF interpolatorCoefficients IS
BEGIN
  a <= resize(-sample1 + 3*sample2 - 3*sample3 + sample4,a'length);
  b <= resize(2*sample1 -5*sample2 +4*sample3 - sample4,b'length);
  c <= resize(- sample1 + sample3,c'length);
  d <= resize(sample2,d'length);
END ARCHITECTURE studentVersion;
