function [corners, img] = harrisCorners(fRGB, filtSize, sigma, k, T, supFactor, visualize)
%
% 'f'        :  RGB image to be analyzed
%
% 'filtSize' :  Determines the size of the filter used for the derivate
%               filter
%
% 'sigma'    :  
%
% 'k'        :  Sensitivity of corner detector. Small k -> more corners
%               will be detected, large k -> less corners will be detected
%
% 'T'        :  Threshold value for corner detection
%
% 'supFactor':  Determines the size of the windows considered for maximum
%               suppression
%
% 'visualize':  switches visualization 'on' or 'off', which will open a
%               figure, with the detected coners marked
%
% The function returns 
%
% 'corners'  :  
%
% 'img'      :  An image with marked corners
forig = fRGB;

% Transform image to grayscale if not done yet
if size(fRGB,3) == 3
    f = rgb2gray(fRGB);
else
    f = fRGB;
end

%% 1. Compute x and y derivatives of image
[dx,dy] = meshgrid(-filtSize:filtSize, -filtSize:filtSize);

% Smoothing the image
gaussSmoothing =1/(2*pi*sigma) *  exp(-(dx.^2 + dy.^2)/(2*sigma^2));
f = conv2(f,gaussSmoothing,'same');

% Getting derivative
fx = conv2(f,dx,'same');
fy = conv2(f,dy,'same');

%% 2. Compute products of derivatives at every pixel
fx2 = fx.^2;
fy2 = fy.^2;
fxy = fx.*fy;

%% 3.  Compute the sums of the products of derivatives at each pixel
weights = exp(-(dx.^2+dy.^2)/2*sigma);

sumfx2 = conv2(fx2, weights, "same");
sumfy2 = conv2(fy2, weights, "same");
sumfxy = conv2(fxy, weights, "same");

%% 4. Define at each pixel the Matrix H
[rows, cols] = size(fx2);
R = zeros(rows, cols); % Array with image dimensions, containing a value where a corner is detected
borderLimit = 3; % Reject corners to close to image borders due to their too small neighborhood -> bad comparable

for pixel = 1:numel(fx2)
    H = [sumfx2(pixel) sumfxy(pixel); sumfxy(pixel) sumfy2(pixel)];

    %% 5. Compute the reponse of the detector at each pixel
    r = det(H) - k * (trace(H))^2;

    %% 6. Threshold on value of R
    if(r > T)
        % Get coordinates of corner
        [row, col]=ind2sub(size(fx2), pixel);
        % Reject if to close to image borders
        if row < borderLimit || row > rows - borderLimit || col < borderLimit || col > cols - borderLimit
            continue;
        end
        R(pixel) = r;
        %end
    end
end

%% 7. Compute nonmax suppression
[rows, cols] = size(R);

for currentRow = 1:rows
    for currentCol = 1:cols
        % If found corner
        if(R(currentRow, currentCol) > 0)
            % checkArray = [(currentRow - supFactor):(currentRow + supFactor); (currentCol - supFactor):(currentCol + supFactor)];
            % Iterate through rows arround corners position
            for loopRow = (currentRow - supFactor):(currentRow + supFactor)
                % Make sure to stay within arrays boundaries
                if(loopRow < 1 || loopRow > rows)
                    % Skip if not
                    continue;
                end
                % Iterate through cols arround corners position
                for loopCol = (currentCol - supFactor):(currentCol + supFactor)
                    % Make sure to stay within arrays boundaries
                    if(loopCol < 1 || loopCol > cols)
                        % Skip if not
                        continue;
                    end
                    if(R(currentRow, currentCol) < R(loopRow, loopCol))
                        R(currentRow, currentCol) = 0;
                    end
                end
            end
        end
    end
end

%% Generate output:
% Struct for output
corners = struct;
corners.length = 0;
corners.coordinates = [[];[]];
corners.pixelIntens= [[];[]];
corners.image = R;

% Length & Coordinates
[rows, cols] = size(R);

for row = 1:rows
    for col = 1:cols
        if (R(row, col) > 0)
            corners.length = corners.length + 1;
            corners.coordinates = [corners.coordinates; [row, col]];
            corners.pixelIntens = [corners.pixelIntens; f(row, col)];
        end 
    end
end

% Generate image for output
switch visualize
    case 'on'
        % Insert corner markings into returned image
        for pixel = 1:numel(R)
            [row, col] = ind2sub(size(fx2), pixel);
            if R(pixel) > 0
                forig = insertMarker(forig, [col row]);
            end
        end
        %f = uint8(f);
        img = forig;
        figure, imshow(img);
    case 'off'
        img = forig;
end

end