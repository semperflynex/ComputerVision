%% 
% Bilder Laden:

I1=rgb2gray(imread('..\images\bild3.jpg'));
I2=rgb2gray(imread('..\images\bild2.jpg'));
%% 
% Feature Erkennung

corners1=detectSURFFeatures(I1);
corners2=detectSURFFeatures(I2);
%% 
% Feature Extraktion

[features1,valid_corners1]=extractFeatures(I1,corners1);
[features2,valid_corners2]=extractFeatures(I2,corners2);
%figure;imshow(I1);hold on
%plot(valid_corners1);
%% 
% Finden von passenden features

indexPairs = matchFeatures(features1, features2, 'Unique', true);
%% 
% Nur jeweils eine Spalte der index Pairs

matchedPoints1 = corners1(indexPairs(:,1), :);
matchedPoints2 = corners2(indexPairs(:,2), :);   

%%
% perform RANSAC myself
transform=RANSAC(matchedPoints1,matchedPoints2,0.99,0.5,4,1.5)
transform=projective2d(transform);

%% Warp ans Stitch together

bounds1=getBounds(I2',eye(3,3));
bounds2=getBounds(I1',transform.T);
bounds=[bounds1;bounds2];
canvasBounds=[min(bounds(:,1:2)),max(bounds(:,3:4))];
canvasSize=ceil(abs(min(bounds(:,1:2)) - max(bounds(:,3:4))))
canvas=zeros(canvasSize,'uint8');

canvas=WarpImage(I2',bounds1,canvasBounds,canvas,eye(3,3));
canvas=WarpImage(I1',bounds2,canvasBounds,canvas,transform.T);
figure('Name','My Implementation');
imshow(canvas');

%% 
% for Comparison:
% Perform RANSAC from Matlab example library
transform = estimateGeometricTransform(matchedPoints1, matchedPoints2,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    

%%Create the Panorama form MAtlab example script
% Use |imwarp| to map images into the panorama and use
% |vision.AlphaBlender| to overlay the images together.

height=480*2;
width=640;
   % Initialize the "empty" panorama.
panorama = zeros([height width 1], 'like', I1);
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

    

figure('Name','Matlab-Ransac');
imshow(panorama);