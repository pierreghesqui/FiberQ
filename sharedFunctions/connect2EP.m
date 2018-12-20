function connect2EP(EP_i,connection,param)
    %the first input will stay, the second one will be deleted
    
    %% modify coordinate
    Segm1 = EP_i.Object;
    indSegm1 = cellfun(@(x) eq(x,EP_i),connection.EP);
    indCandEP = ~indSegm1;
    candidateEP = connection.EP{indCandEP};
    if isa(candidateEP.Object,'dnaBlob')
        indEP1 = connection.indEPSegm;
        indEP2 = 1;
        XYtan2 = candidateEP.XY;
        indTan2 = candidateEP.PixelIdxList;
    elseif isa(candidateEP.Object,'dnaSegm')
        if isequal(indSegm1,[1,0])
            indEP1 = connection.indEP1;
            indEP2 = connection.indEP2;
        else
            indEP1 = connection.indEP2;
            indEP2 = connection.indEP1;
        end
        XYtan2 = candidateEP.XYtan(indEP2,:);
        indTan2 = candidateEP.indTan(indEP2,:);
    end
    
    Segm1.crop(EP_i.indTan(indEP1));
    
    [ yIndex,xIndex,~ ,~] =plotLine2(EP_i.XYtan(indEP1,:)',...
        XYtan2',Segm1.sizeIm,0);
    %im = false(Segm1.sizeIm);im(EP_i.Object.PixelIdxList)=1;im(candidateEP.Object.PixelIdxList)=2;
    %imshow(im),hold on;
    %plot(EP_i.XY(1),EP_i.XY(2),'xr',candidateEP.XY(1),candidateEP.XY(2),'xr',xIndex,yIndex,'og'),
    %
    XY1 = Segm1.XY;
    if isa(candidateEP.Object,'dnaBlob')
        XY2 = candidateEP.XY;
    elseif isa(candidateEP.Object,'dnaSegm')
        candidateEP.Object.crop(candidateEP.indTan(indEP2))
        XY2 = candidateEP.Object.XY;
    end
    minxy = min([[XY1(:,1);XY2(:,1)],[XY1(:,2);XY2(:,2)]]);
    maxxy = max([[XY1(:,1);XY2(:,1)],[XY1(:,2);XY2(:,2)]]);
    XY1 = XY1-minxy+1;
    XY2 = XY2-minxy+1;
    
    im = false(fliplr(maxxy-minxy+1));
    im(sub2ind(size(im),[XY2(:,2);XY1(:,2)],[XY2(:,1);XY1(:,1)]))=true;%figure; imshow(im,[])
    im(sub2ind(size(im),yIndex-minxy(2)+1,xIndex-minxy(1)+1))=true;
    
    skel = bwskel(im,'MinBranchLength',param.thicknessFib);%figure; imshow(skel)
    BP = bwmorph(skel,'branchpoint');
    if any(any(BP))
        skel = deleteBPMulti(skel,param.thicknessFib);%figure; imshow(skel2)
    end
    [Y,X] = find(skel);%figure; imshow(skel)
    X = shiftdim(X); %if it is a row vector, convert it into a column vector
    Y = shiftdim(Y);
    [XY,ind] = Pixel2XY_Ind([X+minxy(1)-1,Y+minxy(2)-1],sub2ind(Segm1.sizeIm,Y+minxy(2)-1,X+minxy(1)-1));
    
    if isa(candidateEP.Object,'dnaBlob')
       newEP = copy(candidateEP);
    elseif isa(candidateEP.Object,'dnaSegm')
        newEP = copy(candidateEP.Object.EP{cellfun(@(x) ~eq(x,candidateEP),candidateEP.Object.EP)});
    end
    
    newEP.LinkedEP(EP_i.ismember(newEP.LinkedEP))=[];
    for p =1:numel(newEP.LinkedEP)
        newEP.LinkedEP{p}.addLinkedEP({newEP});
    end
    deleteEP(EP_i);
    Segm1.EP{cellfun(@isempty,Segm1.EP)} = newEP;
    newEP.Object = Segm1;
    if candidateEP.Object.isInForbidZone
        Segm1.isInForbidZone=true;
    end
    if isa(candidateEP.Object,'dnaBlob')
        deleteBlob(candidateEP.Object);
    elseif isa(candidateEP.Object,'dnaSegm')
        deleteSegm(candidateEP.Object);
    end
    if isequal(XY(1,:),Segm1.EP{2}.XY)||isequal(XY(end,:),Segm1.EP{1}.XY)
        XY = flipud(XY);
        ind = flipud(ind);
    end
    Segm1.XY = XY;
    Segm1.PixelIdxList = ind;
    Segm1.setTanEP;
    
end