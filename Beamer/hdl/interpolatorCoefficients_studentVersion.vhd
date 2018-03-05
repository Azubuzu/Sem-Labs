ARCHITECTURE studentVersion OF interpolatorCoefficients IS
BEGIN
  a <= resize(-sample1,a'length) + resize(3*sample2,a'length) - resize(3*sample3,a'length) + resize(sample4,a'length);
  b <= resize(2*sample1,b'length) - resize(5*sample2,b'length) + resize(4*sample3,b'length) - resize(sample4,b'length);
  c <= resize(- sample1,c'length) + resize(sample3,c'length);
  d <= resize(sample2,d'length);
END ARCHITECTURE studentVersion;
