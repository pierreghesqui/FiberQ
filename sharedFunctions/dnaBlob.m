classdef dnaBlob<  matlab.mixin.Copyable
    
    
    properties
        sizeIm
        PixelIdxList
        PixelList
        EP
        listBlob
        listEP
        isInForbidZone
    end
    
    methods
        function obj = dnaBlob(sizeIm,listBlob,listEP,varargin)
            %% parse input
            p = inputParser;
            checkPixelIdxList = @(x) isnumeric(x)&size(x,2)==1;
            checkPixelList = @(x) isnumeric(x)&size(x,2)==2;
            checkListBlob = @(x) isa(x,'ListBlob');
            checkListEP = @(x) isa(x,'ListEP');
            addRequired(p,'sizeIm',@isnumeric);
            addRequired(p,'listBlob',checkListBlob);
            addRequired(p,'listEP',checkListEP);
            addOptional(p,'PixelIdxList',[],checkPixelIdxList);
            addOptional(p,'PixelList',[],checkPixelList);
            
            parse(p,sizeIm,listBlob,listEP,varargin{:});
            obj.sizeIm=p.Results.sizeIm;
            obj.PixelIdxList=p.Results.PixelIdxList;
            obj.PixelList=p.Results.PixelList;
            obj.listBlob = listBlob;
            obj.listEP = listEP;
            obj.setEP();
            obj.listBlob.addBlob(obj);
        end
        
        function setForbidZone(obj,densityMap)
            if any(shiftdim(densityMap(obj.PixelIdxList)))
                obj.isInForbidZone = true;
            else
                obj.isInForbidZone = false;
            end
        end
        
        function out  = listObject(obj)
            out = obj.listBlob;
        end
        function isM = ismember(obj, objList)
            if ~isempty(objList)
                empt = cellfun(@(x) isempty(x)|~isa(x,'dnaBlob'),objList);
                isM = false(numel(objList),1);
                
                objList(empt) = [];
                
                isM2 = cellfun(@(x) eq(x,obj),objList);
                isM(~empt) = isM2;
            else
                isM =[];
            end
            %isM = cellfun(@(x) eq(x,obj),objList);
        end
        function setEP(obj)
            xyEP = round(mean(obj.PixelList,1));
            EP1 = dnaEP(obj,'PixelIdxList',sub2ind(obj.sizeIm,xyEP(2),xyEP(1)));
            obj.EP = {EP1};
        end
        function deleteBlob (obj)
            try
            %---delete EP and detached All connection EP
            EP = obj.EP{1};
            linkedEP = EP.LinkedEP;
            for i =1:numel(linkedEP)
                linkedEP{i}.LinkedEP(EP.ismember(linkedEP{i}.LinkedEP)) = [];
            end
            deleteEP(EP);
            
            %---delete obj in listBlob
            obj.listBlob.List(obj.ismember(obj.listBlob.List))=[];
            delete (obj)
            catch
                return
            end
        end
        
    end
end

