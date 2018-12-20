function FIBER_THICKNESS = computeFiberThickness(largeSegment)
%figure; imshow(largeSegment,[])
skel = bwmorph(largeSegment,'thin',Inf);
dist = bwdist(~largeSegment);%figure; imshow(dist,[])
FIBER_THICKNESS = double(2*mean(dist(skel)));
end