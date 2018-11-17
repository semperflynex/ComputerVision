function [f] = eightPoint( matchedPoints1, matchedPoints2 )

[nmatchedPoints1,nmatchedPoints2,T1,T2] = normalizePoints(matchedPoints1, matchedPoints2);

for i = 1 : length(matchedPoints1)
    A(i,:) = [nmatchedPoints2(i,1)*nmatchedPoints1(i,1), nmatchedPoints2(i,1)*nmatchedPoints1(i,2), nmatchedPoints2(i,1),nmatchedPoints2(i,2)*nmatchedPoints1(i,1) ,nmatchedPoints2(i,2)*nmatchedPoints1(i,2), nmatchedPoints2(i,2), nmatchedPoints1(i,1), nmatchedPoints1(i,2), 1];
end

[~, ~, vm] = svd(A, 0);
f = reshape(vm(:, end), 3, 3)';

[u, s, v] = svd(f);
s(end) = 0;
f = u * s * v';

f = T2' * f * T1;

f = f / norm(f);
if f(end) < 0
  f = -f;
end

end

