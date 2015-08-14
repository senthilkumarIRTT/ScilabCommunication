//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

predictor = [0 1];
partition = [-1:.1:.9];
codebook = [-1:.1:1];
x=t;
encodedx = dpcmenco(x,codebook,partition,predictor);
decodedx = dpcmdeco(encodedx,codebook,predictor);
plot(x)
plot(decodedx,'red')

