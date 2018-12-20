function segmentVectorsSpliced2 = spliceSegments_EndPointsMethod(segmentVectors,...
    skelLabel,largeLabel,intIm,...
    FiberThickness,THRESHDIST,isThreshLower)

if nargin <7
isThreshLower=0;
end

segmentVectors2 = segmentVectors;
endPointsInd = []; %[ind1,ind2,ind3,...];
endPointsLabel = []; %[lab1,lab2,labi...];
%figure; imshow(skelLabel>0,[])
nbStrands = numel(segmentVectors2);
s = size(skelLabel);

%% Step : EndPointsLinkedByDistance
linkMatrix = zeros(nbStrands);

%------build endPoints coord Matrix and enPointsLabel Matrix-------------
for i = 1 : nbStrands
    endPointsInd = [endPointsInd,segmentVectors2(i).PixelIdxList(1),segmentVectors2(i).PixelIdxList(end)];
    endPointsLabel = [endPointsLabel,i,i];
end
[xendP,yendP] =ind2sub(s, endPointsInd);

distMatrix = pdist2([xendP',yendP'],[xendP',yendP']);%figure; imshow(distMatrix,[])
linkMatrix = distMatrix<THRESHDIST; %figure; imshow(linkMatrix,[])

%---Disconnect endP from the same fiber -----------------------------------
linkMatrix=DisconnectEPFromSameFiber(linkMatrix);

%% Step : EndPoints linked by angle
%--- polynomeFitting--------------
%figure; imshowpair(testSV(segmentVectors2,s,2)>0,testSV(segmentVectorsSpliced,s,2)>0)
%figure; imshow(testSV(segmentVectors2,s,2)>0)
derivMatrix = zeros(2*nbStrands,2);
for i =1:nbStrands
    X = segmentVectors2(i).PixelList(:,1);
    Y = segmentVectors2(i).PixelList(:,2);
    xSmoothed = smooth(X,0.5,'lowess');
    xendP(2*i-1) = xSmoothed(1);xendP(2*i) = xSmoothed(end);
    ySmoothed = smooth(Y,0.5,'lowess');
    yendP(2*i-1) = ySmoothed(1);yendP(2*i) = ySmoothed(end);
    segmentVectors2(i).xySmoothed = [xSmoothed,ySmoothed];
    gx1 = xSmoothed(1)-xSmoothed(2);
    gy1 = ySmoothed(1)-ySmoothed(2);
    gx2 = xSmoothed(end)-xSmoothed(end-1);
    gy2 = ySmoothed(end)-ySmoothed(end-1);
    
    theta1 = atan2(-gy1,gx1)*180/pi;
    theta2 = atan2(-gy2,gx2)*180/pi;
    segmentVectors2(i).theta1 = theta1;
    segmentVectors2(i).g1 = [gx1,gy1]/sqrt(gx1.^2+gy1.^2);
    segmentVectors2(i).g2 = [gx2,gy2]/sqrt(gx2.^2+gy2.^2);
    derivMatrix(2*i-1,:) = [gx1,gy1]/sqrt(gx1.^2+gy1.^2);
    derivMatrix(2*i,:) = [gx2,gy2]/sqrt(gx2.^2+gy2.^2);
end

%---connection vector-------------
connexionVectorM = zeros(2*nbStrands,2*nbStrands,2);
for i = 1:2*nbStrands
    candidateEP = i+1:2*nbStrands;
    candidatesEP = candidateEP(linkMatrix(i,i+1:end));
    xi = xendP(i);
    yi = yendP(i);
    for p = 1:length(candidatesEP)
        candidatesEP_p = candidatesEP(p);
        xp = xendP(candidatesEP_p);
        yp = yendP(candidatesEP_p);
        v = [xp-xi,yp-yi]; v = v/norm(v); v = reshape(v,1,1,2);
        connexionVectorM(i,candidatesEP_p,:) =v;
        connexionVectorM(candidatesEP_p,i,:) =-v;
    end
end
%figure; imshow(connexionVectorM(:,:,1)~=0)
%figure; imshow(linkMatrix~=0,[])

