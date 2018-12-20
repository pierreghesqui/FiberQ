function [imSkel,imBlob]=separateSkelvsBlob(BWim,param)
RP = regionprops(BWim,'MajorAxisLength','MinorAxisLength','PixelIdxList','solidity');
indLengthAxix = [RP.MajorAxisLength]./[RP.MinorAxisLength]<4;
indSolidity = [RP.Solidity]>.7;
indLength = [RP.MajorAxisLength]>param.minLength4SkeletonBefore;
indBlob=indSolidity&indLengthAxix;
indSkel = ~indBlob;
indBlob = indBlob|~indLength;
indSkel = indSkel&indLength;
idxBlob = vertcat(RP(indBlob).PixelIdxList);
idxSkel = vertcat(RP(indSkel).PixelIdxList);

imSkel = false(size(BWim));
imBlob = false(size(BWim));

imSkel(idxSkel)=true;
imBlob(idxBlob)=true;
imSkel =bwmorph(imSkel,'thin',Inf);
imBlob =bwmorph(imBlob,'thin',Inf);%figure; imshowpair(BWim,imSkel)
%figure; imshowpair(imSkel,imBlob)

%figure; imshowpair(imSkel,imdilate(imSkel,strel('disk',3)))
%figure; imshow(imSkel2)
end