function [bwSegments]=getSegments(grayImage,param,...
    withLowThresh)
%GETSEGMENTS returns a binarisation and a skeletisation of the DNA image
%   GRAYIMAGE is the DNA image
%   bwSEGMENTS is a binarisation of the image with DNA in white and the
%   background in black
%   skelSegment is the skeletisation of bwSegments

if nargin <3
    withLowThresh = 0;
end
PSF = param.PSF;
%-----------pad image---------------
sini = size(grayImage);
pad = round(sini/10);
grayImage2 = padarray(grayImage,pad,'symmetric');
%figure; imshow(grayImage2,[])
%figure; imshowpair(grayImage,grayImage3,'montage')

%-----------False-Pos---------------
%thisEdges0bis= edge(grayImage2,'log',0);%figure; imshow(thisEdges0bis)
thisEdges0= edge(grayImage2,'log',0,param.sizeLoGFilter);%figure; imshow(thisEdges0)
thisEdgeFill=imfill(thisEdges0, 'holes');%figure; imshowpair(grayImage,thisEdgeFill)
labelsFalsePos = bwlabel(thisEdgeFill);%figure; imshow(labelsFalsePos>0,[])
%figure; imshow(labelsFalsePos(pad(1)+1:end-pad(1),pad(2)+1:end-pad(2))>0,[])
%imwrite(labelsFalsePos(pad(1)+1:end-pad(1),pad(2)+1:end-pad(2))>0,'C:\Users\transformer\Dropbox\Manuscript\imagesAlgo\labelsFalsePos.png')
clear thisEdgeFill thisEdges0
%------not-detailed-segmentation-(lots of false negatives)
[thisEdges1,thisEdgeThreshLower]= edgeModified(grayImage2,'canny',0,PSF); 
if withLowThresh
    thisEdge = thisEdgeThreshLower;
else
    thisEdge = thisEdges1;
end
thisEdge=bwareaopen(thisEdge, 4); 
bwSegments=imdilate(double(thisEdge), strel('disk',max(1,round(PSF/param.sizeCannyDil))));
%figure; imshow(bwSegments,[])
%imwrite(bwSegments(pad(1)+1:end-pad(1),pad(2)+1:end-pad(2)),'C:\Users\transformer\Dropbox\Manuscript\imagesAlgo\labelsFalseNeg.png')
%------labels2keep------------
remaininglabels = unique(labelsFalsePos.*bwSegments);%figure; imshow(ismember(labelsFalsePos,remaininglabels(2:end)))
labelsIm = labelsFalsePos;
labelsIm(~ismember(labelsFalsePos,remaininglabels)) =0;
bwSegments = logical(labelsIm);
bwSegments = bwSegments(pad(1)+1:end-pad(1),pad(2)+1:end-pad(2));
%------delete non filled shapes---
bwSegments = imopen(bwSegments,[1,1]);
bwSegments = imopen(bwSegments,[1;1]);

end
