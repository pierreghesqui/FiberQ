function T = initialTensor(regionProp,s)
    nbStrand  = numel(regionProp);
    T = zeros(s(1),s(2),2,2);
    R = [0,-1;1,0];
    
    for itStrand = 1:nbStrand
        %left
        vl=regionProp(itStrand).vl;
        xyToken = round(regionProp(itStrand).tokenCoord(:,1));
        %nl = vl;
        nl=R*vl;
        M = nl*nl';
        T(xyToken(2),xyToken(1),:,:)=M;
        %right
        vr=regionProp(itStrand).vr;
        xyToken = round(regionProp(itStrand).tokenCoord(:,2));
        %nr = vr;
        nr=R*vr;
        M = nr*nr';
        T(xyToken(2),xyToken(1),:,:)=M;
    end
    
end