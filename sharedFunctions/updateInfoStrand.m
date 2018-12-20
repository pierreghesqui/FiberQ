function [infoStrand_i,tanFiber_i]=updateInfoStrand(intIm,infoStrand_i,...
    segmentVectorsSpliced,shapeCandidate_i,xmin,ymin,s,labelEP,rIndex,...
    cIndex,endPoint)
if isempty(segmentVectorsSpliced)
    fields = fieldnames(infoStrand_i);
    for i =1:length(fields)
        infoStrand_i.(fields{i}) = [];
    end
    tanFiber_i =[];
else
infoStrand_i.PixelList    = segmentVectorsSpliced.PixelList+[xmin-1,ymin-1];
Xs = smooth(infoStrand_i.PixelList(:,1),0.5,'lowess');
Ys = smooth(infoStrand_i.PixelList(:,2),0.5,'lowess');
infoStrand_i.PixelListSmoothed    = [Xs,Ys];
infoStrand_i.PixelIdxList = sub2ind(s,infoStrand_i.PixelList(:,2),infoStrand_i.PixelList(:,1));
infoStrand_i.MaxIntensity = labelEP;
infoStrand_i.xyLarge = [infoStrand_i.xyLarge;...
    shapeCandidate_i.PixelList+[xmin-1,ymin-1];cIndex'+xmin-1,rIndex'+ymin-1];
infoStrand_i.indLarge = sub2ind(s,infoStrand_i.xyLarge(:,2),infoStrand_i.xyLarge(:,1));
r = intIm(:,:,1);
g = intIm(:,:,2);
b = intIm(:,:,3);
infoStrand_i.intRed  =r(infoStrand_i.PixelIdxList);
infoStrand_i.intGreen  =g(infoStrand_i.PixelIdxList);
infoStrand_i.intBlue  =b(infoStrand_i.PixelIdxList);
mx = min(infoStrand_i.PixelList(:,1));
Mx = max(infoStrand_i.PixelList(:,1));
my = min(infoStrand_i.PixelList(:,2));
My = max(infoStrand_i.PixelList(:,2));
infoStrand_i.BoundingBox  =[mx,my,Mx-mx,My-my];
if endPoint == 2
    tanFiber_i = [Xs(end)-Xs(end-1),Ys(end)-Ys(end-1)];tanFiber_i=tanFiber_i/norm(tanFiber_i);
    %figure; plot(Xs,Ys),hold on, quiver(Xs(end),Ys(end),10*tanFiber_i(1),10*tanFiber_i(2))
elseif endPoint == 1
    tanFiber_i = [Xs(1)-Xs(2),Ys(1)-Ys(2)];tanFiber_i=tanFiber_i/norm(tanFiber_i);
end
end
end