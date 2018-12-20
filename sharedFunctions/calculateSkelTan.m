function tan = calculateSkelTan(s2,OldSkelUntilBPIdx)
[yOld,xOld]=ind2sub(s2,OldSkelUntilBPIdx);
yOldS = smooth(yOld,'lowess',0.5);
xOldS = smooth(xOld,'lowess',0.5);
%figure; imshow(zeros(s2)); hold on, plot(xOldS,yOldS)
tan = [xOldS(end)-xOldS(end-1);yOldS(end)-yOldS(end-1)];
end