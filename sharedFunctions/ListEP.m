classdef ListEP <  matlab.mixin.Copyable
    
    properties
        List
        
    end
    
    methods
        
        function obj = ListEP(List)
            p = inputParser;
            checkListEP = @(L) sum(cellfun(@(x) isa(x,'dnaEP'),L))==size(L,1); 
            addRequired(p,'List',checkListEP);
            parse(p,List);
            obj.List=p.Results.List;
            
        end
        function addEP(obj,EP)
            %if ~any(EP.ismember(obj.List)) && isa(EP,'dnaEP')
                obj.List = vertcatCell(obj.List,EP);
            %end
        end
        function im = listEP2im(obj)
            if~isempty(obj)
                im = zeros(obj.List{1}.sizeIm);
                for i = 1:numel(obj.List)
                    im(obj.List{i}.PixelIdxList)=i;
                end
            else
                im = [];
            end
        end
        function connectEP(obj,param)
            if ~isempty(obj.List)
            imEP = listEP2im(obj);%figure; imshow(imEP,[])
            for i = 1:numel(obj.List)
                XYi = obj.List{i}.XY;
                if isa(obj.List{i}.Object,'dnaBlob')
                    maxDist4Connection = param.maxDist4ConnectionB;
                elseif isa(obj.List{i}.Object,'dnaSegm')
                    maxDist4Connection = param.maxDist4ConnectionS;
                end
                xmin = max(XYi(1)-maxDist4Connection,1);xmax = min(XYi(1)+maxDist4Connection,size(imEP,2));
                ymin = max(XYi(2)-maxDist4Connection,1);ymax = min(XYi(2)+maxDist4Connection,size(imEP,1));
                label2conn = setdiff(imEP(ymin:ymax,xmin:xmax),[0,i]);
                if ~isempty(label2conn)
                    obj.List{i}.addLinkedEP({obj.List{label2conn}})
                end
            end
            
            end
        end
        function setForbidList(obj,BW_rough,grayImage,param,expFold)
            s = size(BW_rough);%figure; imshow(grayImage,[])
            sigma = round(param.DensityStd);
            hsize = round(5*sigma);
             winsize = round([min(hsize,s(1)/4),min(hsize,s(2)/4)]);
             BW = imbinarize(grayImage);
%             
%             densityMapBW_rough = 1/thicknessFib*imfilter(double(BW_rough),ones(winsize)/prod(winsize),'symmetric');
            densityMapGray = imfilter(double(BW),fspecial('gaussian',hsize,sigma),'symmetric');
            density = imfilter(double(BW_rough),fspecial('gaussian',hsize,...
            sigma),'symmetric');
            %figure; imshow(BW,[])
            %figure; imshow(density,[])
            forbidZone= density>param.threshDensity| densityMapGray>param.threshDensity;
            %figure;imshowpair(BW_rough,forbidZone) 
            if exist('expFold','var')
                %forbidZone(s(1)-3*sigma+1:s(1),1:3*sigma)=1;
                imwrite(imfuse(forbidZone,BW_rough),fullfile(expFold,'highDensityArea.png'));
            end
            cellfun(@(x) x.Object.setForbidZone(forbidZone),obj.List);
        end
        
        function deleteListEP(obj)
            
            while ~isempty(obj.List)
                try
                deleteEP(obj.List{1});
                obj.List(1) = [];
                catch
                    continue;
                end
            end
            delete(obj);
        end
        end
end