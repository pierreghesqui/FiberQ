function imOut=drawBoundingBoxes(imIn, maskIn, boxColor)


stats=regionprops(maskIn, 'BoundingBox');

boxImage=zeros(size(maskIn));

for it=1:size(stats, 1)
    thisBox=zeros(size(maskIn));
    thisBox(round(stats(it).BoundingBox(2)): round(stats(it).BoundingBox(2)+stats(it).BoundingBox(4)-1),...
        round(stats(it).BoundingBox(1)): round(stats(it).BoundingBox(1)+stats(it).BoundingBox(3)-1))=1;
    boxEdge=thisBox-bwmorph(thisBox,'erode',2);
    boxImage=logical(boxImage + boxEdge);%figure; imshowpair(boxImage,maskIn>0);
end

myRed=imIn(:,:,1);
myGreen=imIn(:,:,2);
myBlue=imIn(:,:,3);

myRed(boxImage==1)=uint8(boxColor(1));
myGreen(boxImage==1)=uint8(boxColor(2));
myBlue(boxImage==1)=uint8(boxColor(3));

imOut=cat(3, myRed, myGreen, myBlue);