function squelLabel2 = connectStrand(squelLabel)
squelLabel2 = squelLabel;
s = size(squelLabel2);
labels = setdiff(unique(squelLabel2),0);
for i = 1:length(labels)
    imLabel=bwlabel(squelLabel2==labels(i));%figure; imshow(imLabel,[])
    [l,c] = find(imLabel>0);
    L = min(l):max(l);
    C = min(c):max(c);
    imLabel = imLabel(L,C);
    s2 = size(imLabel);
    %-------------------------------------
    labels_i = setdiff(unique(imLabel),0);
    while length(labels_i)>1
            
        d = bwdist(imLabel==1);%figure; imshowpair(d,imLabel==1)
        ind1 = find(imLabel>1);
        [~,idx] = min(d(imLabel>1));
        connP2 = ind1(idx);%figure; imshow(imLabel,[]),hold on,[l,c]=ind2sub(s,connP2);plot(c,l,'xr')
        labelconnP2 = imLabel(connP2);
        d2 = bwdist(imLabel==labelconnP2);
        ind2 = find(imLabel==1);
        [~,idx2] = min(d2(imLabel==1));
        connP1 = ind2(idx2);%figure; imshow(imLabel,[]),hold on,[l,c]=ind2sub(s,connP1);plot(c,l,'xr')
        [ rIndex,cIndex,Index ,maxNbP] = plotLine2( connP1,connP2,s2,0 );
        imLabel(Index) = 1;
        imLabel=bwlabel(imLabel);%figure; imshow(imLabel,[])
        labels_i = setdiff(unique(imLabel),0);
    end
    toAdd = squelLabel2(L,C);toAdd(find(imLabel)) = labels(i);
    squelLabel2(L,C) = toAdd;
end
%figure; subplot(2,1,1),imshow(squelLabel>0,[]),subplot(2,1,2),imshow(squelLabel2>0,[])
end
