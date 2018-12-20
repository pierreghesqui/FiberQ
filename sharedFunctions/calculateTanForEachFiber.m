function tanFiber = calculateTanForEachFiber(infoStrand)
    nbFiber = numel(infoStrand);
    tanFiber = struct('tan1',[],'tan2',[]);
    
    for i=1:nbFiber
        X = infoStrand(i).PixelList(:,1);
        Y = infoStrand(i).PixelList(:,2);
        Xs = smooth(X,0.5,'lowess');
        Ys = smooth(Y,0.5,'lowess');
        tan1 = [Xs(1)-Xs(2),Ys(1)-Ys(2)]; tan1 = tan1/norm(tan1);
        tan2 = [Xs(end)-Xs(end-1),Ys(end)-Ys(end-1)]; tan2 = tan2/norm(tan2);
        tanFiber(i).tan1 = tan1;
        tanFiber(i).tan2 = tan2;
        
    end
end