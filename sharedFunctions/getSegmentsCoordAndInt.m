function segmentProps=getSegmentsCoordAndInt(skelLabel, myImage,threshArea)
if nargin<3
    threshArea=10;
end

binSegments=skelLabel>0;
s = size(skelLabel);
s2 = size(myImage);
segmentProps=regionprops(binSegments,skelLabel, 'PixelIdxList', 'BoundingBox','PixelList','Area','MaxIntensity');

%% fast dilatation
szDil = 2;
for i = 1:numel(segmentProps)
    
    PixelList = segmentProps(i).PixelList;
    x = PixelList(:,1);
    y = PixelList(:,2);
    %x Dil
    x = [reshape(x+[-szDil:szDil],[],1)];
    y = repmat(y,2*szDil+1,1);
    %y Dil 
    y = [reshape(y+[-szDil:szDil],[],1)];
    x = repmat(x,2*szDil+1,1);
    %
    ind2Del = x<1 |x>s(2)  | y<1 | y>s(1);
    x(ind2Del) = [];
    y(ind2Del) = [];
    %
    indxy = sub2ind(s,y,x);
    [u,idx]=unique(indxy);
    indxy = indxy(idx);
    x = x(idx);
    y = y(idx);
    segmentProps(i).indLarge = indxy;
    segmentProps(i).xyLarge = [x,y];
    %im = zeros(s); im(indxy(idx))=1;figure; imshow(im)
    
end







ind2del = find([segmentProps.Area]<threshArea);
segmentProps(ind2del) = [];

for it = 1:size(segmentProps, 1)
    oneSegment=zeros(size(binSegments));
    oneSegment(segmentProps(it).PixelIdxList)=1;
    BB = segmentProps(it).BoundingBox; l  =  floor(BB(2)):floor(BB(2))+ceil(BB(4)); c  =  floor(BB(1)):floor(BB(1))+ceil(BB(3));
    
    ind2Del=l<1|l>s(1);
    ind2Dec=c<1|c>s(2);
    l(ind2Del) = [];
    c(ind2Dec) = [];
    
    smallMyImage = myImage(l,c);
    smallOneSegment=oneSegment(l,c);%figure; imshow(smallOneSegment)
    
    [l0EP,c0EP]=find(bwmorph(smallOneSegment, 'endpoints')==1);
    smallOneSegment(l0EP(1),c0EP(1)) = 0;
    
    %% find index
    ind = sub2ind(s,l0EP+l(1)-1,c0EP+c(1)-1);
    toAvoid = ind(2);
    ind = ind(1);
    contin=1;
    while contin ==1
        [lEP0,cEP0]=find(bwmorph(smallOneSegment, 'endpoints')==1); lEP=lEP0+l(1)-1; cEP = cEP0+c(1)-1;
        if length(lEP0)>1
            indEP = sub2ind(s,lEP,cEP);
            ind=[ind,indEP(indEP~=toAvoid)];
            smallOneSegment(lEP0(indEP~=toAvoid),cEP0(indEP~=toAvoid)) = 0;
        else
            indEP = sub2ind(s,lEP,cEP);
            ind=[ind,indEP];
            contin=0;
        end
    end
    segmentProps(it).PixelIdxList = ind';
    [l,c] = ind2sub(s,ind);
    segmentProps(it).PixelList = [c',l'];
    segmentProps(it).PixelListSmoothed = [smooth(c',0.5,'lowess'),smooth(l',0.5,'lowess')];
    %% find intensity
    if size(myImage,3)==3
    segmentProps(it).intRed = [myImage(sub2ind(s2,l,c,ones(1,length(l))))]';
    segmentProps(it).intGreen = [myImage(sub2ind(s2,l,c,2*ones(1,length(l))))]';
    segmentProps(it).intBlue = [myImage(sub2ind(s2,l,c,3*ones(1,length(l))))]';
    elseif size(myImage,3) ==1
        segmentProps(it).int = [myImage(sub2ind(s2,l,c))]';
    end
end

end