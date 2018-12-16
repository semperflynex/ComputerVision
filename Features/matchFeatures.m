function matches = matchFeatures(f1, f2, features1, features2, n, T, overlap)
    %
    % 'f1'          : First RGB image 
    %
    % 'f2'          : Second RGB image
    %
    % 'features1'   : Detected features coordinates in first image
    %
    % 'features2'   : Detected features coordinates in second image
    %
    % 'n'           : Size of the analyzed area around the feature
    %
    % 't'           : Threshold value for detecting a match
    %
    % 'overlap'     : Estimated overlap of the images, used as plausibility
    %                 check for matched features
    
    f1 = double(rgb2gray(f1));
    f2 = double(rgb2gray(f2));
    
    % Perform image sharpening -> Seems to make result even worse
%     hSharp1 = [[0, -1, 0]; [-1, 4, -1]; [0, -1, 0]];
%     hSharp2 = [[-1, -1, -1]; [-1, 8, -1]; [-1, -1, -1]];
%     f1 = conv2(f1, hSharp1,'same');
%     f2 = conv2(f1, hSharp1,'same');
   
    % Calculate SSD
    SSD = calcSSD(f1,f2, features1, features2, n, T, overlap);
    
    matches = SSD;
    
    function SSD = calcSSD(f1,f2, feat1, feat2, n, T, overlap)
        rows1 = size(feat1,1);
        rows2 = size(feat2,1);
        [imgRows1, imgCols1] = size(f1);
        [imgRows2, imgCols2] = size(f2);
        SSD = [[];[]];
        SSDfinal = [[];[]];% SSDfinal = [[ssd, row1, col1, row2, col2, distance]; ...]

        for row1 = 1:rows1
            %1/3 * row1/rows1 % Debug show progress
            SSDelement = [[];[]]; % SSDelement = [[ssd, zeile1, spalte1, zeile2, spalte2]; ...]
            zeile1 = feat1(row1, 1);
            spalte1 = feat1(row1, 2);
            for row2 = 1:rows2
                ssd = 0;
                zeile2 = feat2(row2, 1);
                spalte2 = feat2(row2, 2);
                for xshift = -n:n
                    if (zeile1+xshift < 1 || zeile1+xshift > imgRows1 || zeile2+xshift < 1 || zeile2+xshift > imgRows2)
                        continue;
                    end
                    for yshift = -n:n
                        if (spalte1+yshift < 1 || spalte1+yshift > imgCols1 || spalte2+yshift < 1 || spalte2+yshift > imgCols2)
                            continue;
                        end
                        ssd = ssd + (f1(zeile1+xshift, spalte1+yshift)-f2(zeile2+xshift, spalte2+yshift))^2;
                    end
                end
                SSDelement = [SSDelement; [ssd, zeile1, spalte1, zeile2, spalte2]];
            end
            % Select best match
            [val, ind] = min(SSDelement(:,1));
            bestMatch = SSDelement(ind, :); % bestMatch = [ssd, row1, col1, row2, col2]
            % Threshold old
            if bestMatch(1) < T
                SSDfinal = [SSDfinal; [bestMatch]]; % SSDfinal = [[ssd, row1, col1, row2, col2]; ...]
            end
        end
        
        % Filter SSDfinal:
        % Set overlap plausibility parameters
        tolerance = 0;
        shift = (1-overlap) * size(f1,2) + tolerance;
        
        for row1 = 1:size(SSDfinal, 1)
            %1/3 + 1/3 * row1/size(SSDfinal, 1) % Debug show progress
            y1 = SSDfinal(row1, 2);
            x1 = SSDfinal(row1, 3);
            y2 = SSDfinal(row1, 4);
            x2 = SSDfinal(row1, 5);
            % Image shift
             if abs(x1-x2) > shift
                 continue
             end
             if abs(y1-y2) > shift
                 continue
             end
            
            % Filter out double matches
            for row2 = 2:size(SSDfinal,1)
                if 1 == isequal(SSDfinal(row1, 2:3), SSDfinal(row2, 2:3)) || 1 == isequal(SSDfinal(row1, 4:5), SSDfinal(row2, 4:5))
                    if SSDfinal(row1, 1) > SSDfinal(row2, 1)
                        SSDfinal(row1, 1) = SSDfinal(row2, 1);
                        SSDfinal(row1, 2) = SSDfinal(row2, 2);
                        SSDfinal(row1, 3) = SSDfinal(row2, 3);
                        SSDfinal(row1, 4) = SSDfinal(row2, 4);
                        SSDfinal(row1, 5) = SSDfinal(row2, 5);
                    else 
                        SSDfinal(row2, 1) = SSDfinal(row1, 1);
                        SSDfinal(row2, 2) = SSDfinal(row1, 2);
                        SSDfinal(row2, 3) = SSDfinal(row1, 3);
                        SSDfinal(row2, 4) = SSDfinal(row1, 4);
                        SSDfinal(row2, 5) = SSDfinal(row1, 5);
                    end
                end
            end
            SSD = [SSD; SSDfinal(row1, :)];
        end
        SSD = unique(SSD, 'rows');
        %__________________________________
        SSDidi = [[];[]];
        for row1 = 1:size(SSD, 1)
            % 2/3 + 1/3 * row1/size(SSD, 1)  % Debug show progress
            y1 = SSD(row1, 2);
            x1 = SSD(row1, 3);
            y2 = SSD(row1, 4);
            x2 = SSD(row1, 5);
            % Image shift
             if abs(x1-x2) > shift
                 continue
             end
             if abs(y1-y2) > shift
                 continue
             end
             SSDidi = [SSDidi; SSD(row1, :)];
        end
        SSD = SSDidi;
        %__________________________________
        
        
        % Uncomment to show matched points without interconnection
%         [rows, cols] = size(SSD);
%         f1 = insertMarker(uint8(f1), [SSD(:, 3) SSD(:, 2)]);
%         f2 = insertMarker(uint8(f2), [SSD(:,5) SSD(:,4)]);
%         figure, montage({f1, f2});
    end
end