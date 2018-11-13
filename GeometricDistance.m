function [error] = GeometricDistance(H,x1,x2)
%Symmetric transfer Error
%Multiple View Geometry page 95
% d(x1,H^-1*x2)²+d(x2,H*x1)²
% H = Homography Matrix
% x1 = first Picture Correspondance
% x2 = second Picture Correspondance

x1=[x1 1];
x2=[x2 2];

Hx1=x1*H;
Hx1=Hx1/Hx1(3); %normieren
d1=x2-Hx1;
d1(3)=0;
d1=norm(d1);

Hx2=x2*inv(H);
Hx2=Hx2/Hx2(3);
d2=x1-Hx2;
d2(3)=0;
d2=norm(d2);

error=d1^2+d2^2;
end

