function largeSegment2=filterMoment(largeSegment)

largeSegment2 = logical(largeSegment); %figure; imshow(largeSegment2==56,[])
largeSegmentProps = regionprops(largeSegment2,'PixelIdxList','Eccentricity');
% MajorAxisLength = [largeSegmentProps.MajorAxisLength];
% MinorAxisLength = [largeSegmentProps.MinorAxisLength];
ecce = [largeSegmentProps.Eccentricity];
ind2Del2 = ecce<0.9428;
%ind2Del = find(MajorAxisLength < 3*MinorAxisLength);
largeSegment2(vertcat(largeSegmentProps(ind2Del2).PixelIdxList))=0;
largeSegment2=largeSegment2>0;
%figure; imshowpair(largeSegment,largeSegment2);

end