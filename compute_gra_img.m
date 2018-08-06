function [ G ] = compute_gra_img( XXs,YYs,Q,Qgate )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    gate = prctile(Q(:),Qgate);
    P = arrayfun(@(x) cut(x,gate),Q);
    [aaa,bbb] = gradient(P);
    G = sqrt(aaa.^2+bbb.^2);
%     figure;surf(XXs,YYs,G);shading flat;view(2);colorbar; %db(Ex0)

end

