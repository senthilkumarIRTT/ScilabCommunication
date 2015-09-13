function [z] = matdeintrlv(y, nrow, ncol)
//Z=MATDEINTRLV(Y, NROW, NCOLl)

//Reorder symbols by filling a matrix by colums and emptying by rows.
//Y is the data that will be filled column by column.
//Y will be the one that will be read row by row.
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

//Check for x
if (~isreal(y)) then    
	error("Y must be real.");
end;
if (isempty(y)) then
    error("Y must not be empty.");
end;

//Check for nrow
if (length(nrow) ~= 1)
    error('NROW must be a scalar integer value.')
end
if (~isreal(nrow)) then    
	error("X must be real.");
end;

//Check for ncol
if (length(ncol) ~= 1)
    error('NCOL must be a scalar integer value.')
end
if (~isreal(ncol)) then    
	error("X must be real.");
end;

//Check for the dimension of the internal matrix
if ((nrow*ncol) ~= size(y,1))            
    error('The product of NROW and NCOL must equal the length of the sequence in DATA.');
end;

//Compute the new indices for Y
int_table = matrix(matrix([1:nrow*ncol],ncol,nrow)',nrow*ncol,1);

z=deintrlv(y,int_table);

//Restore the output to original orientation
if(wid ==1)
	z=z';
end

endfunction

//--------------------------DEINTERLV DEFINITION----------------------------------
function [z] = deintrlv(y, elements)
//DEINTRLV Restore ordering of symbols.

//Z= INTRLV(X, ELEMENTS) restores the original ordering of the elements of y by acting as an inverse of intrlv. 
//If Y has N elements, for each integer k between 1 and N, ELEMENTS must have non-repeated integers between 1 and N.
//ELEMENTS indicates the indices of in which order the output Y appear.
//It determines the order of arrangement of x.
//ELEMENTS should be the same in both intrlv and deintrlv

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

funcprot(0);

//Check if x is a row vector
initial_width = size(y, 1);
if (initial_width == 1)
    //Column vector
    y = y(:);                            
end

//Initialize variables
[m, n] = size(y);
[elem_row, elem_col] = size(elements);
elem_ordered = 1:m;

//Check for x
if (~isreal(y)) then    
	error("Y must be a real number.");
end;
if isempty(x)
    error('Y cannot be empty.')
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
    error('The length of ELEMENTS must equal the length of Y.')
end

//See if elem_ordered and ELEMENTS have one to one mapping
for i=1:length(elements)
    r(i)=find(elem_ordered(:)==elements(i))
end
zero_location=find(r(:)==0);
if (~isempty(zero_location))
    error(" ELEMENTS must be a permutation of the indices of the elements in input ");
end

//Restore the ordering
z= zeros(m,n);                    
z(elements(:),:) = y;  

//Restores the output to the original orientation if sequence in Y is a column vector
if (initial_width == 1)
   z = z';
end
endfunction
