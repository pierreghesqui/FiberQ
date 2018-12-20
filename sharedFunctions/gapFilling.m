function gapFilling(regionProp,mapToken,map)
    nbStrand = numel(regionProp);
    s = size(mapToken);
    coordToken = find(mapToken);
    for itStrand = 1:nbStrand
        
        %left stick
        P0 = regionProp(itStrand).tokenCoord(:,1);
        P1 = regionProp(itStrand).tokenCoord(:,1);
        v = regionProp(itStrand).vl;
        indToken = sub2ind(s,P1(2),P1(1));
        cpt = 0;
        deltal = inf;
        storeInd = [];
        figure;
        while ~ismember(sub2ind(s,P1(2),P1(1)),setdiff(coordToken,indToken)) && cpt<50 ...
                && deltal>0.2
            indToken = sub2ind(s,P1(2),P1(1));
            pStep = possibleStep(P1,v,s);
            pxy   = P1+pStep;
            [m,ind] = max(map(sub2ind(s,pxy(2,:),pxy(1,:))));
            P2 = pxy(:,ind);
            v = P2-P1;
            P1 = P2;
            cpt = cpt+1;
            deltal=map(P1(2),P1(1));
            storeInd = [storeInd,[P1(1);P1(2)]];
            imshow(map,[]);hold on, plot(P0(1),P0(2),'xg'),plot(P1(1),P1(2),'xr'), plot(storeInd(1,:),storeInd(2,:),'ob')
            quiver(P1(1),P1(2),10*v(1),10*v(2))
            pause(1)
        end
        
        %right stick
        
        P0 = regionProp(itStrand).tokenCoord(:,2);
        P1 = regionProp(itStrand).tokenCoord(:,2);
        v = regionProp(itStrand).vr;
        cpt = 0;
        deltal = inf;
        %figure;
        while (~ismember(sub2ind(s,P1(2),P1(1)),coordToken)||cpt==0) && cpt<50 ...
                && deltal>0.2
            pStep = possibleStep(P1,v,s);
            pxy   = P1+pStep;
            [m,ind] = max(map(sub2ind(s,pxy(2,:),pxy(1,:))));
            P2 = pxy(:,ind);
            v = P2-P1;
            P1 = P2;
            cpt = cpt+1;
            deltal=map(P1(2),P1(1));
            %imshow(map,[]);hold on, plot(P0(1),P0(2),'xg'), plot(P1(1),P1(2),'xr')
            %pause(1)
        end
        
    end
end