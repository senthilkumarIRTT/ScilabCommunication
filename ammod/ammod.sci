function [y] = ammod(x,Fc,Fs,varargin)
//Written by Maitreyee Mordekar
[ll,rr] = argn(0)
funcprot(0);

if rr>4 then
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

ini_phase = 0;
if rr==4 then
  ini_phase = varargin(1);
  if isempty(ini_phase) then
    ini_phase = 0;
  end;
  if(~isreal(ini_phase) | ~(length(ini_phase))==1 ) then
    error("INI_PHASE must be a real scalar.");
  end;
end;

t = (0:1/Fs:(size((x),1)-1)/Fs)'
y=(1+x).*sin(2*%pi*Fc*t+ini_phase);


endfunction


