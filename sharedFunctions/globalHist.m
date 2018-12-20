function [h,RedL,x] = globalHist(infoStrand)

%%
nbStrand = numel(infoStrand);


RedL = [infoStrand(:).RedLengths];

if any(RedL>0)
x = 0:5:max(RedL);
[h,~] = histcounts(RedL,x);
else
    x = 0;
    h = 0;
end

end