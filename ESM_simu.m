%% Predefine
clear all;close all;clc;
time_now=datestr(now,30);
global img_save_path
img_save_path = fullfile('source',time_now,'images');
scr_save_path = fullfile('source',time_now,'scripts');
vedio_save_path = fullfile('source',time_now,'videos');
mkdir(fullfile('source',time_now));
mkdir(img_save_path);
mkdir(scr_save_path);
mkdir(vedio_save_path);
copyfile('*.m',scr_save_path);


L=.4;Zscan=.3;bb=0;
Xmin=-L;Xmax=L;
Ymin=-L;Ymax=L;
nx=200;ny=200;
[XXs,YYs]=ndgrid(linspace(Xmin,Xmax,nx),linspace(Ymin,Ymax,ny));
ZZs=Zscan*ones(size(XXs));
freq=10e9;   %frequency
c=3e8;      %velocity of light
w=2*pi*freq;    %omega
lambda=c/freq;  %wavelength
ep0=1/(36*pi*1e9);
u0=4*pi*1e-7;
[Ex,Ey,Ez] = genField(freq,ZZs,YYs,XXs);
x=unique(XXs);y=unique(YYs);
dx=x(2)-x(1);dy=y(2)-y(1);
Escan=Ex;
pv1=(sqrt(Ex.^2+Ey.^2));
 

%% draw the graph scaned from a certain distance Zscan
figure
dbEx = db(Ex);
surf(XXs,YYs,db(Ex),'EdgeColor','none')
colorbar;
title('Scanned total field, dB(V/m)');
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
view(2);
set(gca,'CLim',[max(max(dbEx))-15 max(max(dbEx))]);
axis tight;
filename = ['Scanned total field','.jpg'];
saveas(gcf,fullfile(img_save_path,filename));

%% dbEx0为最后要求的Image 
[dbEx0Ori,pvOri] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,Ex,Ey );
showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0Ori,pvOri, 'Fully Scanned RTF, dB(V/m)' );
shapeEx = size(Ex);
samplenum = 100;
samplexdis = 29;
sampleydis = 29;
samplexnum = floor(shapeEx(2)/samplexdis);
sampleynum = floor(shapeEx(1)/sampleydis);


%% Initial scan points's Image
IniEx = Ex; IniEy = Ey;
for i = 1:shapeEx(1)
    if mod(i,sampleydis)~=0
        IniEx(i,:)=0;
        IniEy(i,:)=0;
    end
end
for j = 1:shapeEx(2)
    if mod(j,samplexdis)~=0
        IniEx(:,j)=0;
        IniEy(:,j)=0;
    end
end

[dbEx0,pv] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,IniEx,IniEy );
showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0,pv, 'Uniformly Scanned RTF, dB(V/m)' );



%% Randomly chosen initial scan points
randini_points_num = 72;
randinipoints=randperm(shapeEx(1)*shapeEx(2),randini_points_num);
RandiniEx = Ex; RandiniEy = Ey;
for i = 1:shapeEx(1)
    for j = 1:shapeEx(2)
        if ~ismember((i*shapeEx(2)+j),randinipoints)
            RandiniEx(i,j)=0;
            RandiniEy(i,j)=0;
        end
    end
end
[dbEx0Randini,pvRandini] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,RandiniEx,RandiniEy);
showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0Randini,pvRandini,...
    sprintf('Randomly Scanned RTF(%d points for Init), dB(V/m)',randini_points_num));%5


