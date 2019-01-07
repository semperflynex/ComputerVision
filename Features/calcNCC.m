function NCC = calcNCC(f1,f2, feat1, feat2, n, T, overlapX, overlapY)
%
% 'f1'          : First image 
%
% 'f2'          : Second image
%
% 'feat1'       : Detected features coordinates in first image
%
% 'feat2'       : Detected features coordinates in second image
%
% 'n'           : Determines size of analyzed window around a feature,
%                 chose an odd number
%
% 'T'           : Threshold value for detecting a match
%
% 'overlap'     : Estimated overlap of the images, used as plausibility
%                 check for matched features

windowsize = n;
n = floor(n/2);

rows1 = size(feat1,1);
rows2 = size(feat2,1);
[imgRows1, imgCols1] = size(f1);
[imgRows2, imgCols2] = size(f2);
NCC = [[];[]]; 

%% Calculate NCCs of all feature's windows
for row1 = 1:rows1
%% Calculate all NCCs for selected feature 1/2
    NCCelement = [[];[]]; 
    zeile1 = feat1(row1, 1);
    spalte1 = feat1(row1, 2);
    mean1 = calcMean(feat1(row1, 2), feat1(row1, 1), windowsize, f1);
    stdDev1 = calcStdDev(feat1(row1, 2), feat1(row1, 1), windowsize, f1);
    % take feature from feat1
    for row2 = 1:rows2
        % take feature from feat2
%% Filter by overlap
        % Set overlap plausibility parameters
        tolerance = 0;
        shiftX = (1-overlapX) * size(f1,2) + tolerance;
        shiftY = (1-overlapY) * size(f1,1) + tolerance;

        y1 = feat1(row1, 1);
        x1 = feat1(row1, 2);
        y2 = feat2(row2, 1);
        x2 = feat2(row2, 2);

        % Image shift
        if abs(x1-x2) > shiftX
            continue
        end
        if abs(y1-y2) > shiftY
            continue
        end
%% Calculate all NCCs for selected feature 2/2
        ncc = 0;
        zeile2 = feat2(row2, 1);
        spalte2 = feat2(row2, 2);
        mean2 = calcMean(feat2(row2, 2), feat2(row2, 1), windowsize, f2);
        stdDev2 = calcStdDev(feat2(row2, 2), feat2(row2, 1), windowsize, f2);
        for xshift = -n:n
            % check if x in picture
            if (zeile1+xshift < 1 || zeile1+xshift > imgRows1 || zeile2+xshift < 1 || zeile2+xshift > imgRows2)
                continue;
            end
            for yshift = -n:n
                % check if y in picture
                if (spalte1+yshift < 1 || spalte1+yshift > imgCols1 || spalte2+yshift < 1 || spalte2+yshift > imgCols2)
                    continue;
                end
                ncc = ncc + ( (f1(zeile1+xshift, spalte1+yshift) - mean1) * (f2(zeile2+xshift, spalte2+yshift) - mean2) ) /...
                            (                      windowsize^2 * stdDev1 * stdDev2                                     );
            end
        end
        NCCelement = [NCCelement; [ncc, zeile1, spalte1, zeile2, spalte2]];
        %NCC = [NCC; [ncc, zeile1, spalte1, zeile2, spalte2]];
    end
%% Select best match by maximal NCC
    if 1 == isempty(NCCelement)
        continue;
    end
    [val, ind] = max(NCCelement(:,1));
    bestMatch = NCCelement(ind, :); % bestMatch = [ncc, row1, col1, row2, col2]

%% Filter best match with threshold value
    %
    if bestMatch(1) < T
        % Skip iteration and drop bestMatch
        continue;
    end



    %% Filter double matches
    % If Länge NCC == 0, füge hinzu
    if size(NCC,1) == 0
        NCC = [NCC; bestMatch];
    % Else prüfe ob Koordinate bereits gematcht
    else
        % If Koordinate links bereits gematcht
        [tf1, rowExist1] = ismember(bestMatch(1,2:3), NCC(:,2:3), 'rows');
        [tf2, rowExist2] = ismember(bestMatch(1,4:5), NCC(:,4:5), 'rows');
        if tf1 == 1
            % If NCC von bestMatch > alte NCC, füge hinzu
            if bestMatch(1,1) > NCC(rowExist1,1)
                NCC(rowExist1,:) = bestMatch;
            % else verwerfe Match
            else
                continue;
            end
        % Elseif Koordinate rechts bereits gematcht    
        elseif tf2 == 1
            % If NCC von bestMatch > alte NCC, füge hinzu
            if bestMatch(1,1) > NCC(rowExist2,1)
                NCC(rowExist2,:) = bestMatch;
            % else verwerfe Match
            else
                continue;
            end 
        % Else nicht gematched, füge Match hinzu
        else
            NCC = [NCC; bestMatch];
        end
    end

end

%% Functions
function mean = calcMean(x, y, windowSize, img)
    delta = floor(windowSize/2);
    X = [x-delta:x+delta];
    Y = [y-delta:y+delta];
    
    % Remove x values outside of image
    delX = X < 1 | X > size(img,2);
    X(delX) = [];
    
    % Remove y values outside of image
    delY = Y < 1 | Y > size(img,1);
    Y(delY) = [];
    
    % Extract Patch of interest
    imgPatch = img(Y, X);
    
    % Sum up values in patch
    sum = 0;
    for pixel = 1:numel(imgPatch)
        sum = sum + imgPatch(pixel);
    end
    
    % Calculate mean value
    mean = 1/numel(imgPatch) * sum;
end

function stdDev = calcStdDev(x, y, windowSize, img)
    delta = floor(windowSize/2);
    X = [x-delta:x+delta];
    Y = [y-delta:y+delta];
    
    % Remove x values outside of image
    delX = X < 1 | X > size(img,2);
    X(delX) = [];
    
    % Remove y values outside of image
    delY = Y < 1 | Y > size(img,1);
    Y(delY) = [];
    
    % Extract Patch of interest
    imgPatch = img(Y, X);
    
    % Calculate mean
    x_mean = calcMean(x, y, windowSize, img);
    
    % Sum up all (x_n - x_mean)^2
    sum = 0;
    
    for pixel = 1:numel(imgPatch)
        sum = sum + (imgPatch(pixel) - x_mean)^2;
    end
    
    % Calculate variance
    var = 1/numel(imgPatch) * sum;
    
    % Calculate standard deviation
    stdDev = sqrt(var);
end

end
