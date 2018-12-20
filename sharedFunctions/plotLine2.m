function [ rIndex,cIndex,Index ,maxNbP] = plotLine2( P1,P2,s,dilSz )
if mod(dilSz,2)~=0
   dilSz = dilSz+1;
end
%image_out = false(s(1),s(2));
if size(P1,1)>1
c = [P1(1,:,:) P2(1,:,:)]; 
l = [P1(2,:,:) P2(2,:,:)];   
else
    [l1,c1] = ind2sub(s,P1);
    [l2,c2] = ind2sub(s,P2);
    c = [c1,c2];
    l = [l1,l2];
end
nPoints = max(abs(diff(l)), abs(diff(c)))+1;  % Number of points in line
nShape = size(l,3);
rIndex = cell(nShape,1);
cIndex = cell(nShape,1);
Index  = cell(nShape,1);
maxNbP =2*dilSz*max(nPoints);

Index  = -ones(nShape,1);
rIndex = -ones(nShape,1);
cIndex = -ones(nShape,1);

for i =1:nShape

rIndex_i = round(linspace(l(:,1,i), l(:,2,i), nPoints(i)));  % Row indices
cIndex_i = round(linspace(c(:,1,i), c(:,2,i), nPoints(i)));

%fast dilatation
rIndex_i2 = [rIndex_i,reshape(rIndex_i'+[1:dilSz/2],[1,(dilSz/2)*length(rIndex_i)]),reshape(rIndex_i'-[1:dilSz/2],[1,(dilSz/2)*length(rIndex_i)])];
cIndex_i2 = repmat(cIndex_i,[1,dilSz+1]);
cIndex_i3 = [cIndex_i2,reshape(cIndex_i2'+[1:dilSz/2],[1,(dilSz/2)*length(cIndex_i2)]),reshape(cIndex_i2'-[1:dilSz/2],[1,(dilSz/2)*length(cIndex_i2)])];
rIndex_i3 = repmat(rIndex_i2,[1,dilSz+1]);

%Column indices
ind2Del = rIndex_i3<1|rIndex_i3>s(1)|cIndex_i3<1|cIndex_i3>s(2);
rIndex_i3(ind2Del) =[];
cIndex_i3(ind2Del) =[];
Index_i = sub2ind(s, rIndex_i3, cIndex_i3);
Index_i = unique(Index_i);
[rIndex_i,cIndex_i ]= ind2sub(s, Index_i);
nbP = length(Index_i);
if nbP>size(Index,2)
    dif    = nbP-size(Index,2);
    Index  = padarray(Index,[0,dif],-1,'post');
    rIndex = padarray(rIndex,[0,dif],-1,'post');
    cIndex = padarray(cIndex,[0,dif],-1,'post');
end
Index(i,1:nbP)  = Index_i;
rIndex(i,1:nbP) = rIndex_i;
cIndex(i,1:nbP) = cIndex_i;
%im = zeros(s); 
%im(sub2ind(s, rIndex_i3, cIndex_i3))=1; figure; imshow(im,[]),hold on,plot(cIndex_i,rIndex_i)
end

% Linear indices
%image_out(index) = true;  % Set the line pixels to the max value of 255 for uint8 types
% image_out = image_out(nbpad+1:end-nbpad,nbpad+1:end-nbpad);
%figure; imshow(imdilate(image_out,strel('disk',8)),[])
end
