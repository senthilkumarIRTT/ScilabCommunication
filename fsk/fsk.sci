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

//   Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

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

phase="cont";
//Check if the phase is continuous or discontinuous
if rr>=6 then
    phase=varargin(2)
    if (strcmpi(phase,"cont") & strcmpi(phase,"discont")) then
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


sym_ord="bin";
if (rr>=4 & rr<=6) then
    sym_ord="bin";
else
    sym_ord=varargin(3);
    if ((strcmpi(sym_ord,"bin")) & (strcmpi(sym_ord,"gray"))) then
        error("Invalid symbol ordering");
    end;
end;

//Check if x is one dimensional
wid=size(x,1);
if wid==1
	x=x(:);
end;

//Gray encoding
if (~strcmpi(sym_ord,'gray'))
    disp("gray coded")
    [x_gray,gray_map] = bin2grayfsk(x,M); 
    index=ismember(x,gray_map);
     x=index-1;
end

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
                OscPhase(iChan,:)=rem(OscPhase(iChan,:) + phIncrSym + phIncrSamp, 2*%pi);
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


//----------------------------------------------------------------------------------------------------------------------------

function [out]=rem(in1, in2)
//Remainder after division
//output is the remainder after in1 is divided by in2
    out=in1-fix(in1./in2).*in2;
endfunction

//----------------------------------------------------------------------------------------------------------------------------

function [z] = fskdemod(y,M,freq_sep,nSamp,varargin)
//FSKDEMOD Frequency shift keying demodulation
//   Z = FSKDEMOD(Y,M,FREQ_SEP,NSAMP) noncoherently demodulates the complex
//   envelope Y of a signal using the frequency shift keying method.  
//   M is the size of the alphabet(Has to be 2^integer).  
//   The output Z will have value from 0 to M-1.  
//   FREQ_SEP is the desired separation between successive frequencies, in Hz.  
//   NSAMP denotes the number of samples per symbol.  
//   If the signal is two dimensional, each column is treated as a channel.
//
//   Z = FSKDEMOD(Y,M,FREQ_SEP,NSAMP,FS) specifies the sampling frequency (Hz).
// 

//   Z = FSKDEMOD(Y,M,FREQ_SEP,NSAMP,Fs,SYMBOL_ORDER) specifies how 
//   the function assigns binary words to corresponding integers. 
//   Ordering could be 'bin' binary or 'gray' gray coded 

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

//Check number of arguments
[ll,rr] = argn(0)
funcprot(0);

if rr<4 then
	error("Too few input arguments.");
end;

if rr>6 then
	error("Too many input arguments.");
end;

//Check for M
if (~isreal(M) | (ceil(M)~=M) | M<=0) then
    error("M must be a scalar positive integer.");
end;

//Check that M is of the form 2^K
if ((ceil(log2(M)) ~= log2(M))) then
    error("M must be a power of 2.");
end;

//Check that the FREQ_SEP is greater than 0
if (~isreal(freq_sep) | ~(length(freq_sep)==1) | freq_sep<=0)     
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
    elseif (~isreal(Fs) | ~(length(Fs)==1) | Fs<=0) then
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

//Symbol order
if (rr==4 | rr==5) then
    sym_ord="bin";
else
    sym_ord=varargin(2);
    if (~(strcmpi(sym_ord,"bin")) & ~(strcmpi(sym_ord,"gray"))) then
        error("Invalid symbol ordering");
    end;
end;

//Check if y is one dimensional
wid=size(y,1);
if wid==1
	y=y(:);
end;

//Obtain the total number of channels
[nRows, nChan] = size(y);

// Preallocate memory
z = zeros(nRows/nSamp, nChan);

// Define the frequencies used for the demodulator.  
freqs = [-(M-1)/2 : (M-1)/2] * freq_sep;

// Use the frequencies to generate M complex tones which will be multiplied with
// each received FSK symbol.  The tones run down the columnns of the "tones"
// matrix.
t = [0 : samp_time : (nSamp*samp_time) - samp_time]';
phase = 2*%pi*t*freqs;
tones = exp(-%i*phase);

// For each FSK channel, multiply the complex received signal with the M complex
// tones.  Then perform an integrate and dump over each symbol period, find the
// magnitude, and choose the transmitted symbol corresponding to the maximum
// magnitude.
for iChan = 1 : nChan       // loop for each FSK channel
    
    for iSym = 1 : nRows/nSamp
        
        // Load the samples for the current symbol
        yTemp = y( (iSym-1)*nSamp+1 : iSym*nSamp, iChan);
        
        // Replicate the received FSK signal to multiply with the M tones
        yTemp = yTemp(:, ones(M,1));

        // Multiply against the M tones
        yTemp = yTemp .* tones;

        // Perform the integrate and dump, then get the magnitude.  Use a
        // subfunction for the integrate and dump, to omit the error checking.
        yMag = abs(intanddump(yTemp, nSamp));
        // Choose the maximum and assign an integer value to it.  Subtract 1 from the
        // output of MAX because the integer outputs are zero-based, not one-based.
        [maxVal, maxIdx] = max(yMag, 'c');
        maxIdx=maxIdx.';
        z(iSym, iChan) = (maxIdx - 1);
        
       end;
end;

// Gray decode if necessary
if (~strcmpi(sym_ord,'gray'))
    disp("gray decoded")
    [z_degray,gray_map] = gray2binfsk(z,M); 
    z = gray_map(z+1);
end

// Restore the output signal to the original orientation
if(wid == 1)
    z = z';
end
endfunction 

//----------------------------------------------------------------------------------------------------------------------------

//Added as a standalone function intdump(x,Nsamp)
function [y] = intanddump(x, Nsamp)
//INTANDDUMP Integrate and dump.
//   Y = INTANDDUMP(X, NSAMP) integrates the signal X for 1 symbol period, then
//   outputs one value into Y. NSAMP is the number of samples per symbol.
//   For two-dimensional signals, the function treats each column as 1
//   channel.

// Assure that X, if one dimensional, has the correct orientation 
wid = size(x,1);
if(wid ==1)
    x = x(:);
end

[xRow, xCol] = size(x);
x = mean(matrix(x, Nsamp, xRow*xCol/Nsamp), 'r');
y = matrix(x, xRow/Nsamp, xCol);      

//restore the output signal to the original orientation 
if(wid == 1)
    y = y.';
end
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [output, mapping] = bin2grayfsk(x, order)
//Convert a binary number to a gray number for fsk        

        //Calculate Gray table
        num = (0:order-1)';
        binary_num =dec2bin(x);
        for i=1:(order)
            shifted = floor(2^(-1)*num(i));
            mapping(i)=bitxor(shifted,num(i));
        end

        // Format output and translate x (map) i.e. convert to Gray
        for j=1:order
            temp=mapping(j)+1;
            output(j)=x(temp);
        end
        
        // Assure that the output, if one dimensional and has the correct orientation
        wid = size(x,1);
        if(wid == 1)
            output = output';
        end
       
endfunction
//----------------------------------------------------------------------------------------------------------------------------------

function [a] = ismember(x, y)
    for i=1:length(x)
        index(i)=find(y(:)==x(i))
    end
    a=index;
endfunction

//----------------------------------------------------------------------------------------------------------------------------------

function [output, mapping]=gray2binfsk(x, order)
        //Calculate Gray table
        num = (0:order-1)';
        binary_num =dec2bin(x);
        for i=1:(order)
            shifted = floor(2^(-1)*num(i));
            mapping(i)=bitxor(shifted,num(i));
        end
        index=ismember(x,mapping);
        output=index-1;
endfunction
