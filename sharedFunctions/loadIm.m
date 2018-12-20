function I_rg = loadIm(imPath,FAST_options)
%lOADIM Load image from .dv, .zi, .tif, .png
%   I_rg = loadIm(imPath_i,FAST_options) load image and match each RGB channel
%   with the good marker (CldU,IdU). 
%
%   INPUTS
%   imPath : (String) path towards the image. Must end with the format 
%   FAST_options : options containing the information to match marker
%   (IdU,CldU) and channels (red, green, blue).
%   
%   OUTPUTS 
%   I_rg : three channel image. WARNING : The red channel has to be 
%   the CldU marker. The green channel has to be the IdU marker

%% load image 
if strcmp(imPath(end-1:end),'dv')||strcmp(imPath(end-1:end),'zi')
    im = imReadDv(imPath);
    
elseif strcmp(imPath(end-2:end),'tif')
        [im] = imread(imPath,1);
        if size(im,3) ==1
            [imChannel1,~] = imread(imPath,1);
            [imChannel2,~] = imread(imPath,2);% figure; imshow(imCLDU,[])
            %[imChannel3,~] = imread(imPath,3);% figure; imshow(imChannel3,[])
            im = cat(3,imChannel1,imChannel2,zeros(size(imChannel1)));
        end
else 
        [im,~] = imread(imPath);% figure; imshow(im,[])
end

%% Match the channel (RGB) with the 2 Markers (IdU, CldU)
if strcmp(FAST_options.colorFirstMarker,'green')
    colorFirstM = 2;
    colorSecondM = 1;
else
    colorFirstM = 1;
    colorSecondM = 2;

end
if strcmp(FAST_options.ChannelFirstMarker,'1')
    channelFirstM =1;
    channelSecondM =2; 
else
    channelFirstM  =2;
    channelSecondM =1; 
end
I_rg = zeros(size(im(:,:,1),1),size(im(:,:,1),2),3,class(im));
I_rg(:,:,colorFirstM) = im(:,:,channelFirstM);
I_rg(:,:,colorSecondM) = im(:,:,channelSecondM);
% figure; imshow(I_rg)



end