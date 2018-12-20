function infoStrand = makeInfoStrand(imOp,squelLabel,largeLabel)

%figure; imshow(squelLabel,[])
%figure; imshow(largeLabel,[])
%figure; imshow(imOp,[])
infoStrand = struct; 
thisRed = imOp(:,:,1);
thisGreen = imOp(:,:,2);
thisBlue = imOp (:,:,3);
if nargin<2
isStrand = logical(sum(imOp,3));
squelLabel = bwlabel(bwmorph(isStrand,'thin',Inf));
largeLabel = bwlabel(logical(sum(imOp,3)));%figure; imshow(largeLabel,[])
end
labels = setdiff(unique(squelLabel),0);
nbLabel = length(labels);
cpt = 1;

for itLabel = labels'
    
    indsquelLabel = find(squelLabel == itLabel); %figure; imshow(squelLabel == itLabel,[])
    correspondingLargeLabel = setdiff(unique(largeLabel(indsquelLabel)),0);
    indLabel = [];
    for k = 1:length(correspondingLargeLabel)
        indLabel = [indLabel; find(largeLabel == correspondingLargeLabel(k))];%figure; imshow(largeLabel == correspondingLargeLabel(k),[])
    end
    %imTest =zeros(size(thisBlue));imTest(indLabel)=1;imTest(99594) = 10;figure;imshow(imTest,[])
    indBlue  = indsquelLabel(thisBlue(indsquelLabel)>255/2) ;%figure; imshow(cat(3,thisRed,thisGreen,thisBlue),[])
    indRed   = indsquelLabel(thisRed(indsquelLabel)>255/2);
    indGreen = indsquelLabel(thisGreen(indsquelLabel)>255/2);
    if (length(indBlue)+length(indRed)+length(indGreen)~=length(indsquelLabel))
        error('length(indBlue)+length(indRed)+length(indGreen)~=length(indLabel)');
    end
    indNoColor = indsquelLabel(thisGreen(indsquelLabel)+thisBlue(indsquelLabel)+thisRed(indsquelLabel)==0);
    RedRatio = length(indRed)/length(indsquelLabel);
    GreenRatio = length(indGreen)/length(indsquelLabel);
    BlueRatio = length(indBlue)/length(indsquelLabel);
    NoColorRatio = length(indNoColor)/length(indsquelLabel);
    siz = length(indsquelLabel);
    if (RedRatio+GreenRatio+BlueRatio+NoColorRatio-1)>1e-10
        error ('in MakeInfoStrand : sum of ratio is not equal to 1')
    end
%     if NoColorRatio>0
%         warning('noColorRatio is greater than 0 in MakeInfoStrand line36')
%     end
    infoStrand(cpt).ind      = indsquelLabel;
    infoStrand(cpt).indLarge = indLabel;
    infoStrand(cpt).xyLarge  = fliplr(ind2sub(size(squelLabel),indLabel));
    infoStrand(cpt).indRed   = indRed;
    infoStrand(cpt).sizRed   = numel(indRed);
    infoStrand(cpt).indGreen = indGreen;
    infoStrand(cpt).sizGreen = numel(indGreen);
    infoStrand(cpt).indBlue  = indBlue;
    infoStrand(cpt).sizBlue  = numel(indBlue);
    infoStrand(cpt).RedRatio = RedRatio;
    infoStrand(cpt).GreenRatio = GreenRatio;
    infoStrand(cpt).BlueRatio = BlueRatio;
    infoStrand(cpt).size=siz;
    cpt = cpt+1;
end

end