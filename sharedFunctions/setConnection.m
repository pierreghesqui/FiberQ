function [connection] = setConnection(EP1,EP2)
EP = {EP1,EP2};
%displaySegm({EP1.Object,EP2.Object}),hold on,quiver(EP1.XYtan(:,1),EP1.XYtan(:,2),10*EP1.tanEP(:,1),10*EP1.tanEP(:,2)),quiver(EP2.XYtan(:,1),EP2.XYtan(:,2),10*EP2.tanEP(:,1),10*EP2.tanEP(:,2))
bothObject = cell(2,1);
bothObject{1} = EP1.Object;
bothObject{2} = EP2.Object;
[class,idx] = getClass (bothObject);
bothObject = bothObject(idx);
if strcmp(class{1},'dnaSegm') && strcmp(class(2),'dnaSegm')
    [~,idx] = sort([EP{1}.PixelIdxList,EP{2}.PixelIdxList]);
    EP=EP(idx);
    connection.EP = EP;
    tan1 = connection.EP{1}.tanEP;
    tan2 = connection.EP{2}.tanEP;
    nbtan1 = size(tan1,1);
    nbtan2 = size(tan2,1);
    
    convect12X = EP{2}.XYtan(:,1)-EP{1}.XYtan(:,1)';
    convect12Y = EP{2}.XYtan(:,2)-EP{1}.XYtan(:,2)';
    dist = sqrt(convect12X.^2+convect12Y.^2);
    connvect12 = cat(3,convect12X,convect12Y);
    connvect12 = connvect12./permute(vecnorm(permute(connvect12,[3,1,2])),[2,3,1]);
    %----projection de chaque connvect sur le tan1 correspondant (each
    %column correspond to one tan1)
    proj1 =reshape(mtimesx(permute(connvect12,[1,3,2]),permute(tan1,[2,3,1])),[nbtan2,nbtan1]);
    theta1 = acosd(proj1);
    %----projection de chaque connvect sur le tan2 correspondant (each line
    %correspond to one tan2
    proj2 = reshape(mtimesx(permute(connvect12,[2,3,1]),permute(-tan2,[2,3,1])),[nbtan1,nbtan2])';
    theta2 = acosd(proj2);
    %----projection de chaque tan1 sur chaque tan2
    theta3 = acosd(-tan2*tan1');
    
    %----score------
    thetaMax = max(cat(3,theta1,theta2,theta3),[],3);
    thetaMax(dist>connection.EP{1}.Object.param.maxDist4ConnectionS)=Inf;
    [~,idx2] = min(thetaMax(:));
    [indEP2,indEP1]=ind2sub(size(theta3),idx2);
    connection.angle  = thetaMax(idx2);
    connection.score = theta2score(thetaMax(idx2));
    connection.indEP1 = indEP1;
    connection.indEP2 = indEP2;
    connection.dist = dist(idx2);

elseif strcmp(class{1},'dnaBlob') && strcmp(class(2),'dnaSegm')
    EPblob = EP{idx==1};
    EPsegment = EP{idx==2};
    maxDistanceB = EPsegment.Object.param.maxDist4ConnectionB;
    tanSegm = EPsegment.tanEP;
    nbtan = size(tanSegm,1);
    connvectSegm_BlobX = EPblob.XY(:,1)-EPsegment.XYtan(:,1)';
    connvectSegm_BlobY = EPblob.XY(:,2)-EPsegment.XYtan(:,2)';
    connvectSegm_Blob = cat(3,connvectSegm_BlobX,connvectSegm_BlobY);
    connvectSegm_Blob = connvectSegm_Blob./permute(vecnorm(permute(connvectSegm_Blob,[3,1,2])),[2,3,1]);
    proj =reshape(mtimesx(permute(connvectSegm_Blob,[1,3,2]),permute(tanSegm,[2,3,1])),[1,nbtan]);
    dist = sqrt(connvectSegm_BlobX.^2+connvectSegm_BlobY.^2);
    theta = acosd(proj);
    theta(dist>maxDistanceB)=Inf;
    [~,idx2] = min(theta);
    [~,indEPSegm]=ind2sub(size(theta),idx2);
    
    connection.angle  = theta(idx2);
    connection.score = theta2score(theta(idx2));
    connection.dist = dist(idx2);
    connection.indEPSegm = indEPSegm;
    connection.EP = {EPsegment,EPblob};
elseif strcmp(class{1},'dnaBlob') && strcmp(class(2),'dnaBlob')
    [~,idx] = sort([EP{1}.PixelIdxList,EP{2}.PixelIdxList]);
    EP=EP(idx);
    connection.EP=EP;
    connection.angle = +Inf;
    connection.score = +Inf;
else
    error('');
end
end

