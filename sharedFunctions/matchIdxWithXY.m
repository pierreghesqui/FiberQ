function matchIdxWithXY(obj)
obj.PixelIdxList = sub2ind(obj.sizeIm,obj.XY(:,2),obj.XY(:,1));
end