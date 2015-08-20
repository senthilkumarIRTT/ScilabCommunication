function [y] = gfconv(A,B,varargin)
    //GFCONV Convolves elemnts over a Galois field.
    
    //GFCONV(A,B) convolves A by B in GF(2)
    //The polynomial degree of resulting polynomial in the resultant GF(2) Y is sum of degree of A plus degree of B.
    
    //The coefficients have to be in the ascending powers of the degree. 
    
    //GFCONV(A,B,P) adds two elements A and B in GF(P).
    //P has to be prime.
    //Entries of A and B should be of length 0 to P-1.
        
    //   Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.
    
    [ll,rr] = argn(0)
    funcprot(0);

    //Check for the number of arguments
    if rr>3 then
          error("Too many input arguments.");
    end

    if rr<2 then
          error("Too few input arguments.");
    end

    [m1,n1]=size(A);
    [m2,n2]=size(B);

    //Check for P
    P = 2;
    if rr>2 then
        P=varargin(1);
        if isempty(P) then
                P=2;
        elseif(~isreal(P) | ~(length(P))==1 | ~prime(P) | floor(P)~=P) 
                error("The field parameter P must be a positive prime integer.");
        end;
    end;

    //Check if elements of A are between 0 and P-1
    w1=find(A<0 | A>P-1)
    if ~isempty(w1) then
        error("The  input elements should be between 0 and P-1");
    end

    //Check if elements of B are between 0 and P-1
    w2=find(B<0 | B>P)
    if ~isempty(w2) then
        error("The input elements should be between 0 and P-1");
    end

    //Convolve A and B modulo P
    conv=convol(A,B);
    y=pmodulo(conv, P);
endfunction

//--------------------------------------------------------------------------PRIME FUNCTION---------------------------------------------------------------------------------------------------------------------------
    function [y] = prime(x)
    //PRIME(X) returns a value 1 or 0 depending on whether the number is a prime or a compostite number.
    //The function will return a value 1 if the number is prime else will return 0.
    
    //Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.
    
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