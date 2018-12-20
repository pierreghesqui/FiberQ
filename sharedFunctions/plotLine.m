function [ image_out ] = plotLine( P1,P2,s )
nbpad = 200; 
image_out = false(s(1)+2*nbpad,s(2)+2*nbpad);
l = [P1(1)+nbpad P2(1)+nbpad];  % x coordinates (running along matrix columns)
c = [P1(2)+nbpad P2(2)+nbpad];   % y coordinates (running along matrix rows)
nPoints = max(abs(diff(l)), abs(diff(c)))+1;  % Number of points in line

rIndex = round(linspace(l(1), l(2), nPoints));  % Row indices
cIndex = round(linspace(c(1), c(2), nPoints));  % Column indices
index = sub2ind(s+2*nbpad, rIndex, cIndex);     % Linear indices
image_out(index) = true;  % Set the line pixels to the max value of 255 for uint8 types
image_out = image_out(nbpad+1:end-nbpad,nbpad+1:end-nbpad);
%figure; imshow(imdilate(image_out,strel('disk',8)),[])
end

