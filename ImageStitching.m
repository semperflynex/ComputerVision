%% 
% Bilder Laden:

I1=rgb2gray(imread('images\bild1.jpg'));
I2=rgb2gray(imread('images\bild3.jpg'));
%% 
% Feature Erkennung

corners1=detectSURFFeatures(I1);
corners2=detectSURFFeatures(I2);
%% 
% Feature Extraktion

[features1,valid_corners1]=extractFeatures(I1,corners1);
[features2,valid_corners2]=extractFeatures(I2,corners2);
figure;imshow(I1);hold on
plot(valid_corners1);
%% 
% Finden von passenden features

indexPairs = matchFeatures(features1, features2, 'Unique', true)
%% 
% Nur jeweils eine Spalte der index Pairs

matchedPoints1 = corners1(indexPairs(:,1), :);
matchedPoints2 = corners2(indexPairs(:,2), :);   
%% 
% Perform RANSAC Automatically

transform = estimateGeometricTransform(matchedPoints1, matchedPoints2,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000)
%% 
% Perform Brute Force Sample Consensus BFSAC
% 
% Hier werden nicht zufällig Punktkombinationen ausgewählt sondern einfach 
% alle möglichen durchiteriert
transform=BFSAC(matchedPoints1,matchedPoints2)
 
%% 
% Transformieren der Bilder mit der errechneten Transformationsmatrix "transform" 
% entweder mit RANSAC oder BFSAC ja nachdem welche zelle zuletzt augeführt wurde
% 
% TODO: hier ist etwas faul

height=480*2
width=640
   % Initialize the "empty" panorama.
panorama = zeros([height width 1], 'like', I1);

%% Step 4 - Create the Panorama
% Use |imwarp| to map images into the panorama and use
% |vision.AlphaBlender| to overlay the images together.

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [0 width];
yLimits = [0 height];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
   
    % Transform I into the panorama.
    warpedImage = imwarp(I2,projective2d(eye(3,3)), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I2,1),size(I1,2)), projective2d(eye(3,3)), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);

    
     % Transform I into the panorama.
    warpedImage = imwarp(I1, transform, 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I1,1),size(I2,2)), transform, 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);

    

figure
imshow(panorama)