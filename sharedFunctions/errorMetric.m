function infoStrand = errorMetric(infoStrand,BW_rough2,FiberThickness)
%figure; imshow(BW_rough2,[])
nbFibers = numel(infoStrand);
s = size(BW_rough2);
sizDil = round(1.5*FiberThickness);
sizDil2 = round(2*FiberThickness);

for i =1:nbFibers
    lfiber = infoStrand(i).PixelList(:,2);
    cfiber = infoStrand(i).PixelList(:,1);
     
    [l_limit_min,l_limit_max,c_limit_min,c_limit_max,...
    lmin,lmax,cmin,cmax] = boundingBox(infoStrand(i).ind, s, sizDil);
    lfiber2 = lfiber- l_limit_min+1;
    cfiber2 = cfiber-c_limit_min+1;
    fiber = BW_rough2(l_limit_min:l_limit_max,c_limit_min:c_limit_max);
    s2   = size(fiber);
    indFiber = sub2ind(s2,lfiber2,cfiber2);
    fiberEP = false(s2);
    fiberEP([indFiber(1);indFiber(end)]) = true;
    
    fiberlabel = bwlabel(fiber);
    ind2Skel = sub2ind(s2,lfiber-l_limit_min+1,cfiber-c_limit_min+1);
    label2Del = unique(fiberlabel(ind2Skel));
    BW_other = ~ismember(fiberlabel,[label2Del;0]); %figure; imshowpair(fiberlabel>0,BW_other);
    mskDil = false(s2);mskDil(indFiber)=true; 
    mskDil = imdilate(mskDil,strel('disk',sizDil));%figure; imshowpair(mskDilEP,fiber);
    mskDilEP = imdilate(fiberEP,strel('disk',sizDil2));
    areaMskDil = sum(mskDil(:));
    density = sum(BW_other(mskDil))/areaMskDil;
    mskObj = zeros(s2);mskObj(mskDil)=BW_other(mskDil);
    mskObjEP = zeros(s2);mskObjEP(mskDilEP)=BW_other(mskDilEP);
    [~,nbObject] = bwlabel( mskObj);
    [~,nbObjectEP] = bwlabel( mskObjEP);

    infoStrand(i).density = density;
    infoStrand(i).nbNeighbourObject = nbObject;
    infoStrand(i).nbNeighbourObjectEP = nbObjectEP;
    %imFiber = testSV(infoStrand(i),s,2,FiberThickness);%figure; imshow(imFiber,[])
end
end