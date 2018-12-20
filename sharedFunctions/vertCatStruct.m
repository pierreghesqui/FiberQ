function [ struct3 ] = vertCatStruct( struct1,struct2 )
struct3 = struct1;


nb = numel(struct3);


for i=1:numel(struct2)
    if isempty(fieldnames(struct3))
        struct3 = struct2(1);
        struct3(i+numel(struct1)) = struct2(i);
        struct3(1) = [];
        nb = 0;
    else
        struct3(i+nb) = struct2(i);
    end
    
end


end

