function [segmentVectors2,strandDeleted,ind2Del] = filterColor(segmentVectors,s)
segmentVectors2 = segmentVectors;
nbSegment = numel(segmentVectors);
ind2Del = [];
for i =1:nbSegment
    indLarge = segmentVectors(i).indLarge; 
    
    color = segmentVectors(i).color;
    
    colorScheme = color(diff([10; color])~=0); %'10' (could be an arbitrary number different from 0,1 or 2.
    indZero = colorScheme==0;colorScheme(indZero) = [];
    colorScheme = colorScheme(diff([10; colorScheme])~=0);
    acceptedScheme = {[1],[2],[1;2],[2;1],[1;2;1],[2;1;2]};
    
    isMem = false;
    cpt =1;
    
    if isempty(colorScheme)
        isMem = true;
    end
    while ~isMem && cpt<=length(acceptedScheme)
        isMem= isequal(colorScheme,acceptedScheme{cpt});
        cpt = cpt+1;
        
    end
    
    if ~isMem
        ind2Del = [ind2Del , i];
    end
    
    
end

strandDeleted = testSV(segmentVectors2(ind2Del),s);
segmentVectors2(ind2Del) = [];


end