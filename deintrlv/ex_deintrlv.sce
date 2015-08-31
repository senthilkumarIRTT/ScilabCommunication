//Written by Maitreyee Mordekar, FOSSEE, IIT Bombay.

//The intrlv function has to be loaded before executing this file. 
//Else it will throw errors.

x=[10:10:100];
disp(x)

elements=[2 3 4 1 5 8 7 6 9 10];
disp(elements)

y=intrlv(x, elements);
disp(y)

z=deintrlv(y,elements);
disp(z)
 