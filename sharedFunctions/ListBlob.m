classdef ListBlob <  matlab.mixin.Copyable
    
    properties
        List
        
    end
    
    methods
        
        function obj = ListBlob(List)
            p = inputParser;
            checkListEP = @(L) sum(cellfun(@(x) isa(x,'dnaBlob'),L))==size(L,1); 
            addRequired(p,'List',checkListEP);
            parse(p,List);
            obj.List=p.Results.List;
            
        end
        function addBlob(obj,Blob)
            %if ~any(Blob.ismember(obj.List))
                obj.List = vertcatCell(obj.List,Blob);
            %end
        end
        
    end
end
