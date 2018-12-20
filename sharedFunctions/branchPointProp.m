function RP_BP = branchPointProp(fiber)
BP = bwmorph(fiber,'branchPoints');
RP_BP = regionprops(BP,'PixelIdxList','PixelList');
end