function listSkelf = filterBoudary(listSkelf)
nbSegm = numel(listSkelf);
if nbSegm>0
    s = listSkelf{1}.sizeIm;
    ind2Del=[];
    
    for i =1:nbSegm
        XY = listSkelf{i}.XY;
        if any(ismember(XY(:,1),[1,s(2)])|ismember(XY(:,2),[1,s(1)]))
            ind2Del = [ind2Del,i];
        end
    end
    listSkelf(ind2Del) =[];
end

end