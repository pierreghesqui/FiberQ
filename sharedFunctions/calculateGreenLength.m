function segmentVectors2 = calculateGreenLength(segmentVectors)
segmentVectors2 = segmentVectors;
nbStrand = numel(segmentVectors);

for i = 1:nbStrand
    color = segmentVectors2(i).color;
    greenPart = color==1;
    greenExtrema = regionprops(greenPart,'Extrema');
    nbGreenParts = size(greenExtrema,1);
    AlltopInd = [];
    AllbotInd = [];
    AlllenPart = [];
    nbGreenParts2=nbGreenParts;
    if nbGreenParts>0
        
        for p = 1:nbGreenParts
            topInd = greenExtrema(p).Extrema(1,2)+0.5;
            AlltopInd = [AlltopInd ,topInd];
            botInd = greenExtrema(p).Extrema(6,2)-0.5;
            AllbotInd = [AllbotInd,botInd];
            lenPart = botInd-topInd+1;
            AlllenPart =[AlllenPart,lenPart];
        end
        
        ind2Del = [];
        for k = 1:nbGreenParts-1 %find if there is some green between
            isRednBetween = ~isempty(find(color(AllbotInd(k)+1:AlltopInd(k+1))==1,1));
            if ~isRednBetween
                ind2Del=[ind2Del,k];
                %             AllbotInd(k)=[];AlltopInd(k+1)=[];
                %             AlllenPart(k) = AlllenPart(k)+AlllenPart(k+1);
                %             AlllenPart(k+1)=[];
                %             nbRedParts2=nbRedParts-1;
            end
        end
        AllbotInd(ind2Del)=[];AlltopInd(ind2Del+1)=[];
        AlllenPart(ind2Del) = AlllenPart(ind2Del)+AlllenPart(ind2Del+1);
        AlllenPart(ind2Del+1)=[];
        nbGreenParts2=nbGreenParts-length(ind2Del);
        
        
    end
    
    segmentVectors2(i).nbGreenParts = nbGreenParts2;
    if ~isempty(AlllenPart)
        segmentVectors2(i).GreenLengths = AlllenPart;
    else
        segmentVectors2(i).GreenLengths =0;
    end
    segmentVectors2(i).GreenbotInd  = AllbotInd;
    segmentVectors2(i).GreentopInd  = AlltopInd;
end

end