function color = deleteSmallRedSpot (color,dist)
%figure; plot(color)
%% find green small spot
   SecondColor = color == 2;
   RP_FC = regionprops(SecondColor,'Area','PixelIdxList');
   area = [RP_FC.Area];
   ind2investigate = find(area < dist);
   
   for i = 1:length(ind2investigate)
       idx = ind2investigate(i);
       PixelIdxList = RP_FC(idx).PixelIdxList;
       firstInd = PixelIdxList(1);
       endInd = PixelIdxList(end);
        if firstInd>1 && endInd<length(color) 
            colorBefAndAft = [color(firstInd-1) color(endInd+1)];
            if isequal(colorBefAndAft,[1,1])
                color(firstInd:endInd) =1;
            end
        end
   end
end