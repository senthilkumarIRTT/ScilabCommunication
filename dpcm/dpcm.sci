function [indx, quanterr] = dpcmenco(x, codebook, partition, predictor)
//Differentially Pulse Coded Modulation Encoding

//INDX = DPCMENCO(x, CODEBOOK, PARTITION, PREDICTOR) produces
//   differential pulse code modulation (DPCM) encoded index INDX. The
//   signal to be encoded is x. The predictive transfer function is
//   provided in PREDICTOR.

// [INDX, QUANTERR] = DPCMENCO(SIG, CODEBOOK, PARTITION, PREDICTOR) outputs the quantized value in QUANTERR.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay

[ll,rr] = argn(0)
funcprot(0);

//Check number of arguments
if rr<4 then
  error("Not enough input variables for DPCMENCO.");
end;

//Check for vector size
if ((length(codebook)-1) ~= length(partition)) then    
  error("The vector size for PARTITION must be the size of CODEBOOK-1.");
end;

if (length(predictor) < 2)
  error("The vector size for PREDICTOR must be more than 1.");
end;

len_predictor = length(predictor) - 1;
predictor = predictor(2:len_predictor+1);
predictor = predictor(:)';
len_x = length(x);

z = zeros(len_predictor, 1);
for i = 1 : len_x;
    out = predictor * z;
    e = x(i) - out;
    // index
    indx(i) = sum(partition < e);
    // quantized value
    quanterr(i) = codebook(indx(i) + 1);
    inp = quanterr(i) + out;
    // renew the estimated output
    z = [inp; z(1:len_predictor-1)];
end;
endfunction


function [y, quanterr] = dpcmdeco(indx, codebook, predictor)
//Differentially Pulse Coded Modulation Decoding

//Y = DPCMDECO(INDX, CODEBOOK, PREDICTOR) produces
//   differential pulse code modulation (DPCM) decoded index signal Y.
//The predictive transfer function is provided in PREDICTOR.
//The predictive-error quantization codebook is given in CODEBOOK. 
//   provided in PREDICTOR.

// [Y, QUANTERR] = DPCMDECO(INDX, CODEBOOK, PREDICTOR) outputs the quantized predictor error in QUANTERR.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay

[ll,rr] = argn(0)
funcprot(0);

//Check number of arguments
if rr<3 then
  error("Not enough input variables for DPCMENCO.");
end;

len_predictor = length(predictor) - 1;
predictor = predictor(2:len_predictor+1);
predictor = predictor(:)';
len_indx = length(indx);

quanterr = indx;
quanterr = codebook(indx+1);

z = zeros(len_predictor, 1);
for i = 1 : len_indx;
    out = predictor * z;
    y(i) = quanterr(i) + out;
    // renew the estimated output
    z = [y(i); z(1:len_predictor-1)];
end;

endfunction
