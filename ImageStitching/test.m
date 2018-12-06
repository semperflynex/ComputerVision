clc;
size(I1)
bounds1=getBounds(I2,eye(3,3));
bounds2=getBounds(I1,transform.T);
bounds=[bounds1;bounds2];
canvasBounds=[min(bounds(:,1:2)),max(bounds(:,3:4))];
canvasSize=ceil(abs(min(bounds(:,1:2)) - max(bounds(:,3:4))))
canvas=zeros(canvasSize,'uint8');

%canvas=WarpImage(I2,bounds1,canvasBounds,canvas,eye(3,3));
canvas=WarpImage(I1,bounds2,bounds2,canvas,transform.T);
imshow(canvas)
