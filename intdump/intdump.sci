function [y] = intdump(x, Nsamp)
//   INTDUMP Integrate and dump.
//   Y = INTDUMPP(X, NSAMP) integrates the signal X for 1 symbol period, then
//   outputs one value into Y. 
//   NSAMP is the number of samples per symbol.
//   For two-dimensional signals, the function treats each column as 1 channel.

//   Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

//Check for x and nSamp
if (~isreal(x))     
    error("X should be numeric");
end;

if(~isreal(Nsamp) | ~(length(Nsamp)==1) | Nsamp<=0 | (ceil(Nsamp) ~=Nsamp ))
    error("NSAMP must be a positive integer.");
end

// Assure that X, if one dimensional, has the correct orientation 
wid = size(x,1);
if(wid ==1)
    x = x(:);
end

// Nsamp must be an integer factor of the number of samples in the received signal.
if(wid==1)  then
    if( rem(length(x), Nsamp) ~=0 )
        error("Number of elements in each channel of X must be an integer multiple of NSAMP.");
    end
else
     if( rem(wid, Nsamp) ~=0 )
        error("Number of elements in each channel of X must be an integer multiple of NSAMP.");
    end
end


[xRow, xCol] = size(x);
x = mean(matrix(x, Nsamp, xRow*xCol/Nsamp), 'r');
y = matrix(x, xRow/Nsamp, xCol);      

//restore the output signal to the original orientation 
if(wid == 1)
    y = y.';
end
endfunction

//------------------------------------------------------------------------------------------------------------------------------------

function [out]=rem(in1, in2)
//Remainder after division
//output is the remainder after in1 is divided by in2
    out=in1-fix(in1./in2).*in2;
endfunction
