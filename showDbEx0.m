function [] = showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0,pv,fig_title )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global img_save_path
figure
surf(XXs,YYs,dbEx0); %db(Ex0)
shading flat;
view(2);
axis tight;
xlabel('X (m)');
ylabel('Y (m)');
colorbar;
xlim([Xmin,Xmax]); % Limit the scale of x in the board
ylim([Ymin,Ymax]); % Limit the scale of y in the board
set(gca,'CLim',[max(max(pv))-15 max(max(pv))]);
title(fig_title);
xlabel('X (m)');
ylabel('Y (m)');
filename = [fig_title(1:(end-9)),'.jpg'];
filepath = fullfile(img_save_path,filename);
disp(filepath);
saveas(gcf,filepath);
end

