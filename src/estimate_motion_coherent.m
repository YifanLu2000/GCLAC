function [motion_coherent] = estimate_motion_coherent(X0, Y0, epsilon)
N = size(X0,1);
M = Y0 - X0;
motion_coherent = zeros(N,1);
for i = 1:N
    distance = sum((X0 - repmat(X0(i,:),N,1)).^2,2);
    motion_difference = sum((M - repmat(M(i,:),N,1)).^2,2);
    motion_coherent_weight = exp(-distance./epsilon)./(motion_difference./distance + 1);
    motion_coherent_weight(isnan(motion_coherent_weight)) = 0;
    motion_coherent_weight(i) = 1;
    motion_coherent(i) = sum(motion_coherent_weight);
end
motion_coherent = mapminmax(motion_coherent',0.001,0.999); % normalize to [0.001,0.999]