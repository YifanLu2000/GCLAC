function  plot_cluster(I1,I2,X,Y,clusters)
N = size(X,1);
IDX1 = zeros(N,1);
for i = 1:size(clusters,2)
    IDX1(find(clusters(:,i)~=0)) = i;
end
interval = 20; SS = 2000;
siz1 = size(I1);
siz2 = size(I2);
IDX2 = find(IDX1>0);
if length(IDX2)>SS
    temp = IDX2(randperm(length(IDX2),SS));
    id = IDX1.*0;
    id(temp) = IDX1(temp);
    IDX1 = id;
end
idx1 = find(IDX1==1);
idx2 = find(IDX1==2);
idx3 = find(IDX1==3);
idx4 = find(IDX1==4);
idx5 = find(IDX1==5);
idx6 = find(IDX1==6);
idx7 = find(IDX1==7);

Imgheight = max(siz1(1),siz2(1));
WhiteInterval = 255*ones(Imgheight, interval, 3);
if siz1(1) == Imgheight
    imgtemp = zeros(Imgheight,siz2(2),3);
    imgtemp(1:siz2(1),:,:) = I2;
    I2 = imgtemp;
else
    imgtemp = zeros(Imgheight,siz1(2),3);
    imgtemp(1:siz1(1),:,:) = I1;
    I1 = imgtemp;
end
WhiteInterval = 255*ones(size(I1,1), interval, 3);
imagesc(cat(2, I1, WhiteInterval, I2)) ;

% WhiteInterval = 255*ones(size(I1,1), interval, 3);
% cc = [84 134 135
%     240 100 73
%     62 43 109
%     255 170 50
%     ]/255;
cc = [];
cc = [cc;
    0 0.0 0.95
     0.0 0.9 0.6
     0.9 0.6 0.0
     0.9 0 0.6
     0.6 0.9 0.1
     0.6 0.0 0.9
     0.9 0.2 0.0];

% imagesc(cat(2, I1, WhiteInterval, I2)) ;
hold on ;
linew = 0.5;
FalseNeg = idx1;
line([X(FalseNeg,1)'; Y(FalseNeg,1)'+size(I1,2)+interval], [X(FalseNeg,2)' ;  Y(FalseNeg,2)'],'linewidth', linew, 'color', cc(1,:)) ;%'g'
TruePos = idx2;
line([X(TruePos,1)'; Y(TruePos,1)'+size(I1,2)+interval], [X(TruePos,2)' ;  Y(TruePos,2)'],'linewidth', linew, 'color',cc(2,:) ) ;%[0,0.5,0.8]
FalsePos = idx3;
line([X(FalsePos,1)'; Y(FalsePos,1)'+size(I1,2)+interval], [X(FalsePos,2)' ;  Y(FalsePos,2)'],'linewidth', linew, 'color',cc(3,:)) ;%  [0.8,0.1,0]
line([X(idx4,1)'; Y(idx4,1)'+size(I1,2)+interval], [X(idx4,2)' ;  Y(idx4,2)'],'linewidth', linew, 'color',cc(4,:) ) ;%[0,0.5,0.8]
line([X(idx5,1)'; Y(idx5,1)'+size(I1,2)+interval], [X(idx5,2)' ;  Y(idx5,2)'],'linewidth', linew, 'color',cc(5,:) ) ;%[0,0.5,0.8]
line([X(idx6,1)'; Y(idx6,1)'+size(I1,2)+interval], [X(idx6,2)' ;  Y(idx6,2)'],'linewidth', linew, 'color',cc(6,:) ) ;%[0,0.5,0.8]
line([X(idx7,1)'; Y(idx7,1)'+size(I1,2)+interval], [X(idx7,2)' ;  Y(idx7,2)'],'linewidth', linew, 'color',cc(7,:) ) ;%[0,0.5,0.8]

axis equal ; 
axis([0 (siz1(2)+siz2(2)+20) 0 Imgheight]);
set(gca,'XTick',-2:1:-1)
set(gca,'YTick',-2:1:-1)