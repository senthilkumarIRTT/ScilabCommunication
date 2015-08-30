function [z] = pmdemod(y,Fc,Fs,phasedev,varargin)
// PMDEMOD Phase Demodulation

//Z = PMDEMOD(Y,Fc,Fs,PHASEDEV) demodulates the phase modulated signal, Y which is modulated at the carrier frequency Fc (Hz). Fs is the sampling frequency (in Hz). 
//PHASEDEV (Hz) is the frequency deviation of the modulated signal.

//Z = PMDEMOD(Y,Fc,Fs,PHASEDEV,INI_PHASE) specifies the initial phase
//(radians) of the modulated signal.
 
//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

[ll,rr] = argn(0)
funcprot(0);

//Check the number of arguments
if rr>5 then
  error("Too many input arguments.");
end;

//Check for y and Fc
if (~isreal(y)) then    
  error("Y must be real.");
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

//Check if y is one dimensional
wid=size(y,1);
if wid==1
	y=y(:);
end;

//Modulation
t = (0:1/Fs:(size((x),1)-1)/Fs)';
t = t(:,ones(1,size(x,2)));

yq=hilbert(y).*exp((-%i*2*%pi*Fc*t)-(%i*2*%pi*ini_phase));
z=(1/phasedev)*atan(imag(yq),real(yq));



//Restore the output to original orientation
if wid==1
	z=z';
end;

endfunction


