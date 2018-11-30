function [ WorldPoints3D ] = triangulateAllViews( tracks, cameraPoses, cameraParams )

for i = 1 : length(tracks)
    viewId = tracks(i).ViewIds;
    cameraMatrices = zeros(4,3,1);
    for j = 1 : length(viewId)
        R = cameraPoses{j, 'Orientation'}{1};
        t = cameraPoses{j, 'Location'}{1};
        camMatrix = cameraMatrix(cameraParams, R', -t*R')';
        idx = 2 * j;
        A(idx-1,:) = tracks(i).Points(j,1) * camMatrix(3,:) - camMatrix(1,:);
        A(idx,:) = tracks(i).Points(j,2) * camMatrix(3,:) - camMatrix(2,:);
    end
    [S,D,V] = svd(A);
    X = V(:, end);
    X = X/X(end);

    WorldPoints3D(i,:) = X(1:3)';
    
end


end

