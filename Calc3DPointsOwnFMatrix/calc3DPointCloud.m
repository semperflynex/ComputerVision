function calc3DPointCloud
imds = imageDatastore('C:\Users\Michi\Dropbox\Michi Uniordner\Master\3.Semester\Computervision\Calc3DPointsOwnFMatrix');

%figure
%montage(imds.Files);
%title('Input Image Sequence');

% Convert the images to grayscale.
images = cell(1, numel(imds.Files));
for i = 1:numel(imds.Files)
    I = readimage(imds, i);
    images{i} = rgb2gray(I);
end

load('A5camerParams.mat');


% Undistort the first image.
I = undistortImage(images{1}, cameraParams); 

% Detect features. Increasing 'NumOctaves' helps detect large-scale
% features in high-resolution images. Use an ROI to eliminate spurious
% features around the edges of the image.
border = 50;
roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
prevPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);

% Extract features. Using 'Upright' features improves matching, as long as
% the camera motion involves little or no in-plane rotation.
prevFeatures = extractFeatures(I, prevPoints, 'Upright', true);

% Create an empty viewSet object to manage the data associated with each
% view.
vSet = viewSet;

% Add the first view. Place the camera associated with the first view
% and the origin, oriented along the Z-axis.
viewId = 1;
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3, 'like', prevPoints.Location), 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));

for i = 2:numel(images)
    % Undistort the current image.
    I = undistortImage(images{i}, cameraParams);
    
    % Detect, extract and match features.
    currPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
    currFeatures = extractFeatures(I, currPoints, 'Upright', true);    
    indexPairs = matchFeatures(prevFeatures, currFeatures, ...
        'MaxRatio', .7, 'Unique',  true);
    
    % Select matched points.
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));
    
    % Estimate the camera pose of current view relative to the previous view.
    % The pose is computed up to scale, meaning that the distance between
    % the cameras in the previous view and the current view is set to 1.
    % This will be corrected by the bundle adjustment.

    [F, inlierIdx] = RANSAC_F_MATRIX(matchedPoints1,matchedPoints2);
    E = cameraParams.IntrinsicMatrix * F * cameraParams.IntrinsicMatrix'; 
    [relativeOrient, relativeLoc] = getCameraPose(E,cameraParams,matchedPoints1(inlierIdx,:), matchedPoints2(inlierIdx,:));
    saveRelLoc(i,:) = relativeLoc;
    % Add the current view to the view set.
    vSet = addView(vSet, i, 'Points', currPoints);
    
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));
    
    % Get the table containing the previous camera pose.
    prevPose = poses(vSet, i-1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};
        
    % Compute the current camera pose in the global coordinate system 
    % relative to the first view.
    orientation = relativeOrient * prevOrientation;
    location    = prevLocation + relativeLoc * prevOrientation;
    vSet = updateView(vSet, i, 'Orientation', orientation, ...
        'Location', location);

    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end

    % Get the table containing camera poses for all views.
    camPoses = poses(vSet);
    
    % Find point tracks across all views.
    tracks = findTracks(vSet);
    
    xyzPoints = triangulateAllViews( tracks, camPoses, cameraParams );
    % Triangulate initial locations for the 3-D world points.
    %xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);
    
    figure;
    
    plotCamera(camPoses, 'Size', 0.2);
    hold on


    % Display the 3-D points.
    pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
    grid on
    hold off

    % Specify the viewing volume.
    loc1 = camPoses.Location{1};
    xlim([loc1(1)-10, loc1(1)+8]);
    ylim([loc1(2)-10, loc1(2)+8]);
    zlim([loc1(3)-1, loc1(3)+20]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    camorbit(0, -30);


