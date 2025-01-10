function [FP,FN] = plot_matches(I1, I2, X, Y, VFCIndex, CorrectIndex)
%   PLOT_MATCHES(I1, I2, X, Y, VFCINDEX, CORRECTINDEX)
%   considers correct indexes and indexes reserved by VFC, and then 
%   only plots the ture positive with blue lines, false positive with red
%   lines, false negative with green lines. For visibility, it plots at
%   most NUMPLOT (Default value is 50) matches proportionately.
%   
% Input:
%   I1, I2: Tow input images.
%
%   X, Y: Coordinates of intrest points of I1, I2 respectively.
%
%   VFCIndex: Indexes reserved by VFC.
%
%   CorrectIndex: Correct indexes.
%
%   See also:: VFC().

% Define the most matches to plot
% NumPlot = 100000;
siz1 = size(I1);
siz2 = size(I2);
NumPlot = 1000;
n = size(X,1);
tmp=zeros(1, n);
tmp(VFCIndex) = 1;
tmp(CorrectIndex) = tmp(CorrectIndex)+1;
VFCCorrect = find(tmp == 2);
TruePos = VFCCorrect;   %Ture positive
tmp=zeros(1, n);
tmp(VFCIndex) = 1;
tmp(CorrectIndex) = tmp(CorrectIndex)-1;
FalsePos = find(tmp == 1); %False positive
tmp=zeros(1, n);
tmp(CorrectIndex) = 1;
tmp(VFCIndex) = tmp(VFCIndex)-1;
FalseNeg = find(tmp == 1); %False negative

FP = FalsePos;
FN = FalseNeg;

NumPos = length(TruePos)+length(FalsePos)+length(FalseNeg);
if NumPos > NumPlot
    t_p = length(TruePos)/NumPos;
    n1 = round(t_p*NumPlot);
    f_p = length(FalsePos)/NumPos;
    n2 = round(f_p*NumPlot);
    f_n = length(FalseNeg)/NumPos;
    n3 = round(f_n*NumPlot);
else
    n1 = length(TruePos);
    n2 = length(FalsePos);
    n3 = length(FalseNeg);
end

per = randperm(length(TruePos));
TruePos = TruePos(per(1:n1));
per = randperm(length(FalsePos));
FalsePos = FalsePos(per(1:n2));
per = randperm(length(FalseNeg));
FalseNeg = FalseNeg(per(1:n3));

% FalsePos = [FalsePos,24];

interval = 20;
Imgheight = max(siz1(1),siz2(1));
WhiteInterval = 255*ones(Imgheight,interval, 3);
if siz1(1) == Imgheight
    imgtemp = 255*ones(Imgheight,siz2(2),3);
    imgtemp(1:siz2(1),:,:) = I2;
    I2 = imgtemp;
else
    imgtemp = 255*ones(Imgheight,siz1(2),3);
    imgtemp(1:siz1(1),:,:) = I1;
    I1 = imgtemp;
end
% imagesc(cat(2, I1, WhiteInterval, I2));
imshow(cat(2, I1, WhiteInterval, I2), 'Border', 'tight');
hold on ;
% linwidth = 0.8;
linwidth = 0.5;
line([X(FalseNeg,1)'; Y(FalseNeg,1)'+size(I1,2)+interval], [X(FalseNeg,2)' ;  Y(FalseNeg,2)'],'linewidth', linwidth, 'color', 'g') ;%'g'
line([X(TruePos,1)'; Y(TruePos,1)'+size(I1,2)+interval], [X(TruePos,2)' ;  Y(TruePos,2)'],'linewidth', linwidth, 'color','b' ) ;%[0,0.5,0.8]
line([X(FalsePos,1)'; Y(FalsePos,1)'+size(I1,2)+interval], [X(FalsePos,2)' ;  Y(FalsePos,2)'],'linewidth', linwidth, 'color','r') ;%  [0.8,0.1,0]

plot(X(TruePos,1)',X(TruePos,2)','x','color','y');
plot(Y(TruePos,1)'+size(I1,2)+interval,Y(TruePos,2)','x','color','y');
plot(X(:,1)',X(:,2)','x','color','y');
plot(Y(:,1)'+size(I1,2)+interval,Y(:,2)','x','color','y');

% [inlier_num,inlierRate,precision_rate,Recall_rate] = evaluatePR(X0,CorrectIndex,inliers);
% msg = sprintf('Prec.: %.3f, Recall: %.3f, F1:%.3f',precision_rate,Recall_rate,2*(precision_rate*Recall_rate)/(precision_rate+Recall_rate));
% text(15, 15, msg, 'FontUnits', 'pixels', 'FontSize', 20, 'Color', [0.95,0.95,0.95], 'BackgroundColor', [0.2,0.2,0.2],'fontname','Arial','FontWeight','bold');
% axis equal ;
% axis([0 (size(I1,2)+size(I2,2)+20) 0 Imgheight]);
% set(gca,'XTick',-2:1:-1)
% set(gca,'YTick',-2:1:-1)
% hold off
% set(gca,'position',[0 0 1 1]);
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperUnits', 'points');
% set(gcf, 'PaperPosition', [0 0 0.5*(size(I1,2)+size(I2,2)) 0.5*Imgheight]);
% set(gcf, 'PaperSize', [0.5*(size(I1,2)+size(I2,2)) 0.5*Imgheight]);
% drawnow;