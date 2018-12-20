classdef ListSegm <  matlab.mixin.Copyable
    
    properties
        List
        
    end
    
    methods
        
        function obj = ListSegm(List)
            p = inputParser;
            checkListEP = @(L) sum(cellfun(@(x) isa(x,'dnaSegm'),L))==size(L,1);
            addRequired(p,'List',checkListEP);
            parse(p,List);
            obj.List=p.Results.List;
            
        end
        function addSegm(obj,Segm)
            %if ~any(Segm.ismember(obj.List))
                obj.List = vertcatCell(obj.List,Segm);
            %end
        end
        function sort(obj)
            L =  cellfun(@length,obj.List);
            [L,idx] = sort(L,'descend');
            obj.List = obj.List(idx);
        end
        function refineEnd(obj,BW_rough)
            nbSegm = numel(obj.List);
            s = size(BW_rough);
            if nbSegm>0
                param = obj.List{1}.param;
                for i =1:nbSegm
                    XY = obj.List{i}.XY;
                    if size(XY,1)>param.thicknessFib
                        XY = refineDown(XY,BW_rough,param);
                        XY = flipud(XY);
                    end
                    if size(XY,1)>param.thicknessFib
                        XY = refineDown(XY,BW_rough,param);
                        XY = flipud(XY);
                        
                    end
                    ind = sub2ind(s,XY(:,2),XY(:,1));
                    obj.List{i}.XY=XY;
                    obj.List{i}.PixelIdxList = ind;
                end
            end
            
        end
        
        function Filter(obj,l,opts)
            ind2Del = cellfun(@(x) x.length<l|x.isInForbidZone,obj.List);%x.length<l|x.isInForbidZone
            obj.List(ind2Del)=[];
        end
        function deleteListSegm(obj)
            
            while ~isempty(obj.List)
                try
                    deleteSegm(obj.List{1});
                    obj.List(1) = [];
                catch
                    continue
                end
            end
            delete(obj);
        end
    end
end
