function skelLabel6 =large2skelWithoutBP(largeLabel3F,FiberThickness)
skelLabel4 = bwmorph(largeLabel3F,'thin',Inf);%figure; imshow(skelLabel4,[]);figure; imshowpair(largeSegmentF,skelSegment4);
skelLabel5 = double(skelLabel4);
skelLabel5(skelLabel4)=largeLabel3F(skelLabel4);%figure; imshow(skelLabel5,[]);
skelLabel6 = deleteBPMulti(skelLabel5,FiberThickness); % figure; imshow(skelLabel6,[]);
end