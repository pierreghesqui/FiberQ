function [listSkelfout, Results_AllFibers] = buildResultTable(...
    listSkelf,imName,FAST_options)
    ind2Del = [];
    nbFibers = numel(listSkelf);
    Image_Name = repmat({imName},nbFibers,1);
    nbMaxPart = 6;
    Marker_Of_Each_Part  = nan(nbFibers,nbMaxPart);
    Length_Of_Each_Part = nan(nbFibers,nbMaxPart);
    listSkelfout = listSkelf;
    nb_Of_Parts = nan(nbFibers,1);
    for i =1 : nbFibers
        color = listSkelf{i}.color;
        grad_C = imfilter(color,[-1;1],'symmetric');
        adaptedColor = color;
        adaptedColor(grad_C~=0)=0;
        adaptedColor= bwlabel(adaptedColor);
        ind = adaptedColor==0; ind(1)=false;
        adaptedColor(ind) = adaptedColor([ind(2:end);false]);adaptedColor(1) =1;
        RP_color = regionprops(adaptedColor,color,'Area','MaxIntensity');
        nbParts = numel(RP_color);
        if nbParts>nbMaxPart
            ind2Del = [ind2Del,i];
            continue;
        end
        nb_Of_Parts(i) = nbParts;
        Marker_Of_Each_Part(i,1:nbParts) =[RP_color.MaxIntensity];
        Length_Of_Each_Part(i,1:nbParts) = [RP_color.Area];  
    end
    listSkelfout(ind2Del)       = [];
    Image_Name(ind2Del,:)          = [];
    Marker_Of_Each_Part(ind2Del,:)  = [];
    Length_Of_Each_Part(ind2Del,:) = [];
    nb_Of_Parts(ind2Del)           = [];
    Fiber_Label                    = [1:numel(listSkelfout)]';
    
    Markers = cell(size(Marker_Of_Each_Part));
    Markers(Marker_Of_Each_Part==1)={FAST_options.FirstMarker};
    Markers(Marker_Of_Each_Part==2)={FAST_options.SecondMarker};
    
    MaxDensity = cellfun(@(x) max(x.density),listSkelfout)';
    MaxDensity = round(10000*MaxDensity)/10000;

    MaxSplicingAngle = cellfun(@(x) max(x.anglesSplices),listSkelfout,'UniformOutput',0);
    MaxSplicingAngle(cellfun(@(x)isempty(x),MaxSplicingAngle)) = {0};
    MaxSplicingAngle = cell2mat(MaxSplicingAngle)';
    MaxSplicingAngle = round(1000*MaxSplicingAngle)/1000;
    MaxSplicingAngle = round(1000*MaxSplicingAngle)/1000;
    
    MaxSplicingDistance = cellfun(@(x) max(x.distanceSplices),listSkelfout,'UniformOutput',0);
    MaxSplicingDistance(cellfun(@(x)isempty(x),MaxSplicingDistance)) = {0};
    MaxSplicingDistance = cell2mat(MaxSplicingDistance)';
    MaxSplicingDistance = round(1000*MaxSplicingDistance)/1000;

    Results_AllFibers = table(Image_Name,Fiber_Label,Markers,...
        Length_Of_Each_Part,nb_Of_Parts,MaxDensity,MaxSplicingAngle,MaxSplicingDistance);
    

end