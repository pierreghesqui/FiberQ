function [classes,idx] = getClass(listCell)
[classes,idx] = sort(cellfun(@class,listCell,'UniformOutput',false));
end