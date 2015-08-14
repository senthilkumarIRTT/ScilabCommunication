M = 4;        // Modulation order
freqsep = 8;  // Frequency separation (Hz)
nsamp = 8;    // Number of samples per symbol
Fs = 32;      // Sample rate (Hz)

//Signal that has magnitude between 0 and M-1
x=[1 2 3 0 2 3 1];

disp("The original signal is=")
disp(x)

y = fskmod(x,M,freqsep,nsamp,Fs);

z= fskdemod(y,M,freqsep,nsamp,Fs);
disp("The demodulated signal is= ")

disp(z)