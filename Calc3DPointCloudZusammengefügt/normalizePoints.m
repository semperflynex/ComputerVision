%Funktion zum normalisieren der korrespondierenden Punktepaare. Die Punkte
%werden um den Koordinatenursprung herum verteilt und werden so skaliert
%dass sie im quadratischen Mittel eine Abweichung von sqrt(2) haben.
%Autor:  Michael Wimmer
function [ normedPoints1,normedPoints2, T1, T2  ] = normalizePoints( matchedPoints1,matchedPoints2 )

%Prüfen ob gleich viele Punkte und über 3
if length(matchedPoints1) == length(matchedPoints2) && length(matchedPoints1) > 3
    points1 = matchedPoints1;
    points2 = matchedPoints2;
    
    %Zentrum der Punkte ermitteln
    c1 = [0 0];
    c2 = [0 0];
    for i = 1 : length(points1)
        c1 = c1 + points1(i,:);
        c2 = c2 + points2(i,:);
    end
    c1 = c1 / length(points1);
    c2 = c2 / length(points2);
    
    %Translation der Punkte sodass Zentrum 0,0 ist
    for j =  1 : length(points1)
        points1(j,:) = points1(j,:) - c1;
        points2(j,:) = points2(j,:) - c2;
    end 

    %Berechne Mittelwert aller Vektoren für Skalierung
    m1 = 0;
    m2 = 0;
    for k = 1 : length(points1)
        m1 = m1 + norm(points1(k,:));
        m2 = m2 + norm(points2(k,:));
    end   
    m1 = m1/length(points1);
    m2 = m2/length(points2);
    
    scale1 = sqrt(2) / m1;
    scale2 = sqrt(2) /m2;
    
    %Berechnen der Transformationsmatrizen
    T1 = diag(ones(1,3)) * scale1;
    T1(1,3) = -scale1 * c1(1);
    T1(2,3) = -scale1 * c1(2);
    T1(3,3) = 1;
    T2 = diag(ones(1,3)) * scale2;
    T2(1,3) = -scale2 * c2(1);
    T2(2,3) = -scale2 * c2(2);
    T2(3,3) = 1;

    %Normieren der Punkte
    normedPoints1 = points1 * scale1;
    normedPoints2 = points2 * scale2;
    
    %Homogenisieren der Punkte
    normedPoints1(:,3) = ones(length(points1),1);
    normedPoints2(:,3) = ones(length(points2),1);

end

