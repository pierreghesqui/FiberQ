function RP_skel2 = deleteBP_1Fiber(RP_skel_i,xBPi,yBPi)
    fiber = RP_skel_i.Image;
    s= size(fiber);
    BB = RP_skel_i.BoundingBox;
    [xmin,xmax,ymin,ymax]  = convertBB2Limit(BB);
    xBPi = xBPi-xmin+1;
    yBPi = yBPi-ymin+1;
    indBPi = sub2ind(s,yBPi,xBPi);
    BP_im = false(s);
    BP_im(indBPi)=true;
    fiber2 = deleteBP_first(fiber,RP_skel_i.PixelList,RP_skel_i.PixelIdxList,...
                xBPi,yBPi,indBPi);
% au niveau de chaque BP, tester la continuité. 
    figure; imshowpair(fiber,fiber2)




end