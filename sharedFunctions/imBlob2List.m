function [olistBlob,olistEP] = imBlob2List(imBlob,olistEP)
if nargin <2
    olistEP = ListEP({});
end
s = size(imBlob);
RP = regionprops(imBlob,'PixelList','PixelIdxList','Centroid');
nbBlob = numel(RP);
% 

olistBlob = ListBlob({});
for i = 1: nbBlob
     dnaBlob(s,olistBlob,olistEP,...
            'PixelList',RP(i).PixelList,'PixelIdxList',...
            RP(i).PixelIdxList);
end
end