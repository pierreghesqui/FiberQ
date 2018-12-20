function matchXYWithIdx(obj)
            [Y,X] = ind2sub(obj.sizeIm,obj.PixelIdxList);
            obj.XY = [X,Y];
end
