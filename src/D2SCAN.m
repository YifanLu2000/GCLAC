function [clusters] = D2SCAN(W,MinPts)
% DBDSCAN - Dominant Set-based DBSCAN Clustering
%
% Inputs:
%   W      - Weighted adjacency matrix.
%   MinPts - Minimum number of points to form a cluster (default: 5).
%
% Outputs:
%   clusters - Cluster labels for each point.

if nargin < 2
    MinPts = 5;
end

% Dominant Set
N = size(W,1);
% find neighbors for each vertex
DSneighborsMat = zeros(N,N); % Initialize neighborhood matrix

for i = 1:N
    neighbors = find(W(:, i)); % Find neighbors of vertex i
    neighbors = [i; neighbors]; % Include self in neighbors
    Nn = length(neighbors);

    % Skip if not enough neighbors
    if Nn < 8  % 8
        continue;
    end

    % Extract subgraph and optimize using replicator equation
    WN = W(neighbors,neighbors);
    % replicator equation to optimize x'Ax and determine the DS
    Xre = ones(Nn, 1) / Nn; % Initialize replicator
    for iter = 1:5
        Xre = Xre .* (WN*Xre) / (Xre' * WN * Xre);
    end

    % Threshold replicator output to define dominant set
    Xre(Xre < 1 / (Nn * 5)) = 0;
    Xre(Xre ~= 0) = 1;

    % Skip if dominant set is too small
    if length(find(Xre~=0)) < 8 
        continue;
    end

    % Check coherence of dominant set
    fx = Xre' * WN * Xre;
    if fx < 3
        continue;
    end

    % Add dominant set to neighborhood matrix
    DSneighborsMat(i,neighbors) = Xre;
end

% Symmetrize neighborhood matrix
DSneighborsMat = DSneighborsMat + DSneighborsMat';
DSneighborsMat(DSneighborsMat ~= 0) = 1;

% DBSCAN Clustering based on dominant set connectivities
clusters = zeros(N,1);
curCluster = 0;
visited = zeros(N,1);
outliers = zeros(N,1);

for i = 1:N
    if visited(i) == 1
        continue;
    end
    visited(i) = 1;

    % Find neighbors of current point
    neighbors = find(DSneighborsMat(i,:));
    Nn = length(neighbors);

    % Mark as outlier if neighbors are insufficient
    if Nn < MinPts
        outliers(i) = 1;
    else
        % expand cluster
        curCluster = curCluster + 1;
        clusters(i) = curCluster;

        j = 1;
        while j < length(neighbors)
            curNeighbors = neighbors(j);
            if visited(curNeighbors) == 0
                visited(curNeighbors) = 1;
                neighbors2 = find(DSneighborsMat(curNeighbors,:));
                if length(neighbors2) >= MinPts
                    neighbors = [neighbors,neighbors2];
                end
            end
            clusters(curNeighbors) = curCluster;
            j = j + 1;
        end
    end
end

% Merge Clusters Based on Connectivity
clusterNum = curCluster;
L = zeros(N,clusterNum);
for cluster = 1:clusterNum
    L(clusters == cluster, cluster) = 1;
end
connectthreshold = 20;
maximizerSize = size(L,2);
while true
    if maximizerSize == 0
        break;
    end

    % Compute connectivity between clusters
    degred = L' * W * L;
    degred = degred - diag(diag(degred));

    % Stop if connectivity is below threshold
    if max(max(degred)) < connectthreshold
        break;
    end

    % Merge the most connected clusters
    [~,indexx] = max(max(degred));
    [~,indexy] = max(degred(:,indexx));
    Li = L(:,indexx);Lj = L(:,indexy);
    
    Lij = (Li+Lj)>=1;
    L(:,indexx) = Lij;
    L(:,indexy) = [];
end

% Finalize clusters
clusters = zeros(N,size(L,2));
clusters(L ~= 0) = 1;
end
