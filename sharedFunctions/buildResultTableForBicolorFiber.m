function [Results_BicolorFibers]=buildResultTableForBicolorFiber(...
            Results_AllFibers,FAST_options)
        
nbFiber = size(Results_AllFibers,1);
toKeep = [Results_AllFibers.nb_Of_Parts]==2;

Results_BicolorFibers = Results_AllFibers(toKeep,:);
Results_BicolorFibers.Markers(:,3:end) =[];
Results_BicolorFibers.Length_Of_Each_Part(:,3:end) =[];
for i =1:size(Results_BicolorFibers,1)
    colors = Results_BicolorFibers.Markers(i,:);
    if ~isequal(colors,{FAST_options.FirstMarker,FAST_options.SecondMarker})
        Results_BicolorFibers.Markers(i,:) = fliplr(colors);
        Results_BicolorFibers.Length_Of_Each_Part(i,:)=...
            fliplr(Results_BicolorFibers.Length_Of_Each_Part(i,:));
    end
            
end
Results_BicolorFibers.ratios= Results_BicolorFibers.Length_Of_Each_Part(:,2)./...
                                Results_BicolorFibers.Length_Of_Each_Part(:,1);

end