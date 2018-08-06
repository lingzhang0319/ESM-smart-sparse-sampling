function [ frame ] = drawVedioFrame( Xmin,Xmax,Ymin,Ymax,XXs,YYs,...
    dbEx0Ori,pvOri,dbEx0Temp,pvTemp,Gra,W,fig_title )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% figure('rend','painters','pos',[10 10 1000 900]);
subplot(2,2,1);
surf(XXs,YYs,dbEx0Temp); 
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
axis equal;
colorbar;
axis tight;
shading flat;
view(2);
xlim([Xmin,Xmax]); % Limit the scale of x in the board
ylim([Ymin,Ymax]); % Limit the scale of y in the board
set(gca,'CLim',[max(max(pvTemp))-15 max(max(pvTemp))]);
title(fig_title(1));

subplot(2,2,2);
surf(XXs,YYs,W);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
axis equal;
colorbar;
axis tight;
shading flat;
view(2);
title(fig_title(2));

subplot(2,2,3);
surf(XXs,YYs,dbEx0Ori);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
axis equal;
colorbar;
axis tight;
shading flat;
view(2);
xlim([Xmin,Xmax]); % Limit the scale of x in the board
ylim([Ymin,Ymax]); % Limit the scale of y in the board
set(gca,'CLim',[max(max(pvOri))-15 max(max(pvOri))]);
title(fig_title(3));

subplot(2,2,4);
surf(XXs,YYs,Gra);
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
axis equal;
colorbar;
axis tight;
shading flat;
view(2);
title(fig_title(4));

frame = getframe(gcf);            % ��ͼ�������Ƶ�ļ���
% frame.cdata = imresize(frame.cdata, [875 1667]); % ������Ƶ��ߣ�HΪ����(��)��WΪ����(��)

end


