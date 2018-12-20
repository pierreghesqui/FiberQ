function segmentVectors2 = calculateRedLength(segmentVectors)
segmentVectors2 = segmentVectors;
nbStrand = numel(segmentVectors);

for i = 1:nbStrand
    %any(ismember(segmentVectors2(i).indLarge,sub2ind([2048,2048],1110,1048)))
    color = segmentVectors2(i).color;%figure; plot(color)
    redPart = color==2;
    redExtrema = regionprops(redPart,'Extrema');
    nbRedParts = size(redExtrema,1);
    AlltopInd = [];
    AllbotInd = [];
    AlllenPart = [];
    nbRedParts2=nbRedParts;
    if nbRedParts>0
        
        for p = 1:nbRedParts
            topInd = redExtrema(p).Extrema(1,2)+0.5;
            AlltopInd = [AlltopInd ,topInd];
            botInd = redExtrema(p).Extrema(6,2)-0.5;
            AllbotInd = [AllbotInd,botInd];
            lenPart = botInd-topInd+1;
            AlllenPart =[AlllenPart,lenPart];
        end
        
        ind2Del = [];
        for k = 1:nbRedParts-1 %find if there is some green between
            isGreenBetween = ~isempty(find(color(AllbotInd(k)+1:AlltopInd(k+1))==1,1));
            if ~isGreenBetween
                ind2Del=[ind2Del,k];
%             AllbotInd(k)=[];AlltopInd(k+1)=[];
%             AlllenPart(k) = AlllenPart(k)+AlllenPart(k+1);
%             AlllenPart(k+1)=[];
%             nbRedParts2=nbRedParts-1;
            end
        end
        AllbotInd(ind2Del)=[];AlltopInd(ind2Del+1)=[];
        
        AlllenPart=AllbotInd-AlltopInd;
        nbRedParts2=nbRedParts-length(ind2Del);
    end
    
    segmentVectors2(i).nbRedParts = nbRedParts2;
    if ~isempty(AlllenPart)
        segmentVectors2(i).RedLengths = AlllenPart;
    else
        segmentVectors2(i).RedLengths =0;
    end
    segmentVectors2(i).RedbotInd  = AllbotInd;
    segmentVectors2(i).RedtopInd  = AlltopInd;
end

end