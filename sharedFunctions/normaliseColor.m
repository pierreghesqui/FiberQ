function [isNormDone,thisRedN,thisGreenN] = normaliseColor(largeSegment,thisRed,thisGreen,THRESH_DO_NORM)
    imBeforeNorm = cat(3,thisRed,thisGreen,zeros(size(thisGreen))); %figure; imshow(imBeforeNorm,[])
    s = size(thisGreen);
    % do we need normalisation ?
        areaTotalMsk = length(find(largeSegment));
        %proportion of red (or green) in the fiber mask
        areaRed = length(find(largeSegment & thisRed>thisGreen)) / areaTotalMsk;
        areaGreen = length(find(largeSegment & thisRed<=thisGreen))/ areaTotalMsk;
        thisRed2 = thisRed; thisRed2(thisRed2==1)=nan;
        thisGreen2=thisGreen;thisGreen2(thisGreen2==1)=nan;
        
        DoNormalisation = areaRed >THRESH_DO_NORM; 
    % if yes do
        if DoNormalisation ||1
            prc_5_Red = prctile(thisRed2(largeSegment),5);
            prc_95_Red = prctile(thisRed2(largeSegment),95);
            prc_5_Green = prctile(thisGreen2(largeSegment),5);
            prc_95_Green = prctile(thisGreen2(largeSegment),95);
            thisRedN=imadjust(thisRed,[prc_5_Red,prc_95_Red],[0,1]);
            thisGreenN=imadjust(thisGreen,[prc_5_Green,prc_95_Green],[0,1]);
%            redN     = prctile(thisRed2(largeSegment),95);
%            greenN   = prctile(thisGreen2(largeSegment),95);
%            thisRedN =thisRed/redN; thisRedN( thisRedN>1)=1;
%            thisGreenN=thisGreen/greenN;thisGreenN( thisGreenN>1)=1;
    % else no 
        else
            thisRedN =thisRed;
            thisGreenN=thisGreen/prctile(thisGreen2(largeSegment),95);thisGreenN( thisGreenN>1)=1;
        end
  imAfterNorm = cat(3,thisRedN,thisGreenN,zeros(size(thisGreen)));%figure; imshow(imAfterNorm,[])
  isNormDone=DoNormalisation==1;
  %figure; imshowpair(imBeforeNorm,imAfterNorm,'montage')
  %figure; imshow(imAfterNorm)
end