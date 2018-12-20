function [fiber,BP_im2,...
    fiber_PixelList,fiber_PixelIdxList,...
    BP_PixelList,BP_PixelIdxList,...
    xmin,xmax,ymin,ymax] = extractFiber(skelLabel,BP_im,RPlabel,RP_BP,label_i)%figure; imshow(skelLabel>0,[])
    
    indBP = [RP_BP.MaxIntensity]==label_i;
    BB = RPlabel.BoundingBox;
    [xmin,xmax,ymin,ymax] = convertBB2Limit(BB);
    [gridx,gridy] = meshgrid(1:xmax-xmin+1,1:ymax-ymin+1);
    BP_im2 = zeros(ymax-ymin+1,xmax-xmin+1);
    fiber = zeros(ymax-ymin+1,xmax-xmin+1);
    s=size(fiber);
    fiber_PixelList = RPlabel.PixelList-[xmin-1,ymin-1];
    fiber_PixelIdxList = sub2ind(s,fiber_PixelList(:,2),fiber_PixelList(:,1));
    fiber(fiber_PixelIdxList) = 1;
    BP_PixelList=vertcat(RP_BP(indBP).PixelList)-[xmin-1,ymin-1];
    BP_PixelIdxList=sub2ind(s,BP_PixelList(:,2),BP_PixelList(:,1));
    BP_im2(BP_PixelIdxList)=1;
end