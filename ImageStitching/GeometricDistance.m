function [error] = GeometricDistance(H,x1,x2)
%Symmetric transfer Error
%Multiple View Geometry page 95
% d(x1,H^-1*x2)²+d(x2,H*x1)²
% H = Homography Matrix
% x1 = first Picture Correspondance
% x2 = second Picture Correspondance
Hx1=TfH(x1,H);
d1=x2-Hx1;
d1=norm(d1);

Hx2=TfH(x2,inv(H));
d2=x1-Hx2;
d2=norm(d2);

error=d1^2+d2^2;
end

