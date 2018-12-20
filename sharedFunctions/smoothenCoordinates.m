function [ regPropSquel ] = smoothenCoordinates( regPropSquel )
%SMOOTHENCOORDINATES smoothen the x,y coordinates for each strand
nbStrands = numel(regPropSquel);
for i = 1 : nbStrands
    xy = regPropSquel(i).PixelList;
    %figure; plot(x,y,'rx')
    xs = smooth(xy(:,1),0.15,'moving'); ys = smooth(xy(:,2),0.15,'moving');
    %figure;subplot(2,1,1), plot(xy(:,1),xy(:,2),'rx'),subplot(2,1,2), plot(xs,ys,'rx')
    regPropSquel(i).SmoothPixelList = [xs,ys];
end


end

