function [XY,Ind] = PixelList2XY(PixelList,indi)
    c = PixelList(:,1);
    l = PixelList(:,2);
    ci = c(indi);
    li = l(indi);
    
    XY = [ci,li];
    c(indi)=-2;
    l(indi)=-2;
        nbInd = length(c);

    Ind = zeros(nbInd,1);
    Ind(1) = indi;
    for i =2: nbInd
        cNeigh = ismember(c,[ci-1,ci,ci+1]);
        lNeigh = ismember(l,[li-1,li,li+1]);
        indi = cNeigh&lNeigh;
        ci = c(indi);
        li = l(indi);
        XY = [XY;ci,li];
        c(indi)=-2;
        l(indi)=-2;
        Ind(i) = find(indi);
        %~isequal(size(Ind(i)),size(find(indi)))
    end
    
end