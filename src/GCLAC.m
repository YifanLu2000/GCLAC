function [inliers, clusters, Affinity] = GCLAC(X0, Y0, sigma, nc, MinPts, epsilon, inlier_threshold)
% GCLAC - Feature Matching via Graph Clustering with Local Affine Consensus
%
% Input:
%   X0, Y0          - Matrices of feature points (shape: Nx2).
%   sigma           - Scaling parameter for affinity computation (default: 10).
%   nc              - Controls the size of grid division (default: sqrt(N/4), clamped to [5, 15]). 
%   MinPts          - Minimum points required for clustering (default: 5).
%   epsilon         - Parameter controlling graph sparsity (default: 1e4).
%   inlier_threshold - Threshold for motion coherence filtering (default: 1).
%
% Output:
%   inliers         - Indices of inlier matches.
%   clusters        - Cluster assignments for matched features.
%   Affinity        - Weighted adjacency matrix of the constructed graph.
%
% Usage:
%   [inliers, clusters, Affinity] = GCLAC(X0, Y0);
%
% Example:
%   X0 = rand(100, 2); % Random feature points in image 1
%   Y0 = rand(100, 2); % Random feature points in image 2
%   [inliers, clusters, Affinity] = GCLAC(X0, Y0);
%
% Author:
%   Yifan Lu
%   Email: lyf048@whu.edu.cn
%   Paper: "Feature Matching via Graph Clustering with Local Affine Consensus"
%   Published in: International Journal of Computer Vision (IJCV), 2024
%   DOI: 10.1007/s11263-024-02291-5
%
% License:
%   This code is licensed under the MIT License.

% Set default values for optional arguments
if nargin < 7 || isempty(inlier_threshold)
    inlier_threshold = 1;
end
if nargin < 6 || isempty(epsilon)
    epsilon = 1e4;
end
if nargin < 5 || isempty(MinPts)
    MinPts = 5;
end
if nargin < 4 || isempty(nc)
    N = size(X0, 1); % Number of feature points
    nc = min(max(round(sqrt(N / 4)), 5), 15); % Default nc in range [5, 15]
end
if nargin < 3 || isempty(sigma)
    sigma = 10;
end

% Validate `nc` and `sigma`
if nc <= 0
    N = size(X0, 1);
    nc = min(max(round(sqrt(N / 4)), 5), 15);
end
if sigma <= 0
    sigma = 10;
end

% Construct the affinity matrix
[Affinity, Lxy] = construct_affinity(X0, Y0, nc, sigma, epsilon, inlier_threshold);

% Perform graph clustering
[clusters] = D2SCAN(Affinity, MinPts);

% Identify inliers
inliers = find(sum(clusters, 2) > 0);
end