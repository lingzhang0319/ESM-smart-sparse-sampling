function [ dbEx0,pv ] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,Ex,Ey )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Scale = 2*pi/abs(dx)/length(x);
Cut = floor((length(x)-1)/2)+1;
K=0:(length(x)-1);
K(K>=Cut) = K(K>=Cut)-length(x);
kx1 = K*Scale;
Scale = 2*pi/abs(dy)/length(y);
Cut = floor((length(y)-1)/2)+1;
K=0:(length(y)-1);
K(K>=Cut) = K(K>=Cut)-length(y);
ky1 = K*Scale;
[KX,KY]=ndgrid(kx1,ky1);
k=2*pi*freq*sqrt(ep0*u0);
focus=-Zscan; %focusing distance;
Kz=sqrt(k.^2-KX.^2-KY.^2);
ps=exp(-1i*((Kz)*focus)); 

EX=fft2(Ex);
EX0=EX.*ps;
Ex0=ifft2(EX0);
dbEx0=db(Ex0);

EY=fft2(Ey);
EY0=EY.*ps;
Ey0=ifft2(EY0);

pv=db(sqrt(Ex0.^2+Ey0.^2));

end

