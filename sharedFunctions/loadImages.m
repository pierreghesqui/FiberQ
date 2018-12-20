function ImCell = loadImages(listFolder,nbCannal)
%LOADIMAGES returns a list of all pairs of DNA images with the folder path.
%   LISTFOLDER: cell containing paths towards the folder containing the
%   data
%   NBCANNAL : integer specifying the number of channels (or color) in the
%   image. (generally, the number of channel is 2)
%   IMCELL : cell containing the path of the folder containing the images,
%   and the images. 

for i = 1:numel(listFolder)
    folder_i = fullfile(listFolder{i},'RawImages' );
    imagePath_i = dir(folder_i); imagePath_i = imagePath_i(3:end); imagePath_i = {imagePath_i.name};
    
    ImCell{i,1} = listFolder{i};
    
    for c = 1:nbCannal
        imc = imread(fullfile(folder_i,imagePath_i{c}));
        ImCell{i,c+1} = imc;
    end
    
end
end