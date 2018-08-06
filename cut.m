function [ output ] = cut( input,gate )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if input<gate
        output = gate;
    else
        output = input;
    end

end

