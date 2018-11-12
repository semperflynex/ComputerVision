function [error] = TransformError(tfMatrix,Point1,Point2)
%TRANSFORMERROR Summary of this function goes here
%   Detailed explanation goes here
%Point1=transpose(Point1);
%Point2=transpose(Point2);
calculatedPoint=Point1*tfMatrix;
calculatedPoint=calculatedPoint/calculatedPoint(3);
diff=Point2-calculatedPoint;
diff=[diff(1);diff(2)];
error=norm(diff);
end

