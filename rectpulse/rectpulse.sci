function [y] = rectpulse(x, Nsamp)
// RECTPULSE Rectangular pulse shaping.

//Y = RECTPULSE(X, NSAMP) returns Y, a rectangular pulse shaped version of X, with NSAMP samples per symbol. 
//This function replicates each symbol in X NSAMP times. 

//   For two-dimensional signals, the function treats each column as 1 channel.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

funcprot(0);

//Check for x
if (~isreal(x)) then    
	error("X must be a real number.");
end;

//Check for Nsamp
if(~isreal(Nsamp) | ceil(Nsamp)~=Nsamp | Nsamp<=0  ) 
	error("NSAMP must be a real positive integer.");
end;

[m, n] = size(x);

if (m==1 & n~=1)
            y= matrix(ones(Nsamp,1)*matrix(x, 1, m*n),m, n*Nsamp);
else
            y= matrix(ones(Nsamp,1)*matrix(x, 1, m*n),m*Nsamp, n);
end
endfunction