%----- vote ---------------------
[l,c]  = find(triu(linkMatrix));
for i =1:length(l)
    EP1 = l(i);
    EP2 = c(i);
    connectVect1_2 = reshape(connexionVectorM(EP1,EP2,:),1,2);
    deriv1 = derivMatrix(EP1,:);
    deriv2 = derivMatrix(EP2,:);
    
    %---- comparaison derive
    cosDeriv = deriv1*deriv2';
    if cosDeriv>-sqrt(2)/2
        linkMatrix(EP1,EP2)=false;
        linkMatrix(EP2,EP1)=false;
        continue;
    end
    
    %---- comparaison connexion vect
    cosEP1_D = deriv1*connectVect1_2';
    cosEP2_D = deriv2*-connectVect1_2';
    %figure; imshow(testSV(segmentVectors,s,2)>0,[]),hold on ,...
    %quiver(776,222,deriv2(1)*10,deriv2(2)*10),
    %quiver(764,234,-connectVect1_2(1)*10,-connectVect1_2(2)*10),
    if cosEP1_D<sqrt(2.2)/2 || cosEP2_D<sqrt(2.2)/2
        linkMatrix(EP1,EP2)=false;
        linkMatrix(EP2,EP1)=false;
        continue;
    end
    
end

%------ if there exist more than 1 connexion for one EndPoint, choose only the closest one
finalLinkedMatrix = zeros(size(linkMatrix));

for i = 1 : 2*nbStrands
    connexionPossible = find(linkMatrix(i,:));
    if ~isempty(connexionPossible)
        [~,ind] = min(distMatrix(i,connexionPossible));
        finalLinkedMatrix(i,connexionPossible(ind(1)))=1;
    end
end
finalLinkedMatrix2 = double((finalLinkedMatrix+finalLinkedMatrix')==2);
% figure; imshow(finalLinkedMatrix2,[])

%------ convert EndPoint Matrix into Segment Matrix
SegmentMatrix = finalLinkedMatrix2+cat(1,finalLinkedMatrix2(2:end,:),zeros(1,2*nbStrands));
SegmentMatrix([2:2:2*nbStrands],:) =[];
SegmentMatrix = SegmentMatrix+cat(2,SegmentMatrix(:,2:end),zeros(nbStrands,1));
SegmentMatrix(:,[2:2:2*nbStrands]) =[]; %figure; imshow(SegmentMatrix,[])

G=graph(double(SegmentMatrix));%figure ; imshow(double(finalLinkedMatrix2))
bins = conncomp(G);
newLabel = skelLabel;%figure; imshow(newLabel,[])
%figure; imshow(testSV(segmentVectors2,s,2)>0,[])
for i =1:nbStrands
    newLabel(segmentVectors2(i).PixelIdxList) = bins(i);
end
%figure ; imshowpair(skelLabel,newLabel2)
%figure; imshow(skelLabel>0)
%figure; imshow(testSV(segmentVectorsSpliced,s)>0,[])

newLabel2 = connectStrand(newLabel);
newLabel2 = deleteBPMulti(bwlabel(newLabel2>0),FiberThickness);%figure; imshow(newLabel2>0,[])
segmentVectorsSpliced = getSegmentsCoordAndInt(newLabel2,intIm);
%figure; imshow(testSV(segmentVectorsSpliced,s,2)>0)
newLabel2 = testSV(segmentVectorsSpliced,s,2);
[splicedIm,segmentVectorsSpliced2] = refineEndStrand(newLabel2,segmentVectorsSpliced,...
    intIm,double(largeLabel>0),FiberThickness,2*FiberThickness);
%figure; imshowpair(largeLabel>0,testSV(segmentVectorsSpliced2,s,2)>0)
%figure; imshowpair(newLabel2>0,testSV(segmentVectorsSpliced,s,2)>0,'montage')
%figure; imshow(testSV(segmentVectorsSpliced2,s,2)>0)
if isThreshLower
splicedIm2 = imdilate(splicedIm,strel('disk',2));%figure; imshow(splicedIm,[])
splicedIm2 = bwmorph(splicedIm2,'thin',Inf);
newLabel3 = deleteBPMulti(bwlabel(splicedIm2),FiberThickness);%figure; imshow(newLabel2>0,[])
segmentVectorsSpliced2 = getSegmentsCoordAndInt(newLabel3,intIm);%figure; imshow(testSV(segmentVectorsSpliced2,s)>0)
end
end