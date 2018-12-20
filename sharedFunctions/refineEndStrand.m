function [skelLabel2,RP_Strands]=refineEndStrand(skelLabel,RP_Strands,im,...
    largeSegm,fiberThickness,EndDistAnalysis)
if nargin<6
    EndDistAnalysis=fiberThickness;
end
s = size(skelLabel);%figure; imshowpair(skelLabel,largeSegm)
sim = size(im);
%RP_Strands = getSegmentsCoordAndInt(skelLabel,skelLabel);
threshProj = 0.8;
ind2Del = [];
for i =1 : numel(RP_Strands)
    
    if length(RP_Strands(i).PixelList) >2*EndDistAnalysis
        XY = RP_Strands(i).PixelList;
        Xs = smooth(RP_Strands(i).PixelList(:,1),.50,'lowess');
        Ys = smooth(RP_Strands(i).PixelList(:,2),.50,'lowess');%figure; imshow(skelLabel>0,[]),hold on, plot( XY(end,1),XY(end,2),'xr')
        %% check end
        XYbeg = RP_Strands(i).PixelList(1:end-EndDistAnalysis-1,:);
        XYend = RP_Strands(i).PixelList(end-EndDistAnalysis:end,:);
        nbPixel = length(XYbeg);
       
            Xbeg = smooth(XYbeg(:,1),.50,'lowess');
            Ybeg = smooth(XYbeg(:,2),.50,'lowess');
            
            Xend = smooth(XYend(:,1),length(XYend(:,1)),'lowess');
            Yend = smooth(XYend(:,2),length(XYend(:,2)),'lowess');

        %figure; imshow(skelLabel==RP_Strands(i).MaxIntensity); hold on,plot(Xbeg,Ybeg),plot(Xend,Yend)
        tan = [Xbeg(end)-Xbeg(end-1),Ybeg(end)-Ybeg(end-1)]; tan=tan/norm(tan);
        tanEnd = [mean(gradient(Xend)),mean(gradient(Yend))]; tanEnd=tanEnd/norm(tanEnd);
        
        projection = tan*tanEnd';
        if projection<threshProj
            
            while findPixelValue(largeSegm,XYbeg(end,1)+tan(1),...
                    XYbeg(end,2)+tan(2),'nearest')==1
                XYbeg = [XYbeg;XYbeg(end,1)+tan(1),XYbeg(end,2)+tan(2)];%figure; imshow(skelLabel,[]),hold on, plot( XYbeg(:,1),XYbeg(:,2),'xr')
            end
            
            RP_Strands(i).PixelList=round(XYbeg);
        else
           
            tan = [Xs(end)-Xs(end-1),Ys(end)-Ys(end-1)]; tan=tan/norm(tan);
            while findPixelValue(largeSegm,XY(end,1)+tan(1),...
                    XY(end,2)+tan(2),'nearest')==1%figure; imshowpair(largeSegm,skelLabel>0),hold on,plot(XY(end,1)+tan(1),XY(end,2)+tan(2),'xr')
                XY = [XY;XY(end,1)+tan(1),XY(end,2)+tan(2)];
            end
            RP_Strands(i).PixelList=round(XY);
        end
        
        %% check Beg
         if length(RP_Strands(i).PixelList) <=2*EndDistAnalysis
             ind2Del=[ind2Del,i];
             continue;
         end
        XY = RP_Strands(i).PixelList;
        XYend = RP_Strands(i).PixelList(EndDistAnalysis+1:end,:);
        XYbeg = RP_Strands(i).PixelList(1:EndDistAnalysis,:);
         nbPixel = length(XYend);
        
            Xend = smooth(XYend(:,1),.50,'lowess');
            Yend = smooth(XYend(:,2),.50,'lowess');
            
            Xbeg = smooth(XYbeg(:,1),length(XYbeg(:,1)),'lowess');
            Ybeg = smooth(XYbeg(:,2),length(XYbeg(:,1)),'lowess');
       
        %figure; imshow(skelLabel==RP_Strands(i).MaxIntensity); hold on,plot(Xend,Yend), plot(Xbeg,Ybeg)
        tan = [Xend(1)-Xend(2),Yend(1)-Yend(2)]; tan=tan/norm(tan);
        tanBeg = [mean(gradient(Xbeg)),mean(gradient(Ybeg))]; tanBeg=tanBeg/norm(tanBeg);
        
        projection = tan*tanBeg';
        if projection>-threshProj
            
            while findPixelValue(largeSegm,XYend(1,1)+tan(1),...
                    XYend(1,2)+tan(2),'nearest')==1
                XYend = [XYend(1,1)+tan(1),XYend(1,2)+tan(2);XYend];
            end
            RP_Strands(i).PixelList=round(XYend);
            else
            
            tan = [Xs(1)-Xs(2),Ys(1)-Ys(2)]; tan=tan/norm(tan);
            while findPixelValue(largeSegm,XY(1,1)+tan(1),...
                    XY(1,2)+tan(2),'nearest')==1
                XY = [XY(1,1)+tan(1),XY(1,2)+tan(2);XY];
            end
            RP_Strands(i).PixelList=round(XY);
        end
        %%
        XY = RP_Strands(i).PixelList;
        RP_Strands(i).PixelListSmoothed = [smooth(XY(:,1),0.5,'lowess'),smooth(XY(:,2),0.5,'lowess')];
        RP_Strands(i).PixelIdxList = sub2ind(s,XY(:,2),XY(:,1));
        
        RP_Strands(i).intRed = im(sub2ind(sim,XY(:,2),XY(:,1),1*ones(size(XY,1),1)));
        RP_Strands(i).intGreen = im(sub2ind(sim,XY(:,2),XY(:,1),2*ones(size(XY,1),1)));
        RP_Strands(i).intBlue = im(sub2ind(sim,XY(:,2),XY(:,1),3*ones(size(XY,1),1)));
        
    else
        ind2Del=[ind2Del,i];
    end
end
RP_Strands(ind2Del)=[];
skelLabel2 = testSV(RP_Strands,s,2);
%figure; imshowpair(skelLabel,skelLabel2)
end