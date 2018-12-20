function ind = findBestContinuity(chosenSegm,ListConnSegm2)
for i = 1:numel(ListConnSegm2)
    
    [t(i),p(i)] = testContinuityBwt2Segm(chosenSegm,ListConnSegm2{i});
end
ind = find(t==1&p==max(p),1);
end