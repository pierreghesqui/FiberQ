function coordUV = chgtRep(coordXY,theta)
%CHGTREP transform the coordinate by a rotation of angle theta.
%   coordXY is the list of xy coordinates (Warning: X ==> lines,
%   Y==>colums)
%   theta is the angle of the rotation
%   coordUV is the coordinates in the arrival space.
nbShape = length(theta);
% nbP = size(coordXY,2);
cosTheta = reshape(cos(theta),[1,1,nbShape]);
sinTheta = reshape(sin(theta),[1,1,nbShape]);
X = coordXY(1,:,:);
Y = coordXY(2,:,:);
coordUV = [X.*cosTheta+Y.*sinTheta ; X.*(-sinTheta)+Y.*(cosTheta)];

end
