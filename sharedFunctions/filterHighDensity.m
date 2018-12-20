function largeSegm2 = filterHighDensity(largeSegm) 
    s = size(largeSegm);
    thresh = 0.1;
    largeLabel = bwlabel(largeSegm);
    winsize = round(s/4);
    win = ones(winsize);
    denMax = sum(win(:));
    densityMap = imfilter(double(largeSegm>0),win/denMax,'same');%figure; imshow(densityMap,[])%figure; imshowpair(largeSegm,densityMap,'montage')
    densityMap = imclose(densityMap>thresh,win);
    indHighDensity = find(densityMap);
    label2Del = setdiff(unique(largeLabel(indHighDensity)),0);
    largeLabel(ismember(largeLabel,label2Del))=false;
    largeSegm2 =largeLabel>0;%figure; imshowpair(largeSegm,largeSegm2)
    
end
%figure; imshowpair(largeSegm,densityMap)