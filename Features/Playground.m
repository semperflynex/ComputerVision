clear; 
clc;
workingDir = pwd;
cd(workingDir);

%% Load image(s)
%fHM1=imread('..\images\03pic.jpg');
%fHM2=imread('..\images\04pic.jpg');
fHM1=imread('C:\Users\phili\Desktop\S3 Bilder\Steinecke\01.jpg');
fHM2=imread('C:\Users\phili\Desktop\S3 Bilder\Steinecke\02.jpg');

% resize and scale large images for faster processing
%fHM1 = imresize(fHM1, 0.3);
%fHM2 = imresize(fHM2, 0.3);
fHM1 = imrotate(fHM1, 270);
fHM2 = imrotate(fHM2, 270);

figure, montage({fHM1, fHM2});

impixelinfo;

%% Detect features
[cornersHM1, imgHM1] = harrisCorners(fHM1, 1, 1, 0.24, 2000000, 1, 'off');
cornersHM1.length
[cornersHM2, imgHM2] = harrisCorners(fHM2, 1, 1, 0.24, 2000000, 1, 'off');
cornersHM2.length
% Show detected features
%figure, montage({imgHM1, imgHM2});impixelinfo;  

%% Match Features windowsize 7
windowSize = 7;
threshold = 100000;
thresholdNCC = 0.8;
xOverlap = 0.6;
yOverlap = 0.9;
blur = 'off';
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', windowSize, threshold, xOverlap, yOverlap, blur);
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SAD', windowSize, threshold, xOverlap, yOverlap, blur);
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MAE', windowSize, threshold, xOverlap, yOverlap, blur);
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MSE', windowSize, threshold, xOverlap, yOverlap, blur);
matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'NCC', windowSize, thresholdNCC, xOverlap, yOverlap, blur);
% Visualize matchet points with interconnections
if 0 == isempty(matches1)
    figure('NumberTitle', 'off', 'Name', 'SSD');showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);;
end
if 0 == isempty(matches2)
    figure('NumberTitle', 'off', 'Name', 'SAD');showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches3)
    figure('NumberTitle', 'off', 'Name', 'MAE');showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches4)
    figure('NumberTitle', 'off', 'Name', 'MSE');showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches5)
    figure('NumberTitle', 'off', 'Name', 'NCC');showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);
end

%% Match Features windowsize 9
windowSize = 9;
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', windowSize, threshold, xOverlap, yOverlap, blur);
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SAD', windowSize, threshold, xOverlap, yOverlap, blur);
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MAE', windowSize, threshold, xOverlap, yOverlap, blur);
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MSE', windowSize, threshold, xOverlap, yOverlap, blur);
matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'NCC', windowSize, thresholdNCC, xOverlap, yOverlap, blur);
% Visualize matchet points with interconnections
if 0 == isempty(matches1)
    figure('NumberTitle', 'off', 'Name', 'SSD');showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);;
end
if 0 == isempty(matches2)
    figure('NumberTitle', 'off', 'Name', 'SAD');showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches3)
    figure('NumberTitle', 'off', 'Name', 'MAE');showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches4)
    figure('NumberTitle', 'off', 'Name', 'MSE');showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches5)
    figure('NumberTitle', 'off', 'Name', 'NCC');showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);
end

%% Match Features windowsize 11
windowSize = 11;
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', windowSize, threshold, xOverlap, yOverlap, blur);
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SAD', windowSize, threshold, xOverlap, yOverlap, blur);
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MAE', windowSize, threshold, xOverlap, yOverlap, blur);
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MSE', windowSize, threshold, xOverlap, yOverlap, blur);
matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'NCC', windowSize, thresholdNCC, xOverlap, yOverlap, blur);
% Visualize matchet points with interconnections
if 0 == isempty(matches1)
    figure('NumberTitle', 'off', 'Name', 'SSD');showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);;
