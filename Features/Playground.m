clear; 
clc;
workingDir = pwd;
cd(workingDir);

%% Load image(s)
fHM1=imread('..\images\Mauer1.jpg');
fHM2=imread('..\images\Mauer2.jpg');

% resize and scale large images for faster processing
fHM1 = imresize(fHM1, 0.15);
fHM2 = imresize(fHM2, 0.15);
fHM1 = imrotate(fHM1, 270);
fHM2 = imrotate(fHM2, 270);

figure, montage({fHM1, fHM2});
impixelinfo;


%% Detect features
[cornersHM1, imgHM1] = harrisCorners(fHM1, 1, 1, 0.24, 0.01, 1);
[cornersHM2, imgHM2] = harrisCorners(fHM2, 1, 1, 0.24, 0.01, 1);

% Show detected features
figure, montage({imgHM1, imgHM2});impixelinfo;  

%% Match Features windowsize 8
windowSize = 8;
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', windowSize, 200000, 4/5, 0.9);
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SAD', windowSize, 200000, 4/5, 0.9);
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MAE', windowSize, 200000, 4/5, 0.9);
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MSE', windowSize, 200000, 4/5, 0.9);
%matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'NCC', windowSize, 200000, 4/5, 0.9);
% Visualize matchet points with interconnections
figure('NumberTitle', 'off', 'Name', 'SSD');showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);
figure('NumberTitle', 'off', 'Name', 'SAD');showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);
figure('NumberTitle', 'off', 'Name', 'MAE');showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);
figure('NumberTitle', 'off', 'Name', 'MSE');showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);
%figure('NumberTitle', 'off', 'Name', 'NCC');showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);

%% Match Features windowsize 10 
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 10, 200000, 4/5);

% Visualize matchet points with interconnections
figure;showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);

%% Match Features windowsize 12
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 12, 200000, 4/5);

% Visualize matchet points with interconnections
figure;showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);

%% Match Features windowsize 14
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 14, 200000, 4/5);

% Visualize matchet points with interconnections
figure;showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);

%% Match Features windowsize 16
matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates, 16, 200000, 4/5);

% Visualize matchet points with interconnections
figure;showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);

