function [largeLabel,skelLabel, infoStrand_i,tanFiber_i]=enlargeEndPoint(intIm,...
    largeLabel,skelLabel, infoStrand_i,tanFiber_i,...
    RP_large,FiberThickness,endPoint)
s = size(largeLabel);
%figure; imshow(largeLabel,[])
thresh_dist = 4*FiberThickness;

%% chercher les shapes les plus proches
X = infoStrand_i.PixelList(:,1);
Y = infoStrand_i.PixelList(:,2);

%%
if endPoint ==2
    X_EP = infoStrand_i.PixelList(end,1);
    Y_EP = infoStrand_i.PixelList(end,2);
elseif endPoint ==1
    X_EP = infoStrand_i.PixelList(1,1);
    Y_EP = infoStrand_i.PixelList(1,2);
end
labelEP = skelLabel(Y_EP,X_EP);
%figure; imshow(skelLabel>0,[]),hold on, plot(X_EP,Y_EP,'xr')
%figure; imshowpair(skelLabel>0,largeLabel>0),hold on,plot(X_EP,Y_EP,'og'),plot(X,Y,'xr')
%boundingBox
xmin = min(max(1,min(min(X),X_EP-thresh_dist)),s(2));
xmax = min(max(1,max(max(X),X_EP+thresh_dist)),s(2));
ymin = min(max(1,min(min(Y),Y_EP-thresh_dist)),s(1));
ymax= min(max(1,max(max(Y),Y_EP+thresh_dist)),s(1));

LargeLabelWithoutLabel = largeLabel;
LargeLabelWithoutLabel(LargeLabelWithoutLabel==largeLabel(Y_EP,X_EP))=0;
%figure; imshow(LargeLabelWithoutLabel>0,[]),hold on, plot(X_EP,Y_EP,'xr')
otherLabels = setdiff(unique(LargeLabelWithoutLabel(ymin:ymax,xmin:xmax)),0);
if ~isempty(otherLabels)>0
    [im_largeReduced,xmin,xmax,ymin,ymax] = adjustImSize(RP_large,...
        otherLabels,[X,Y],labelEP,xmin,xmax,ymin,ymax);
    X_EP2 = X_EP-xmin+1;
    Y_EP2 = Y_EP-ymin+1;
    X2 = X-xmin+1;
    Y2 = Y-ymin+1;
    s2 = size(im_largeReduced);
    skelLabelReduced = zeros(s2);
    shapeCandidate=buildShapeCandidate(im_largeReduced,RP_large,labelEP,...
        otherLabels,xmin,ymin,thresh_dist);
    %clear im_largeReduced
    if endPoint ==2
        indGoodCandidate = findBestCandidate(shapeCandidate,X_EP2,Y_EP2, tanFiber_i.tan2,im_largeReduced);
    elseif endPoint ==1
        indGoodCandidate = findBestCandidate(shapeCandidate,X_EP2,Y_EP2, tanFiber_i.tan1,im_largeReduced);
    end
    %figure; imshow(skelLabel(ymin:ymax,xmin:xmax),[]),hold on,plot(X_EP2,Y_EP2,'xr'),
    %plot(infoStrand_i.PixelListSmoothed(:,1),infoStrand_i.PixelListSmoothed(:,2),'xg')
    %quiver(X_EP2,Y_EP2,10*tanFiber_i.tan2(1),10*tanFiber_i.tan2(2))
    if ~isempty(indGoodCandidate)
        XYLink_Reduced = shapeCandidate(indGoodCandidate).linkXYReduced;
        [ rIndex,cIndex,Index ,maxNbP] = plotLine2(XYLink_Reduced',[X_EP2,Y_EP2]',s2,0);
        %skelLabelReduced2 = connectSkel2newBlob(s2,sub2ind(s2,Y2,X2),Index',shapeCandidate(indGoodCandidate).PixelIdxList,labelEP);
        skelLabelReduced(sub2ind(s2,Y2,X2))=labelEP;
        skelLabelReduced(Index) = labelEP;
        skelLabelReduced2 = skelLabelReduced;
        skelLabelReduced2(shapeCandidate(indGoodCandidate).PixelIdxList)=labelEP;
        skelLabelReduced2 = double(bwmorph(skelLabelReduced2,'thin',Inf))*labelEP;
        %figure; imshow(skelLabelReduced,[]);figure; imshow(skelLabelReduced2,[])
        
        skelLabelReduced2 = deleteBPMulti (skelLabelReduced2, FiberThickness);
        nbPixelAdded = max(sum(skelLabelReduced2(:))-sum(skelLabelReduced(:)>0),0);
        %BP = bwmorph(skelLabelReduced,'branchpoints'); 
        %figure; imshow(skelLabelReduced,[])
        if any(skelLabelReduced2(:))
        segmentVectorsSpliced = getSegmentsCoordAndInt(skelLabelReduced2,double(skelLabelReduced2)*labelEP);
        [~,segmentVectorsSpliced] = refineEndStrand(skelLabelReduced2,segmentVectorsSpliced,...
            intIm(ymin:ymax,xmin:xmax,:),double(LargeLabelWithoutLabel(ymin:ymax,xmin:xmax)>0),FiberThickness,nbPixelAdded);
        %skelLabelReduced3 = testSV(segmentVectorsSpliced,s2,2,1);
        %figure;imshowpair(skelLabelReduced3,LargeLabelWithoutLabel(ymin:ymax,xmin:xmax))
        [infoStrand_i,tan2]=updateInfoStrand(intIm,infoStrand_i,segmentVectorsSpliced,...
            shapeCandidate(indGoodCandidate),xmin,ymin,s,labelEP,rIndex,cIndex,endPoint);
        clear segmentVectorsSpliced skelLabelReduced LargeLabelWithoutLabel
        if endPoint == 1
            tanFiber_i.tan1 = tan2;
        elseif endPoint == 2
            tanFiber_i.tan2 = tan2;
        end
        skelLabel(infoStrand_i.PixelIdxList) = labelEP;%figure; imshowpair(skelLabel==labelEP,skelLabel)
        largeLabel(shapeCandidate(indGoodCandidate).PixelIdxListBig)=0;%figure; imshow(largeLabel==391,[])
        %figure; imshow(skelLabel==labelEP,[]),hold on,quiver(infoStrand_i.PixelList(end,1),infoStrand_i.PixelList(end,2),10*tan2(1),10*tan2(2))
        if ~isempty(infoStrand_i.Area)
        [largeLabel,skelLabel, infoStrand_i,tanFiber_i] = enlargeEndPoint(intIm,largeLabel,skelLabel, infoStrand_i,tanFiber_i,...
        RP_large,FiberThickness,endPoint);
        end
        end
    end
end %figure; imshow(skelLabel>0,[])