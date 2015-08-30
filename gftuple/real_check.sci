function [y]=real_check(x)
    z=(real(x)==x);
    if (z)
          y=1;
    else
          y=0;
    end;
    disp(y)
endfunction  