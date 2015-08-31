function [y] = intrlv(x, elements)
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