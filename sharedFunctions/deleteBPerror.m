function squelSegment2 =deleteBP(squelSegment,fiberThickness)

if nargin<2
    fiberThickness =6;
end

skelLabel = bwlabel(squelSegment); %figure; imshow(skelLabel>0,[])

%% Detect All BranchPoints
RP_skelLabel = regionprops(skelLabel,'Area','PixelIdxList','PixelList');
BP = bwmorph(squelSegment,'branchPoints');%figure; imshowpair(squelSegment,BP)
RP_BP = regionprops(BP,'PixelIdxList','PixelList');
s=size(squelSegment);


for i = 1:size(RP_BP,1) %for each BP
    %%dilatation coord
    [XY,indCross]=crossCoordinate([RP_BP(i).PixelList],s);
    
    indBPC = RP_BP(i).PixelIdxList;
    label = setdiff(unique(skelLabel(indBPC)),0);
    if isempty(label)
        continue;
    end
    if isequal(label,0) || isempty(RP_skelLabel(label).Area)
        continue;
    end
    %fiber construction
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
    fiber(sub2ind(sfib,RP_BP(i).PixelList(:,2)-ymin+1,RP_BP(i).PixelList(:,1)-xmin+1)) = false;
    yCros = XY(:,2)-ymin+1;xCros = XY(:,1)-xmin+1;
    ind2Del =yCros<1|yCros>sfib(1);
    yCros(ind2Del)=[];xCros(ind2Del) = [];
    ind2Del =xCros<1|xCros>sfib(2);
    yCros(ind2Del)=[];xCros(ind2Del) = [];
    fiber(sub2ind(sfib,yCros,xCros)) =false;%figure; imshow(fiber)
    %figure; imshow(fiber),hold on, plot(RPBP(i).PixelList(:,1)-xmin+1,RPBP(i).PixelList(:,2)-ymin+1,'xr')
    
    RP_fiber = regionprops(fiber,'Area','PixelIdxList','PixelList');

    if size(RP_fiber,1)<=1
       
        splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
        splSkelLabel(splSkelLabel==label) = 0;
        splSkelLabel = splSkelLabel+double(fiber).*label;
        skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;
        
    elseif size(RP_fiber,1)==2
        Areas = [RP_fiber.Area];
        [~,indMax] = max(Areas);
        isMax = [1:size(RP_fiber,1)]==indMax(1);
        if sum(Areas(~isMax)<Areas(isMax)/5) == size(RP_fiber,1)-1
            fiber(vertcat(RP_fiber(~isMax).PixelIdxList))=false;
            % TODO :to modify in order to include slope condition. Don't delete
            % everything
        else
            fiber = logical(connectStrand(double(fiber)));
        end
        splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
        splSkelLabel(splSkelLabel==label) = 0;
        splSkelLabel = splSkelLabel+double(fiber).*label;
        skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;
    else
        ind = find([RP_fiber.Area]<3*fiberThickness,1);
        if isempty(ind) %if all subfibers are small, delete the all fiber
            splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
            splSkelLabel(splSkelLabel==label) = 0;
            skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;
        else
            while size(RP_fiber,1)>2
                %reperons le maximum
                Areas = [RP_fiber.Area];
                [~,indMax] = max(Areas);
                isMax = [1:size(RP_fiber,1)]==indMax(1);
                
                %Si les fibres petites sont de tailles comparables, on
                %relie celle qui minimise la pente.
                AreasSmallFib = Areas(~isMax);
                isComparable = comparableSize(AreasSmallFib,maxDiff);
                
                %Sinon, on relie la plus grande
                
               
            end
            fiber = logical(connectStrand(double(fiber)));
            splSkelLabel = skelLabel(ymin:ymax,xmin:xmax);
            splSkelLabel(splSkelLabel==label) = 0;
            splSkelLabel = splSkelLabel+double(fiber).*label;
            skelLabel(ymin:ymax,xmin:xmax) = splSkelLabel;%figure; imshow(fiber)
            
        end%figure; imshowpair(skelLabel==label,BP)
        
    end %end if
    RP_skelLabel(label).Area = sum(fiber(:));
    [l,c] = find(fiber);
    newCoord = [c+xmin-1,l+ymin-1];
    RP_skelLabel(label).PixelList = newCoord;
    RP_skelLabel(label).PixelIdxList = sub2ind(s,newCoord(:,2),newCoord(:,1));
    
end%for each BP

squelSegment2 = bwmorph(skelLabel>0,'thin');

%figure; imshowpair(squelSegment2,imdilate(bwmorph(skelLabel>0,'branchPoints'),strel('disk',10)))
end


%%
%  if sum(Areas(~isMax)<Areas(isMax)/5) == size(RP_fiber,1)-1 %<==> si les petites fibres sont toutes trop petites, on les supprime toutes les deux
%                     fiber(vertcat(RP_fiber(~isMax).PixelIdxList))=false;%figure; imshow(fiber,[])
%                     RP_fiber = regionprops(fiber,'Area','PixelIdxList','PixelList');
%                 else
%                     %sinon, on supprime la plus petite.
%                     [~,ind2] = min([RP_fiber.Area]);
%                     fiber(RP_fiber(ind2).PixelIdxList)=false;
%                     RP_fiber = regionprops(fiber,'Area','PixelIdxList','PixelList');
%                 end