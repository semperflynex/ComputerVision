%% 
% Bilder Laden:

I1=rgb2gray(imread('..\images\bild1.jpg'));
I2=rgb2gray(imread('..\images\bild2.jpg'));
%% 
% Feature Erkennung Matlab Methoden

corners1=detectSURFFeatures(I1);
corners2=detectSURFFeatures(I2);

% Feature Extraktion

[featuresML1,valid_corners1]=extractFeatures(I1,corners1);
[featuresML2,valid_corners2]=extractFeatures(I2,corners2);
 
indexPairs = matchFeatures(featuresML1, featuresML2, 'Unique', true);

 %Nur jeweils eine Spalte der index Pairs

MlMp1 = corners1(indexPairs(:,1), :);
MlMp2 = corners2(indexPairs(:,2), :);   
MlMp1=MlMp1.Location;
MlMp2=MlMp2.Location;
%%
%feature erkennung eigene Methoden
[cornersHM1, MarkedImg1] = harrisCorners(I1, 1, 1, 0.24, 0.001, 1,'off');
[cornersHM2, MarkedImg2] = harrisCorners(I2, 1, 1, 0.24, 0.001, 1,'off');
%matching
matches = matchFeaturesOwn(I1, I2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', 8, 200000, 4/5,0.9,'off');
HmMp1=[matches(:,3),matches(:,2)]
HmMp2=[matches(:,5),matches(:,4)]

%%
% perform RANSAC myself
transform=RANSAC(HmMp1,HmMp2,0.99,0.5,4,1.5)
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
transform = estimateGeometricTransform(MlMp1, MlMp2,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

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
