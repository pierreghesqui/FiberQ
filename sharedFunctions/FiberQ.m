function FiberQ(inp,EOPs)
%FIBERQ : This function contains the for loop to process each image
%The for loop can be easily converted in parallel loop to speed up the
%treatment (see below).

% inp : input from the user interface. inp{1,:} are the path to images, 
% inp{2,:} is the name of the first pulse (IdU or CldU)
% inp{3,:} is the channel of the first pulse
% inp{4,:} will be the color of the first pulse on the result images
% EOPs : list of all Experimentally Optimised Parameters (see article for
% details). They can be modified on the user interface (Tab "Parameters" and "advanced parameters"). 

addpath(genpath('sharedFunctions'));
format = {'tif','png','dv','czi','jpeg'};

expFold = {inp{:,1}};
WhichChannelIsWhat = buildFiberQ_options(inp);

for p = 1:length(expFold)
    try
        %% image Processing
        f = waitbar(0,'Please wait...');
        f.Children.Title.Interpreter = 'none';
        
        % load image Path and name :
        expFold_p = expFold{p};
        [imName,imPath] = buildImNamePath(expFold_p,format);
        nbImage = numel(imPath);
      
%if you want to convert the for loop in parforloop, uncomment the following
%line and comment the line below
%       parfor i = 1:nbImage)
        for i = 1:nbImage
            try
                
                imName_i = imName{i};
                imPath_i = imPath{i};
                expFold_p2 = strsplit(expFold_p,filesep);
                txt = {['Folder: "' expFold_p2{end}  '" in progress'],['image: "' imName_i '" in progress...'] };
                waitbar((i-1)/nbImage,f,txt);
                
                %image Processing of the ie image:
                ImageProcessing_FiberQ (imPath_i,WhichChannelIsWhat(p),EOPs);
                
            catch exception
                errorString = ['Error in analysisScript. In' ...
                    fullfile(expFold_p,imName{i}) ' Message:' exception.message...
                    buildCallStack(exception)]
                logit(expFold_p,errorString);
                continue
            end
        end
        
        %% Building of the result Table
        FolderResults = table;
        FolderBicolorResults = table;
        
        for i = 1:nbImage
            try
                
                imName_i = imName{i};
                [FolderResults,FolderBicolorResults]=GatherResults (FolderResults,...
                    FolderBicolorResults,imName_i,expFold_p);
            catch exception
                errorString = ['Error in analysisScript. In' ...
                    fullfile(expFold_p,imName{i}) ' Message:' exception.message...
                    buildCallStack(exception)]
                logit(expFold_p,errorString);
                continue
            end
        end
        
        %save the result table
        save(fullfile(expFold_p,'Results','FolderResults.mat'),'FolderResults',...
            'FolderBicolorResults')
        writetable(FolderResults,fullfile(expFold_p,'Results','FolderResults.xls'))
        writetable(FolderBicolorResults,fullfile(expFold_p,'Results','FolderBicolorResults.xls'))
        close(f)
    catch
        continue;
    end
end
if exist('f','var')
    close(f)
end

end