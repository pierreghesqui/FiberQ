function connect2Segm(Segm1,Segm2)
[~,XYEP1]= Segm1.endPoint;
[~,XYEP2]= Segm2.endPoint;
s=Segm1.sizeIm;
d = pdist2([XYEP1],[XYEP2]);
[mindistEP,ind] = min(d(:));
[indEPS1,indEPS2] = ind2sub([2,2],ind(1));
[ rIndex,cIndex,Index ,maxNbP] = plotLine2( XYEP1(indEPS1,:)',XYEP2(indEPS2,:)'...
    ,s,0 );
%figure; displaySegm({Segm1,Segm2}),hold on, plot(cIndex,rIndex,'xr');

XY2 = skeletonizeLine([Segm1.XY;[cIndex',rIndex'];Segm2.XY]);
Segm3 = dnaSegm(s,'XY',XY2);
NodesS1 = Segm1.LinkedNodes;
NodesS2 = Segm2.LinkedNodes;

if indEPS1 ==1
    Segm3.setLinkedNodes({NodesS2{Contrary1vs2( indEPS2)};...
        NodesS1{Contrary1vs2( indEPS1)}});
elseif indEPS1==2
Segm3.setLinkedNodes({NodesS1{Contrary1vs2( indEPS1)};NodesS2{Contrary1vs2( indEPS2)}});
else
    error('more than 2 nodes')
end
Segm3.world = Segm2.world;
% -- update Node
Node2update= NodesS1{indEPS1};
Node2update.disconnectNode({Segm1,Segm2});


Segm1.replaceSegm(Segm3);

deleteSegm(Segm2);
end