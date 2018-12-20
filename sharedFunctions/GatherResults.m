function [FolderResults,FolderBicolorResults]=GatherResults (FolderResults,...
                FolderBicolorResults,imName_i,expFold_p)
            C = strsplit(imName_i,'.');lengthFormat = length(C{end});
            load(fullfile(expFold_p,'Results',...
            imName_i(1:end-lengthFormat-1),'AL_Table.mat'));
            
            FolderResults=vertcat(FolderResults,Results_AllFibers);
            nbBicolorFiber = size(Results_BicolorFibers,1);
            for i = 1:nbBicolorFiber
                Markers = Results_BicolorFibers.Markers(i,:);
                if isequal(Markers,[2,1])
                    Results_BicolorFibers.Color_Of_Each_Part(i,:) = ...
                        fliplr(Markers);
                    Results_BicolorFibers.Length_Of_Each_Part(i,:) = ...
                        fliplr(Results_BicolorFibers.Length_Of_Each_Part(i,:));
                end
            end
            FolderBicolorResults = vertcat(FolderBicolorResults,...
                Results_BicolorFibers);
end