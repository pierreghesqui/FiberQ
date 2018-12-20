function Results_AllFibers = reorderTable(Results_AllFibers)
for i =1:size(Results_AllFibers,1)
    if isequal(Results_AllFibers.Color_Of_Each_Part(i,1:2),[2,1])
        Results_AllFibers.Color_Of_Each_Part(i,1:2)=fliplr(Results_AllFibers.Color_Of_Each_Part(i,1:2));
        Results_AllFibers.Length_Of_Each_Part(i,1:2)=fliplr(Results_AllFibers.Length_Of_Each_Part(i,1:2));
    end
end
end