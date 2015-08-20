function [y] = gfadd(A,B,varargin)
    //GFADD Add polynomials over a Galois field.
    
    //GFADD(A,B) adds the two numbers over GF(2)
    //If one of the two inputs is shorter than the other, than zero padding is done to the shorter number to
    //make the two elements of equal length.
    
    //GFADD(A,B,P) adds two elements A and B in GF(P).
    //P has to be prime.
    //Entries of A and B should be of length 0 to P-1.
    //If one of the two inputs is shorter than the other, than zero padding is done to the shorter number to
    //make the two elements of equal length.
    
    //GFADD(A,B,P,LENGTH) returns the same result as in GFADD(A,B,P) but truncated to length LENGTH.
        
    //   Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.
    
[ll,rr] = argn(0)
funcprot(0);

//Check for the number of arguments
if rr>4 then
      error("Too many input arguments.");
end

if rr<2 then
      error("Too few input arguments.");
end

[m1,n1]=size(A);
[m2,n2]=size(B);

//Zero padding on rows
if m1>m2 then
    B(m2+1:m1,:)=0;
elseif m1<m2
    A(m1+1:m2,:)=0;
end

//zero padding on columns
if n1>n2 then
    B(:,n2+1:n1)=0;
elseif n1<n2 then
    A(:,n1+1:n2)=0;
end

//Common size of the two inputs
[m1,n1]=size(A);

//Check for P
P = 2;
if rr>2 then
    P=varargin(1);
    if isempty(P) then
		P=2;
    elseif(~isreal(P) | ~(length(P))==1 | ~prime(P)) 
        error("P must be a real prime number.");
    end;
end;

len=n1;
if rr>3 then
    len=varargin(2);
    if isempty(len) then
		len=n1;
    elseif(~isreal(len) | ~(length(len))==1) 
        error("LENGTH must be a real number.");
    end;
end;

//Check if elements of A are between 0 and P-1
w1=find(A<0 | A>P-1)
if ~isempty(w1) then
    error("The  input elements should be between 0 and P-1");
end

//Check if elements of A are between 0 and P-1
w2=find(B<0 | B>P)
if ~isempty(w2) then
    error("The input elements should be between 0 and P-1");
end

//Add A and B modulo P
y=pmodulo(A+B, P);

if  n1<len then
    y(:,n1+1:len)=0
else
   y=y(:,1:len);
end
endfunction

//--------------------------------------------------------------------------PRIME FUNCTION---------------------------------------------------------------------------------------------------------------------------
function [y] = prime(x)
    //PRIME(X) returns a value 1 or 0 depending on whether the number is a prime or a compostite number.
    //The function will return a value 1 if the number is prime else will return 0.
    
   //   Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.
    
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