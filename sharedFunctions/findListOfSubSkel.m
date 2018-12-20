function [listSubSkelIdx ,skelLabelReduced2]= findListOfSubSkel(skelLabelReduced,indBPConnected2Old)
skelLabelReduced2=skelLabelReduced;
    pixel2Del = false(size(skelLabelReduced));
    pixel2Del(indBPConnected2Old)=true;
    pixel2Del=imdilate(pixel2Del,ones(3));
    skelLabelReduced2(pixel2Del)=0;%figure; imshow(skelLabelReduced2,[])
    listSubSkelIdx = regionprops(skelLabelReduced2>0,'PixelIdxList');
end