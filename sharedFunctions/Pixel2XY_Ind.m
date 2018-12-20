function [XY,ind] = Pixel2XY_Ind(PixelList,PixelIdxList)
nbConnection = zeros(length(PixelIdxList),1);
for i=1:length(PixelIdxList)
    xi = PixelList(i,1);
    yi = PixelList(i,2);
    nbConnection(i) = sum(ismember(PixelList(:,1),[xi-1,xi,xi+1])&...
        ismember(PixelList(:,2),[yi-1,yi,yi+1]))-1;
end
indfirst = find(nbConnection==1,1);
[XY,order] = PixelList2XY(PixelList,indfirst);
ind = PixelIdxList(order);
end