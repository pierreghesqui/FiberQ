function segmentVectors2 = filterBadStrands(segmentVectors,largeSegm)

    s =size(largeSegm);
    %figure; imshow(largeSegm,[])
    [r,g,b] = testSV(segmentVectors,size(largeSegm));
    %figure ; imshow(cat(3,r,g,b));
    %% Filter 1 : fiber size (delete smallest strand)
    prctil = 50;
    totArea = [segmentVectors.Area];
    thresh = prctile(totArea,prctil);
    indHighDensity = totArea < thresh;
    segmentVectors2 = segmentVectors;
    segmentVectors2(indHighDensity) = [];
    [r2,g2,b2] = testSV(segmentVectors2,size(largeSegm));%figure; imshow(rgb2gray(cat(3,r2,g2,b2)))
    %figure ; imshowpair(rgb2gray(cat(3,r,g,b)),rgb2gray(cat(3,r2,g2,b2)));
    
    %% Filter 2 : densité
    winsize = round(s/4);
    win = ones(winsize);
    denMax = sum(win(:));
    densityMap = imfilter(double(largeSegm>0),win)/denMax;%figure; imshow(densityMap,[])
    densityMap = imclose(densityMap>0.1,win);
    indHighDensity = find(densityMap);
    ind2Del = [];
    for i = 1:numel(segmentVectors2)
        if(~isempty(find(ismember(segmentVectors2(i).indLarge,indHighDensity),1)))
            ind2Del = [ind2Del, i];
        end
    end
    segmentVectors2(ind2Del)=[];
    [r2,g2,b2] = testSV(segmentVectors2,size(largeSegm));
    %figure ; imshowpair(rgb2gray(cat(3,r2,g2,b2)),densityMap);
    %figure ; imshowpair(rgb2gray(cat(3,r,g,b)),rgb2gray(cat(3,r2,g2,b2)));
    
end

