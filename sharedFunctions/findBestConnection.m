function fiber3 = findBestConnection(fiber,xBP,yBP)%figure; imshow(fiber);
%% Build fiber parameters
EP_fiber = bwmorph(fiber,'endpoints');%figure; imshow(EP_fiber,[])
indBP = find(bwmorph(fiber,'branchPoints'));%figure; imshow(bwmorph(fiber,'branchPoints'),[])
fiberLabel = bwlabel(fiber);%figure; imshow(fiberLabel,[])
fiberLabel2 = fiberLabel;
fiber2 = fiber;
RP_fiber = regionprops(fiberLabel,'Area','PixelIdxList','PixelList');
nbSubFiber = size(RP_fiber,1);
RP_fiber(1).indEP =[];
RP_fiber(1).xyEP =[];
s = size(fiber);

%% Detect EndPoints on each sub Fiber
[indEP] = find(EP_fiber);
labelEP = fiberLabel(indEP);
for i =1:length(indEP)
    RP_fiber(labelEP(i)).indEP = [RP_fiber(labelEP(i)).indEP,indEP(i)];
    [yEP,xEP] = ind2sub(s,indEP(i));
    RP_fiber(labelEP(i)).xyEP = [RP_fiber(labelEP(i)).xyEP;xEP,yEP];
end

%% findCoord for each SubFiber
for i = 1:nbSubFiber %i = label
    %find closest point among EP
    [~,indMin] = min(pdist2(RP_fiber(i).xyEP,[xBP,yBP]));
    [~,indMax] = max(pdist2(RP_fiber(i).xyEP,[xBP,yBP]));
    toAvoid = RP_fiber(i).indEP(indMax);
    %         x1 = RP_fiber(i).xyEP(indMin,1);
    %         y1 = RP_fiber(i).xyEP(indMin,2);
    indsubFiber = [];
    continueCriteria = 1;
    cpt =1;
    xyMoins1 = [RP_fiber(i).xyEP(indMin,1),RP_fiber(i).xyEP(indMin,2)];
    RP_fiber(i).xyEPMin = xyMoins1;
    while(continueCriteria)
        EP_fiber2 = bwmorph(fiberLabel2==i,'endpoints');%figure; imshow(fiberLabel2,[])
        indEP2 = find(EP_fiber2);
        [yEP2,xEP2] = ind2sub(s,indEP2);
        if length(indEP2)>1
            [m,ind1] = min(pdist2([xEP2,yEP2],xyMoins1));
            if m>sqrt(2)
                continueCriteria=0;
                continue;
            end
            indsubFiber=[indsubFiber,indEP2(ind1)];
            if ismember(indEP2(ind1),indBP)&& cpt ~=1
                continueCriteria=0;
            end
            fiberLabel2(indsubFiber(end))=0;
            xyMoins1=[xEP2(ind1),yEP2(ind1)];
        else
            indsubFiber=[indsubFiber,indEP2];
            continueCriteria = 0;
        end
        cpt = cpt+1;
        
    end
    indsubFiber=fliplr(indsubFiber);
    RP_fiber(i).indSubFiber = fliplr(indsubFiber);
    [ySubFiber,xSubFiber] = ind2sub(s,indsubFiber);
    RP_fiber(i).xySubFiber = [xSubFiber',ySubFiber'];
    RP_fiber(i).sizSubFiber = length(indsubFiber);
    
    if RP_fiber(i).sizSubFiber<30
        ratioSmooth = 0.9;
    else
        ratioSmooth = 0.5;
    end
    xSubFiberS = smooth([RP_fiber(i).xySubFiber(:,1)],ratioSmooth,'lowess');
    ySubFiberS = smooth([RP_fiber(i).xySubFiber(:,2)],ratioSmooth,'lowess');
    RP_fiber(i).xySubFiberS = [xSubFiberS,ySubFiberS];
    if RP_fiber(i).sizSubFiber>1
    tanBP = [xSubFiberS(end)-xSubFiberS(end-1);ySubFiberS(end)-ySubFiberS(end-1)];
    tanBP = tanBP/norm(tanBP);
    RP_fiber(i).tanBP = tanBP;
    else 
        fiberLabel(RP_fiber(i).indSubFiber)=0;
    end
end
    fiber2([RP_fiber.indSubFiber])=0;
%% Debuggin plot
doDebugPlot = 1;
if doDebugPlot
    figure; imshow(fiber,[]),hold on;
    
    for i = 1:nbSubFiber
        if RP_fiber(i).sizSubFiber>1
        plot(RP_fiber(i).xySubFiberS(:,1),RP_fiber(i).xySubFiberS(:,2));
        quiver(RP_fiber(i).xyEPMin(1),RP_fiber(i).xyEPMin(2),...
                10*RP_fiber(i).tanBP(1),10*RP_fiber(i).tanBP(2));
        end
     end
close all
end


%% choose best Fiber among the smallest

%delete case where there is only one point on the Subfiber
%RP_fiber([RP_fiber.sizSubFiber]<2)=[];

projection = zeros(nbSubFiber,1);
[~,indMax] = max([RP_fiber.sizSubFiber]);
tanBig = RP_fiber(indMax).tanBP;
for i =1:nbSubFiber
    if RP_fiber(i).sizSubFiber>1
    tanBP = RP_fiber(i).tanBP;
    projection(i) = [-tanBP]'*tanBig;
    end
end
projection(indMax) =-Inf;
[~,indBetterSubFiber] = max(projection);

%fiber = 
fiber2 ([RP_fiber([indBetterSubFiber,indMax]).indSubFiber])=1;%figure; imshow(fiber2,[])
fiber3 = connectStrand(fiber2);%figure; imshowpair(fiber,fiber3)
%figure; imshow(fiber3,[]),hold on,plot(xBP,yBP,'xr')



end