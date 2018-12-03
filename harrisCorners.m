function [corners, img] = harrisCorners(fRGB, filtSize, sigma, k, T, supFactor)
% Todo: Gaussian low-pass the image
%
% 'f'        :  RGB image to be analyzed
%
% 'filtSite' :  Determines the size of the filter used for the derivate
%               filter
%
% 'sigma'    :  
%
% 'k'        :  Sensitivity of corner detector. Small k -> more corners
%               will be detected, large k -> less corners will be detected
%
% 'T'        :  Threshold value for corner detection
%
% 'supFactor":  Determines the size of the windows considered for maximum
%               suppression
%
% The function returns 

    % Transform image to grayscale
    f=rgb2gray(fRGB);
    
    % 1. Compute x and y derivatives of image
    [dx,dy] = meshgrid(-filtSize:filtSize, -filtSize:filtSize);

    fx = conv2(f,dx,'same');
    fy = conv2(f,dy,'same');

    % 2. Compute products of derivatives at every pixel
    fx2 = fx.^2;
    fy2 = fy.^2;
    fxy = fx .* fy;

    % 3.  Compute the sums of the products of derivatives at each pixel
    weights = exp(-(dx.^2+dy.^2)/2*sigma);

    sumfx2 = conv2(fx2, weights, "same");
    sumfy2 = conv2(fy2, weights, "same");
    sumfxy = conv2(fxy, weights, "same");

    % 4. Define at each pixel the Matrix H
    [rows, cols] = size(fx2);
    R = zeros(rows, cols);

    fDetected = f;

    for pixel = 1:numel(fx2)
        H = [sumfx2(pixel) sumfxy(pixel); sumfxy(pixel) sumfy2(pixel)];

        % 5. Compute the reponse of the detector at each pixel
        r = det(H) - k * (trace(H))^2;

        % 6. Threshold on value of R
         if(r > T)
             [col, row]=ind2sub(size(fx2), pixel);
             R(pixel) = r;
             fDetected = insertMarker(fDetected, [row col]);
         end
    end

    % Test other threshold formulation
     T = T*max(R(:));
    [rows, cols] = size(R);
    
    RThresholded = zeros(rows, cols);
    
    for row = 1:rows
        for col = 1:cols
            if R(row, col) > T
                RThresholded(row, col) = R(row, col);
            end
        end
     end

    % 7. Compute nonmax suppression
    [rows, cols] = size(RThresholded);

    for currentRow = 1:rows
        for currentCol = 1:cols
            % If found corner
            if(RThresholded(currentRow, currentCol) > 0)
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
                        if(RThresholded(currentRow, currentCol) < RThresholded(loopRow, loopCol))
                            RThresholded(currentRow, currentCol) = 0;
                        end
                    end
                end
            end
        end
    end

    fSuppressed = f;

    for pixel = 1:numel(RThresholded)
        if (RThresholded(pixel)>0)
            [col, row]=ind2sub(size(RThresholded), pixel);
            fSuppressed = insertMarker(fSuppressed, [row col]);
        end
    end

    % Uncomment to visualize the difference between detected and finally accepted corners
    % montage([fRGB, fDetected, fSuppressed])
    
    corners = RThresholded;
    img = fSuppressed;
end