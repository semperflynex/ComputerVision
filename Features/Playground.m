clear; 
clc;
workingDir = pwd;
cd(workingDir);

%% Load image(s)
fHM1=imread('images\Haus1.jpg');
fHM2=imread('images\Haus2.jpg');
fHM1 = imresize(fHM1, 0.15);
fHM2 = imresize(fHM2, 0.15);
fHM1 = imrotate(fHM1, 270);
fHM2 = imrotate(fHM2, 270);
figure, montage({fHM1, fHM2});

impixelinfo;


%% Detect features
[cornersHM1, imgHM1] = harrisCorners(fHM1, 1, 1, 0.24, 0.001, 1);
[cornersHM2, imgHM2] = harrisCorners(fHM2, 1, 1, 0.24, 0.001, 1);

% Show detected features
%figure, montage({imgHM1, imgHM2});impixelinfo;  

%% Match Features
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 8, 200000, 4/5);

% Visualize matchet points with interconnections
figure;showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);

matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 10, 200000, 4/5);

% Visualize matchet points with interconnections
%figure;showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);

matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 12, 200000, 4/5);

% Visualize matchet points with interconnections
%figure;showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);

matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 14, 200000, 4/5);

% Visualize matchet points with interconnections
%figure;showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);

matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 16, 200000, 4/5);

% Visualize matchet points with interconnections
figure;showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);

