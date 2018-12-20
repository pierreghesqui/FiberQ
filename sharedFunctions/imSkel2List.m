function [olistSegm,olistEP] =  imSkel2List(imSkel,olistEP,param)
if nargin  <2
olistEP = ListEP({});

end
s = size(imSkel);%figure; imshow(imSkel);
%% build Graph
mask = ones(3);
mask(2,2) =0;
%----compute pixel connection
nbConnPixel = imfilter(double(imSkel),mask);
nbConnPixel(~imSkel) =0;
%-----compute branch and nodes
branchPixels = nbConnPixel;
branchPixels(branchPixels>2)=0;
[imNodes] = bwlabel(nbConnPixel>2);%figure; imshow(imNodes);
%------Build Segment and Blobs
imSkelWWBP = imSkel&~imNodes;%figure; imshow(imSkelWWBP);
lblSkelWWBP=bwlabel(imSkelWWBP);%figure; imshow(lblSkelWWBP);
EPim = bwmorph(lblSkelWWBP,'endpoints');%figure; imshow(EPim);
EPimlbl = double(EPim);
EPimlbl(EPim)=lblSkelWWBP(EPim);%figure; imshow(EPimlbl);


listSegm = regionprops(lblSkelWWBP,bwmorph(branchPixels,'endPoints'),...
    'PixelList','PixelIdxList','PixelValues');

nbSegment = numel(listSegm);
% 

olistSegm = ListSegm({});


for i =1:nbSegment
    
    if length(listSegm(i).PixelIdxList)>1
        
        dnaSegm(param,s,olistSegm,olistEP,...
            'XY',listSegm(i).PixelList,'PixelIdxList',...
            listSegm(i).PixelIdxList);
        
    end
end
end