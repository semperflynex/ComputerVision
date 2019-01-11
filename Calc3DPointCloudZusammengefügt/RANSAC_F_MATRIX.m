%Klasse die in einem RANSAC Algorithmus die bestmögliche Fundamentalmatrix
%ermittelt
%Autor: Michael Wimmer
function [F , bestInlier] = RANSAC_F_MATRIX( matchedPoints1, matchedPoints2 )
F = 0;
hPoints1 = [matchedPoints1, ones(length(matchedPoints1),1)];
hPoints2 = [matchedPoints2, ones(length(matchedPoints2),1)];

%Festlegen von Iterationen und Schwellwert für Inlier 
Iterationen = 10000;
thresh = 0.1;
inlierCount = 0;
bestF = 0;
bestInlier = 0;

for i = 1 : Iterationen
   %Auswählen von 8 zufälligen Punkten und Berechnung der Fundamentalmatrix
   %über 8-Punkte Algorithmus
   idx = randperm(length(matchedPoints1),8);
   f = eightPoint(matchedPoints1(idx,:),matchedPoints2(idx,:));

   %Sampson Distanz um Güte der Fundamentalmatrix zu schätzen und Inlier zu
   %ermitteln
   epCons = (hPoints2 * f)';
   epCons = epCons .* hPoints1';
   d = sum(epCons,1) .^2;   
   fx1 = f * hPoints1';
   fx2 = f' * hPoints2';
   d = d ./ fx1(1,:).^2 + fx1(2,:).^2 + fx2(1,:).^2 + fx2(2,:).^2;

   %Ermittlung der Inlier anhand der Sampson Distanz
   inlier = false;
   for j = 1 : length(d)
       if d(j) < thresh
           inlier(j) = true;
       else
           inlier(j) = false;
       end
   end
   
   %Speichern falls Güte einer Fundamentalmatrix besser als vorige 
   if sum(inlier) > inlierCount
       bestF = f;
       bestInlier = inlier;
       inlierCount = sum(inlier);
   end    
end
%Berechnen der Fundamentalmatrix aus allen Inliern der am besten
%geschätzten Fundamentalmatrix
if(inlierCount > 8)
    inlierCount
    F = eightPoint(matchedPoints1(bestInlier,:),matchedPoints2(bestInlier,:));
end
end

