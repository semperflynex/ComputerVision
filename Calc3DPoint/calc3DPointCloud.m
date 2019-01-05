%Hauptklasse zum Berechnen von Punktwolken aus einer Bildsequenz
%Autoren: Adam Mahmoud, Philipp Kronser, Michael Wimmer
function calc3DPointCloud
%Eingabe des Pfades unter dem die Bilddateien liegen (Bildreihenfolge
%alphabetisch nach Bildname)
imds = imageDatastore('C:\Users\Michi\Dropbox\Michi Uniordner\Master\3.Semester\Computervision\Calc3DPointCloudohneKorrespondenzanalyse');


%Konvertieren der Bilder in Grauwertbilder
images = cell(1, numel(imds.Files));
for i = 1:numel(imds.Files)
    I = readimage(imds, i);
    images{i} = rgb2gray(I);
end
%Laden der Kameraparameter
load('smallCameraParams.mat');

I = undistortImage(images{1}, smallCameraParams); 

% Detect features. Increasing 'NumOctaves' helps detect large-scale
% features in high-resolution images. Use an ROI to eliminate spurious
% features around the edges of the image.
border = 50;
roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
prevPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
prevFeatures = extractFeatures(I, prevPoints, 'Upright', true);

%Erstellen der ViewSet Datenstruktur zum Speichern aller Kameraposen und
%zugehörigen Punkte
vSet = viewSet;
%Hinzufügen der ersten View die als Referenz im Nullpunkt sowie als
%Orientierung die Einheitsmatrix besitzt
viewId = 1;
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3, 'like', prevPoints.Location), 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));

%Iterieren über alle Bilder ab dem zweiten
for i = 2:numel(images)
    I = undistortImage(images{i}, smallCameraParams);
    
    % Detect, extract and match features.
    currPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
    currFeatures = extractFeatures(I, currPoints, 'Upright', true);    
    indexPairs = matchFeatures(prevFeatures, currFeatures, ...
        'MaxRatio', .7, 'Unique',  true);

    
    % Select matched points.
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));
    
    %Schätzen der Fundamentalmatrix
    [F, inlierIdx] = RANSAC_F_MATRIX(matchedPoints1,matchedPoints2);
    %Extrahieren der Essenziellen Matrix aus der geschätzten
    %Fundamentalmatrix
    E = smallCameraParams.IntrinsicMatrix * F * smallCameraParams.IntrinsicMatrix';
    %Extrahieren der Kamerapose aus der Essenziellen Matrix
    [relativeOrient, relativeLoc] = getCameraPose(E,smallCameraParams,matchedPoints1(inlierIdx,:), matchedPoints2(inlierIdx,:));

    %Hinzufügen der neuen Pose und deren Punkte in ViewSet
    vSet = addView(vSet, i, 'Points', currPoints);
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
    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end
    %Extrahiere Kameraposen und Tracks (Korrespondierende Punkte die über
    %mehrere Bilder hinweg sichbar sind
    camPoses = poses(vSet);
    tracks = findTracks(vSet);
    %Trianguliere über alle gefundenen Tracks um alle Punkte in 3D zu
    %erhalten
    xyzPoints = triangulateAllViews( tracks, camPoses, smallCameraParams );

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



