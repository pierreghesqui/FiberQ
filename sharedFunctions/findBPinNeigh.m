function indBP2  = findBPinNeigh(fiber,indBP_i)
s = size(fiber);
[l,c]=ind2sub(s,indBP_i);
[BPl,BPc] = find(bwmorph(fiber,'branchPoints'));
d = (BPl-l).^2+(BPc-c).^2;
ind = find(d<=2);
indBP2 = sub2ind(s,BPl(ind),BPc(ind));

end