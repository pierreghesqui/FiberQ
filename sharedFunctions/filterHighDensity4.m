function [listSkel,densityMap] = filterHighDensity4(BW_rough,...
    grayImage,listSkel,param,thresh)

    winS = param.DensityWindowSize;
    thicknessFib = param.thicknessFib;
    s = size(BW_rough);
    largeLabel = bwlabel(BW_rough);
    
    winsize = [min(winS,round(s(1)/4)),min(winS,round(s(2)/4))];
    BW = imbinarize(grayImage);
    %% Experience dilatation
    %figure; imshowpair(BW_rough,BW_roughDilat);
    %densityMapBW_roughD = 1/PSF*imfilter(double(BW_roughDilat),ones(winsize)/prod(winsize),'symmetric');
    %figure; imshow(densityMapBW_roughD,[]),title('densityMapBW_roughD')
    %%
    densityMapBW_rough = 1/thicknessFib*imfilter(double(BW_rough),ones(winsize)/prod(winsize),'symmetric');
    densityMapGray =1/thicknessFib*imfilter(double(BW),ones(winsize)/prod(winsize),'symmetric');
    %figure; imshow(densityMapBW_rough,[]),title('densityMapBW_rough')
    %figure; imshow(densityMapGray,[])
    %figure; imshow(BW)
    %figure; imshow(BW_rough)
    %figure; imshow(grayImage,[])
    densityMap = max(densityMapGray,densityMapBW_rough);
    %figure; imshowpair(densityMapBW_rough>thresh,segm2Im(listSkel,'',1)>0)
    %figure; imshowpair(densityMapGray,BW_rough)
    
    nbSkel = numel(listSkel);
    if nbSkel >0
    ind2Del=[];
    for i =1:nbSkel
        ind = listSkel{i}.PixelIdxList;
        if max(densityMap(ind))>=thresh
            ind2Del = [ind2Del;i];
        end
    end
    listSkel(ind2Del)=[];%figure; imshow(segm2Im(listSkel,'',2),[])
    end
end