function coloR2 = deleteBlueColor(coloR)
coloR2 = coloR;
colorBlue = coloR==0;
RP = regionprops(colorBlue,'PixelIdxList');
nbBlueRegion = numel(RP);

for i = 1 : nbBlueRegion
    
    noLeft = 0;
    noRight = 0;
    pixelIdxList_i = RP(i).PixelIdxList;
    indLeft = pixelIdxList_i(1)-1;
    indRight = pixelIdxList_i(end)+1;
    if indLeft>0
        colorLeft = coloR(indLeft);
    else
        noLeft = 1;
        colorLeft = [];
    end
    if indRight<length(coloR)
        colorRight = coloR(indRight);
    else
        noRight = 1;
        colorRight = [];
    end
    
    if noRight&&~noLeft
        coloR2(pixelIdxList_i) = colorLeft;
    elseif ~noRight&&noLeft
        coloR2(pixelIdxList_i) = colorRight;
    elseif ~noRight&&~noLeft
        nbBluePixel = length(pixelIdxList_i);
        halfNb = max(1,floor(nbBluePixel/2));
        coloR2(pixelIdxList_i(1:halfNb))=colorLeft;
        coloR2(pixelIdxList_i(halfNb+1:end))=colorRight;
    end
    
end
end