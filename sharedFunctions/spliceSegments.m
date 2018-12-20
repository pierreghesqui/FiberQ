function [newLabel]=spliceSegments(bwSkel,maxDistance,minOverlap,threshConnectComponent,degPoly)
%SPLICESEGMENTS connects the segments which are located on a same 'thickline' and close to each other
%   Each DNA segment is rotated in its principal component space. Then, a polynome of degree = 2 approximate the segment.
%   Two 'Thicklines' (Thickness = 10 pixels) goes from the two extremities
%   of the segment in a direction given by the derivative of the polynome
%   at its extremities. (The line Indexes are given by the function
%   GETLINES
%
%   BWSEGMENTS is the binary image of DNA given by the function GETSEGMENTS
%   MAXDISTANCE is the maximum distance that can separate two close DNA
%   segment
%   MINOVERLAP is the minimum overlap between the 'thickline' and the DNA
%   segment so that the segment belongs to the same DNA strand
%   THRESHCONNECTCOMPONENT is the minimum 'weight of the connection' to
%   consider that two segments are linked
%   NEWLABEL is the labellised image : each segment with the same label
%   belongs to the same DNA strand.
%   To sum up there are three conditions to connect to DNA segment :
%   1) those 2 DNA belong to the same 'thickline' (overlap >minOverlap)
%   2) they are not too far (distance < maxDistance)
%   3) the 'weight of the connection' (see below) is more than THRESHCONNECTCOMPONENT
%   
%   The 'weight of the connection' between all segment lines is set to 0 at
%   the begining. Each time a thick line bind two DNA segments, the weight of their connection is incremented.
%   Finally, the DNA strands are considered to be the independant connected
%   component in the graph.
%%%%%%%%%%%%%%%


[rowIndexLeft,colIndexLeft,rowIndexRight,colIndexRight,...,
 indexLeft,indexRight, imlabels,labels,regProp] = getLines(bwSkel,maxDistance,'deg',degPoly);

nblabels = length(labels);
ConnectionMat = zeros(nblabels);
[ind0] = find(imlabels==0,1,'first');
indexLeft(indexLeft==-1) = ind0;
indexRight(indexRight==-1) = ind0;
labelsOnLines = imlabels(cat(2,indexLeft,indexRight));
%overlap
area = [regProp.Area];
%figure; imshow(imlabels,[])

for i = 1 :nblabels
    labelsConnected = setdiff(unique(labelsOnLines(i,:)),[labels(i),0]);
    
    % im = zeros(size(imlabels));    im(cat(2,indexLeft(i,:),indexRight(i,:)))=1;figure;subplot(1,2,1),imshow(imlabels,[]),subplot(1,2,2), imshowpair(logical(imlabels),im)
    overlap = sum(labelsOnLines(i,:)'==labelsConnected,1)./area(labelsConnected);
    labels2Link = labelsConnected(overlap>minOverlap);
    
    ConnectionMat(i,labels2Link) = ConnectionMat(i,labels2Link)+1;
    ConnectionMat(labels2Link,i) = ConnectionMat(labels2Link,i)+1;
end

ConnectionMat(ConnectionMat<threshConnectComponent)=0;
G =graph(ConnectionMat);
bins = conncomp(G);
newLabel = imlabels;

for i =1:nblabels
    newLabel(regProp(i).PixelIdxList) = bins(i);
end

%fig = figure,imshow(label2rgb(newLabel,'prism', 'k'))
end

%
