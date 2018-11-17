function  calcFMatrix

p1 = rgb2gray(imread('p1.jpg'));
p2 = rgb2gray(imread('p2.jpg'));

load('A5camerParams.mat');

%p1 = undistortImage(p1, A5cameraParams);
%p2 = undistortImage(p2,A5cameraParams);
points1 = detectHarrisFeatures(p1);
[features1, points1] = extractFeatures(p1,points1);
points2 = detectHarrisFeatures(p2);
[features2, points2] = extractFeatures(p2,points2);

matchPairs = matchFeatures(features1, features2);
matchedPoints1 = points1(matchPairs(:, 1), :);
matchedPoints2 = points2(matchPairs(:, 2), :);

[F, inlier] = RANSAC_F_MATRIX(matchedPoints1, matchedPoints2);
A = 0;
%F = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC'),
%estFMatrix(matchedPoints1, matchedPoints2);

end


