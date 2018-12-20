function color = deleteSmallGreenSpot (color,dist)
%figure; plot(color)
%% find green small spot
   FirstColor = color == 1;
   RP_FC = regionprops(FirstColor,'Area','PixelIdxList');
   area = [RP_FC.Area];
   ind2investigate = find(area < dist);
   
   for i = 1:length(ind2investigate)
       idx = ind2investigate(i);
       PixelIdxList = RP_FC(idx).PixelIdxList;
       firstInd = PixelIdxList(1);
       endInd = PixelIdxList(end);
        if firstInd>1 && endInd<length(color) 
            colorBefAndAft = [color(firstInd-1) color(endInd+1)];
            if isequal(colorBefAndAft,[2,2])
                color(firstInd:endInd) =2;
            end
        end
   end
   
end