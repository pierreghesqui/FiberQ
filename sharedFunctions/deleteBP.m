function skelLabel3 =deleteBP(skelLabel,fiberThickness)
if nargin<2
    fiberThickness=6;
end
if length(setdiff(unique(skelLabel),0)) == 1
    skelLabel = bwlabel(skelLabel);
end
%skelLabel = bwlabel(squelSegment);%figure; imshow(skelLabel>0,[])
RP1 = regionprops(skelLabel,'Area','PixelIdxList','PixelList');
BP = bwmorph(skelLabel,'branchPoints');%figure; imshow(skelLabel)
RPBP = regionprops(BP,'PixelIdxList','PixelList');
s=size(skelLabel);
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
        splSkelLabel(splSkelLabel==label) = 0;
        splSkelLabel = splSkelLabel+double(fiber).*label;
        skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;
    elseif size(RP2,1)==2
        fiber = logical(connectStrand(double(fiber)));
        splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
        splSkelLabel(splSkelLabel==label) = 0;
        splSkelLabel = splSkelLabel+double(fiber).*label;
        skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;
    else
        ind = find([RP2.Area]<5*fiberThickness,1);
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

skelLabel2 = bwmorph(skelLabel>0,'thin');
skelLabel3 = double(skelLabel2);
skelLabel3(skelLabel2)=skelLabel(skelLabel2);
%figure; imshowpair(squelSegment2,imdilate(bwmorph(skelLabel>0,'branchPoints'),strel('disk',10)))
end