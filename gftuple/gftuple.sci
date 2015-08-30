function [y] = gftuple(A,varargin)
    //GFTUPLE Simplify or convert the format of elements of a Galois field.
    //For all syntaxes, A is a matrix, each row of which represents an element
    //of a Galois field.  If A is a column of integers, then MATLAB interprets
   //each row as an exponential format of an element.  Negative integers and
   //-Inf all represent the zero element of the field.  If A has more than one
   //column MATLAB interprets each row as a polynomial format of an element.
   //In that case, each entry of A must be an integer between 0 and P-1.
    
    //All formats are relative to a root of a primitive polynomial specified by
   //the second input argument, described below.
   
   //TP = GFTUPLE(A, M) returns the simplest polynomial format of the elements
   //that A represents, where the kth row of TP corresponds to the kth row of A.  
   //Formats are relative to a root of the default primitive polynomial for
   //GF(2^M).  M is a positive integer.
      
   //TP = GFTUPLE(A, M, P) is the same as TP = GFTUPLE(A, M) except that 2 is
    //replaced by a prime number P.

    //TP = GFTUPLE(A, PRIM_POLY, P) is the same as TP = GFTUPLE(A, PRIM_POLY)
    //except that 2 is replaced by a prime number P.

    //TP = GFTUPLE(A, PRIM_POLY, P, PRIM_CK) is the same as the syntax above
    //except that GFTUPLE checks whether PRIM_POLY represents a polynomial that
    //is indeed primitive.  If not, then GFTUPLE generates an error and does not
    //return TP.  The input argument PRIM_CK can be any number or string.
    
    //[TP, EXPFORM] = GFTUPLE(...) returns the additional matrix EXPFORM.  The
    //kth row of EXPFORM is the simplest exponential format of the element that
    //the kth row of A represents.
    //Note: This function performs computations in GF(P^M) where P is prime. To
    //perform equivalent computations in GF(2^M), you can also apply the .^
    //operator and the LOG function to Galois arrays.

    //In exponential format, the number k represents the element alpha^k, where
    //alpha is a root of the chosen primitive polynomial.  In polynomial format,
    //the row vector k represents a list of coefficients in order of ascending
    //exponents. For E.g.: For GF(5), k = [4 3 0 2] represents 4 + 3x + 2x^3.

    //To generate a FIELD matrix over GF(P^M), as used by other GF functions
    //such as GFADD, the following command may be used:
    //FIELD = GFTUPLE([-1 : P^M-2]', M, P);
    
    //Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.
    
    [ll,rr] = argn(0)
    funcprot(0);

    //Error checking for P
    if rr<3 then
          P=2;
    else
          P=varargin(2);
          if(~isreal(P) | ~(length(P))==1 | ~prime(P) | P<2 |  floor(P)~=P)
                  error("The field parameter P must be a positive prime integer.")
          end
    end

//    //Error checking for A
//    if (isempty(A) | ndims(A) > 2)
//            error("The form of A is invalid.")
//    end
    [m_A, n_A]=size(A);
//    if n_A==1 then
//            if any(any(~floor_compare(A) | ~real_check(A)))
//                y=(floor(A)~=A | real(A)~=A)
//                y_a=(~floor_compare(A) | ~real_check(A))
//                disp(y_a)
//                    error("If input A is a column vector, then its entries must be real integers.");
//            end
//    else
//            if any(any(abs(A)~=A | floor(A)~=A))
//                    error("If input A is a matrix, then its entries must be real positive integers.");
//            end
//    end
//    
    //Error checking of further parameters
    prim_poly = varargin(1);
    [m_pp, n_pp] = size(prim_poly);
    if ( ndims(prim_poly)>2 | (m_pp > 1) )
            error("The second input argument must be either a scalar or a row vector.");
    else
            //WRITE FOR PRIME POLY. NEEDS GFPRIMDF
            //if (n_pp==1)
                //prime polynomial
            if n_pp~=1
                    if (isempty(prim_poly) | ~isreal(prim_poly) | any( floor(prim_poly))~=prim_poly)
                            error("Entries in PRIM_POLY must be real positive integers.");
                    end
                    if (prim_poly(1)==0 | prim_poly(n_pp)~=1)
                            error("PRIM_POLY must be a monic primitive polynomial, see GFPRIMDF.");
                    end
                    if (any((prim_poly >= p) | (prim_poly < 0)))
                            if ( p == 2 )
                                    error("Coefficients in PRIM_POLY must be either zero or one.");
                            else
                                    error("Coefficients in PRIM_POLY must be between 0 and P-1.");
                            end
                   end
                   m = n_pp - 1;
                     //if rr>3
                     //          return a flag using gfprimck
                     //end
                   
            end
    end
    
    q=P^m;
    //The 'alpha^m' equivalence is determined from the primitive polynomial.
    alpha_m = pmodulp( -1*prim_poly(1:m) , P);
    
    //First calculate the full 'field' matrix.  Each row of the 'field'    
    //matrix is the polynomial representation of one element in GF(P^M).
    field = zeros(q,m);
    field(2:m+1,:) = eye(m);
    for k = m+2:q,
            fvec = [0 field(k-1,:)];
            if (fvec(m+1)>0)
                    fvec(1:m) = pmodulo( fvec(1:m)+fvec(m+1)*alpha_m, P );
            end
            field(k,:) = fvec(1:m);
    end
    
    
    //Calculate the simplest polynomial form of the input 'a'.
    poly_form = zeros(m_a, m);
    if n_a == 1
        //Exponential input representation case.
        idx = find( a > q-2 );
        a(idx) = mod( a(idx), q-1 );
        a(a<0) = -1;
        poly_form = field( a+2 , : );
//    else
//        //Polynomial input representation case.  Cycle through each input row.
    end
    

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

//-----------------------------------------------------------------------ANY FUNCTION---------------------------------------------------------------------------------------------------------------------------
function [y]=any(x)
   //ANY(X) returns a 1 if any element of the input is a non-zero
   [m1, n1]=size(x);
   
   y=0;
   for i=1:n1
          z=find(x(:,i)~=0)
          if isempty(z) then    
                  y(i)=0;
          else
                  y(i)=1;
          end
   end
endfunction

//----------------------------------------------------------------------FLOOR COMPARE----------------------------------------------------------------------------------------------------------
function [y]=floor_compare(x)
    z=(floor(x)==x);
    if (z)
          y=1;
    else
          y=0;
    end;
endfunction  