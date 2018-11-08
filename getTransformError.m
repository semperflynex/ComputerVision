function [error] = TransformError(tfMatrix,Point1,Point2)
%TRANSFORMERROR Summary of this function goes here
%   Detailed explanation goes here
Point1=transpose(Point1)
Point2=transpose(Point2)
calculatedPoint=tfMatrix*Point1;
diff=Point2-calculatedPoint;
diff=diff/diff(3)
diff=[diff(1);diff(2)]
error=norm(diff);
end

