function [outIm]=deleteLargeShape(largeSegment,...
    param)
lblIm = bwlabel(largeSegment);

skel = bwmorph(largeSegment,'thin',Inf);
complementSegment = imcomplement(largeSegment);
imDist = bwdist(complementSegment);%figure; imshow(imDist,[])
RP = regionprops(skel,imDist,'PixelValues','PixelIdxList');
PixelValue = {RP.PixelValues};
ind2Del = cellfun(@(x) any(x>param.maxDiameterForSkel),PixelValue);
lbl2Del = lblIm(vertcat(RP(ind2Del).PixelIdxList));
outIm=~ismember(lblIm,[lbl2Del;0]);%figure; imshow(lblIm2)
end