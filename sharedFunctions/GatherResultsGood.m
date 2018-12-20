function [FolderResultsGood,FolderBicolorResultsGood]=GatherResultsGood (FolderResultsGood,...
                FolderBicolorResultsGood,imName_i,expFold_p)
            C = strsplit(imName_i,'.');lengthFormat = length(C{end});
            load(fullfile(expFold_p,'Results',...
            imName_i(1:end-lengthFormat-1),'AL_GoodTable.mat'));
            
            FolderResultsGood=vertcat(FolderResultsGood,Results_AllGoodFibersEP);
            nbBicolorFiber = size(Results_GoodBicolorFibersEP,1);
            for i = 1:nbBicolorFiber
                Color_Of_Each_Part = Results_GoodBicolorFibersEP.Color_Of_Each_Part(i,:);
                if isequal(Color_Of_Each_Part,[2,1])
                    Results_GoodBicolorFibersEP.Color_Of_Each_Part(i,:) = ...
                        fliplr(Color_Of_Each_Part);
                    Results_GoodBicolorFibersEP.Length_Of_Each_Part(i,:) = ...
                        fliplr(Results_GoodBicolorFibersEP.Length_Of_Each_Part(i,:));
                end
            end
            FolderBicolorResultsGood = vertcat(FolderBicolorResultsGood,...
                Results_GoodBicolorFibersEP);

end