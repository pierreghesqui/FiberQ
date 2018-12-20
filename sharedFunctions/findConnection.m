function [Xcon,Ycon] = findConnection(StrandPixelIdxList,XCros,YCros)
    d = [];
    for i =1:length(XCros)
        DeltaX = StrandPixelIdxList(:,1)-XCros(i);
        DeltaY = StrandPixelIdxList(:,2)-YCros(i);
        d = [d,min(DeltaX.^2+DeltaY.^2)];
    end
    [m] = min(d);
    Xcon = XCros(d==m);
    Ycon = YCros(d==m);
end
