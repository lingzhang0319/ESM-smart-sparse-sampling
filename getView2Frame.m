function [ frame ] = getView2Frame( XXs,YYs,W,fig_title )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
surf(XXs,YYs,W);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
title(fig_title);
colorbar;
axis tight;
shading flat;
view(2);
frame = getframe(gcf);            % 把图像存入视频文件中
frame.cdata = imresize(frame.cdata, [875 1667]); % 设置视频宽高：H为行数(高)，W为列数(宽)
end

