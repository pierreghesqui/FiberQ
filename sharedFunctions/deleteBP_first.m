function fiber2 = deleteBP_first(fiber,pixelList,pixelIdxList,xBPi,yBPi,indBPi)
s = size(fiber);
nbBP = length(indBPi);
fiber2 = fiber;
for i = 1 : nbBP
    [~,indCross]=crossCoordinate([xBPi(i),yBPi(i)],s);
    indBPC = indBPi(i);
    fiber2(indBPC) = false;%figure; imshow(fiber,[])
    fiber2(indCross) =false;
    RP_fiber = regionprops(fiber2,'Area','PixelIdxList','PixelList');
    
    if size(RP_fiber,1)==2
        fiber2 = logical(connectStrand(double(fiber2)));
    else
        ind = find([RP_fiber.Area]<20,1);
        if isempty(ind)
            fiber2 = false(s);
        else
            while size(RP_fiber,1)>2
                [~,ind2] = min([RP_fiber.Area]);
                fiber2(RP_fiber(ind2).PixelIdxList)=false;
                RP_fiber = regionprops(fiber2,'Area','PixelIdxList','PixelList');
            end
            fiber2 = logical(connectStrand(double(fiber2)));
            
        end%figure; imshowpair(skelLabel==label,BP)
    end 
end %figure; imshowpair(fiber,fiber2,'montage')
end