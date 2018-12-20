function segmentVectors3=filterSegmSize(segmentVectors2,THRESH_SIZE)
segmentVectors3 = segmentVectors2;
Area = [segmentVectors2.Area];
minArea = prctile(Area,THRESH_SIZE);
ind2Del = find(Area<minArea);

segmentVectors3(ind2Del) = [];

end