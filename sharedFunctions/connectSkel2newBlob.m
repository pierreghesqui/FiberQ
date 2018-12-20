function skelLabelReduced2 = connectSkel2newBlob(s2,oldSkelIdx,IndexConLine,newShapeIdx,labelEP)

skelLabelReduced = zeros(s2);
skelLabelReduced(oldSkelIdx)=labelEP;
skelLabelReduced(IndexConLine) = labelEP;
skelLabelReduced(newShapeIdx)=labelEP;
skelLabelReduced = double(bwmorph(skelLabelReduced,'thin',Inf))*labelEP;%figure; imshow(skelLabelReduced,[])
BP = bwmorph(skelLabelReduced,'BranchPoints');%figure; imshow(BP,[])
indBP = find(BP);
%% find BP connected to oldSkel
oldSkel2 = [oldSkelIdx;IndexConLine];
[xSkel,ySkel,skelInd]= skel2ind(skelLabelReduced,oldSkelIdx(1));
dist = distInd(s2,indBP,skelInd(end));
indBPConnected2Old = indBP(dist<2);

%%
[listSubSkel,skelLabelReduced2] = findListOfSubSkel(skelLabelReduced,indBPConnected2Old);
for i =1:numel(listSubSkel)
    isOldSkel(i) = any(ismember(listSubSkel(i).PixelIdxList,oldSkel2));
end
OldSkelUntilBPIdx = listSubSkel(isOldSkel).PixelIdxList;
tan = calculateSkelTan(s2,OldSkelUntilBPIdx);
isNewSkel = find(~isOldSkel);
allOthertan =[];
skelLabelReduced2(vertcat(listSubSkel(isOldSkel).PixelIdxList))=0;%figure; imshow(skelLabelReduced2);
RPOrientation =regionprops(skelLabelReduced2,'Orientation');
for i =isNewSkel
   OldSkelUntilBPIdx = listSubSkel(i).PixelIdxList; 
   [y,x] = ind2sub(s2,OldSkelUntilBPIdx);%figure; imshow(zeros(s2)),hold on,plot(x,y,'xr')
   angle = computeOrientation(x,y);
   tanNew = calculateSkelTan(s2,OldSkelUntilBPIdx);
   allOthertan=[allOthertan,tanNew]
end

end