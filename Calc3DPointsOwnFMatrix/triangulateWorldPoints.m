function [ worldPoints ] = triangulateWorldPoints( cameraMatrix1,cameraMatrix2,points1,points2 )

for i = 1 : length(points1)

A(1,:) = points1.Location(i,1) * cameraMatrix1(3,:) - cameraMatrix1(1,:);
A(2,:) = points1.Location(i,2) * cameraMatrix1(3,:) - cameraMatrix1(2,:);
A(3,:) = points2.Location(i,1) * cameraMatrix2(3,:) - cameraMatrix2(1,:);
A(4,:) = points2.Location(i,2) * cameraMatrix2(3,:) - cameraMatrix2(2,:);


[S,D,V] = svd(A);
X = V(:, end);
X = X/X(end);

worldPoints(i,:) = X(1:3)';
end


end

