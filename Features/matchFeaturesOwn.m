function matches = matchFeaturesOwn(f1, f2, features1, features2, method, n, T, overlapX, overlapY)
%
% 'f1'          : First RGB image 
%
% 'f2'          : Second RGB image
%
% 'features1'   : Detected features coordinates in first image
%
% 'features2'   : Detected features coordinates in second image
%
% 'n'           : Size of the analyzed area around the feature
%
% 'method'      : Choose method 'NCC', 'SSD', 'SAD', 'MSE', 'MAE', 'all'
%
% 'T'           : Threshold value for detecting a match
%
% 'overlapX'    : Estimated overlap in x dimension of the images, used as 
%                 plausibility check for matched features
%
% 'overlapY'    : Estimated overlap in y dimension of the images, used as 
%                 plausibility check for matched features

% Transform image to grayscale if not done yet
if size(f1,3) == 3
    f1 = double(rgb2gray(f1));
f2 = double(rgb2gray(f2));
else
    f1=double(f1);
    f2=double(f2);
end

% Perform image sharpening -> Seems to make result even worse
%     hSharp1 = [[0, -1, 0]; [-1, 4, -1]; [0, -1, 0]];
%     hSharp2 = [[-1, -1, -1]; [-1, 8, -1]; [-1, -1, -1]];
%     f1 = conv2(f1, hSharp1,'same');
%     f2 = conv2(f1, hSharp1,'same');

% To do:
% Rotation Invariance
%rotated = rotatePatch()

switch method
    case 'NCC'
        % Calculate normalized cross correlation (NCC)
        NCC = calcNCC(f1,f2, features1, features2, n, T, overlapX, overlapY);
        matches = NCC;
    case 'SSD'
        % Calculate sum of squared differences (SSD)
        SSD = calcSSD(f1,f2, features1, features2, n, T, overlapX, overlapY);
        matches = SSD;
    case 'SAD'
        % Calculate sum of absolute differences (SAD)
        SAD = calcSAD(f1,f2, features1, features2, n, T, overlapX, overlapY);
        matches = SAD;
    case 'MSE'
        % Calculate mean square error (MSE)
        MSE = calcMSE(f1,f2, features1, features2, n, T, overlapX, overlapY);
        matches = MSE;
    case 'MAE'
        % Calculate mean absolte error (MAE)
        MAE = calcMAE(f1,f2, features1, features2, n, T, overlapX, overlapY);
        matches = MAE;
    case 'all'
        % Calculate normalized cross correlation (NCC)
        %NCC = calcNCC
        % Calculate sum of squared differences (SSD)
        SSD = calcSSD(f1,f2, features1, features2, n, T, overlap);
        % Calculate sum of absolute differences (SAD)
        %SAD = calcSAD()
        % Calculate mean square error (MSE)
        %MSE = calcMSE();
        % Calculate mean absolte error (MAE)
        %MAE = calcMAE();
        % Create descriptor
end
% Rank transform the image
%rT = calcRankTransform()

end