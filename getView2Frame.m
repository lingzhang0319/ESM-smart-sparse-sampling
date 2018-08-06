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
frame = getframe(gcf);            % ��ͼ�������Ƶ�ļ���
frame.cdata = imresize(frame.cdata, [875 1667]); % ������Ƶ��ߣ�HΪ����(��)��WΪ����(��)
end

