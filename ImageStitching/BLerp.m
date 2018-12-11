function [color] = BLerp(pos,I)
%BLERP Bilinear Interpolation
% Gets Bilinera interpolated Color Value for Position pos in Image I
% 
% p1..p5.. p2
%
%    color
%
% p3..p6.. p4

x=pos(1);
y=pos(2);
if(floor(x)<=0)
    x
end
if (floor(y)<=0)
    y
end




p1=I(floor(x),floor(y));
p2=I(ceil(x),floor(y));
p3=I(floor(x),ceil(y));
p4=I(ceil(x),ceil(y));

p1=double(p1);
p2=double(p2);
p3=double(p3);
p4=double(p4);

p5=p2-(p2-p1)*(ceil(x)- x);
p6=p4-(p4-p3)*(ceil(x)- x);

color=p6-(p6-p5)*(ceil(y)-y);
end

