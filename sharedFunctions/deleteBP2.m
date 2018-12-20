function squelSegment2 =deleteBP2(skelSegment,fiberThickness)
s = size(skelSegment);
skelLabel = bwlabel(skelSegment);
RP_skel = regionprops(skelLabel,'BoundingBox','Area','PixelIdxList','PixelList','Image');

BP_im = labelBP(skelLabel);
label2investigate = setdiff(unique(BP_im),0);
nbLabel = length(label2investigate);

for i = 1:nbLabel
    label_i = label2investigate(i);
    indBP_i = find(BP_im==label_i);
    [yBPi,xBPi] = ind2sub(s,indBP_i);
    RP_skel2 = deleteBP_1Fiber(RP_skel(label_i),xBPi,yBPi);
    RP_skel(label_i)=RP_skel2;
end



end

