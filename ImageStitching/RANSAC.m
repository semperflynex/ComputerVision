function [H] = RANSAC(points1,points2,p,eta,s,t)
%RANSAC Algorithm
% Calculates the Homography Matrix H
% using pairs of Feature Points
% p= Confidence
% eta=estimated proportion of outliers
% s= number of Points required for the Model
% t= threshold distance (should be 5.99*sigma², but sigma is unknown)
c=size(points1,1);

%%
%Determine the Number of random Samples minimally required
% s= number of Points required for the Model
N=log(1-p)/log(1-(1-eta)^s);
N=ceil(N)
%%
% generate N random pairs of four Points
combinations=zeros(N,s);
for i=1:N
    sequence=randperm(c,s);
    %if add random sequence to vector if it doesnt exist already
    if (isempty(find(ismember(combinations,sequence,'rows'), 1)))
        combinations(i,:)=sequence;
    end
end
%%
maxinlier=0;
for i=1:N
    %pick s point pairs required for the calculation
    selectedPoints1=zeros(s,2);
    selectedPoints2=zeros(s,2);
    for j=1:s
        selectedPoints1(j,:)=points1(combinations(i,j),:);
        selectedPoints2(j,:)=points2(combinations(i,j),:);
    end
   %calculate the transform
   newH=ProjectiveTransform(selectedPoints1,selectedPoints2);
%     newH=fitgeotrans(selectedPoints1,selectedPoints2, 'projective');
%     newH=newH.T;
    
    inlier=0;
    %evaluate H against all samples
    for n=1:c
        error=GeometricDistance(newH,points1(n,:),points2(n,:));
        error=sqrt(error);
        if error<t
            inlier=inlier+1;
        end
    end
    
    if inlier>maxinlier
        H=newH;
        maxinlier=inlier;
    end
end
maxinlier
%%
% recalculate matrix using all inliers
% NOT VERY EFFECTIVE!
newH=H;
for j=1:10
% get all inliers
inliers1=points1(1:maxinlier,:);
inliers2=points2(1:maxinlier,:);
i=1;
sumError=0;
for n=1:c
        error=GeometricDistance(newH,points1(n,:),points2(n,:));
        error=sqrt(error);
        if error<t
            inliers1(i,:)=points1(n,:);
            inliers2(i,:)=points2(n,:);
            i=i+1;
            sumError=sumError+error;
        end
end
sumError
i-1

% calculate new matrix
newH=ProjectiveTransform(inliers1,inliers2);
%newH=newH.T;


%get the new error
i=1;
for n=1:c
        error=GeometricDistance(newH,points1(n,:),points2(n,:));
        error=sqrt(error);
        if error<t
            inliers1(i,:)=points1(n,:);
            inliers2(i,:)=points2(n,:);
            i=i+1;
            sumError=sumError+error;
        end
end

end

%H=newH;
end

