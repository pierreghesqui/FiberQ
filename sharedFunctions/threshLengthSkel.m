function [threshOtsu,thresh_98] = threshLengthSkel(imSkel,PSF)
skel = deleteBPMulti(imSkel,PSF);%figure; imshow(skel>0,[])
RP = regionprops(skel, 'Area','PixelIdxList');
Area = round([RP.Area]);

    threshOtsu = round(multithresh(Area));

    thresh_98 = round(prctile(Area,98));
end