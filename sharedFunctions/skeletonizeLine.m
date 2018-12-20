function XY2 = skeletonizeLine(XY1)
s = fliplr(max(XY1));
ind = sub2ind(s,XY1(:,2),XY1(:,1));
[U,ind2keep,~] = unique(ind);
XY1 = XY1(ind2keep,:);
[Xlim,Ylim] = limitXY(XY1);
im = false(Ylim(2)-Ylim(1)+1,Xlim(2)-Xlim(1)+1);
im(sub2ind(size(im),XY1(:,2)-Ylim(1)+1,XY1(:,1)-Xlim(1)+1)) = true;%figure; imshow(im,[])
[l,c] = find(bwmorph(im,'skel',Inf));
XY2 = [c+Xlim(1)-1,l+Ylim(1)-1];
end

