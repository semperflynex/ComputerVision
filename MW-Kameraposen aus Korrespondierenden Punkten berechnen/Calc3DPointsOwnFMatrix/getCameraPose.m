function [ camOrientation, camLocation ] = getCameraPose( E )
W = [0 -1 0;1 0 0; 0 0 1];
Z = [0 1 0;-1 0 0;0 0 0];

%E Matrix verbessern um den Epiploar Constriaints zu entsprechen
[U,D,V] = svd(E);
s = (D(1,1) + D(2,2)) /2;
D(1,1) = s;
D(2,2) = s;
D(3,3) = 0;
E = U * D * V;
[U,D,V] = svd(E);

t = U * Z * U';
R1 = U * W * V';
R2 = U * W' * V'

%Prüfen ob Determinante nicht negatv
if(det(R1) < 0)
    R1 = -R1;
end
if(det(R2) < 0)
    R2 = -R2;
end

t = [t(3, 2), t(1, 3), t(2, 1)];

%Es Ergeben sich 4 Mögliche Lösungen




end

