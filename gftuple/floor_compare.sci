function [y]=floor_compare(x)
    z=(floor(x)==x);
    if (z)
          y=1;
    else
          y=0;
    end;
    disp(y)
endfunction  