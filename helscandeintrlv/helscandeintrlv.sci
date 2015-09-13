function [z] = helscandeintrlv(y, nrow, ncol, hstep)
//Z = HELSCANDEINTRLV(Y, NROW, NCOL, HSTEP) 

//Restores symbols by filling a matrix by rows and reading them out 
//by scanning along the diagonals of this array.
//Y is the data that will be filled row by row.
//Z will be the output read along the diagonal.
//The array step size, HSTEP, is the slope of the diagonal.
//It must be a nonnegative integer less than the specified number of rows.
//NROW*NCOL is the dimension of the internal matrix.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

funcprot(0);

//Keep a backup of original data string
orig_y=y;

//Check if x is one dimensional
wid=size(y,1);
if wid==1
	y=y(:);
end;

y_size=size(y);

//Check for Y
if (~isreal(y)) then    
	error("Y must be real.");
end;
if (isempty(y)) then
    error("Y must not be empty.");
end;

//Check for NROW
if (length(nrow) ~= 1)
    error('NROW must be a scalar integer value.')
end
if (~isreal(nrow)) then    
	error("NROW must be a positive integer.");
end;
if(nrow<=0)
    error("NROW must be a positive integer value.")
end;

//Check for NCOL
if (length(ncol) ~= 1)
    error('NCOL must be a scalar integer value.')
end
if (~isreal(ncol)) then    
	error("NCOL must be a positive integer.")
end;
if(ncol<=0)
    error("NCOL must be a positive integer value.")
end;

//Check for the dimension of the internal matrix
if ((nrow*ncol) ~= size(y,1))            
    error("The product of NROW and NCOL must equal the length of the sequence in Y.")
end;

//Check for HSTEP
if (hstep<=0)
    error("HSTEP must be a positive integer value.")
end
if (hstep>=nrow | hstep<0)
    error("Array step size has to be positive integer and less than NROW");
end;


//Compute the new indices for Y
int_table=zeros(nrow*ncol,1);
for i=1:nrow
    for j=1:ncol
        int_table((i-1)*ncol + j)=pmodulo((i-1) + hstep*(j-1), nrow)*ncol +j;
    end
end

z=deintrlv(y,int_table);

//Restore the output to original orientation
if(wid ==1)
	z=z';
end

endfunction

//--------------------------DEINTERLV DEFINITION--------------------------------
function [y] = deintrlv(x, elements)
//INTRLV Reorder sequence of symbols.

//Y= INTRLV(X, ELEMENTS) rearranges the elements of  X without repeating or omitting any of its elements. 
//If X has N elements, for each integer k between 1 and N, ELEMENTS must have non-repeated integers between 1 and N.
//ELEMENTS indicates the indices of in which order the output Y appear.
//It determines the order of arrangement of x.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

funcprot(0);

//Check if x is a row vector
initial_width = size(x, 1);
if (initial_width == 1)
    //Column vector
    x = x(:);                            
end

//Initialize variables
[m, n] = size(x);
[elem_row, elem_col] = size(elements);
elem_ordered = 1:m;

//Check for x
if (~isreal(x)) then    
	error("X must be a real number.");
end;
if isempty(x)
    error('X cannot be empty.')
end;

//Check if ELEMENTS is a matrix
if (elem_row >= 2 & elem_col >= 2)             
    error('ELEMENTS must be a vector of integers.');
end;
if isempty(elements)
    error('ELEMENTS cannot be empty.')
end;

//See if elements and X can be mapped one-to-one
if (length(elements) ~= m )
    error('The length of ELEMENTS must equal the length of input X.')
end

//See if elem_ordered and ELEMENTS have one to one mapping
for i=1:length(elements)
    r(i)=find(elem_ordered(:)==elements(i))
end
zero_location=find(r(:)==0);
if (~isempty(zero_location))
    error(" ELEMENTS must be a permutation of the indices of the elements in input ");
end

//Permutes sequence of symbols given in X
y = x(elements(:),:);                    

//Restores the output to the original orientation if sequence in X is a column vector
if (initial_width == 1)
   y = y';
end
endfunction