end
if 0 == isempty(matches2)
    figure('NumberTitle', 'off', 'Name', 'SAD');showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches3)
    figure('NumberTitle', 'off', 'Name', 'MAE');showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches4)
    figure('NumberTitle', 'off', 'Name', 'MSE');showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches5)
    figure('NumberTitle', 'off', 'Name', 'NCC');showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);
end

%% Match Features windowsize 13
windowSize = 13;
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', windowSize, threshold, xOverlap, yOverlap, blur);
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SAD', windowSize, threshold, xOverlap, yOverlap, blur);
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MAE', windowSize, threshold, xOverlap, yOverlap, blur);
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MSE', windowSize, threshold, xOverlap, yOverlap, blur);
matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'NCC', windowSize, thresholdNCC, xOverlap, yOverlap, blur);
if 0 == isempty(matches1)
    figure('NumberTitle', 'off', 'Name', 'SSD');showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);;
end
if 0 == isempty(matches2)
    figure('NumberTitle', 'off', 'Name', 'SAD');showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches3)
    figure('NumberTitle', 'off', 'Name', 'MAE');showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches4)
    figure('NumberTitle', 'off', 'Name', 'MSE');showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches5)
    figure('NumberTitle', 'off', 'Name', 'NCC');showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);
end

%% Match Features windowsize 15
windowSize = 15;
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', windowSize, threshold, xOverlap, yOverlap, blur);
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SAD', windowSize, threshold, xOverlap, yOverlap, blur);
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MAE', windowSize, threshold, xOverlap, yOverlap, blur);
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MSE', windowSize, threshold, xOverlap, yOverlap, blur);
matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'NCC', windowSize, thresholdNCC, xOverlap, yOverlap, blur);
% Visualize matchet points with interconnections
if 0 == isempty(matches1)
    figure('NumberTitle', 'off', 'Name', 'SSD');showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);;
end
if 0 == isempty(matches2)
    figure('NumberTitle', 'off', 'Name', 'SAD');showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches3)
    figure('NumberTitle', 'off', 'Name', 'MAE');showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches4)
    figure('NumberTitle', 'off', 'Name', 'MSE');showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches5)
    figure('NumberTitle', 'off', 'Name', 'NCC');showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);
end

%% Match Features windowsize 30
windowSize = 30;
matches1 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SSD', windowSize, threshold, xOverlap, yOverlap, blur);
matches2 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'SAD', windowSize, threshold, xOverlap, yOverlap, blur);
matches3 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MAE', windowSize, threshold, xOverlap, yOverlap, blur);
matches4 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'MSE', windowSize, threshold, xOverlap, yOverlap, blur);
matches5 = matchFeaturesOwn(fHM1, fHM2, cornersHM1.coordinates, cornersHM2.coordinates,'NCC', windowSize, thresholdNCC, xOverlap, yOverlap, blur);
% Visualize matchet points with interconnections
if 0 == isempty(matches1)
    figure('NumberTitle', 'off', 'Name', 'SSD');showMatchedFeatures(fHM1,fHM2,[matches1(:,3), matches1(:,2)],[matches1(:,5), matches1(:,4)],'montage','Parent',axes);;
end
if 0 == isempty(matches2)
    figure('NumberTitle', 'off', 'Name', 'SAD');showMatchedFeatures(fHM1,fHM2,[matches2(:,3), matches2(:,2)],[matches2(:,5), matches2(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches3)
    figure('NumberTitle', 'off', 'Name', 'MAE');showMatchedFeatures(fHM1,fHM2,[matches3(:,3), matches3(:,2)],[matches3(:,5), matches3(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches4)
    figure('NumberTitle', 'off', 'Name', 'MSE');showMatchedFeatures(fHM1,fHM2,[matches4(:,3), matches4(:,2)],[matches4(:,5), matches4(:,4)],'montage','Parent',axes);
end
if 0 == isempty(matches5)
    figure('NumberTitle', 'off', 'Name', 'NCC');showMatchedFeatures(fHM1,fHM2,[matches5(:,3), matches5(:,2)],[matches5(:,5), matches5(:,4)],'montage','Parent',axes);
end