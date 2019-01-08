function [I2] = WarpImage(srcI,srcbounds,canvasBounds,Canvas,H)
%WARPIMAGE Warps Image and stitches it on setCanvas
% x2= transformed coordinate Vector [x y 1]
% x1= vector in original Image
iH=inv(H);
for x=srcbounds(1):srcbounds(3)
    for y=srcbounds(2):srcbounds(4)
        
        x1=TfH([x,y],iH);
        %check if Pixel is in the original picture
        %else dont change canvas Pixel
        srcSize=size(srcI);
        xInside=x1(1)>1&&x1(1)<=srcSize(1);
        yInside=x1(2)>1&&x1(2)<=srcSize(2);
        if xInside&&yInside
            color=BLerp(x1,srcI);
            % +1 because Matlab array index starts at 1
            Canvas(x-canvasBounds(1),y-canvasBounds(2))=color;
        end
        
    end
end
I2=Canvas;
end

