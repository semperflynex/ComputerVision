function [bounds] = getBounds(I,H)
%GETBOUNDS [xMin yMin xMax yMax]


ISize=size(I);

%transform every corner
corners=[0,0;ISize(1),0;0,ISize(2);ISize(1),ISize(2)];
for i=1:4
    corners(i,:)=TfH(corners(i,:),H);
end

TMin=min(corners);
TMax=max(corners);

bounds=round([TMin,TMax]);

end