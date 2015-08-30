function [y] = prime(x)
    //PRIME(X) returns a value 1 or 0 depending on whether the number is a prime or a compostite number.
    //The function will return a value 1 if the number is prime else will return 0.
    
    //   Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.
[ll,rr] = argn(0)
funcprot(0); 

if rr>1 then
      error("Too many input arguments.");
end

if(~isreal(x) | ~(length(x))==1 | x==0  )
            error("Zero is neither prime nor composite");
end;

if(~isreal(x) | ~(length(x))==1 | x<0  ) 
	error("X must be a real, positive scalar.");
end;

//Implementation of the functionality
y=1;        
for i = 2:(x-1)
         //if x is divisible by any of the number smaller than x, then number is composite
         if modulo(x,i)==0 then
             y=0;
         break;
     end; 
end;
endfunction
    