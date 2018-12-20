function regPropSquel =calcLRvect(regPropSquel)
nbStrands = numel(regPropSquel);

for i = 1:nbStrands
    x = regPropSquel(i).SmoothPixelList(:,1);
    y = regPropSquel(i).SmoothPixelList(:,2);
    gx = gradient(x);gy = gradient(y);
    tmoy = max(round(length(gx)*0.1),1);
    vl = -[mean(gx(1:tmoy)),mean(gy(1:tmoy))]; vr = [mean(gx(end-tmoy+1:end)),mean(gy(end-tmoy+1:end))];
    regPropSquel(i).vl = vl'/norm(vl);
    regPropSquel(i).vr = vr'/norm(vr);
end

end