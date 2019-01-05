%Funktion zum Triangulieren von 3D Punkten aus mehreren Kameraposen und deren
%korrespondierenden Punkten
%Autor: Michael Wimmer
function [ WorldPoints3D ] = triangulateAllViews( tracks, cameraPoses, cameraParams )

%Über alle gefundenen Pointtracks
for i = 1 : length(tracks)
    %Extrahieren der beteiligten View Ids für den jeweiligen Track
    viewId = tracks(i).ViewIds;
    A = zeros(2,4);
    %Bauen der A Matrix anhand aller beteiligten Views (je 2 Zeilen pro
    %View)
    for j = 1 : length(viewId)
        R = cameraPoses{viewId(j), 'Orientation'}{1};
        t = cameraPoses{viewId(j), 'Location'}{1};
        camMatrix = cameraMatrix(cameraParams, R', -t*R')';
        idx = 2 * j;
        A(idx-1,:) = tracks(i).Points(j,1) * camMatrix(3,:) - camMatrix(1,:);
        A(idx,:) = tracks(i).Points(j,2) * camMatrix(3,:) - camMatrix(2,:);
    end
    %Singulärwertzerlegung und extrahieren des Ergebnisses als korrespondierend
    %zum kleinsten Singulärwert (letzte Spalte von V)
    [S,D,V] = svd(A);
    X = V(:, end);
    X = X/X(end);

    WorldPoints3D(i,:) = X(1:3)';
    
end


end

