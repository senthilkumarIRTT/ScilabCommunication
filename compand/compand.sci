function [out] = compand(in, param, V, method)
//OUT = COMPAND(IN, PARAM, V) computes mu-law compressor with mu given
//   in PARAM and the peak magnitude given in V.

//   OUT = COMPAND(IN, PARAM, V, METHOD) computes mu-law or A-law
//   compressor or expander computation with the computation method given
//   in METHOD. PARAM provides the mu or A value. V provides the input
//   signal peak magnitude. METHOD can be chosen as one of the following:
//   METHOD = 'mu/compressor' mu-law compressor.
//   METHOD = 'mu/expander'   mu-law expander.
//   METHOD = 'A/compressor'  A-law compressor.
//  METHOD = 'A/expander'    A-law expander.

//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

[ll,rr] = argn(0)
funcprot(0);

if rr<3 then
	error("Not enough input parameters.");
elseif rr<4 
    method = 'mu/compressor';
    disp("less than 4")
//else 
////    if type(method~=10) then
////        error("Parameter METHOD in COMPAND must be a string.");   
////    end
//    method=convstr(method,"l");
end;

if (~isreal(in)| ~isreal(param) | ~isreal(V) ) then    
	error("Inputs IN, PARAM and V must be real numbers.");
end;

// mu-law compressor
if ~(strcmpi(method,"mu/compressor")) then
    out=V*((log(1 + (param * abs(in)/V)))/log(1 + param)).* sign(in);
// mu-law expander    
elseif ~(strcmpi(method,"mu/expander"))
    out =  (V/param)*((exp((abs(in)/V)*log(1+param)))-1).* sign(in);
//A-law
elseif ~(strcmpi(method, 'a/compressor')) | ~(strcmpi(method, 'a/expander'))
    lnAp1 = log(param) + 1;
    VdA   = V / param;
    if ~(strcmpi(method, 'a/compressor'))
        // A-law compressor
        indx = find(abs(in) <= VdA);
        if ~isempty(indx)
            out(indx) = param / lnAp1 * abs(in(indx)) .* sign(in(indx));
        end
        indx = find(abs(in) >  VdA);
        if ~isempty(indx)
            out(indx) = V / lnAp1 * (1 + log(abs(in(indx)) / VdA)) .* sign(in(indx));
        end
    else
        //A-law expander
        VdlnAp1 = V / lnAp1;
        indx = find(abs(in) <= VdlnAp1);
        if ~isempty(indx)
            out(indx) = lnAp1 / param * abs(in(indx)) .* sign(in(indx));
        end
        indx = find(abs(in) >  VdlnAp1);
        if ~isempty(indx)
            out(indx) = VdA * exp(abs(in(indx)) / VdlnAp1 - 1) .* sign(in(indx));
        end
    end
else 
    error("Parameter METHOD has invalid value.")
end