function [im] = loadImAndHyperparam(imName_i,imPath_i,withIm)
if nargin<3
    withIm=1;
end
if strcmp(imName_i(end-1:end),'dv')
    if withIm
        im = imReadDv(imPath_i);
    else
        im=[];
    end

elseif strcmp(imName_i(end-1:end),'zi')
    im = imReadDv(imPath_i);

elseif strcmp(imName_i(end-2:end),'tif')
    if withIm
        [im] = imread(imPath_i,1);
        if size(im,3) ==1
         [imCLDU,~] = imread(imPath_i,1);
        [imIDU,~] = imread(imPath_i,2);% figure; imshow(imCLDU,[])
        im = cat(3,imCLDU,imIDU,zeros(size(imIDU)));
        end
    else
        im = [];
    end
   
else
    if withIm
        [im,~] = imread(imPath_i);% figure; imshow(im,[])
    else
        im =[];
    end
   
    
end
end