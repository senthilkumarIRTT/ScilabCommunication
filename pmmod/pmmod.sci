function [y] = pmmod(x,Fc,Fs,phasedev,varargin)
// PMMOD Phase modulation

//Y = PMMOD(X,Fc,Fs,PHASEDEV) modulates the the message X at the carrier frequency Fc (Hz). Fs is the sampling frequency (in Hz). 
//PHASEDEV (Hz) is the frequency deviation of the modulated signal.

//Y = PMMOD(X,Fc,Fs,PHASEDEV,INI_PHASE) specifies the initial phase
//(radians) of the modulated signal.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

[ll,rr] = argn(0)
funcprot(0);

//Check the number of arguments
if rr>5 then
  error("Too many input arguments.");
end;

//Check for x and Fc
if (~isreal(x)) then    
  error("X must be real.");
end;
if(~isreal(Fc) | ~(length(Fc))==1 | Fc<=0  ) 
  error("Fc must be a real, positive scalar.");
end;

//Check for the sampling frequency, Fs
if(~isreal(Fs) | ~(length(Fs))==1 | Fs<=0  )
  error("Fs must be a real, positive scalar.");
end;
if (Fs<=2*Fc) then
  error("Fs must be at least 2*Fc");
end;

//Check for PHASEDEV
if(~isreal(phasedev) | ~(length(phasedev))==1 | phasedev<=0  )
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

//Check if x is one dimensional
wid=size(x,1);
if wid==1
	x=x(:);
end;

//Modulation
t = (0:1/Fs:(size((x),1)-1)/Fs)';
t = t(:,ones(1,size(x,2)));

y = cos(2*%pi*Fc*t + phasedev*x + ini_phase);  

//Restore the output to original orientation
if wid==1
	y=y';
end;

endfunction


