//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

A=[6 6 6 1 1];
B=[2 6 6 1];

X=gfsub(A,B,7);
disp("Output A-B=")
disp(X)

Y=gfsub(B,A,7);
disp("Output B-A=")
disp(Y)

Z=gfsub(B,A,7,4);
disp("The truncated output of B-A is=")
disp(Z)