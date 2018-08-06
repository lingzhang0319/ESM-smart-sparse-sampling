function [Ex,Ey,Ez,Hx,Hy,Hz]=dipole_field1(I0l,f,x0,y0,z0,X,Y,Z)
% I0l - dipole current
% f - frequency
% x0,y0,z0 - coordinates of the dipole
% X,Y,Z - coordinates of the observation points
 
k=2*pi*f/299792458;
eta=119.91*pi;

Ex=zeros(size(X));
Ey=zeros(size(X));
Ez=zeros(size(X));
Hx=zeros(size(X));
Hy=zeros(size(X));
Hz=zeros(size(X));
for i=(1:numel(X))
    X0=X(i)-x0;
    Y0=Y(i)-y0;
    Z0=Z(i)-z0;
   
    r=sqrt(X0^2+Y0^2+Z0^2);
    theta=atan2(sqrt(X0.^2+Y0.^2),Z0);
    phi=atan2(Y0,X0);
   
    C2S=[sin(theta)*cos(phi) cos(theta)*cos(phi) -sin(phi);...
    sin(theta)*sin(phi) cos(theta)*sin(phi)  cos(phi);...
     cos(theta)          -sin(theta)          0];
  
    Hr=0;
    Hth=0;
    Hph=1i*k*I0l*sin(theta)/4/pi/r*(1+1/1i/k/r)*exp(-1i*k*r);

    Er=eta*I0l*cos(theta)/2/pi/r^2*(1+1/1i/k/r)*exp(-1i*k*r);
   
    Eth=1i*eta*k*I0l*sin(theta)/4/pi/r*(1+1/1i/k/r-1/(k*r)^2)*exp(-1i*k*r);

    Eph=0;

    Ecart=C2S*[Er;Eth;Eph];
    Hcart=C2S*[Hr;Hth;Hph];

    Ex(i)=Ecart(1);
    Ey(i)=Ecart(2);
    Ez(i)=Ecart(3);

    Hx(i)=Hcart(1);
    Hy(i)=Hcart(2);
    Hz(i)=Hcart(3);
   
 
end