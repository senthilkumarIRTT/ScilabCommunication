//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

nsamp = 5; //Number of samples per symbol
nsymb = 3; //Number of symbols

ch1 = [0:nsymb-1]';
ch2 = [1:nsymb]';
x = [ch1 ch2] // Two-channel signal
disp(x)
y = rectpulse(x,nsamp)
disp(y)