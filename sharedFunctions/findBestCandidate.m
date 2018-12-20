function indGoodCandidate = findBestCandidate(shapeCandidate,X_EP2,Y_EP2,tanEP,im_largeReduced)
    nbShape = numel(shapeCandidate);
    %figure; imshow(im_largeReduced,[]),hold on
    
    %tanEP = tanFiber_i.tan2;
    %quiver(X_EP2,Y_EP2,10*tanEP(1),10*tanEP(2))
    
    threshP=0.85;
    isGoodCandidate = false(1,nbShape);
    for i =1:nbShape
        
        if shapeCandidate(i).connectionStrategy == 1 %for small shape
            
            tanConnection1 = [shapeCandidate(i).Centroid(1)-X_EP2,...
                shapeCandidate(i).Centroid(2)-Y_EP2];
            tanConnection1 = tanConnection1/norm(tanConnection1);
            tanConnection2 = [shapeCandidate(i).linkXYReduced(1)-X_EP2,...
                shapeCandidate(i).linkXYReduced(2)-Y_EP2];
            tanConnection2 = tanConnection2/norm(tanConnection2);
            
            proj1 = max(tanEP*tanConnection1',tanEP*tanConnection2');
            proj3 = tanConnection1*tanConnection2';
            isGoodCandidate(i) = proj1>threshP & proj3>0.7;
            %quiver(X_EP2,Y_EP2,10*tanConnection1(1),10*tanConnection1(2))
            %quiver(X_EP2,Y_EP2,10*tanConnection2(1),10*tanConnection2(2))
        elseif shapeCandidate(i).connectionStrategy == 2
            tanNeighbourFiber = shapeCandidate(i).tan;%norm(tanNeighbourFiber)
            tanConnection1 = [shapeCandidate(i).Centroid(1)-X_EP2,...
                shapeCandidate(i).Centroid(2)-Y_EP2];
            tanConnection1 = tanConnection1/norm(tanConnection1);
            tanConnection2 = [shapeCandidate(i).linkXYReduced(1)-X_EP2,...
                shapeCandidate(i).linkXYReduced(2)-Y_EP2];
            tanConnection2 = tanConnection2/norm(tanConnection2);
            proj1 = tanEP*tanNeighbourFiber';
            proj2 = max(tanEP*tanConnection1',tanEP*tanConnection2');
            proj3 = tanConnection1*tanConnection2';
            isGoodCandidate(i) = abs(proj1)>threshP & proj2>threshP & proj3>0.7;
            %quiver(X_EP2,Y_EP2,10*tanConnection1(1),10*tanConnection1(2))
            %quiver(X_EP2,Y_EP2,10*tanConnection2(1),10*tanConnection2(2))
        end
    end
   if any (isGoodCandidate)
       minDist = [shapeCandidate.mindistance];
       [m,indminminDist] = min(minDist(isGoodCandidate));
       ind =1:nbShape; ind = ind(isGoodCandidate);
       indGoodCandidate = ind(indminminDist(1));
       
   else
       indGoodCandidate=[];
   end
end