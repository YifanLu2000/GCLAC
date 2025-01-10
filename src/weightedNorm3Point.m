function [A] = weightedNorm3Point(xs1,xs2,weight)
[c,N] = size(xs1);
A = rand(3);
if N < 3
%     fprintf('Input points are less the 3!\n');
    return;
end
if (size(xs1) ~= size(xs2))
%     error ('Input point sets are different sizes!')
    return;
end
if (length(weight) ~= N)
%     error ('Input point sets and weight are different sizes!')
    return;
end
if c == 2
    xs1 = [xs1 ; ones(1,size(xs1,2))];
    xs2 = [xs2 ; ones(1,size(xs2,2))];
end
if size(weight,2) == 1
    weight = weight';
end
[xs1, T1] = normalise2dpts(xs1);
[xs2, T2] = normalise2dpts(xs2);
xs1(isnan(xs1)) = 1;
xs2(isnan(xs2)) = 1;
xs1 = xs1 .* repmat(weight,3,1);
xs2 = xs2 .* repmat(weight,3,1);
A1 = (xs1*xs1') \ xs1 * xs2(1,:)';
A2 = (xs1*xs1') \ xs1 * xs2(2,:)';
A = [A1';A2';0,0,1];
A = T2\A*T1;
