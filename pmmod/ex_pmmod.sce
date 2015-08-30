//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

Fs =200;
t = [0:Fs]'/Fs;
ini_phase =0;
Fc = 20; 
phasedev = 4;
x =-0.1*sin(2*%pi*t); 
y = pmmod(x,Fc,Fs,phasedev,ini_phase);



 z =fft(x);
 zz =abs(z(1:length(z)/2 ));
 axis = (0:Fs/length(zz):Fs -(Fs/length(zz)))/2;
 subplot(3,1,1); plot(x);
 title(' modulating signal');
 a3=get("current_axes");
 a4=a3.title;
a4.font_size=4; 
a4.font_style=8
subplot(3,1,2); plot(y);
title('Phase modulated signal');
a5=get("current_axes");
 a6=a5.title;
a6.font_size=4; 
a6.font_style=8
subplot(3,1,3); plot(axis,zz);
title('Spectrum of modulating signal');
a7=get("current_axes");
 a8=a7.title;
a8.font_size=4; 
a8.font_style=8
