function [segmentVectors2] = refineUniformStrand (segmentVectors,largeSegment,s)
    %figure; imshowpair(largeSegment,testSV(segmentVectors,s)>0)
    
    redRatios = [segmentVectors.RedRatio]+[segmentVectors.BlueRatio];
    strand2Refine = find(redRatios<0.1 | redRatios>0.9);
    for i = 1 : length(strand2Refine)
        BB = segmentVectors(strand2Refine(i)).BoundingBox;
        
    end
end