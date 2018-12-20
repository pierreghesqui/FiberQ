function skelLabel2 = deleteBPMulti(skelLabel,FiberThickness)
if nargin<2
    FiberThickness=6;
end
skelLabel=bwlabel(skelLabel);
skelLabel2 = deleteBP(skelLabel,FiberThickness);
cpt = 1;
while ~isempty(find(bwmorph(skelLabel2,'branchPoints'),1))&&cpt<30
    skelLabel2 = deleteBP(skelLabel2,FiberThickness);
    cpt = cpt+1;
end
if cpt >=30%figure; imshow(skelLabel2,[])
    error('BranchPoints are already present after 10 deleteBP');
end