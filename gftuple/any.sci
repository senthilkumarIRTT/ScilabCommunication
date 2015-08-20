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