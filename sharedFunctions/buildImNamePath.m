function [imName,imPath] = buildImNamePath(expFold_p,format)
if nargin<2
    format = {'png','tif','czi','dv'};
end
nbFormat = numel(format);
imName = {};
imPath = {};
for i = 1 : nbFormat
    ext = ['\*.' format{i}];
    imName_i =  dir([expFold_p ext]);imName_i={imName_i.name}';
    imPath_i = fullfile(expFold_p,imName_i);
    imName = vertcat(imName,imName_i);
    imPath = vertcat(imPath,imPath_i);
end

end