%% Region-based randomly choose scan points
randini_points_num = 1;
sep_num = 8;
num = 0;
cube_len = [floor(shapeEx(1)/sep_num),floor(shapeEx(2)/sep_num)];
RandiniEx = Ex; RandiniEy = Ey;
% randinipoints = randperm(cube_len(1)*cube_len(2),randini_points_num);
for i0 = 1:sep_num
    for j0 = 1:sep_num
        if (i0==1&&j0==1)||(i0==1&&j0==cube_len(2))||...
           (i0==cube_len(1)&&j0==1)||(i0==cube_len(1)&&j0==cube_len(2))
            randini_points_num = 2;
        elseif i0==1||i0==cube_len(1)||j0==1||j0==cube_len(2)
            randini_points_num = randi(2);
        else
            randini_points_num = 1;
        end
        
        randinipoints = randperm(cube_len(1)*cube_len(2),randini_points_num);
        for k = 1:randini_points_num
            RPs(num+k).x = (i0-1)*cube_len(1)+floor(randinipoints(k)/cube_len(2));
            RPs(num+k).y = (j0-1)*cube_len(2)+mod(randinipoints(k),cube_len(2));
            if RPs(num+k).y == 0
                RPs(num+k).y =1;
            end
        end
        num = num + randini_points_num;
        for i = 1:cube_len(1)
            for j = 1:cube_len(2)
                realx = (i0-1)*cube_len(1)+i;
                realy = (j0-1)*cube_len(2)+j;
                if ~ismember((i*cube_len(2)+j),randinipoints)
                    RandiniEx(realx,realy)=0;
                    RandiniEy(realx,realy)=0;
                end
            end
        end
    end
end
[dbEx0Randini,pvRandini] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,RandiniEx,RandiniEy);
showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0Randini,pvRandini,...
    sprintf('Region-based randomly chosen points RTF(%d points for Init), dB(V/m)',...
    randini_points_num*sep_num^2));%5



%% Gradient Ascend Algorithm
ADD_UNI = false;
if ADD_UNI
    TempEx=zeros(shapeEx);
    TempEy=zeros(shapeEx);
    for i = 1:shapeEx(1)
        for j = 1:shapeEx(2)
            if RandiniEx(i,j)~=0
                TempEx(i,j)=RandiniEx(i,j);
            elseif IniEx(i,j)~=0
                TempEx(i,j)=IniEx(i,j);
            end
            if RandiniEy(i,j)~=0
                TempEy(i,j)=RandiniEy(i,j);
            elseif IniEy(i,j)~=0
                TempEy(i,j)=IniEy(i,j);
            end

        end
    end
else
    TempEx=RandiniEx;TempEy=RandiniEy;
end

STDTempEx=TempEx;STDTempEy=TempEy;
dif_gate = 160; gra_gate = 5;ex_gate=1;step_len=10;circlerad = 6;
difs=[];gras=[];
vedio1_path = fullfile(vedio_save_path,'GAA_RFT.avi');
% vedio2_path = fullfile(vedio_save_path,'points.avi');

% writerObj1=VideoWriter(vedio1_path);  % 定义一个视频文件用来存动画
% open(writerObj1);                    % 打开该视频文件

% writerObj2=VideoWriter(vedio2_path);  % 定义一个视频文件用来存动画
% open(writerObj2);                    % 打开该视频文件

oddeven=0;
% figure('rend','painters','pos',[10 10 1000 900]);
for i = 1:ceil(num/2)
    for oddeven = 0:1
        if oddeven ==0 
            xtemp = RPs(i).x;
            ytemp = RPs(i).y;
        else
            if mod(num,2)~=0 && i ==ceil(num/2)
                break;
            end
            xtemp = RPs(num+1-i).x;
            ytemp = RPs(num+1-i).y;
        end
        n1=0;n2=0;
        while(n2<=2&&n1<=6)
            bb=bb+1;
            [dbEx0Temp0,pvTemp0] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,TempEx,TempEy );
            G=compute_gra_img(XXs,YYs,dbEx0Randini,80);
            [xtemp,ytemp,gra] = nextStep( dbEx0Temp0,abs(TempEx),xtemp,ytemp,...
                (4+10/(3*G(xtemp,ytemp)+1)));
