function [ camOrientation, camLocation ] = getCameraPose( E, cameraParams, inlierPoints1, inlierPoints2 )
%Kapitel 9.6 in dem Englischen Buch
W = [0 -1 0;1 0 0; 0 0 1];
Z = [0 1 0;-1 0 0;0 0 0];

%E Matrix verbessern um den Epiploar Constraints zu entsprechen
[U,D,V] = svd(E);
% s = (D(1,1) + D(2,2)) /2;
% D(1,1) = s;
% D(2,2) = s;
% D(3,3) = 0;
% E = U * D * V;
% [U,D,V] = svd(E);

%t ist dritte Spalte von U
t = U * Z * U';
R1 = U * W * V';
R2 = U * W' * V';

%Prüfen ob Determinante nicht negatv
if(det(R1) < 0)
    R1 = -R1;
end
if(det(R2) < 0)
    R2 = -R2;
end

t = [t(3, 2), t(1, 3), t(2, 1)];

%Es Ergeben sich 4 Mögliche Lösungen
[R,t,worldPoints] = validateTranslationAndRotation(R1,R2,t, cameraParams, inlierPoints1, inlierPoints2);

%Invertieren um Transformation Cam1 Coords in Cam2 Coords in Cam2 Coords in
%Cam1 Coords zu überführen
camOrientation = R';
camLocation = -t * camOrientation;

end

