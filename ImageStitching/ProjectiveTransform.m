function [H] = ProjectiveTransform(xy,uv)
%PROJECTIVETRANSFORM Summary of this function goes here
% ohne strich =xy
% x=x
% y=y
% mit ' =uv
% u=x'
% v=y'
[xy,uv,T1,T2]=normalizePoints(xy,uv);

M = size(xy,1);
x = xy(:,1);
y = xy(:,2);
vec_1 = ones(M,1);
vec_0 = zeros(M,1);
u = uv(:,1);
v = uv(:,2);

%w=1 w'=1

A=[vec_0 vec_0 vec_0 -x -y -vec_1 x.*v y.*v v;
    x y vec_1 vec_0 vec_0 vec_0 -x.*u -y.*u u];

svd(A)

H=eye(3);
end

