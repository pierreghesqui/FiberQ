function segmentVectors2=filterCurvature(segmentVectors,largeLabel,threshTheta)
largeSegment = largeLabel >0;
s=size(largeSegment);
segmentVectors2 = segmentVectors;
nbSegment    = numel(segmentVectors2);
ind2Del= [];
for i = 1 : nbSegment
    indLarge = segmentVectors2(i).indLarge;
    indLargeD = dilateInd(indLarge,s,1);
    
    PixelList = segmentVectors2(i).PixelList;
    l  =  min(PixelList(:,2)):max(PixelList(:,2)); 
    c  =  min(PixelList(:,1)):max(PixelList(:,1)); 
    smallIm = largeSegment(l,c,:);
    
    x = smooth(PixelList(:,1),0.75,'lowess');
    y = smooth(PixelList(:,2),0.75,'lowess');
    
    dx  = gradient(x);
    dy  = gradient(y);
    theta = atan2(-dy,dx)*180/pi;%figure; plot(theta)
    thetamin = min(theta);
    thetaMax = max(theta);
    deltaTheta = thetaMax-thetamin;
    
    %indSmooth = sub2ind(s,round(y),round(x)); 
    
%     if ~isempty(find(~ismember(indSmooth,indLargeD),1))
%         ind2Del = [ind2Del,i];
%         continue;
%     end
    if deltaTheta > threshTheta
        ind2Del = [ind2Del,i];
%     figure('units','normalized','outerposition',[0 0 1 1]); subplot(2,2,[1,2]), imshow(largeSegment,[]), hold on, plot(x,y);
%     subplot(2,2,[3]), imshow(smallIm,[]); hold on, plot(x(1)-c(1)+1,y(1)-l(1)+1,'*r');plot(x-c(1)+1,y-l(1)+1);
%     subplot(2,2,[4]), plot(theta); title(['deltaTheta = ' num2str(deltaTheta)])
    end


end

segmentVectors2(ind2Del)=[];

%figure; imshow(largeLabel>0,[])

end
function indLarge2 = dilateInd(indLarge,s,szD)
    [y,x] = ind2sub(s,indLarge);
    x = reshape([x+[-szD,0,szD]],[],1);
    y = repmat(y,[2*szD+1,1]);
    
    y = reshape([y+[-szD,0,szD]],[],1);
    x = repmat(x,[2*szD+1,1]); 
    
    ind2Del = y<1|y>s(1)|x<1|x>s(2);
    x(ind2Del) = [];
    y(ind2Del) = [];
    indLarge2 = unique(sub2ind(s,y,x));
    
end