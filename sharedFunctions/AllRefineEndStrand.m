function  [segmentVectors5,largeLabel] = AllRefineEndStrand(segmentVectors2,...
    largeLabel,largeSegmentThreshLower,intIm,FiberThickness,s)

skelLabel = testSV(segmentVectors2,s,2);%figure; imshow(skelLabel>0,[])
%figure; imshowpair(skelLabel>0,largeSegmentThreshLower)
largeSegmentThreshLower = bwlabel(largeSegmentThreshLower);%figure; imshowpair(largeSegmentThreshLower>0,skelLabel>0)
labels2Del = unique(largeSegmentThreshLower(skelLabel>0));
largeLabels2investigate = ~ismember(largeSegmentThreshLower,labels2Del); 
%figure; imshowpair(largeLabels2investigate>0,skelLabel>0)
%figure; imshowpair(largeSegmentThreshLower>0,skelLabel>0)
largeLabels2investigate=bwlabel(largeLabels2investigate);%figure;imshowpair(largeSegmentThreshLower,largeLabels2investigate)
[segmentVectors4] = refineStrand(segmentVectors2,largeLabels2investigate,skelLabel,...
    FiberThickness,intIm); %figure; imshow(testSV(segmentVectors4,s)>0)
skelLabel = deleteBPMulti(testSV(segmentVectors4,s,2),FiberThickness);%figure; imshow(testSV(segmentVectors4,s,2)>0,[])
segmentVectors4b = getSegmentsCoordAndInt(skelLabel,intIm);%find(bwmorph(skelLabel2,'branchPoints'))
[~,segmentVectors4b] = refineEndStrand(skelLabel,segmentVectors4b,...
    intIm,double(largeLabel>0),2*FiberThickness);
skelLabel = bwlabel(testSV(segmentVectors4b,s,2)>0);
%figure; imshow(testSV(segmentVectors4b,s)>0,[])
%figure; imshow(testSV(segmentVectors2,s)>0,[])
%figure; imshowpair(testSV(segmentVectors2,s)>0,testSV(segmentVectors4,s)>0)
%figure; imshowpair(skelLabel2>0,testSV(segmentVectors4b,s)>0)
%figure; imshow(largeLabel>0)
%figure; imshow(skelLabel3>0)
%figure; imshow(skelLabel2>0)
%figure; imshow(splicedIm,[])
THRESHDIST = 5*FiberThickness;
segmentVectors5 = spliceSegments_EndPointsMethod(segmentVectors4b,...
    skelLabel,largeSegmentThreshLower,intIm,...
    FiberThickness,THRESHDIST,1);
%figure; imshowpair(testSV(segmentVectors4b,s,2)>0,testSV(segmentVectors5,s,2)>0)
%figure; imshowpair(skelLabel3>0,testSV(segmentVectors5,s)>0)
%figure; imshow(testSV(segmentVectors5,s,2)>0)
%figure; imshow(largeSegmentThreshLower,[])
end