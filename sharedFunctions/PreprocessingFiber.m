function [imAfterNorm,s,grayImage,PSF] = PreprocessingFiber (im,EOPs)

%% Step : median filter
filtSz = 4;
im = double(im)/double(max(im(:)));%figure; imshow(im,[])
thisGreen  = medfilt2(im(:,:,2),[filtSz,filtSz],'symmetric');% figure; imshow(thisGreen,[])
thisRed    = medfilt2(im(:,:,1),[filtSz,filtSz],'symmetric');% figure; imshow(thisRed,[])
im2 = cat(3,thisRed,thisGreen,zeros(size(thisRed)));%figure; imshowpair(im,im2,'montage')
clear thisGreen thisRed
grayImage = mat2gray(mean(im2(:,:,1:2),3)); %figure; imshow(grayImage);%figure; imshowpair(grayImage,im2,'montage');
s = size(grayImage);
param = Metric(2,EOPs);

%% Step : binarisation and skeletisation
[largeSegment] = EdgeDetectionMethod(grayImage,param);%figure; imshowpair(largeSegment,im)

%% Step :  filterHighDensity
largeSegment = filterHighDensity2(largeSegment,7);%figure; imshowpair(largeSegment,largeSegmentF)
%figure; imshow(largeSegment)
%% Step :  Remove Big Shapes
largeSegment=RemoveLargeShapes(largeSegment,7);

%% Step : Fiber Thickness
skel= bwmorph(largeSegment,'thin',Inf);
sigma = 8*3;
hsize = 4*sigma;
density =  imfilter(double(largeSegment),fspecial('gaussian',hsize, sigma),'symmetric');
%figure; imshow(density,[])
BP = imdilate(bwmorph(skel,'branchpoint'),ones(3));
skel(BP) = false;
RP = regionprops(skel,'Area','PixelIdxList','PixelList');
for i = 1:numel(RP)
    RP(i).maxDensity = max(density(RP(i).PixelIdxList));
end
indLong = [RP.Area]>prctile([RP.Area],50);
RP(~indLong)=[];
[~,ind] = sort([RP.maxDensity]);
RP = RP(ind);
RP([RP.maxDensity]<0.1)=[];
listSegm = ListSegm({});
listEP = ListEP({});

for i =1:numel(RP)
dnaSegm(param,s,listSegm,listEP,...
            'XY',RP(i).PixelList,'PixelIdxList',...
            RP(i).PixelIdxList);
end
PSFs = [];
cpt = 1;

while length(PSFs)<200&&cpt<=length(listSegm.List)
    
    segm_i = listSegm.List{cpt};
    
    PSFFib = calculatePSF(segm_i,grayImage,largeSegment,im);
    
    PSFs =cat(2,PSFs, PSFFib);
    cpt = cpt+1;
    
end
PSF = median(PSFs);%figure; histogram(PSFs,1:1:30)

%% Step : Delete small Segment = noise
THRESH_SIZE_SKEL = 4.5*PSF;
[largeSegment2] = DelSmallStrand(largeSegment,THRESH_SIZE_SKEL); %TO BE IMPROVED WITH A CLOSING BEFORE DELETING SMALL STRANDS
largeLabel2 = bwlabel(largeSegment2);
%figure; imshowpair(largeSegmentF,largeSegment2)
%% Step : Filter 1st moment == 2nd moment
largeLabel3F=bwlabel(filterMoment(largeLabel2>0));
clear largeLabel2

%% Step : Normalise Image Colors
[~,thisRedN,thisGreenN] = normaliseColor(largeLabel3F>0,im2(:,:,1),im2(:,:,2),0.07);
imAfterNorm  = cat(3,thisRedN,thisGreenN,zeros(s));%figure; imshow(imAfterNorm,[])
s = [size(imAfterNorm,1),size(imAfterNorm,2)];
grayImage = rgb2gray(imAfterNorm);% figure; imshow(grayImage,[])


end