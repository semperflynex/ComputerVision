%     function intensities = collectIntensities(f, featureList)
%         intensities = [[];[]];
%         [rows, cols] = size(featureList);
%         for row = 1:rows
%             intensities = [ intensities; [ featureList(row, 1), featureList(row, 2), f(featureList(row, 1),featureList(row, 2))]];
%         end
%     end

%     function intensities = buildAverages(f, features, n)
%     % Currently not used
%         [rows, cols] = size(features);
%         intensities = [[];[]];
%         
%         for currentRow = 1:rows
%             intensCum = 0;
%             count = 0;
%             f(features(currentRow,1),features(currentRow,2))
%             for loopRow = (features(currentRow,1) - n):(features(currentRow,1) + n)
%                 % Make sure to stay within arrays boundaries
%                 [loopRow, features(currentRow,1) - n]
%                 if(loopRow < 1 || loopRow > imgRows) % Skip if not
%                     continue;
%                 end
%                 % Iterate through cols arround corners position
%                 for loopCol = (features(currentRow,2) - n):(features(currentRow,2) + n)
%                     % Make sure to stay within arrays boundaries
%                     if(loopCol < 1 || loopCol > imgCols) % Skip if not
%                         continue;
%                     end
%                     % Sum up intensities
%                     intensCum = intensCum + f(loopRow, loopCol);
%                     count = count + 1;
%                 end    
%             end         
%             intensAvrg = intensCum/count;%(2*n+1)^2;    
%             intens = f(features(currentRow,1), features(currentRow,2)); 
%             % intensities1 = [[row, col, intens, intensAvrg]; ...]
%             intensities = [intensities; [features(currentRow,1), features(currentRow,2), intens, intensAvrg]];
%         end
%     end