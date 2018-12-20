function largeSegment=RemoveLargeShapes(largeSegment,FIBER_THICKNESS)
regProp = regionprops(largeSegment,'MajorAxisLength','MinorAxisLength','PixelIdxList');
threshMinorAxis = 4*FIBER_THICKNESS;
minorAxis = [regProp.MinorAxisLength];
ind2Del = minorAxis>threshMinorAxis;
idx2Del = vertcat(regProp(ind2Del).PixelIdxList);
regProp(ind2Del) = [];
largeSegment(idx2Del) = 0;
end
