function y = fskmod(x,M,freq_sep,nSamp,varargin)
//FSKMOD Frequency shift keying modulation
//   Y = FSKMOD(X,M,FREQ_SEP,NSAMP) outputs the complex envelope of the
//   modulation of the message signal X using frequency shift keying modulation. 
//   M is the size of the alphabet(Has to be 2^integer).  
//   The message can have value from 0 to M-1.  
//   FREQ_SEP is the desired separation between successive frequencies, in Hz.  
//   NSAMP denotes the number of samples per symbol.  
//   If the signal is two dimensional, each column is treated as a channel.
//
//   Y = FSKMOD(X,M,FREQ_SEP,NSAMP,FS) specifies the sampling frequency (Hz).
//
//   Y = FSKMOD(X,M,FREQ_SEP,NSAMP,FS,PHASE) specifies the phase continuity
//   across FSK symbols.  
//   PHASE can be either 'cont' for continuous phase, or 'discont' for 
//   discontinuous phase. 

//   Y = FSKMOD(X,M,FREQ_SEP,NSAMP,Fs,PHASE,SYMBOL_ORDER) specifies how 
//   the function assigns binary words to corresponding integers. 
//   Ordering could be 'bin' binary or 'gray' gray coded 

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

[ll,rr] = argn(0)
funcprot(0);

//Check number of arguments
if rr<4 then
	error("Too few input arguments.");
end;

if rr>7 then
	error("TToo many input arguments.");
end;

//Check for x
if (~isreal(x) | (ceil(x)~=x)) then    
	error("X must be real and an integer between zero and M-1.");
end;

//Check for M
if (~isreal(M) | (ceil(M)~=M) | M<=0) then
    error("M must be a scalar positive integer.");
end;

//Check that M is of the form 2^K
if ((ceil(log2(M)) ~= log2(M))) then
    error("M must be a power of 2.");
end;

// Check that all X are integers within [0,M-1]
if ((min(min(x)) < 0) | (max(max(x)) > (M-1))) then
    error("Elements of input X must be integers in [0, M-1].");
end;

//Check that the FREQ_SEP is greater than 0
if (~isreal(freq_sep) | ~(length(freq_sep))==1 | freq_sep<=0)     
    error("FREQ_SEP must be a scalar greater than 0.");
end;

//Check that NSAMP is an integer greater than 1
if ((ceil(nSamp) ~= nSamp) | (nSamp <= 1))
    error("NSAMP must be an integer greater than 1.");
end;

//Check for Fs
if rr>=5 then
    Fs=varargin(1);
    if (isempty(Fs)) then
        Fs=1;
    elseif (~isreal(Fs) | ~length(Fs)==1 | Fs<=0) then
        error("Fc must be a real, positive scalar.");
    end;
else
    Fs=1;
end;

samp_time=1/Fs;

//Check that the maximum frequency is not greater than Fs/2
max_freq = ((M-1)/2)*freq_sep;
if (max_freq > Fs/2) then
    error("The maximum frequency must be less than or equal to Fs/2.");
end;

//Check if the phase is continuous or discontinuous
if rr>=6 then
    phase=varargin(2);
    if (~strcmpi(phase,"cont") | ~strcmpi(phase,"discont")) then
        error("PHASE should be cont or discont ");
    end;
else
    phase="cont";
end;

if (strcmpi(phase, 'cont'))
    phase_cont = 1;
else
    phase_cont = 0;
end;

if (rr>=4 & rr<=6) then
    sym_ord="bin";
else
    sym_ord=vararg(3);
    if (~(strcmpi(sym_ord,"bin")) & ~(strcmpi(sym_ord,"gray"))) then
        error("Invalid symbol ordering");
    end;
end;

//Check if x is one dimensional
wid=size(x,1);
if wid==1
	x=x(:);
end;


//Obtain the total number of channels
[nRows, nChan] = size(x);

//Initialize the phase increments and the oscillator phase for modulator with discontinuous phase.
phaseIncr = (0:nSamp-1)' * (-(M-1):2:(M-1)) * 2*%pi * freq_sep/2 * samp_time;

// phIncrSym is the incremental phase over one symbol, across all M tones.
[a,b]=size(phaseIncr);
phIncrSym = phaseIncr(a,:);

// phIncrSamp is the incremental phase over one sample, across all M tones.
phIncrSamp = phaseIncr(2,:);    // recall that phaseIncr(1,:) = 0
OscPhase = zeros(nChan, M);

// phase = nSamp*number_of_symbols* number_of_channels
Phase = zeros(nSamp*nRows, nChan);

//Discontinuous phase
if ((~phase_cont) & (floor(nSamp*freq_sep/2*samp_time)==nSamp*freq_sep/2*samp_time))
    exp_phaseIncr = exp(%i*phaseIncr);
    y = matrix(exp_phaseIncr(:,x+1), nRows*nSamp, nChan);
else
    for iChan=1:nChan
        prevPhase=0;
        for iSym=1:nRows
            // Get the initial phase for the current symbol
            if (phase_cont)
                ph1=prevPhase;
            else
                ph1=OscPhase(iChan, x(iSym,iChan)+1);
            end;
            
            // Compute the phase of the current symbol by summing the initial phase
            // with the per-symbol phase trajectory associated with the given M-ary
            // data element.
            Phase(nSamp*(iSym-1)+1:nSamp*iSym,iChan) = ...
                ph1*ones(nSamp,1) + phaseIncr(:,x(iSym,iChan)+1);

            // Update the oscillator for a modulator with discontinuous phase.
            // Calculate the phase modulo 2*pi so that the phase doesn't grow too
            // large.
            if (~phase_cont)
                //need to run the rem.sci file
                OscPhase(iChan,:)=rem(OscPhase(iChan,:) + phIncrSym + phIncrSamp, 2*pi);
            end;

            // If in continuous mode, the starting phase for the next symbol is the
            // ending phase of the current symbol plus the phase increment over one
            // sample.
            prevPhase = Phase(nSamp*iSym,iChan) + phIncrSamp(x(iSym,iChan)+1);
        end;
    end;
    y = exp(%i*Phase);
end;

if(wid == 1)
    y = y.';
end;

endfunction

function [out]=rem(in1, in2)
    out=in1-fix(in1./in2).*in2;
endfunction