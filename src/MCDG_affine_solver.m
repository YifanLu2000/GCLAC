function [bestInliers, bestA] = MCDG_affine_solver(X0, Y0, motion_coherent, threshold)
N = size(X0,1);
Xt = [X0,ones(N,1)]';
Yt = [Y0,ones(N,1)]';
init_inliers = find(motion_coherent > 0.7);
A = weightedNorm3Point(Xt(:,init_inliers),Yt(:,init_inliers),motion_coherent(init_inliers));
d = reprojectionDistanceAffine(Xt,Yt,A);
curInliers = find(d < threshold);
bestInliers = curInliers;
numBestInliers = length(bestInliers);
bestA = A;
irlsSteps = 4;
motion_coherent_constant = (1-motion_coherent)./motion_coherent;
alpha = 10;
beta = 100;
th_multiplier = 4; th_step_size = (th_multiplier*threshold - threshold)./irlsSteps;
s = 3;
for loirls = 0:irlsSteps
    % step 1
    p = exp(-(d/threshold).^2./alpha);
    p = p./(p+(motion_coherent_constant).^(beta / alpha).*exp(-1/alpha));
    p(isnan(p)) = 0;
    loind = find(d<=(th_multiplier*threshold - th_step_size*loirls));
    % step 2
    if length(loind) >= s
        loind2 = randsample(loind, min(s*7, length(loind)));
        A = weightedNorm3Point(Xt(:, loind2), Yt(:, loind2), p(loind2));
    end
    d = reprojectionDistanceAffine(Xt,Yt,A);
    loind = find(d<=threshold);
    if length(loind) > numBestInliers
        bestInliers = loind;
        numBestInliers = length(bestInliers);
        bestA = A;
    end
    alpha = alpha * 0.5;
    beta = beta * 0.5;
end