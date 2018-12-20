function  shapeCandidate=buildShapeCandidate(im_largeReduced,RP_large,labelEP,...
    otherLabels,xmin,ymin,thresh_dist)
shapeCandidate = struct('label',num2cell(otherLabels),'mindistance',[]);
s2 = size(im_largeReduced);
    bwdistance = bwdist(im_largeReduced==labelEP);
    for i = 1:length(otherLabels)
        ind = sub2ind(s2,RP_large(otherLabels(i)).PixelList(:,2)-ymin+1,...
            RP_large(otherLabels(i)).PixelList(:,1)-xmin+1);
       [mind,idx] = min(bwdistance(ind));
        link = ind(idx(1));
        [yreduced,xreduced] =  ind2sub(s2,link);
        shapeCandidate(i).mindistance =  mind;
        shapeCandidate(i).indlinkReduced =  link;
        shapeCandidate(i).linkXYReduced =  [xreduced,yreduced];
        shapeCandidate(i).moment = RP_large(otherLabels(i)).MajorAxisLength/RP_large(otherLabels(i)).MinorAxisLength;
        shapeCandidate(i).MajorAxisLength =RP_large(otherLabels(i)).MajorAxisLength;
        shapeCandidate(i).MinorAxisLength =RP_large(otherLabels(i)).MinorAxisLength;
        shapeCandidate(i).PixelList =RP_large(otherLabels(i)).PixelList-[xmin-1,ymin-1];
        shapeCandidate(i).PixelListBig =RP_large(otherLabels(i)).PixelList;
        shapeCandidate(i).PixelIdxListBig =RP_large(otherLabels(i)).PixelIdxList;
        shapeCandidate(i).PixelIdxList =sub2ind(s2,shapeCandidate(i).PixelList(:,2),shapeCandidate(i).PixelList(:,1));
    end
    
    for i =1:numel(shapeCandidate)
        if shapeCandidate(i).moment<3
            shapeCandidate(i).connectionStrategy = 1;
            shapeCandidate(i).Centroid = RP_large(otherLabels(i)).Centroid-[xmin-1,ymin-1];
        else
            shapeCandidate(i).connectionStrategy = 2;
            theta = RP_large(otherLabels(i)).Orientation;
            shapeCandidate(i).tan = [cos(theta*pi/180),sin(-theta*pi/180)];
            shapeCandidate(i).Centroid = RP_large(otherLabels(i)).Centroid-[xmin-1,ymin-1];
        end
    end
    minDist = [shapeCandidate.mindistance];
    ind2Del = minDist>thresh_dist;
    shapeCandidate(ind2Del) = [];
end