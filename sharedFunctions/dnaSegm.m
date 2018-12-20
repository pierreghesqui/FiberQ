classdef dnaSegm <  matlab.mixin.Copyable
    properties
        PixelIdxList
        XY
        XYsmoothed
        EP
        sizeIm
        listEP
        listSegm
        param
        color
        isInForbidZone
        nbSplices =0
        anglesSplices
        distanceSplices
        nbSegm = 0;
        nbBlob = 0;
        otherCandidates = {};
        density
        
    end
    
    methods
        function obj = dnaSegm(param,sizeIm,listSegm,listEP,varargin)
            %% parse input
            p = inputParser;
            checkXY = @(x) size(x,2)==2 & isnumeric(x) & size(x,1)>1;
            checkPixelIdxList = @(x) size(x,1)>1 & isnumeric(x) &size(x,2)==1;
            
            addRequired(p,'param',@(x) isa(x,'Metric'));
            addRequired(p,'s',@isnumeric);
            addRequired(p,'listSegm',@(x) isa(x,'ListSegm'));
            addRequired(p,'listEP',@(x) isa(x,'ListEP'));
%             addRequired(p,'listBlob',@(x) isa(x,'ListBlob'));
            addOptional(p,'XY',[],checkXY);
            addOptional(p,'PixelIdxList',[],checkPixelIdxList);
            
            parse(p,param,sizeIm,listSegm,listEP,varargin{:});
            obj.sizeIm=p.Results.s;
            obj.param=p.Results.param;
            obj.PixelIdxList=p.Results.PixelIdxList;
            obj.XY=p.Results.XY;
            
            %% match XY with PixelIdxList
            if any(strcmp(p.UsingDefaults,'XY'))...
                    &&~any(strcmp(p.UsingDefaults,'PixelIdxList'))
                matchXYWithIdx(obj);
            end
            if any(strcmp(p.UsingDefaults,'PixelIdxList'))...
                    &&~any(strcmp(p.UsingDefaults,'XY'))
                matchIdxWithXY(obj);
            end
            [XY,PixelIdxList] = Pixel2XY_Ind(obj.XY,obj.PixelIdxList);
            obj.XY=XY;
            obj.PixelIdxList=PixelIdxList;
            obj.listSegm=listSegm;
            obj.listEP=listEP;
            checkMatchXYPixelIdx(obj);
            obj.setEP;
            obj.setTanEP;
            obj.listSegm.addSegm(obj);
        end
        function out  = listObject(obj)
            out = obj.listSegm;  
        end
        function crop(obj,ind)
            indObj = obj.PixelIdxList;
            idx = find(indObj==ind);
            len = length(indObj);
            if idx<=floor(len/2)
                obj.PixelIdxList(1:idx-1)=[];
                obj.XY(1:idx-1,:) = [];
            else
                obj.PixelIdxList(idx+1:end)=[];
                obj.XY(idx+1:end,:) = [];
            end
        end
        function setEP(obj)
