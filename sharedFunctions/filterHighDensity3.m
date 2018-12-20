function largeSegm2 = filterHighDensity3(largeSegm,FIBER_THICKNESS) 
    s = size(largeSegm);
    skel = bwmorph(largeSegm,'thin',Inf);
    thresh = 0.1;
    largeLabel = bwlabel(largeSegm);
    
    winsize = [min(30*FIBER_THICKNESS,s(1)/4),min(30*FIBER_THICKNESS,s(2)/4)];
    fun = @(block_struct) mean2(block_struct.data) * ones(size(block_struct.data));
    densityMap = blockproc(largeSegm,winsize,fun);%figure; imshow(densityMap,[])
    
    %figure; imshow(densityMap,[])%figure; imshowpair(largeSegm,densityMap,'montage')
    
    indHighDensity = find(densityMap>thresh);
    label2Del = setdiff(unique(largeLabel(indHighDensity)),0);
    largeLabel(ismember(largeLabel,label2Del))=false;
    largeSegm2 =largeLabel>0;%figure; imshowpair(largeSegm,largeSegm2)
    
end