%                     floor(max((step_len-5*G(i,j)),3)));%max((step_len-(9-n1)*n1/2),4) );abs(TempEx)
            if gra == -1
                break; 
            elseif gra == -2
                randregs = randi(360,1,3)*pi/180;
                regxs = floor(x+cos(randregs)*circlerad);
                regys = floor(y+sin(randregs)*circlerad);
                for k = 1:3
                    if regxs(k)>=1&&regxs(k)<=shapeEx(1)&&regys(k)>=1&&regys(k)<=shapeEx(2)
                        TempEx(regxs(k),regys(k)) = Ex(regxs(k),regys(k));%maybe ques
                    end
                end
            else
                TempEx(xtemp,ytemp)= Ex(xtemp,ytemp);%maybe ques
            end

            [dbEx0Temp,pvTemp] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,TempEx,TempEy );
            fig_title = ["GAA, RTF, dB(V/m)","GAA, Sample Points Distribution","Fully Scanned RTF, dB(V/m)","GGA RTF Gradient Map"];
%             frame = drawVedioFrame( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0Ori,pvori,dbEx0Temp,pvTemp,G,abs(TempEx),fig_title);
%             frame = getDbEx0Frame( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0Temp0,pvTemp0,...
%                 'Gradient Ascend Algorithm, RTF, dB(V/m)' );%6
%             writeVideo(writerObj1,frame); % 将帧写入视频
            dif = computeImgDif( dbEx0Temp,dbEx0Temp0 );
            difs=[difs,dif];gras=[gras,gra];
%             frame = getView2Frame(XXs,YYs,abs(TempEx),'GAA, Sample Points Distribution');
%             writeVideo(writerObj2,frame); % 将帧写入视频

            if (dif>dif_gate||gra>gra_gate)&&Ex(xtemp,ytemp)>ex_gate
                n1=n1+1;
            else
                n2=n2+1;
            end
            dbEx0Temp0=dbEx0Temp;pvTemp0=pvTemp;
        end
    end
end
% close(writerObj1); %// 关闭视频文件句柄
% close(writerObj2); %// 关闭视频文件句柄

showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0Temp0,pvTemp0,'Gradient Ascend Algorithm, RTF, dB(V/m)' );%6
showView2(XXs,YYs,abs(TempEx),'GAA, Sample Points Distribution');
ju=(TempEx~=0);
res = tabulate(ju(:))

%% Locate the source precisely
dbEx0Temp0copy = dbEx0Temp0;
max_img_val = max(dbEx0Temp0(:));
[maxx,maxy] = find(dbEx0Temp0==max_img_val);
filtered_img = zeros(shapeEx);
counter = 0;
while counter<4
%     for i = (maxx-6):(maxx+6)
%        for j = (maxy-6):(maxy+6)
%            dist = sqrt((i-maxx)^2+(j-maxy)^2);
%            if i>0 && j>0 && i<shapeEx(1) && j<shapeEx(2) && dist<=5
%                filtered_img(i,j) = dbEx0Temp0(i,j); 
%            end
%            dbEx0Temp0(i,j) = 0;
%        end
%     end
    J = regionGrow(dbEx0Temp0,maxx,maxy);
    filtered_img = filtered_img + J;
    dbEx0Temp0 = dbEx0Temp0 .* ~J;
    max_img_val = max(dbEx0Temp0(:));
    [maxx,maxy] = find(dbEx0Temp0==max_img_val);
    counter=counter+1;
end
showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,filtered_img,pvTemp0,...
    sprintf('Filtered GAA RTF, dB(V/m)'));%4

%% Randomly chosen scan points' Image
rand_points_num = res{2,2};
randpoints=randperm(shapeEx(1)*shapeEx(2),rand_points_num);
RandEx = Ex; RandEy = Ey;
for i = 1:shapeEx(1)
    for j = 1:shapeEx(2)
        if ~ismember((i*shapeEx(2)+j),randpoints)
            RandEx(i,j)=0;
            RandEy(i,j)=0;
        end
    end
end
[dbEx0Rand,pvRand] = getdbEx0( ep0,u0,freq,x,dx,y,dy,Zscan,RandEx,RandEy);
showDbEx0( Xmin,Xmax,Ymin,Ymax,XXs,YYs,dbEx0Rand,pvRand,...
    sprintf('Randomly Scanned RTF(%d points), dB(V/m)',rand_points_num));%4


