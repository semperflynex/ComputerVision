function [corners, img] = harrisCorners(fRGB, filtSize, sigma, k, T, supFactor)
% To do: Gaussian low-pass the image
% To do: Merge different loops for speed enhacement 
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
% The function returns 
%
% 'corners'  :  
%
% 'img'      :  An image with marked corners

% Transform image to grayscale if not done yet
if size(fRGB,3) == 3
    f = rgb2gray(fRGB);
else
    f = fRGB;
end

% Perform image sharpening
%     hSharp1 = [[0, -1, 0]; [-1, 4, -1]; [0, -1, 0]];
%     hSharp2 = [[-1, -1, -1]; [-1, 8, -1]; [-1, -1, -1]];
%     f = conv2(f, hSharp1,'same');
%    figure; montage({f,f1,f2});


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
RAngles = [[];[]];
AnglesForDrawing = [[];[]];
fDetected = f;

for pixel = 1:numel(fx2)
    H = [sumfx2(pixel) sumfxy(pixel); sumfxy(pixel) sumfy2(pixel)];

    % 5. Compute the reponse of the detector at each pixel
    r = det(H) - k * (trace(H))^2;

    % 6. Threshold on value of R
    borderLimit = 5; % cut of corners detected to close to image limits 
    if(r > T)
         [row, col]=ind2sub(size(fx2), pixel);%-------------------------------------------------------------------------------------------
         if(row > borderLimit && row < size(fx,1)-borderLimit &&col > borderLimit && col < size(fx,2)-borderLimit)
             R(pixel) = r;
             %fDetected = insertMarker(fDetected, [row col]);
         end
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
            AnglesForDrawing = [AnglesForDrawing; [row, col, fx(row, col), fy(row,col)]]; % AnglesForDrawing = [[row, col, dx, dy];...]
            RAngles = [RAngles; [row, col, (atan(fy(row, col)/fx(row, col))*180/pi)]]; % RAngles = [[row, col, angle];...]
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

% for pixel = 1:numel(RThresholded)
%     if (RThresholded(pixel)>0)
%         [row, col]=ind2sub(size(RThresholded), pixel);
%         fSuppressed = insertMarker(fSuppressed, [col row]);
%     end
% end

% Uncomment to visualize the difference between detected and finally accepted corners
% montage([fRGB, fDetected, fSuppressed])

% Generate output:
corners = struct;
corners.length = 0;
corners.coordinates = [[];[]];
corners.pixelIntens= [[];[]];
corners.image = RThresholded;

% Length & Coordinates
[rows, cols] = size(RThresholded);

for row = 1:rows
    for col = 1:cols
        if (RThresholded(row, col) > 0)
            corners.length = corners.length + 1;
            corners.coordinates = [corners.coordinates; [row, col]];
            corners.pixelIntens = [corners.pixelIntens; f(row, col)];
        end 
    end
end

% return marked image
img = fSuppressed;

% Visualize corner directions
%     resize = 1;
%     figure, imshow(fSuppressed); hold on;impixelinfo; 
%     q1 = quiver(AnglesForDrawing(:,2),AnglesForDrawing(:,1),AnglesForDrawing(:,2)*resize,AnglesForDrawing(:,1)*resize);
%     q1.Color = 'green';
%     q1.LineWidth = 2;
%     q2 = quiver(AnglesForDrawing(:,2),AnglesForDrawing(:,1),10*resize.*ones(length(AnglesForDrawing),1),tan(RAngles(:,3)*pi/180)*10*resize.* ones(length(AnglesForDrawing),1));
%     AnglesForDrawingCalc = [AnglesForDrawing(:,1), AnglesForDrawing(:,2), 10*resize.*ones(length(AnglesForDrawing),1), tan(RAngles(:,3)*pi/180)*10*resize.* ones(length(AnglesForDrawing),1)]
%     q2.Color = 'red';
%     q2.LineWidth = 2;

end