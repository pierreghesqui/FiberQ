function [ResultIm]=EdgeDetectionMethod(grayImage,param,...
    withLowThresh)
%EdgeDetectionMethod returns a binarisation and a skeletisation of the DNA image
%   GRAYIMAGE is the DNA image
%   ResultIm is a binarisation of the image with DNA in white and the
%   background in black

if nargin <3
    withLowThresh = 0;
end
PSF = param.PSF;
%-----------pad image---------------
sini = size(grayImage);
pad = round(sini/10);
grayImage2 = padarray(grayImage,pad,'symmetric');


%-----------False-Positive-image---------------
falsePosit0= edge(grayImage2,'log',0,param.sizeLoGFilter);%figure; imshow(thisEdges0)
falsePositFill=imfill(falsePosit0, 'holes');%figure; imshowpair(grayImage,thisEdgeFill)
labelsFalsePos = bwlabel(falsePositFill);%figure; imshow(labelsFalsePos>0,[])
clear falsePositFill falsePosit0

%------not-detailed-segmentation-(lots of false negatives)
[falseNeg1,thisEdgeThreshLower]= edgeModified(grayImage2,'canny',0,PSF); 
if withLowThresh
    falseNeg = thisEdgeThreshLower;
else
    falseNeg = falseNeg1;
end
falseNeg=bwareaopen(falseNeg, 4); 
falseNegDil=imdilate(double(falseNeg), strel('disk',max(1,round(PSF/param.sizeCannyDil))));

%------ Combination :We keep only shapes of "labelsFalsePos" which are
% intersected by "falseNegDil" ------------
labels2keep = unique(labelsFalsePos.*falseNegDil);%figure; imshow(ismember(labelsFalsePos,remaininglabels(2:end)))
labelsIm = labelsFalsePos;
labelsIm(~ismember(labelsFalsePos,labels2keep)) =0;
ResultIm = logical(labelsIm);
ResultIm = ResultIm(pad(1)+1:end-pad(1),pad(2)+1:end-pad(2));

%------delete non filled shapes (ie shape which exit the image)---
ResultIm = imopen(ResultIm,[1,1]);
ResultIm = imopen(ResultIm,[1;1]);

end
