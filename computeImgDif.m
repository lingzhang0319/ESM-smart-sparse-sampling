function [ dif ] = computeImgDif( img1,img2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
imgdif=img1-img2;
imgdifsq = imgdif.^2;
dif=sqrt(sum(imgdifsq(:)));
end

