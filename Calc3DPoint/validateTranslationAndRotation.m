%Funktion zum validieren 4 möglicher Lösungen nach ermittlung der
%Rotationsmatrizen und Translation
%Autor: Michael Wimmer
function [R,t,worldPoints] = validateTranslationAndRotation(R1,R2,t, cameraParams,points1,points2)
                                   
cameraMatrix1 = cameraMatrix(cameraParams, eye(3),zeros(1,3));
R1 = R1';
R2 = R2';

%Triangulieren von Fall 1 R1 und t und ermitteln der Anzahl der Punkte die
%hinter den Kameras liegen
cameraMatrix2 = cameraMatrix(cameraParams, R1,t);
worldPoints1 = triangulateWorldPoints(cameraMatrix1',cameraMatrix2',points1,points2);
worldPoints1FromScndCam = worldPoints1 * R1 + t;
numNegZ1 = sum(worldPoints1(:,3) < 0 | worldPoints1FromScndCam(:,3) < 0);

%Triangulieren von Fall 2 R1 und -t und ermitteln der Anzahl der Punkte die
%hinter den Kameras liegen
cameraMatrix2 = cameraMatrix(cameraParams, R1,-t);
worldPoints2 = triangulateWorldPoints(cameraMatrix1',cameraMatrix2',points1,points2);
worldPoints2FromScndCam = worldPoints2 * R1 - t;
numNegZ2 = sum(worldPoints2(:,3) < 0 | worldPoints2FromScndCam(:,3) < 0);

%Triangulieren von Fall 3 R2 und t und ermitteln der Anzahl der Punkte die
%hinter den Kameras liegen
cameraMatrix2 = cameraMatrix(cameraParams, R2,t);
worldPoints3 = triangulateWorldPoints(cameraMatrix1',cameraMatrix2',points1,points2);
worldPoints3FromScndCam = worldPoints3 * R2 + t;
numNegZ3 = sum(worldPoints3(:,3) < 0 | worldPoints3FromScndCam(:,3) < 0);

%Triangulieren von Fall 4 R2 und -t und ermitteln der Anzahl der Punkte die
%hinter den Kameras liegen
cameraMatrix2 = cameraMatrix(cameraParams, R2,-t);
worldPoints4 = triangulateWorldPoints(cameraMatrix1',cameraMatrix2',points1,points2);
worldPoints4FromScndCam = worldPoints4 * R2 -t;
numNegZ4 = sum(worldPoints4(:,3) < 0 | worldPoints4FromScndCam(:,3) < 0);

%Ermitteln des Falles mit der geringsten Anzahl Punkten die hinter den
%Kameras liegen
[numNeg,idx] = min([numNegZ1,numNegZ2,numNegZ3,numNegZ4]);

%Rückgabe des plausibelsten Falles
if(idx == 1)
    R =  R1;
    t = t;
    worldPoints = worldPoints1;
end
if(idx == 2)
   R = R1;
   t =  -t;
   worldPoints = worldPoints2;
end
if(idx == 3)
    R = R2;
    t = t;
    worldPoints = worldPoints3;
end
if(idx == 4)
    R = R2;
    t = -t;
    worldPoints = worldPoints4;
end
   
end

