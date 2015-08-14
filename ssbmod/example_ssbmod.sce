//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

Fs =200;
t = [0:2*Fs+1]'/Fs;
ini_phase =0;
Fc = 50;//try fc=100, 1000 
x =sin(2*%pi*t); 
y = ssbmod(x,Fc,Fs,ini_phase,'upper');



 z =fft(y);
 zz =abs(z(1:length(z)/2+1 ));
 axis = (0:Fs/length(zz):Fs -(Fs/length(zz)))/2;
 subplot(3,1,1); plot(2+x);
 title(' modulating signal');
 a3=get("current_axes");
 a4=a3.title;
a4.font_size=4; 
a4.font_style=8
subplot(3,1,2); plot(y);
title('Amplitude modulated signal');
a5=get("current_axes");
 a6=a5.title;
a6.font_size=4; 
a6.font_style=8
subplot(3,1,3); plot(axis,zz);
title('Spectrum of amplitude modulated signal');
a7=get("current_axes");
 a8=a7.title;
a8.font_size=4; 
a8.font_style=8
