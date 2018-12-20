function [im_largeReduced,xmin,xmax,ymin,ymax] = adjustImSize(RP_large,...
    otherLabels,XY,label_EP,xmin,xmax,ymin,ymax)

for i = 1 : length(otherLabels)
    X = RP_large(otherLabels(i)).PixelList(:,1);
    Y = RP_large(otherLabels(i)).PixelList(:,2);
    xmin = min(min(X),xmin);
    xmax = max(max(X),xmax);
    ymin = min(min(Y),ymin);
    ymax = max(max(Y),ymax);
    
end
nbc = xmax-xmin+1;
nbl = ymax-ymin+1;
im_largeReduced = zeros(nbl,nbc);
im_largeReduced(sub2ind([nbl,nbc],XY(:,2)-ymin+1,XY(:,1)-xmin+1))=label_EP;
for i = 1 : length(otherLabels)
    X = RP_large(otherLabels(i)).PixelList(:,1);
    Y = RP_large(otherLabels(i)).PixelList(:,2);
   im_largeReduced(sub2ind([nbl,nbc],Y-ymin+1,X-xmin+1)) = otherLabels(i);
    
end%figure; imshow(im_largeReduced,[])

end