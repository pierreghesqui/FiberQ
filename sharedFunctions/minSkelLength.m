function otsu = minSkelLength(imSkel,PSF,opts)
skel = deleteBPMulti(imSkel,PSF);%figure; imshow(skel>0,[])
RP = regionprops(skel, 'Area','PixelIdxList');
Area = round([RP.Area]);
% if strcmp(opts,'otsu')
    otsu = round(multithresh(Area));
% % else
%     thresh = round(prctile(Area,98));
end
% pr=round(prctile(Area,98));
% [hist,edges] = histcounts(Area,...
%     min(Area):max(Area));
% M = max(hist);
% figure; plot(hist), hold on ; line([pr;pr],[0;M],'Color','red','LineWidth',3)
% line([otsu;otsu],[0;M],'Color','red','LineWidth',3)
% %reconstruct only object bigger than prc
% PixelIdxList = vertcat(RP(Area>pr).PixelIdxList);
% imBigObject = false(size(BW_roughf));
% imBigObject(PixelIdxList) = true;%figure; imshow(imBigObject,[])
