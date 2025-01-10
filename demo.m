clc,clear all;
close all;
warning off;
initialization;
load('book.mat'); img1 = imread('book_l.jpg'); img2 = imread('book_r.jpg');
% load('church.mat'); img1 = imread('church_l.jpg'); img2 = imread('church_r.jpg');
N = size(X,1);
if size(img1,3)==1
    img1=repmat(img1,[1 1 3]);
end
if size(img2,3)==1
    img2=repmat(img2,[1 1 3]);
end
tic
[inliers,clusters,W] = GCLAC(X,Y);
time = toc;
figure;
plot_matches(img1, img2, X, Y, CorrectIndex, CorrectIndex);
correctind = length(intersect(inliers,CorrectIndex));
disp('**************** Results for GC-LAC ****************')
fprintf('classes = %d\n',size(clusters,2));
[inlier_num,inlierRate,precision_rate,Recall_rate] = evaluatePR(X,CorrectIndex,inliers);
fprintf('runtime = %.3fs\n',time/10);
fprintf('precision_rate = %d / %d = %2.4f\n',correctind, length(inliers), precision_rate*100);
fprintf('Recall_rate = %d / %d = %2.4f\n', correctind, length(CorrectIndex), Recall_rate*100);
figure;
plot_cluster(img1,img2,X,Y,clusters); % plot 200 matches at most for visibility
