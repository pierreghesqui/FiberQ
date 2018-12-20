function dist = distInd(s2,ind1,ind2)
[y1,x1]= ind2sub(s2,ind1)
[y2,x2] = ind2sub(s2,ind2);
dist = pdist2([x1,y1],[x2,y2]);
end
