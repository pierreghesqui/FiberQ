function squelSegment2 =deleteBP1(squelSegment)
    skelLabel = bwlabel(squelSegment);%figure; imshow(skelLabel>0,[])
    RP1 = regionprops(skelLabel,'Area','PixelIdxList','PixelList');
    BP = bwmorph(squelSegment,'branchPoints');%figure; imshowpair(squelSegment,BP)
    RPBP = regionprops(BP,'PixelIdxList','PixelList');
    s=size(squelSegment);
    for i = 1:size(RPBP,1)
        %%dilatation coord
        [XY,indCross]=crossCoordinate([RPBP(i).PixelList],s);
        
        indBPC = RPBP(i).PixelIdxList;
        label = setdiff(unique(skelLabel(indBPC)),0);
        if isempty(label)
            continue;
        end
        if isequal(label,0) || isempty(RP1(label).Area)  
            continue;     
        end
        %fiber construction
        xmin = min(RP1(label).PixelList(:,1));
        xmax = max(RP1(label).PixelList(:,1));
        ymin = min(RP1(label).PixelList(:,2));
        ymax = max(RP1(label).PixelList(:,2));
        
        fiber = false(ymax-ymin+1,xmax-xmin+1);
        sfib = size(fiber);
        xfib = RP1(label).PixelList(:,1)-xmin+1;
        yfib = RP1(label).PixelList(:,2)-ymin+1;
        
        %build Fiber
        fiber(sub2ind(sfib,yfib,xfib)) = true; %figure; imshow(fiber)
        
        %del branchPoint
        fiber(sub2ind(sfib,RPBP(i).PixelList(:,2)-ymin+1,RPBP(i).PixelList(:,1)-xmin+1)) = false;
        
        yCros = XY(:,2)-ymin+1;xCros = XY(:,1)-xmin+1;
        ind2Del =yCros<1|yCros>sfib(1);
        yCros(ind2Del)=[];xCros(ind2Del) = [];
        ind2Del =xCros<1|xCros>sfib(2);
        yCros(ind2Del)=[];xCros(ind2Del) = [];
        fiber(sub2ind(sfib,yCros,xCros)) =false;%figure; imshow(fiber)
        %figure; imshow(fiber),hold on, plot(RPBP(i).PixelList(:,1)-xmin+1,RPBP(i).PixelList(:,2)-ymin+1,'xr')
        RP2 = regionprops(fiber,'Area','PixelIdxList','PixelList');
        if size(RP2,1)<=1
               splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
               splSkelLabel = splSkelLabel+double(fiber).*label;
               skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;

        elseif size(RP2,1)==2
            fiber = logical(connectStrand(double(fiber)));
            splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
               splSkelLabel(splSkelLabel==label) = 0;
               splSkelLabel = splSkelLabel+double(fiber).*label;
               skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;
        else
           ind = find([RP2.Area]<20);
           if isempty(ind)
               fiber = false(ymax-ymin+1,xmax-xmin+1);
               splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
               splSkelLabel(splSkelLabel==label) = 0;
               splSkelLabel = splSkelLabel+double(fiber).*label;
               skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;

           else
               while size(RP2,1)>2
               [~,ind2] = min([RP2.Area]);
               fiber(RP2(ind2).PixelIdxList)=false;
               RP2 = regionprops(fiber,'Area','PixelIdxList','PixelList');
               end
               fiber = logical(connectStrand(double(fiber)));
               splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
               splSkelLabel(splSkelLabel==label) = 0;
               splSkelLabel = splSkelLabel+double(fiber).*label;
               skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;%figure; imshow(fiber)
           end%figure; imshowpair(skelLabel==label,BP)

        end
       RP1(label).Area = sum(fiber(:));
       [l,c] = find(fiber);
       newCoord = [c+xmin-1,l+ymin-1];
       RP1(label).PixelList = newCoord;
       RP1(label).PixelIdxList = sub2ind(s,newCoord(:,2),newCoord(:,1));

    end
    
    squelSegment2 = bwmorph(skelLabel>0,'thin');
    
  %figure; imshowpair(squelSegment2,imdilate(bwmorph(skelLabel>0,'branchPoints'),strel('disk',10)))
end