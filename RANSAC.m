function [H] = RANSAC(points1,points2,p,eta,s)
%RANSAC Algorithm
% Calculates the Homography Matrix H
% using pairs of Feature Points
% p= Confidence
% eta=estimated proportion of outliers
% s= number of Points required for the Model
%%
%Determine the Number of random Samples minimally required
% s= number of Points required for the Model
N=log(1-p)/log(1-(1-eta)^s);
N=ceil(N)
%%
% generate N random pairs of four Points
count=points1.Count;
combinations=zeros(count,s);
for i=1:N
    sequence=randperm(points1.Count,s);
    %if add random sequence to vector if it doesnt exist already
    if (isempty(find(ismember(combinations,sequence,'rows'))))
        combinations(i,:)=sequence;
    end
end
%%
for i=1:N
    sequence=combinations(:

end

