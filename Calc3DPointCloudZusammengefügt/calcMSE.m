function MSE = calcMSE(f1,f2, feat1, feat2, n, T, overlapX, overlapY)
    %
    % 'f1'          : First image 
    %
    % 'f2'          : Second image
    %
    % 'feat1'       : Detected features coordinates in first image
    %
    % 'feat2'       : Detected features coordinates in second image
    %
    % 'n'           : Determines size of analyzed window around a feature
    %
    % 'T'           : Threshold value for detecting a match
    %
    % 'overlap'     : Estimated overlap of the images, used as plausibility
    %                 check for matched features
    

    n = floor(n/2);
    
    rows1 = size(feat1,1);
    rows2 = size(feat2,1);
    [imgRows1, imgCols1] = size(f1);
    [imgRows2, imgCols2] = size(f2);
    MSE = [[];[]]; % All MSE = [[mse, row1, col1, row2, col2, distance]; ...]
    MSE1 = [[];[]];

    %% Calculate MSE of all feature's windows
    for row1 = 1:rows1
        %% Calculate all MSEs for selected feature
        MSEelement = [[];[]]; 
        zeile1 = feat1(row1, 1);
        spalte1 = feat1(row1, 2);
        for row2 = 1:rows2
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
%% Calculate all MSEs for selected feature 2/2
            mse = 0;
            count = 0;
            zeile2 = feat2(row2, 1);
            spalte2 = feat2(row2, 2);
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
                    mse = mse + (f1(zeile1+xshift, spalte1+yshift)-f2(zeile2+xshift, spalte2+yshift))^2;
                    count = count +1;
                end
            end
            mse = (1/count) * mse;
            MSEelement = [MSEelement; [mse, zeile1, spalte1, zeile2, spalte2]];
        end
        
        %% Select best match by minimal MSE
        if 1 == isempty(MSEelement)
            continue;
        end
        [val, ind] = min(MSEelement(:,1));
        bestMatch = MSEelement(ind, :); % bestMatch = [mse, row1, col1, row2, col2]
        
        %% Filter best match with threshold value
        if bestMatch(1) > T
            % Skip iteration and drop bestMatch
            continue;
        end
        
%         %% Filter by overlap
%         % Set overlap plausibility parameters
%         tolerance = 0;
%         shiftX = (1-overlapX) * size(f1,2) + tolerance;
%         shiftY = (1-overlapY) * size(f1,1) + tolerance;
%         
%         y1 = bestMatch(1, 2);
%         x1 = bestMatch(1, 3);
%         y2 = bestMatch(1, 4);
%         x2 = bestMatch(1, 5);
%         
%         % Image shift
%         if abs(x1-x2) > shiftX
%             continue
%         end
%         if abs(y1-y2) > shiftY
%             continue
%         end
        
        %% Filter double matches
        % If L�nge MSE == 0, f�ge hinzu
        if size(MSE,1) == 0
            MSE = [MSE; bestMatch];
        % Else pr�fe ob Koordinate bereits gematcht
        else
            % If Koordinate links bereits gematcht
            [tf1, rowExist1] = ismember(bestMatch(1,2:3), MSE(:,2:3), 'rows');
            [tf2, rowExist2] = ismember(bestMatch(1,4:5), MSE(:,4:5), 'rows');
            if tf1 == 1
                % If MSE von bestMatch < alte MSE, f�ge hinzu
                if bestMatch(1,1) < MSE(rowExist1,1)
                    MSE(rowExist1,:) = bestMatch;
                % else verwerfe Match
                else
                    continue;
                end
            % Elseif Koordinate rechts bereits gematcht    
            elseif tf2 == 1
                % If MSE von bestMatch < alte MSE, f�ge hinzu
                if bestMatch(1,1) < MSE(rowExist2,1)
                    MSE(rowExist2,:) = bestMatch;
                % else verwerfe Match
                else
                    continue;
                end 
            % Else nicht gematched, f�ge Match hinzu
            else
                MSE = [MSE; bestMatch];
            end
        end
        
    end

end