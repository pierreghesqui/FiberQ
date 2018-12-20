function FiberQ(inp,EOPs)
addpath(genpath('sharedFunctions'));
format = {'tif','png','dv','czi','jpeg'};

expFold = {inp{:,1}};
FiberQ_options = buildFiberQ_options(inp);


for p = 1:length(expFold)
    try
        f = waitbar(0,'Please wait...');%,'CreateCancelBtn','setappdata(gcbf,''Cancel'',1)');
        f.Children.Title.Interpreter = 'none';
        expFold_p = expFold{p};
        [imName,imPath] = buildImNamePath(expFold_p,format);
        nbImage = numel(imPath);
        
        for i = 1:nbImage
            try
                
                imName_i = imName{i};
                imPath_i = imPath{i};
                expFold_p2 = strsplit(expFold_p,filesep);
                txt = {['Folder: "' expFold_p2{end}  '" in progress'],['image: "' imName_i '" in progress...'] };
                waitbar((i-1)/nbImage,f,txt);

%                 if getappdata(f,'Cancel')
%                     break
%                 end
                ParForFunction (imPath_i,expFold_p,FiberQ_options(p),EOPs);
                i
            catch exception
                errorString = ['Error in analysisScript. In' ...
                    fullfile(expFold_p,imName{i}) ' Message:' exception.message...
                    buildCallStack(exception)]
                logit(expFold_p,errorString);
                continue
            end
        end
        
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