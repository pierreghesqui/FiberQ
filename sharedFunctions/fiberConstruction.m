function fiber = fiberConstruction(RP_skelLabel,RP_BP,XY,label)
    xmin = min(RP_skelLabel(label).PixelList(:,1));
    xmax = max(RP_skelLabel(label).PixelList(:,1));
    ymin = min(RP_skelLabel(label).PixelList(:,2));
    ymax = max(RP_skelLabel(label).PixelList(:,2));
    
    fiber = false(ymax-ymin+1,xmax-xmin+1);
    sfib = size(fiber);
    xfib = RP_skelLabel(label).PixelList(:,1)-xmin+1;
    yfib = RP_skelLabel(label).PixelList(:,2)-ymin+1;
    
    %build Fiber
    fiber(sub2ind(sfib,yfib,xfib)) = true; %figure; imshow(fiber)
    
    %del branchPoint
    xBP_in_fiber = RP_BP.PixelList(:,1)-xmin+1;
    yBP_in_fiber = RP_BP.PixelList(:,2)-ymin+1;
    fiber(sub2ind(sfib,yBP_in_fiber,xBP_in_fiber)) = false;
    yCros = XY(:,2)-ymin+1;xCros = XY(:,1)-xmin+1;
    ind2Del =yCros<1|yCros>sfib(1);
    yCros(ind2Del)=[];xCros(ind2Del) = [];
    ind2Del =xCros<1|xCros>sfib(2);
    yCros(ind2Del)=[];xCros(ind2Del) = [];
    fiber(sub2ind(sfib,yCros,xCros)) =false;
end