%             if ~isempty() %% TODO
%                 delete(obj.EP{1})
%                 delete(obj.EP{2})
%             end
            EP1 = dnaEP(obj,'PixelIdxList',obj.PixelIdxList(1));
            EP2 = dnaEP(obj,'PixelIdxList',obj.PixelIdxList(end));
            obj.EP = {EP1,EP2};
            %displaySegm({obj}),hold on
            %plot(EP1.XY(1),EP1.XY(2),'xr',EP2.XY(1),EP2.XY(2),'xr')
            %EP1.PixelIdxList ==926541|EP2.PixelIdxList ==926541
        end
        function obj = convertSegm2Blob(segm)
            obj = Blob(segm.sizeIm,'PixelList',segm.XY);
        end
        
             
        function setForbidZone(obj,densityMap)
            
            if any(shiftdim(densityMap(obj.PixelIdxList)))
                obj.isInForbidZone = true;
            else
                obj.isInForbidZone = false;
            end
        end
        
        
        function deleteSegm(obj)
            try
            %% delete in ListSegm
            listSegm = obj.listSegm;
            listSegm.List(obj.ismember(listSegm.List)) = [];
            %% deleteEP
            if any(cellfun(@(x) ~isempty(x),obj.EP))
                EP = obj.EP;
                EP{1}.Object = [];
                EP{2}.Object = [];
                deleteEP(EP{1});
                deleteEP(EP{2});
            end
            delete(obj)
            catch
                return
            end
            %%
        end
        
        
        
        function setLinkedNodes(obj,LinkedNodes)
            obj.LinkedNodes = LinkedNodes;
            for i = 1:2
                LinkedNodes_i = LinkedNodes{i};
                if~isempty(LinkedNodes_i)
                    if ~any(ismember(obj,LinkedNodes_i.LinkedSegment))
                        LinkedNodes_i.addLinkedSegment(obj)
                    end
                end
            end
        end
        function isM = ismember(obj, objList)
            if ~isempty(objList)
            empt = cellfun(@(x) isempty(x)|~isa(x,'dnaSegm'),objList);
            isM = false(numel(objList),1);
            
            objList(empt) = [];
            
            isM2 = cellfun(@(x) eq(x,obj),objList);
            isM(~empt) = isM2;
            else
                isM =[];
            end
            %isM = cellfun(@(x) eq(x,obj),objList);
        end
        function l = length(obj)
            l = length(obj.PixelIdxList);
        end
        function smoothSkel(obj)
            param0 = obj.param;
            maxSmoothRange = param0.maxSmoothRange;
            len = length(obj);
            l=min(len,maxSmoothRange);
            Xs = shiftdim(smooth(obj.XY(:,1),l,'lowess'));
            Ys = shiftdim(smooth(obj.XY(:,2),l,'lowess'));
            obj.XYsmoothed = [Xs,Ys];
            %figure; hold on, plot(obj.XY(:,1)),plot(Xs)
            %figure; hold on, plot(obj.XY(:,2)),plot(Ys)
        end
        function setTanEP(obj)
            obj.smoothSkel;
            %imshow(segm2Im({obj},'',0));hold on
            %plot(obj.XYsmoothed(:,1),obj.XYsmoothed(:,2))
            Xs = obj.XYsmoothed(:,1);
            Ys = obj.XYsmoothed(:,2);
            len = length(Xs);
            ecart = round(obj.param.thicknessFib/2);
            idxLeft = [1:ecart:floor(len/2)];idxLeft=idxLeft(1:min(length(idxLeft),7));
            idxRight = [len:-ecart:floor(len/2)+1];idxRight=idxRight(1:min(length(idxRight),7));
            indL = false(len,1);indL(idxLeft)=true;
            indR = false(len,1);indR(idxRight)=true;
            
            tan  = [[Xs(2)-Xs(1);Xs(2:end)-Xs(1:end-1)],[Ys(2)-Ys(1);Ys(2:end)-Ys(1:end-1)]];
            tanL = tan(indL,:);
            tanL = tanL./vecnorm(tanL')';
            tanL = flipud(-tanL);
            tanR = tan(indR,:);
            tanR = tanR./vecnorm(tanR')';
            XYtanL = flipud(obj.XY(indL,:));
            XYtanR = obj.XY(indR,:);
            PixelIdxListTanL = sub2ind(obj.sizeIm,XYtanL(:,2),XYtanL(:,1));
            PixelIdxListTanR = sub2ind(obj.sizeIm,XYtanR(:,2),XYtanR(:,1));
                       
            
            obj.EP{1}.tanEP = tanL;
            obj.EP{2}.tanEP = tanR;
            obj.EP{1}.XYtan = XYtanL;
            obj.EP{2}.XYtan = XYtanR;
            obj.EP{1}.indTan = PixelIdxListTanL;
            obj.EP{2}.indTan = PixelIdxListTanR;
            %displaySegm({obj.EP{1}.Object,obj.EP{2}.Object}),hold on
            %quiver(obj.EP{1}.XYtan(:,1),obj.EP{1}.XYtan(:,2),10*obj.EP{1}.tanEP(:,1),10*obj.EP{1}.tanEP(:,2))
            %quiver(obj.EP{2}.XYtan(:,1),obj.EP{2}.XYtan(:,2),10*obj.EP{2}.tanEP(:,1),10*obj.EP{2}.tanEP(:,2))
            %obj.EP{1}.PixelIdxList ==705495 ||obj.EP{2}.PixelIdxList ==705495;
        end
       
        function [indEP,XYEP] = endPoint(obj)
            indEP = [obj.PixelIdxList(1);obj.PixelIdxList(end)];
            XYEP = [obj.XY(1,:);obj.XY(end,:)];
        end
        function ind = indInWorld(obj)
             ListSegments= obj.world.ListSegments;
             ind = find(cellfun(@(x) isequal(x,obj),ListSegments));
             if length(ind)>2
                 error([num2str(length(ind)) 'identical segments in the world'])
             end
        end
        function obj = replaceSegm(obj,segm)
            listProp =properties(obj);
            for i = 1:numel(listProp)
                
                    obj.(listProp{i}) = segm.(listProp{i});
                
                
            end
            obj.setLinkedNodes(obj.LinkedNodes);

            delete(segm);
        end
        function out = isalone(obj)
            if isempty(obj.EP{1}.LinkedEP)&&isempty(obj.EP{2}.LinkedEP)
                out = true;
            else
                out = false;
            end
        end

    end
end