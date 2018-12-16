function [pos] = TfH(pos,H)
%transforms Point in with Matrix H
pos=[pos 1];
pos=pos*H;
pos=pos/pos(3);
pos=pos(1:2);
end
