function [largeSegment2,largeLabel2] = DelSmallStrand(largeSegment,thresh)

        squelSegment2 = bwmorph(largeSegment>0,'thin',Inf);
        RP = regionprops(squelSegment2,'PixelIdxList','Area');
        ind2Del = [RP.Area]<thresh;
        Idx2Del = vertcat(RP(ind2Del).PixelIdxList);
        squelSegment2(Idx2Del) = false;
        
        lbLargeSegment = bwlabel(largeSegment);
        label2keep = setdiff(unique(lbLargeSegment(squelSegment2)),0);
        largeSegment2 = largeSegment;
        largeSegment2(~ismember(lbLargeSegment,label2keep))=0;
        largeLabel2 = bwlabel(largeSegment2);
end

