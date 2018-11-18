% Todo: Gaussian low-pass the image

clc;
workingDir = pwd;
cd(workingDir);

% Set parameters
filtSize = 1;
sigma = 1;
k = 0.24;
T = 0.1;
supFactor = 2;

% 0. Load image and transform to grayscale
f=double(rgb2gray(imread('images\checkers.jpg')));

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

% for row = 1:rows
%     for col = 1:cols
%         H = [sumfx2(rows,cols) sumfxy(pixel); sumfxy(pixel) sumfy2(pixel)];


for pixel = 1:numel(fx2)
    H = [sumfx2(pixel) sumfxy(pixel); sumfxy(pixel) sumfy2(pixel)];
    
    % 5. Compute the reponse of the detector at each pixel
    r = det(H) - k * (trace(H))^2;   
    
    % 6. Threshold on value of R
    if(r > T)
        [col, row]=ind2sub(size(fx2), pixel);
        R(pixel) = r;
        f = insertMarker(f, [row col]);
    end 
end

[rows, cols] = size(R);

for pixel = 1:numel(R)
    % If found corner
    if(R(pixel) > 0)
        % Get Position
        [col, row] = ind2sub(size(R), pixel);
        [row col]
        R(pixel)
        supFactor
        testArray = [(row - supFactor):(row + supFactor); (col - supFactor):(col + supFactor)];
        % Iterate through rows arround corners position
        for loopRow = (row - supFactor):(row + supFactor)
            % Make sure to stay within arrays boundaries
            if(loopRow < 1 || loopRow > rows)
                % Skip if not
                continue;
            end 
            % Iterate through cols arround corners position
            for loopCol = (col - supFactor):(col + supFactor)
                % Make sure to stay within arrays boundaries
                if(loopCol < 1 || loopCol > cols)
                    % Skip if not
                    continue;
                end 
                if(R(pixel) < R(loopRow, loopCol))
                    R(pixel) = 0;
                end
            end
        end  
    end
end

%figure, imshow(f);

% We also want c to be a local maximum in a 9×9 neighborhood 
% (with non-maximum suppression).
% for each pixel, before applying non-maximum suppression 
% (computing the local maximum).
% 7. Compute nonmax suppression
