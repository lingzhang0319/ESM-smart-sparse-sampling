function [ bestX,bestY,biggest_dif ] = nextStep( W,STD,x,y,step_len )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

%% New Method based on generated image
radius = 15;
sizeW = size(W);
bestX=x;bestY=y;
tarX=x;tarY=y;
max_val = W(x,y);
biggest_dif=0;
for i=[(x-radius):(x+radius)]
    for j=[(y-radius):(y+radius)]
        if i>0&&j>0&&i<sizeW(1)&&j<sizeW(2)&&W(i,j)>=max_val
            max_val = W(i,j);
            dist =sqrt((i-x)^2+(j-y)^2);
            tarX=i;tarY=j;
%             bestX=x+sign(i-x)*step_len;bestY=y+sign(j-y)*step_len;
            if dist>=5
                bestX=floor(x+sign(i-x)*abs(i-x)*step_len/dist);
                bestY=floor(y+sign(j-y)*abs(j-y)*step_len/dist);
                biggest_dif = W(i,j)-W(x,y);
            else
                bestX=i;bestY=j;
                biggest_dif = -2;return;
            end
%             disp(bestX);disp(bestY);
        end
    end
end

%% Old method based on scanned points
% radius = 21;
% sizeW = size(W);
% bestX=x;bestY=y;
% biggest_dif=0;
% for i=[(x-radius):(x+radius)]
%     for j=[(y-radius):(y+radius)]
%         if i>0&&j>0&&i<sizeW(1)&&j<sizeW(2)&&W(i,j)~=0
%             dif = (W(i,j)-W(x,y))/(sqrt((i-x)^2+(j-y)^2));
%             if dif>=biggest_dif
%                 bestX=x+sign(i-x)*step_len;bestY=y+sign(j-y)*step_len;
%                 biggest_dif = dif;
%             end
%         end
%     end
% end

%% If there is no change, then randomly chose a direction
if bestX==x&&bestY==y
    bestX=x+step_len*randi([-1,1],1,1);
    bestY=y+step_len*randi([-1,1],1,1);
end

%% To make sure that the new step is in the board
if bestX>sizeW(1)
    bestX=sizeW(1);
    biggest_dif = -1;return;
end
if bestX<1
    bestX=1;
    biggest_dif = -1;return;
end
if bestY>sizeW(2)
    bestY=sizeW(2);
    biggest_dif = -1;return;
end
if bestY<1
    bestY=1;
    biggest_dif = -1;return;
end

%% Avoid the density in some certain area to be too high
count = 0;
for i = [(bestX-1):(bestX+1)]
    for j = [(bestY-1):(bestY+1)]
        if i<1||j<1||i>sizeW(1)||j>sizeW(2)
            count=count+1; 
        elseif STD(i,j)~=0
            count=count+1;
        end
    end
end 
if count>=1
   biggest_dif=-1; return;
end

count = 0;
for i = [(bestX-2):(bestX+2)]
    for j = [(bestY-2):(bestY+2)]
        if i<1||j<1||i>sizeW(1)||j>sizeW(2)
            count=count+1; 
        elseif STD(i,j)~=0
            count=count+1;
        end
    end
end 
if count>=2
   biggest_dif=-1; 
end

count = 0;
for i = [(bestX-3):(bestX+3)]
    for j = [(bestY-3):(bestY+3)]
        dist = sqrt((i-bestX)^2+(j-bestY)^2);
        if i<1||j<1||i>sizeW(1)||j>sizeW(2)
            count=count+1; 
        elseif STD(i,j)~=0&&dist<=3
            count=count+1;
        end
    end
end 
if count>=5
   biggest_dif=-1; 
end

count = 0;
for i = [(bestX-5):(bestX+5)]
    for j = [(bestY-5):(bestY+5)]
        dist = sqrt((i-bestX)^2+(j-bestY)^2);
        if i<1||j<1||i>sizeW(1)||j>sizeW(2)
            count=count+1; 
        elseif STD(i,j)~=0&&dist<=5
            count=count+1;
        end
    end
end 
if count>=8
   biggest_dif=-1; 
end

count = 0;
for i = [(tarX-6):(tarX+6)]
    for j = [(tarY-6):(tarY+6)]
        dist = sqrt((i-tarX)^2+(j-tarY)^2);
        if i<1||j<1||i>sizeW(1)||j>sizeW(2)
            count=count+1; 
        elseif STD(i,j)~=0&&dist<=5
            count=count+1;
        end
    end
end 
if count>=12
   biggest_dif=-1; 
end



end
