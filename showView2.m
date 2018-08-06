function [] = showView2( XXs,YYs,W,fig_title )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global img_save_path
figure;
surf(XXs,YYs,W);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
title(fig_title);
colorbar;
axis tight;
shading flat;
view(2);
filename = [fig_title,'.jpg'];
filepath = fullfile(img_save_path,filename);
disp(filepath);
saveas(gcf,filepath);
end

