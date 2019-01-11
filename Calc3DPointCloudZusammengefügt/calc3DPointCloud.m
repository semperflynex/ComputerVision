%Hauptklasse zum Berechnen von Punktwolken aus einer Bildsequenz
%Autoren: Adam Mahmoud, Philipp Kronser, Michael Wimmer
function calc3DPointCloud
%Eingabe des Pfades unter dem die Bilddateien liegen (Bildreihenfolge
%alphabetisch nach Bildname)
imds = imageDatastore('*.jpg');

%Konvertieren der Bilder in Grauwertbilder
images = cell(1, numel(imds.Files));
for i = 1:numel(imds.Files)
    I = readimage(imds, i);
    I = imrotate(I, 270);
    images{i} = rgb2gray(I);
    %figure, imshow(I);
end
%Laden der Kameraparameter
load('S3cameraParams.mat');%
I = undistortImage(images{1}, S3cameraParams); 

% Detect features. Increasing 'NumOctaves' helps detect large-scale
% features in high-resolution images. Use an ROI to eliminate spurious
% features around the edges of the image.
% border = 50;
% roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
% prevPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
% prevFeatures = extractFeatures(I, prevPoints, 'Upright', true);
[corners, img] = harrisCorners(I, 1, 1, 0.05, 1.5e7, 1, 'off');

%Erstellen der ViewSet Datenstruktur zum Speichern aller Kameraposen und
%zugehörigen Punkte
vSet = viewSet;
%Hinzufügen der ersten View die als Referenz im Nullpunkt sowie als
%Orientierung die Einheitsmatrix besitzt
viewId = 1;
vSet = addView(vSet, viewId, 'Points', [corners.coordinates(:,1), corners.coordinates(:,2)], 'Orientation', ...
    eye(3), 'Location', ...
    zeros(1, 3));

%Iterieren über alle Bilder ab dem zweiten
for i = 2:numel(images)
    imds.Files(i)
    I2 = undistortImage(images{i}, S3cameraParams);

%     % Detect, extract and match features.
%     currPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
%     currFeatures = extractFeatures(I, currPoints, 'Upright', true);    
%     indexPairs = matchFeatures(prevFeatures, currFeatures, ...
%         'MaxRatio', .7, 'Unique',  true);
% 
%     
%     % Select matched points.
%     matchedPoints1 = prevPoints(indexPairs(:, 1));
%     matchedPoints2 = currPoints(indexPairs(:, 2));
    [corners2, img2] = harrisCorners(I2, 1, 1, 0.05, 1.5e7, 1, 'off');
    % Parameters for matching
    windowSize = 20;
    threshold = 40000;
    thresholdNCC = 1;
    xOverlap = 0.6;
    yOverlap = 0.9;
    blur = 'off';
    matches = matchFeaturesOwn(I,I2, corners.coordinates,corners2.coordinates, 'NCC', windowSize, 1, xOverlap, yOverlap, blur);
    matchedPoints1 = [matches(:,2),matches(:,3)];
    matchedPoints2 = [matches(:,4),matches(:,5)];
    %Schätzen der Fundamentalmatrix
    [F, inlierIdx] = RANSAC_F_MATRIX( matchedPoints1,matchedPoints2);
    %Extrahieren der Essenziellen Matrix aus der geschätzten
    %Fundamentalmatrix
    E = S3cameraParams.IntrinsicMatrix * F * S3cameraParams.IntrinsicMatrix';
    %Extrahieren der Kamerapose aus der Essenziellen Matrix
    [relativeOrient, relativeLoc] = getCameraPose(E,S3cameraParams,matchedPoints1(inlierIdx,:), matchedPoints2(inlierIdx,:));
    saveRelLoc(i,:) = relativeLoc;
    %Hinzufügen der neuen Pose und deren Punkte in ViewSet
    vSet = addView(vSet, i, 'Points',  [corners2.coordinates(:,1), corners2.coordinates(:,2)]);
    indexPairs = getIndexPairs(corners,corners2, matchedPoints1, matchedPoints2);   
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));
    prevPose = poses(vSet, i-1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};
    orientation = relativeOrient * prevOrientation;
    location    = prevLocation + relativeLoc * prevOrientation;
    vSet = updateView(vSet, i, 'Orientation', orientation, ...
        'Location', location);

    %Punkte und Features des aktuellen Bildes werden zu vorigen  sodass sie
    %mit dem nächsten Bild verglichen werden können
%     prevFeatures = currFeatures;
%     prevPoints   = currPoints;  
    corners = corners2;
    I = I2;
end
    %Extrahiere Kameraposen und Tracks (Korrespondierende Punkte die über
    %mehrere Bilder hinweg sichbar sind
    camPoses = poses(vSet);
    tracks = findTracks(vSet);
    %Trianguliere über alle gefundenen Tracks um alle Punkte in 3D zu
    %erhalten
    xyzPoints = triangulateAllViews( tracks, camPoses, S3cameraParams );

    %Plotten der Kameraposen und 3D Punkte  
    figure;  
    plotCamera(camPoses, 'Size', 0.2);
    hold on
    pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
    grid on
    hold off
    loc1 = camPoses.Location{1};
    xlim([loc1(1)-10, loc1(1)+8]);
    ylim([loc1(2)-10, loc1(2)+8]);
    zlim([loc1(3)-3, loc1(3)+20]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    camorbit(0, -30);
    
end



