function [xSkel,ySkel,skelInd] = skel2ind(skel,firstInd)
    skel2 = skel;
    skelInd =firstInd;
    BP = bwmorph(skel2,'branchpoints');
    indBP = find(BP);
    EPind1 = find(bwmorph(skel2,'endpoints'));
    skel2(firstInd) = 0;
    continu = 1;
    while continu 
        EPind2 = find(bwmorph(skel2,'endpoints'));%figure; imshowpair(skel,skel2)
        EP = EPind2(~ismember(EPind2,EPind1));
        skel2(EP) =0;
        if isempty(EP)
            continu =0;
        elseif ismember(EP,indBP)
            continu =0;
        else
            skelInd=[skelInd,EP];
            EPind1 = EPind2;
        end
        
        if sum(skel2)==0
            continu =0;
        end
        
    end
    [ySkel,xSkel] =ind2sub(size(skel), skelInd);
    %skelInd = [skelInd;
end