function [y] = ssbmod(x,Fc,Fs,varargin)
//SSBMOD Single Sideband amplitude modulation

//Y=ssbmod(x,Fc,Fs)
//It amplitude modulates signal x with carrier frequency Fc(Hz) and at a sampling frequency Fs(Hz).
//Default sideband is the lower band.

//Y=ssbmod(x,Fc,Fs,INI_PHASE) 
//The function adds the INI_PHASE(radians) to the modulated signal.

//Y=ssbmod(x,Fc,Fs,INI_PHASE, 'upper') 
//The function uses the upper sideband.

//Fs must satisfy Fs>2*(Fc+BW), BW is the bandwidth of x.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

[ll,rr] = argn(0)
funcprot(0);

//Check number of arguments
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

//Check for INI_PHASE
ini_phase = 0;
if rr>=4
	ini_phase=varargin(1);
	if isempty(ini_phase)
		ini_phase=0;
  	elseif(~isreal(ini_phase) | ~(length(ini_phase))==1 ) 
    		error("INI_PHASE must be a real scalar.");
  	end;
end;

//Check for METHOD
Method='';
if rr==5 then
	Method=varargin(2)
	disp(Method)
	if (strcmpi(Method, 'upper')) then
		error('String argument must be upper.');
	end;
end;

//Check if x is one dimensional
wid=size(x,1);
if wid==1
	x=x(:);
end;

//Modulation
t = (0:1/Fs:(size(x,1)-1)/Fs)';
t = t(:,ones(1,size(x,2)));

if ~strcmpi(Method, 'upper')
	y=x.*cos(2*%pi*Fc*t+ini_phase)-imag(hilbert(x)).*sin(2*%pi*Fc*t+ini_phase);
else
	y=x.*cos(2*%pi*Fc*t+ini_phase)+imag(hilbert(x)).*sin(2*%pi*Fc*t+ini_phase);
end;

//Restore the output to original orientation
if wid==1
	y=y';
end;

endfunction


