//    Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

M = 8;        // Modulation order
freqsep = 8;  // Frequency separation (Hz)
nsamp = 8;    // Number of samples per symbol
Fs = 64;      // Sample rate (Hz)

//Signal that has magnitude between 0 and M-1
x=[1 2 3 4 2 5 0 1 6 0 7 3];

disp("The original signal is=") 
disp(x)
//Y = FSKMOD(X,M,FREQ_SEP,NSAMP,Fs,PHASE,SYMBOL_ORDER)
y = fskmod(x,M,freqsep,nsamp,Fs, 'cont', 'gray');

z= fskdemod(y,M,freqsep,nsamp,Fs, 'gray');
disp("The demodulated signal is= ")

disp(z)