function   listSkelf = findRedAndGreenLimit(listSkelf,im,param)
%figure; imshow(im,[])%figure; imshow(segm2Im(listSkelf,'',0))
FiberThickness = param.thicknessFib;
opts.smoothing = 1;
s= size(im);
nbStrands = numel(listSkelf);
ind2Del=[];

for i = 1:nbStrands
    
    %% find small image
    XY = listSkelf{i}.XY;
    smoothPixelList =[smooth(XY(:,1),0.25,'loess'),smooth(XY(:,2),0.25,'loess')];
    l = min(XY(:,2)):max(XY(:,2));
    c = min(XY(:,1)):max(XY(:,1));
    smallIm = im(l,c,:);
    PixelIdxList = listSkelf{i}.PixelIdxList;

    %% find red and green intensity
    if opts.smoothing
        indR = sub2ind([s(1),s(2),3],XY(:,2),XY(:,1),ones(size(XY,1),1));
        indG = sub2ind([s(1),s(2),3],XY(:,2),XY(:,1),2*ones(size(XY,1),1));
        intR = smooth(im(indR),2*FiberThickness);
        intG = smooth(im(indG),2*FiberThickness);
        if 0
        figure; plot(intR,'red','LineWidth',2),hold on, plot(intG,'green','LineWidth',2)
        set(gca,'FontSize',15)
        end
    else
        indR = sub2ind([s(1),s(2),3],XY(:,2),XY(:,1),ones(size(XY,1),1));
        indG = sub2ind([s(1),s(2),3],XY(:,2),XY(:,1),2*ones(size(XY,1),1));
        intR = im(indR);
        intG = im(indG);

    end

    deltaRG = intR-intG-eps;% there is '-eps' to detect constant zeros parts
      
    %% find zero crossing  
    deltaRGdec = [deltaRG(2:end);0];%figure; plot(deltaRG)
    deltaSquared = [deltaRG].*[deltaRGdec];%figure; plot(deltaSquared)
    indZeroCross  = find(deltaSquared<0);
    indZeroCross(indZeroCross==1|indZeroCross==length(intG))=[];
    indZeroCross = [1;indZeroCross;length(intG)];
    
    %% analysis of each sub segment to assign the color
    nbSegment = length(indZeroCross)-1;
    color = zeros(length(intR),1);
    for itSegment = 1:nbSegment
        ind     = indZeroCross(itSegment):indZeroCross(itSegment+1);
        meanG   = mean(intG(ind));
        meanR   = mean(intR(ind));
        isRed   = meanR>meanG & meanR-meanG > 0.07;
        isGreen = meanG>meanR & meanG-meanR > 0.07;
        isBlue  = ~(isRed||isGreen);
        
        if isGreen 
            color(ind) = 1;
        elseif isRed
            color(ind) = 2;
        end
    end
    
    %% fonction qui transforme le bleu en rouge ou vert
        color = deleteBlueColor(color); 
        dist = param.minPulseLength;
        color = deleteSmallGreenSpot (color,dist);
        color = deleteSmallRedSpot (color,dist);
        if isempty(setdiff(unique(color),0))
            ind2Del = [ind2Del,i];
            continue;
        end
        listSkelf{i}.color  = color;

end
    listSkelf(ind2Del) = [];
    

end


