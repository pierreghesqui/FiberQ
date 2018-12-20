classdef dnaEP <  matlab.mixin.Copyable
    properties
        PixelIdxList
        XY
        LinkedEP
        Object
        sizeIm
        tanEP
        XYtan
        indTan
        listEP
        listObject
        
    end
    
    methods
        function obj = dnaEP(Object,varargin)
            %% TOUJOURS APPELER CETTE FUNCTION AVEC dnaSegm.setEP;
            
            %% parse input
            p = inputParser;
            checkObject = @(x) isa(x,'dnaSegm')|isa(x,'dnaBlob');
            checkXY = @(x) size(x,2)==2 & isnumeric(x);
            checkPixelIdxList = @(x)  isnumeric(x)&size(x,2)==1;
            
            addRequired(p,'Object',checkObject);
            addOptional(p,'XY',[],checkXY);
            addOptional(p,'PixelIdxList',[],checkPixelIdxList);
            
            parse(p,Object,varargin{:});
            obj.Object = p.Results.Object;
            obj.sizeIm = p.Results.Object.sizeIm;
            obj.PixelIdxList=p.Results.PixelIdxList;
            obj.XY=p.Results.XY;
            obj.LinkedEP = {};
            %% match XY with PixelIdxList
            if any(strcmp(p.UsingDefaults,'XY'))...
                    &~any(strcmp(p.UsingDefaults,'PixelIdxList'))
                matchXYWithIdx(obj);
            end
            if any(strcmp(p.UsingDefaults,'PixelIdxList'))...
                    &~any(strcmp(p.UsingDefaults,'XY'))
                matchIdxWithXY(obj);
            end
            checkMatchXYPixelIdx(obj);
            obj.listEP = Object.listEP;
%             obj.listBlob = Object.listBlob;
            obj.listObject = Object.listObject;
            obj.listEP.addEP(obj);
            
        end
        function ListConnection = getImportantConnection(obj)
            
            %importantEP = obj.getImpEP4Connection();%imshow(segm2Im({obj.Object},'withConn'))
            importantEP = obj.LinkedEP;
            ListConnection = {};
            for i =1:numel(importantEP)
                
                LinkedEP = importantEP{i}.LinkedEP;%imshow(segm2Im({obj.Object,LinkedEP{i}.Object},'withConn'))
                for j =1:numel(LinkedEP)
                    connection = setConnection(importantEP{i},LinkedEP{j});%imshow(segm2Im({importantEP{i}.Object,LinkedEP{j}.Object},'withConn'))
                    if connection.score >4 ||connection.dist >obj.Object.param.maxDist4ConnectionB
                        continue;
                    end
                    
                    if ~any(cellfun(@(x) eq(x.EP{1},connection.EP{1})&eq(x.EP{2},connection.EP{2}),ListConnection))
                        ListConnection = vertcatCell(ListConnection,connection);
                    end
                end
                
            end
            ListConnection = sortListConnection(ListConnection);
        end
        
        function listImpEP=getImpEP4Connection(obj)
            listImpEP = {obj};
            linkedEP1 = obj.LinkedEP;
            nbLinkedEP1 = numel(linkedEP1);
            checkIfAlreadyPresent = @(x) any(ismember(x,listImpEP))|eq(x,listImpEP{1});
            for i =1:nbLinkedEP1
                EPi = linkedEP1{i};
                if isa(EPi.Object,'dnaBlob')
                   linkedEP2 = EPi.LinkedEP;
                   nbLinkedEP2 = numel(linkedEP2);
                    for j= 1:nbLinkedEP2
                        EPj = linkedEP2{j};
                        if ~checkIfAlreadyPresent(EPj)
                            listImpEP=vertcatCell(listImpEP,EPj);
                        end
                    end
                end
                if ~checkIfAlreadyPresent(EPi)
                    listImpEP=vertcatCell(listImpEP,EPi);
                end
            end
        end
        
        function d = dist(obj,EP)
            d=sqrt((obj.XY(1)-EP.XY(1))^2+(obj.XY(2)-EP.XY(2))^2);
        end
        
        function isM = ismember(obj,ListEP)
            if ~isempty(ListEP)
            empt = cellfun(@(x) isempty(x)|~isa(x,'dnaEP'),ListEP);
            isM = false(numel(ListEP),1);
            
            ListEP(empt) = [];
            
            isM2 = cellfun(@(x) eq(x,obj),ListEP);
            
            isM(~empt) = isM2;
            else
                isM =false;
            end
        end
        
        function addLinkedEP(obj,list)
            for i = 1:numel(list)
                if~any(list{i}.ismember(obj.LinkedEP))
                    obj.LinkedEP = vertcatCell(obj.LinkedEP,list{i});
                    
                end
                if ~any(obj.ismember(list{i}.LinkedEP))
                    list{i}.LinkedEP = vertcatCell(list{i}.LinkedEP,obj);
                end
            end
        end
                
        function deleteEP(obj)
            try
            %% delete in Object
            if ~isempty(obj.Object)
                ind2Del =obj.ismember(obj.Object.EP);
                if any(ind2Del)
                    obj.Object.EP{ind2Del}=[];
                end
            end
            %% delete in listEP
            listEP = obj.listEP;
            listEP.List(obj.ismember(listEP.List))=[];
            
            %% delete in LinkedEP
            linkedEP = obj.LinkedEP;
            for i =1:numel(linkedEP)
                linkedEP{i}.LinkedEP(obj.ismember(linkedEP{i}.LinkedEP))=[];
            end
            delete(obj)

            catch
                return
            end

        end
        
        
      
    end
end