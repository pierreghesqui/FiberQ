function [infoStrand] = refineStrand(infoStrand,largeLabel2Investigate,skelLabel,...
    FiberThickness,intIm)
s= size(largeLabel2Investigate);%figure; imshowpair(skelLabel,largeLabel2Investigate)

%% Step 1 : Calculate tan for each fiber;
tanFiber = calculateTanForEachFiber(infoStrand);
nbFiber = numel(tanFiber);
%% Step 2 : enlarge each End Point

RP_large = regionprops(largeLabel2Investigate>0,largeLabel2Investigate,'PixelIdxList',...
    'Centroid','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation');
skelLabel2 = skelLabel;
largeLabel2Investigate2 =largeLabel2Investigate;
ind2Del=[];
for i =1 : nbFiber
    infoStrand_i=infoStrand(i);
    tanFiber_i = tanFiber(i);
    if length(infoStrand_i.PixelList(:,1))>3*FiberThickness
    [largeLabel2Investigate2,skelLabel2, infoStrand_i,tanFiber_i]=enlargeEndPoint(intIm,...
        largeLabel2Investigate2,skelLabel2,infoStrand_i,tanFiber_i,RP_large,FiberThickness,1);
    if ~isempty(infoStrand_i.Area)
    [largeLabel2Investigate2,skelLabel2, infoStrand_i,tanFiber_i]=enlargeEndPoint(intIm,...
        largeLabel2Investigate2,skelLabel2,infoStrand_i,tanFiber_i,RP_large,FiberThickness,2);
    else 
        ind2Del = [ind2Del,i];
    end
    else 
        ind2Del = [ind2Del,i];
    end
    infoStrand(i) = infoStrand_i;
    tanFiber(i) =tanFiber_i;
%figure; imshow(testSV(infoStrand_i,s,2)>0),hold on,plot(infoStrand_i.PixelList(:,1),infoStrand_i.PixelList(:,2))
end
infoStrand(ind2Del) = [];
tanFiber(ind2Del) = [];
end