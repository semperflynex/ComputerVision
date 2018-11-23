
selectedPoints1=matchedPoints1(1:4).Location;
selectedPoints2=matchedPoints2(1:4).Location;

H=fitgeotrans(selectedPoints1,selectedPoints2, 'projective');
H=H.T

myH=ProjectiveTransform(selectedPoints1,selectedPoints2);
H-myH