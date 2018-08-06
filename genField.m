function [ Ex,Ey,Ez ] = genField( freq,ZZs,YYs,XXs )
% Generate Electronic and Magnetic Field by several dot sources 
%   Detailed explanation goes here
sour = struct('x',{0,-0.26,-0.15,0.14,-0.3,0.3},...
    'y',{0.15,0.2,-0.2,0.15,-0.3,0},...
    'z',{0},...
    'I',{1.5,1.5,1.5,1.5,0,0});%{1.2,2.5,2,1.4,0,0}

sour_len = length(sour);
for i = 1:sour_len
    [sour(i).Ex,sour(i).Ey,sour(i).Ez,sour(i).Hx,sour(i).Hy,sour(i).Hz]...
    = dipole_field1(sour(i).I,freq,sour(i).z,sour(i).y,sour(i).x,ZZs,YYs,XXs);
    if i == 1
        Ex = sour(i).Ez;
        Ey = sour(i).Ey;
        Ez = sour(i).Ex;
        Hx = sour(i).Hx;
        Hy = sour(i).Hy;
        Hz = sour(i).Hz;
    else
        Ex = Ex + sour(i).Ez;
        Ey = Ey + sour(i).Ey;
        Ez = Ez + sour(i).Ex;
        Hx = Hx + sour(i).Hx;
        Hy = Hy + sour(i).Hy;
        Hz = Hz + sour(i).Hz;        
    end
end

end

