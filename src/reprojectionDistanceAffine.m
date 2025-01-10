function [d] = reprojectionDistanceAffine(X,Y,A)
d = sqrt(sum((Y - A*X).^2,1));
