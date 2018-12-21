function [imName,imPath] = buildImNamePath(expFold_p,format)
%BUILDIMNAMEPATH : make the list of all images in the directory "expFold_p"
%only .png, .tif, .czi and .dv are accepted

%expFold_p : name of the directory where to find images
%format : (optional) format of the image we want to proceed
%imName : name of the image : example : {'image1.png'}
%imPath : paths of the images : example : {'C:\Destkop\image1.png'}

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

