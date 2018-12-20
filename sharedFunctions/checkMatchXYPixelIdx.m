  function checkMatchXYPixelIdx(obj)
            if ~isequal(sub2ind(obj.sizeIm,obj.XY(:,2),obj.XY(:,1)),...
                    obj.PixelIdxList)
                error('XY and PixelIdxList don t match');
            end
        end