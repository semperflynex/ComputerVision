%Funktion zum Triangulieren von 3D Punkten aus 2 Kameramatrizen und deren
%korrespondierenden Punkten
%Autor: Michael Wimmer
function [ worldPoints ] = triangulateWorldPoints( cameraMatrix1,cameraMatrix2,points1,points2 )

%Über alle korrespondierenden Punktepaare
for i = 1 : length(points1)
%Erstellen der A Matrix
A(1,:) = points1(i,1) * cameraMatrix1(3,:) - cameraMatrix1(1,:);
A(2,:) = points1(i,2) * cameraMatrix1(3,:) - cameraMatrix1(2,:);
A(3,:) = points2(i,1) * cameraMatrix2(3,:) - cameraMatrix2(1,:);
A(4,:) = points2(i,2) * cameraMatrix2(3,:) - cameraMatrix2(2,:);

%Singulärwertzerlegung und extrahieren des Ergebnisses als korrespondierend
%zum kleinsten Singulärwert (letzte Spalte von V)
[U,D,V] = svd(A);
X = V(:, end);
X = X/X(end);

worldPoints(i,:) = X(1:3)';
end


end

