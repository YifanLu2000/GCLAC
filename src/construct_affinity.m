function [W, Lxy] = construct_affinity(X0, Y0, nc, sigma, epsilon, inlier_threshold)
% CONSTRUCT_AFFINITY - Constructs the affinity matrix for feature points
%
% Inputs:
%   X0, Y0           - Feature points in two images.
%   nc               - Controls the size of grid division (used to define grid intervals).
%   sigma            - Parameter controlling weighting in affinity matrix.
%   epsilon          - Parameter for motion coherence filtering.
%   inlier_threshold - Threshold for identifying inliers.
%
% Outputs:
%   W                - Affinity matrix.
%   Lxy              - Grid-based location labels for each feature point.

% Number of feature points
N = size(X0, 1);

% Add homogenous coordinates for feature points
Xt = [X0, ones(N, 1)]';
Yt = [Y0, ones(N, 1)]';

% Normalize feature points to [0.01, 0.99]
Xn = (mapminmax(X0', 0.01, 0.99))';

% Divide feature space into grid intervals
interval = 1 / nc;
Lxy = floor(Xn ./ interval) + 1;

% Initialize affinity matrix
W = zeros(N, N);

% Iterate over grid cells
for xnum = 1:nc-1
    for ynum = 1:nc-1
        % Find local points within the sliding window
        local_points = find((Lxy(:, 1) == xnum | Lxy(:, 1) == xnum + 1) & ...
                            (Lxy(:, 2) == ynum | Lxy(:, 2) == ynum + 1));
        N_local_points = length(local_points);

        % Skip regions with insufficient points
        if N_local_points < 5 
            continue;
        end

        % Remove duplicate matches
        [idxUnique, ~] = removeRepeat(X0(local_points,:),Y0(local_points,:));
        local_points_no_repeat = local_points(idxUnique);

        % Compute local affine transformation
        [~, H] = MCDG_A(X0(local_points_no_repeat, :), ...
                            Y0(local_points_no_repeat, :), ...
                            inlier_threshold, epsilon);

        % Extract local feature points in homogenous coordinates
        Xc = Xt(:,local_points); 
        Yc = Yt(:,local_points);

        % Compute pairwise weights for affinity matrix
        for i = 1:N_local_points
            for j = i+1:N_local_points
                wij = 4.5-(norm(Yc(:,i)-Yc(:,j))-norm(H*(Xc(:,i)-Xc(:,j))))^2/sigma;
                
                % Update weights if current weight is larger
                if W(local_points(i),local_points(j))<wij
                    W(local_points(i),local_points(j)) = wij;
                    W(local_points(j),local_points(i)) = wij;
                end
            end
        end
    end
end
end
