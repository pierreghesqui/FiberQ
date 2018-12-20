function [XY,indCross] = crossCoordinate(pixelList,s)

nbBP = size(pixelList,1);
XY =[];
indCross = [];
for i = 1:nbBP
%% left
if pixelList(i,1)>1
    XYLM = [pixelList(i,1)-1,pixelList(i,2)];
else
    XYLM = [];
end

if pixelList(i,1)>1&&pixelList(i,2)>1
    XYLU = [pixelList(i,1)-1,pixelList(i,2)-1];
else
    XYLU = [];
end

if pixelList(i,1)>1&&pixelList(i,2)<s(1)
    XYLD = [pixelList(i,1)-1,pixelList(i,2)+1];
else
    XYLD = [];
end

%% right
if pixelList(i,1)<s(2)
    XYRM = [pixelList(i,1)+1,pixelList(i,2)];
else
    XYRM = [];
end

if pixelList(i,1)<s(2) && pixelList(i,2)>1
    XYRU = [pixelList(i,1)+1,pixelList(i,2)-1];
else
    XYRU = [];
end

if pixelList(i,1)<s(2)&&pixelList(i,2)<s(1)
    XYRD = [pixelList(i,1)+1,pixelList(i,2)+1];
else
    XYRD = [];
end
%% med

if pixelList(i,2)>1
    XYMU = [pixelList(i,1),pixelList(i,2)-1];
else
    XYMU = [];
end

if  pixelList(i,2)<s(1)
    XYMD = [pixelList(i,1),pixelList(i,2)+1];
else
    XYMD = [];
end
XY = [XY;XYLM;XYLU;XYLD;XYRM;XYRU;XYRD;XYMU;XYMD];

indCross = [indCross;sub2ind(s,XY(:,2),XY(:,1))];
end


end