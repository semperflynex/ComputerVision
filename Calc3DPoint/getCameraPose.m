%Funktion zum ermitteln der relativen Kamerapose aus Essentieller Matrix
%Autor: Michael Wimmer
function [ camOrientation, camLocation ] = getCameraPose( E, cameraParams, inlierPoints1, inlierPoints2 )
%Matrizen zum extrahieren der Rotationsmatrizen und Translation
W = [0 -1 0;1 0 0; 0 0 1];
Z = [0 1 0;-1 0 0;0 0 0];
%Singulärwertzerlegung der Essentiellen Matrix
[U,D,V] = svd(E);

%Extrahieren der Rotationsmatrizen und Translation
t = U * Z * U';
R1 = U * W * V';
R2 = U * W' * V';

%Prüfen ob Determinante nicht negativ
if(det(R1) < 0)
    R1 = -R1;
end
if(det(R2) < 0)
    R2 = -R2;
end
%Translation in letzter Spalte
t = [t(3, 2), t(1, 3), t(2, 1)];

%Validieren der Plausibelsten Lösung
[R,t,worldPoints] = validateTranslationAndRotation(R1,R2,t, cameraParams, inlierPoints1, inlierPoints2);

%Invertieren um Transformation Cam1 Coords in Cam2 Coords in Cam2 Coords in
%Cam1 Coords zu überführen
camOrientation = R';
camLocation = -t * camOrientation;

end

