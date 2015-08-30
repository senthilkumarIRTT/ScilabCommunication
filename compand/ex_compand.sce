//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

//Mu-law
in=[1 2 3 4 5];
Amp=5;
Mu=255;
companded=compand(in,Mu,Amp,"mu/compressor");
disp("Compressed output by Mu-law=")
disp(companded)

expanded=compand(companded, Mu, Amp, "mu/expander");
disp("Expanded output by Mu-law=")
disp(expanded)

//A-law
in=[1 2 3 4 5];
Amp=5;
A=87.6;
companded=compand(in,A,Amp,"mu/compressor");
disp("Compressed output by A-law=")
disp(companded)

expanded=compand(companded, A, Amp, "mu/expander");
disp("Expanded output by A-law=")
disp(expanded)