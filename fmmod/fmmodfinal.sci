function [y] = freqmod(x,Fc,Fs,freqdev,varargin)
//Written by Manas Ranjan Das
[ll,rr] = argn(0)
funcprot(0);

if rr>5 then
  error("Too many input arguments.");
end;
if (~isreal(x)) then    
  error("X must be real.");
end;

if(~isreal(Fc) | ~(length(Fc))==1 | Fc<=0  ) 
  error("Fc must be a real, positive scalar.");
end;

if(~isreal(Fs) | ~(length(Fs))==1 | Fs<=0  )
  error("Fs must be a real, positive scalar.");
end;


if (Fs<=2*Fc) then
  error("Fs must be at least 2*Fc");
end;

if(~isreal(freqdev) | ~(length(freqdev))==1 | freqdev<=0  )
  error("phasedev must be a real, positive scalar.");
end;

ini_phase = 0;
if rr==5 then
  ini_phase = varargin(1);
  if isempty(ini_phase) then
    ini_phase = 0;
  end;
  if(~isreal(ini_phase) | ~(length(ini_phase))==1 ) then
    error("INI_PHASE must be a real scalar.");
  end;
end;

t = (0:1/Fs:(size((x),1)-1)/Fs)'
int_x = cumsum(x)/Fs;
y = cos(2*%pi*Fc*t+2*%pi*freqdev*int_x+ini_phase);

endfunction


