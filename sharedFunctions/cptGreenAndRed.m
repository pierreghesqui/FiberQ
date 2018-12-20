function [infoStrand,globalGreenRatio]  = cptGreenAndRed(label, thisGreen, thisRed)
    listlabel = setdiff(unique(label),0);
    label2 = imdilate(label,strel('disk',5));%figure; imshow(label2,[])
    msk = logical(label2);
    infoStrand = struct;
    greenBigger = thisGreen>thisRed;
    globalGreenRatio = sum(greenBigger(msk))/sum(msk(:));
    for i =1:length(listlabel)
        label_i = listlabel(i);
        imlabel = label2 == label_i;
        int = greenBigger(imlabel);
        infoStrand(i).greenRatio = sum(int)/length(int);
        infoStrand(i).area = length(int);
        infoStrand(i).idx = find(imlabel);
    end
    
end