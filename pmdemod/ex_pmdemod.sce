//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

//Run ex_pmmod and then this example to check both modulation and demodulation.

//Fs =200;
//t = [0:Fs]'/Fs;
//ini_phase =0;
//Fc = 20; 
//phasedev = 4; 
g = pmdemod(y,Fc,Fs,phasedev,ini_phase);



 z1 =fft(g);
 zz1 =abs(z1(1:length(z1)/2 ));
 axis = (0:Fs/length(zz):Fs -(Fs/length(zz1)))/2;
 subplot(3,1,1); plot(y);
 title('Received signal');
 a3=get("current_axes");
 a4=a3.title;
a4.font_size=4; 
a4.font_style=8
subplot(3,1,2); plot(g);
title('Phase demodulated signal');
a5=get("current_axes");
 a6=a5.title;
a6.font_size=4; 
a6.font_style=8
subplot(3,1,3); plot(axis,zz1);
title('Spectrum of phase demodulated signal');
a7=get("current_axes");
 a8=a7.title;
a8.font_size=4; 
a8.font_style=8
