function XY = refineDown(XY,BW_rough,param)
%figure; imshow(BW_rough,[]),hold on,plot(XYbeg(:,1),XYbeg(:,2))
%plot(XY(:,1),XY(:,2))
BW_rough =double(BW_rough);
    smoothRange = min(floor(size(XY,1)*0.5),param.maxSmoothRange);
    Xs = smooth(XY(:,1),smoothRange,'lowess');
    Ys = smooth(XY(:,2),smoothRange,'lowess');
    endDistAnalysis = param.endDistAnalysis;
    XYUp = zeros(size(XY,1)-endDistAnalysis,2);
    XYDown = zeros(endDistAnalysis,2);
    XYbeg =[XY(1:end-endDistAnalysis,1),XY(1:end-endDistAnalysis,2)];
    XYUp(:,1) = smooth(XY(1:end-endDistAnalysis,1),smoothRange,'lowess');
    XYUp(:,2) = smooth(XY(1:end-endDistAnalysis,2),smoothRange,'lowess');
    XYDown(:,1) =smooth(XY(end-endDistAnalysis+1:end,1),'lowess');
    XYDown(:,2) =smooth(XY(end-endDistAnalysis+1:end,2),'lowess');
    nbPixelDown = size(XYUp,1);
    
    tan = [XYUp(end,1)-XYUp(end-1,1);XYUp(end,2)-XYUp(end-1,2)];
    tan = tan/norm(tan);
    tanDown = [mean(gradient(XYDown(:,1)));mean(gradient(XYDown(:,2)))];
    tanDown=tanDown/norm(tanDown);
    projection = tan'*tanDown;
    threshproj=0.8;
    if projection<threshproj
        while findPixelValue(BW_rough,XYbeg(end,1)+tan(1),...
                XYbeg(end,2)+tan(2),'nearest')==1
            XYbeg = [XYbeg;XYbeg(end,1)+tan(1),XYbeg(end,2)+tan(2)];
        end
        XY = round(XYbeg);
    else
        tan  = [Xs(end)-Xs(end-1),Ys(end)-Ys(end-1)];tan=tan/norm(tan);
        while findPixelValue(BW_rough,XY(end,1)+tan(1),...
                XY(end,2)+tan(2),'nearest')==1
            XY = [XY;XY(end,1)+tan(1),XY(end,2)+tan(2)];
        end
        XY = round(XY);
    end
    %im = false(size(BW_rough));
    %im(sub2ind(size(BW_rough),XY(:,2),XY(:,1)))=true; 
    %imshow(im),hold on,quiver(XY(end,1),XY(end,2),10*tan(1),10*tan(2))
end