%Funktion die die Indizes der gematchen Punkte in allen gefundenen
%markanten Punkten für 2 Bilder ermittelt und eine Verbindung herstellt
%Autor: Michael Wimmer
function [ indexPairs] = getIndexPairs(corners, corners2, matchedPoints1, matchedPoints2)
indexPairs1 = [];
    indexPairs2 = [];
    for j = 1 : length(matchedPoints1)
        testPoint = [matchedPoints1(j,2), matchedPoints1(j,1)];
        for k = 1 : length(corners.coordinates)
            if(testPoint == corners.coordinates(k,:))
                indexPairs1 = [indexPairs1; k];
            end
        end
    end
    for m = 1 : length(matchedPoints2)
        testPoint = [matchedPoints2(m,2), matchedPoints2(m,1)];
        for n = 1 : length(corners2.coordinates)
            if(testPoint == corners2.coordinates(n,:))
                indexPairs2 = [indexPairs2; n];
            end  
        end
    end
    indexPairs = [indexPairs1, indexPairs2];
end

