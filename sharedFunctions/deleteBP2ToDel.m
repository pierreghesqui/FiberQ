function squelSegment2 =deleteBP2(squelSegment)
    skelLabel = bwlabel(squelSegment);%figure; imshow(skelLabel,[])
    RP1 = regionprops(skelLabel,'Area','PixelIdxList');
    BP = imdilate(bwmorph(squelSegment,'branchPoints'),strel('disk',1));
    RPBP = regionprops(BP,'PixelIdxList');
    s=size(squelSegment);
    nbBP = size(RPBP,1);
    for i = 1:nbBP
        indBP_i = RPBP(i).PixelIdxList;
        label = mode(unique(setdiff(skelLabel(indBP_i),0)));
        
        fiber = false(s); 
        if label==0      continue;     end
        fiber(RP1(label).PixelIdxList) = true;%figure; imshow(fiber)
        fiber(indBP_i)=false;
        RP2 = regionprops(fiber,'Area','PixelIdxList');
        ind = find([RP2.Area]<20);
        if isempty(ind)
            skelLabel(vertcat(RP2.PixelIdxList)) = 0;
            skelLabel(RPBP(i).PixelIdxList) = 0;
        else
            [~,ind2] = min([RP2.Area]);
            fiber2 = bwmorph(fiber,'thicken');
            
            
        end
        
        
    end
    
    squelSegment2 = skelLabel>0;
  %figure; imshow(squelSegment2,[])
end