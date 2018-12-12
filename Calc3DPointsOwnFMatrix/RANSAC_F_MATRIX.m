function [ F , bestInlier] = RANSAC_F_MATRIX( matchedPoints1, matchedPoints2 )
F = 0;
hPoints1 = [matchedPoints1.Location, ones(length(matchedPoints1),1)];
hPoints2 = [matchedPoints2.Location, ones(length(matchedPoints2),1)];

Iterationen = 1000;
thresh = 0.1;
inlierCount = 0;
bestF = 0;
bestInlier = 0;


for i = 1 : Iterationen
   idx = randperm(length(matchedPoints1),8);
   f = eightPoint(matchedPoints1.Location(idx,:),matchedPoints2.Location(idx,:));

   %Sampson Distanz für Inlier Berechnung 
   for i = 1 : length(matchedPoints1)
       fx1 = f * hPoints1(i,:)';
       fx2 = f' * hPoints2(i,:)';
       d(i) = ((hPoints2(i,:) * f * hPoints1(i,:)')^2) / (fx1(1)^2 + fx1(2)^2 + fx2(1)^2 + fx2(2)^2);
   end
   
   inlier = false;
   for j = 1 : length(d)
       if d(j) < thresh
           inlier(j) = true;
       else
           inlier(j) = false;
       end
   end
   
   
   if sum(inlier) > inlierCount
       bestF = f;
       bestInlier = inlier;
       inlierCount = sum(inlier);
   end    
end
if(inlierCount > 8)
    inlierCount
    F = eightPoint(matchedPoints1.Location(bestInlier,:),matchedPoints2.Location(bestInlier,:));
end
end

