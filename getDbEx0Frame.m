function [ frame ] = getDbEx0Frame( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0,pv,fig_title )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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
frame = getframe(gcf);            % ��ͼ�������Ƶ�ļ���
frame.cdata = imresize(frame.cdata, [875 1667]); % ������Ƶ��ߣ�HΪ����(��)��WΪ����(��)

end

