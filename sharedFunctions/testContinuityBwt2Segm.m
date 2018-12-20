function [t,crit] = testContinuityBwt2Segm(Segm1,Segm2)
t = 0;
[~,XYEP1]= Segm1.endPoint;
[~,XYEP2]= Segm2.endPoint;

d = pdist2([XYEP1],[XYEP2]);
[mindistEP,ind] = min(d(:));
[indEPS1,indEPS2] = ind2sub([2,2],ind(1));
EP1 = XYEP1(indEPS1,:);
EP2 = XYEP2(indEPS2,:);
vEP1_EP2 = EP2-EP1;vEP1_EP2=vEP1_EP2/norm(vEP1_EP2);

if d(ind)<4
    tan1 = Segm1.tanEP( indEPS1,:);
    tan2 = Segm2.tanEP(indEPS2,:);%displaySegm({Segm1,Segm2})
    projTan = -tan1*tan2';
    if projTan>0.8
        t = 1;
    end
    crit = projTan;
else
    tan1 = Segm1.tanEP( indEPS1,:);
    tan2 = Segm2.tanEP(indEPS2,:);
    projTan = -tan1*tan2';
    projTan__vEP1_EP2 = min(vEP1_EP2*tan1',vEP1_EP2*(-tan2'));
    if projTan>0.8 & projTan__vEP1_EP2>0.8
        t = 1;
    end
    crit = min(projTan__vEP1_EP2,projTan);
end
% displaySegm({Segm1,Segm2})
end