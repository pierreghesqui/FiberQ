function [FolderResults,FolderBicolorResults]=GatherResultsLong (FolderResults,...
                FolderBicolorResults,imName_i,expFold_p)
            C = strsplit(imName_i,'.');lengthFormat = length(C{end});
            load(fullfile(expFold_p,'Results',...
            imName_i(1:end-lengthFormat-1),'AL_Table.mat'));
            
            FolderResults=vertcat(FolderResults,Results_LongFibers);
            nbBicolorFiber = size(Results_LongBicFibers,1);
            for i = 1:nbBicolorFiber
                Color_Of_Each_Part = Results_LongBicFibers.Color_Of_Each_Part(i,:);
                if isequal(Color_Of_Each_Part,[2,1])
                    Results_LongBicFibers.Color_Of_Each_Part(i,:) = ...
                        fliplr(Color_Of_Each_Part);
                    Results_LongBicFibers.Length_Of_Each_Part(i,:) = ...
                        fliplr(Results_LongBicFibers.Length_Of_Each_Part(i,:));
                end
            end
            FolderBicolorResults = vertcat(FolderBicolorResults,...
                Results_LongBicFibers);
end