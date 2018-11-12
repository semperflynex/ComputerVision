function [transform] = BFSAC(matchedPoints1,matchedPoints2)
%   Brute Force Sample Consensus BFSAC
% 
% Hier werden nicht zufällig Punktkombinationen ausgewählt sondern einfach 
% alle möglichen durchiteriert
warning('off','all')


 c=matchedPoints1.Count
 maxinliner=0;
   for p1=1:c
       for p2=p1+1:c
          for p3=p2+1:c
            for p4=p3+1:c
                
               if (maxinliner<23)
                   
                
                 selectedPoints1=[matchedPoints1(p1);matchedPoints1(p2);matchedPoints1(p3);matchedPoints1(p4)];
                  selectedPoints2=[matchedPoints2(p1);matchedPoints2(p2);matchedPoints2(p3);matchedPoints2(p4)];
                   
                vntform = fitgeotrans(selectedPoints1.Location,selectedPoints2.Location, 'projective');
                ntform=vntform.T;
                inliner=0;
                
                parfor n=1:c
                    idiff=getTransformError(ntform,[matchedPoints1(n).Location,1],[matchedPoints2(n).Location,1]);
                   if(idiff<1.00)
                       inliner=inliner+1;
                   end
                end
                
               if (inliner>maxinliner)
                   tform=ntform;
                   maxinliner=inliner
               end
                end
             
            end
          end
       end
   end
   transform=projective2d(tform);
end

