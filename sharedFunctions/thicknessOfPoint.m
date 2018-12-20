function thick = thicknessOfPoint(largeSegment,x,y,nVec)

    s = size(largeSegment);
    %% up
    isinImage= true;
    x1=x;
    y1=y;
    thickU=0;
    while(isinImage)
        x1 = x1+nVec(1);
        y1 = y1+nVec(2);
        if x1<1||x1>s(2)||y1<1||y1>s(1)
            thick =[];
            return
        end
        int = findPixelValue(largeSegment,x1,y1);
        %int = largeSegment(y1,x1);
        if int ==1
           thickU=thickU+1;
        else
            thickU=thickU+1;
            isinImage=false;
        end
    end
    %% down
    isinImage= true;
    x1=x;
    y1=y;
    thickD=0;
    while(isinImage)
        
        x1 = x1-nVec(1);
        y1 = y1-nVec(2);
        if x1<1||x1>s(2)||y1<1||y1>s(1)
            thick =[];
            return
        end
         int = findPixelValue(largeSegment,x1,y1);
        if int ==1
           thickD=thickD+1;
        else
            thickD=thickD+1;
            isinImage=false;
        end
    end
    thick= thickU+thickD;

end