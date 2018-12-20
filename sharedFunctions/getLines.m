function [rIndexL,cIndexL,rIndexR,cIndexR,indexL,indexR, imlabels,labels,regPropSquel]=getLines(squel,maxDistance,varargin)
%GETLINES returns the Indexes of the thicklines for each DNA segment in the
%   BINARYIMAGE. 
%   Each segment has 2 thicklines (at its left extremity and at its right
%   extremities). The direction of the thicklines is given by the derivative
%   of the polynome (deg = 2) that approximate the segment in its principal
%   component space.
%   BINARYIMAGE is the binary image given by the function GETSEGMENTS
%   MAXDISTANCE is the maximum distance of the lines 
%
%   RINDEXL : indexes of the rows of the left thicklines for each DNA
%   segment
%   CINDEXL : indexes of the colums of the left thicklines for each DNA
%   segment
%   rINDEXR :  indexes of the rows of the right thicklines...
%   cINDEXL :  indexes of the columns of the left thicklines...
%   indexL  :  global indexes of the left thicklines.
%   indexR  :   global indexes of the right thicklines.
%   imlabels :  labels of the DNA segments.
%   labels : list of the labels
%   regPropSquel : properties of each segment (given by regprops function:

%% DEFAULT OPTS
opts.deg = 2;
opts = parsePV_Pairs(opts,varargin);
rightLine=1;
%% analyse de la segmentation

%brP = imdilate(bwmorph(squel,'branchpoints'),strel('disk',1));%figure; imshow(brP,[])
%squel = squel & ~brP;

% regPropSquel=regionprops(squel,'MajorAxisLength','MinorAxisLength','Centroid','Orientation','Area','PixelList','PixelIdxList');
% ind2Del = [regPropSquel.MajorAxisLength]<prctile([regPropSquel.MajorAxisLength],10)|...
%     [regPropSquel.MajorAxisLength]<2*[regPropSquel.MinorAxisLength]|...
%     [regPropSquel.Area]<5;
% lab2Del = find(ind2Del);
% imlabels = bwlabel(squel); %figure; imshow(imlabels==1267,[])
% imlabels(ismember(imlabels,lab2Del)) = 0;
%squel = imdilate(squel,strel('disk',2));
imlabels = bwlabel(logical(squel));
regPropSquel=regionprops(imlabels,'MajorAxisLength','MinorAxisLength','Centroid','Orientation','Area','PixelList','PixelIdxList');
%figure; imshow(imlabels,[])
labels = unique(setdiff(imlabels,0));
%figure; imshowpair(squel,imlabels)
nbShape = numel(regPropSquel);
area = [regPropSquel.Area];
Marea = max(area);

%% Matrice de changement de repère
theta = deg2rad([regPropSquel.Orientation]);%+pi/2;

%% changement de repère

%---Build Coordinate Matrix xy
xy_cell = {regPropSquel.PixelList};
xy = zeros(2,Marea,nbShape);
for i = 1:nbShape
    xy_i = xy_cell{i}';
    xy(:,:,i)=padarray(xy_i,[0,Marea-area(i)],'post','replicate');
end
%---------Coord system chgt -------------
xyC = round(reshape([regPropSquel.Centroid],[2,1,nbShape]));
%figure; imshow(squel,[]), hold on, plot(xyC(1),xyC(2),'xr','LineWidth',2)
xycent = xy-xyC;
%

coordUV = chgtRep(xycent,theta);

%-------find left and right end points indices
[~,indMinU] = min(permute(coordUV,[2,1,3])); indMinU = indMinU(:,1,:);
[~,indMaxU] = max(permute(coordUV,[2,1,3])); indMaxU = indMaxU(:,1,:);

%---- calculate polynome coefficient for each Shape
deg = opts.deg;
coefficients = nan(1,deg+1,nbShape);

for i =1:nbShape
    x = coordUV(1,:,i); y = coordUV(2,:,i);
    [Cx,ia,~] =unique(x,'stable');
    Cy = y(ia);  
   if length(Cx)<150
       coefficients_i = polyfit(Cx,Cy,1);
       coefficients(:,:,i) = [zeros(1,deg-length(coefficients_i)+1),coefficients_i];
   else
coefficients_i = polyfit(Cx,Cy,deg);
coefficients(:,:,i) = coefficients_i;
   end
end

%-------find left and right end points coordinates
uvL = [coordUV(sub2ind(size(coordUV),ones(nbShape,1),reshape(indMinU,[nbShape,1]),[1:nbShape]')),coordUV(sub2ind(size(coordUV),2*ones(nbShape,1),reshape(indMinU,[nbShape,1]),[1:nbShape]'))]';
uvR = [coordUV(sub2ind(size(coordUV),ones(nbShape,1),reshape(indMaxU,[nbShape,1]),[1:nbShape]')),coordUV(sub2ind(size(coordUV),2*ones(nbShape,1),reshape(indMaxU,[nbShape,1]),[1:nbShape]'))]';
uvL = reshape(uvL,[2,1,nbShape]);
uvR = reshape(uvR,[2,1,nbShape]);
xyL = chgtRep(uvL,-theta)+xyC;
xyR = chgtRep(uvR,-theta)+xyC;
 
%% visualisation the  polynome

%% extension

if rightLine ==0
    
elseif rightLine==1
op1 = repmat([deg:-1:0],[1,1,nbShape]);
opL = matXexposantn(uvL,deg);
opR = matXexposantn(uvR,deg);

thetaL = atan(mtimesx(op1.*coefficients,opL))+pi;
%thetaLtest = cat(2,thetaL-deg2rad(5),thetaL,thetaL+deg2rad(5));
thetaR = atan(mtimesx(op1.*coefficients,opR));
%thetaRtest = cat(2,thetaR-deg2rad(5),thetaR, thetaR+deg2rad(5));
% thetaL = atan(2*coefficients(1,1,:).*uvL(1,:,:)+coefficients(1,2,:))+pi;%angle tangent a gauche
% thetaR = atan(2*coefficients(1,1,:).*uvR(1,:,:)+coefficients(1,2,:));%angle tangent a droite
deltau = maxDistance*cos(thetaL);
deltav = maxDistance*sin(thetaL);
uvA    = [uvL(1,:,:)+deltau; uvL(2,:,:)+deltav];
xyA    = chgtRep(uvA,-theta)+xyC;

deltau = maxDistance*cos(thetaR);
deltav = maxDistance*sin(thetaR);
uvB    = [uvR(1,:,:)+deltau; uvR(2,:,:)+deltav];
xyB    = chgtRep(uvB,-theta)+xyC; 

[rIndexL,cIndexL,indexL,maxNbP] = plotLine2(round(xyA),round(xyL),size(squel),10);
[rIndexR,cIndexR,indexR,maxNbP] = plotLine2(round(xyB),round(xyR),size(squel),10);
% ind = 49;
% layerLine = zeros(size(squel)); layerLine(setdiff(indexL(ind,:),-1)) = 100;layerLine(setdiff(indexR(ind,:),-1)) = 100;
% figure; imshowpair(squel,layerLine);
end
 
end
function op = matXexposantn(uv,deg)
nbShape = size(uv,3);
op = zeros(1,1,nbShape);
for n = 0:deg-1
    op = cat(1,uv(1,:,:).^n,op);
end
end
function opts = parsePV_Pairs(opts,UserInputs)
ind = find(strcmpi(UserInputs,'deg'));
if ~isempty(ind)
    opts.deg = UserInputs{ind + 1};
end

end



