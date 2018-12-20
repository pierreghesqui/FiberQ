function ParForFunction (imPath_i,expFold_p,FiberQ_options,EOPs)
imName_i = splitAfterLastFileSep(imPath_i);
splittedName = strsplit(imName_i,'.');lengthFormat = length(splittedName{end});
%----------Create Result Folders--------------
if~exist(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1)),'dir')
    mkdir(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1)))
end
%----------LoadImage --------------------------
%dname = 
logit(expFold_p,'Load Image')
[I_rg] = loadIm(imPath_i,FiberQ_options);
logit(expFold_p,'Load Image Done')
%figure; imshow(I_rg,[])
%imwrite(I_rg,'..\article\I_rg.tif')

%%=========================================================================
%% Pre-Processing
%%========================================================================

[I_rgN,s,...
    grayImage,PSF] = PreprocessingFiber (I_rg,EOPs);%figure; imshow(I_rgN,[]),hold on, plot(listSkel{1}.XY(:,1),listSkel{1}.XY(:,2))
logit(expFold_p,'PreprocessingFiber Done')

%=====================================================================================
%% Processing
%=====================================================================================
%% Step : Get largeSegment
param = Metric(PSF,EOPs);
[BW_rough] = getSegments(grayImage,param,...
    1);
logit(expFold_p,'getSegments Done')

%---
if ~any(BW_rough(:))
    return
end
%I_rgN2 =cat(3,mat2gray(I_rgN(:,:,1)),mat2gray(I_rgN(:,:,2)),mat2gray(I_rgN(:,:,3)));
%figure; imshow(I_rgN2,[])
[BW_roughf]=deleteLargeShape(BW_rough,param);%figure; imshowpair(BW_rough,BW_roughf)
logit(expFold_p,'deleteLargeShape Done')
%---

[imSkel,imBlob] = separateSkelvsBlob(BW_roughf,param);%figure; imshowpair(imSkel,imBlob)
logit(expFold_p,'separateSkelvsBlob Done')

%% PruneSkel : elaguer l'image
save(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
    'checkpointBeforePruneSkel.mat'));
% 
% load(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
%     'checkpointBeforePruneSkel.mat'))
logit(expFold_p,'PruneSkel...')
listSkel = PruneSkel(imSkel,imBlob,BW_rough,grayImage,param,...
    fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1)));
logit(expFold_p,'PruneSkel Done')
save(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
     'listSkelAfterPruneSkel.mat'),'listSkel');
% load(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
%     'checkpointBeforePruneSkel.mat'))
% load(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
%       'listSkelAfterPruneSkel.mat'))
listSkel = setDensityOnSkel(listSkel,BW_rough,param);

%% Step : Build red and green ratios
toPlot = 0;
intIm = imgaussfilt(I_rgN,param.thicknessFib/5,'Padding','symmetric');
listSkel = findRedAndGreenLimit(listSkel,intIm,param);

%% Control fibers
%listSkel=controlFibers(listSkel,I_rgN,PSF);

%% Table

[listSkel,Results_AllFibers] = buildResultTable(...
    listSkel, imName_i,FiberQ_options);%figure; imshow(segm2Im(listSkel,'',0))
[Results_BicolorFibers]=buildResultTableForBicolorFiber(...
    Results_AllFibers,FiberQ_options);
indBico = Results_AllFibers.nb_Of_Parts==2;
logit(expFold_p,'findRedAndGreenLimit Done')

% maxSplicingDistance = 
% maxSplicingAngle = 
% maxDensity = 

%=========================================================================
%% Display Results
%=========================================================================

skelSegm       = segm2Im(listSkel,'',0); 
imBox         = drawBoundingBoxes(I_rgN, skelSegm, [255,255,255]);
skelSegmColor =segm2colorIm(listSkel,2);%figure; imshow(skelSegmColor,[])
I_colorSkel2 = imfuse2(I_rgN,skelSegmColor);%figure; imshow(I_colorSkel2,[])
labeledImage  = BuildImageWithLabel(I_colorSkel2,listSkel,...
    Results_AllFibers.Fiber_Label,s);
ratio = Results_BicolorFibers.Length_Of_Each_Part(:,2)./...
    Results_BicolorFibers.Length_Of_Each_Part(:,1)*100;
RatioImage = BuildImageWithRatio(skelSegmColor,listSkel(indBico),...
    ratio,s);

save(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
    'AL_InfoStrand.mat'),'listSkel','indBico')
save(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
    'AL_Table.mat'),'Results_BicolorFibers','Results_AllFibers')
imwrite2(RatioImage,fullfile(expFold_p,'Results',...
    imName_i(1:end-lengthFormat-1),['Segm_Ratio'  '.png']))
imwrite2(labeledImage,fullfile(expFold_p,'Results',...
    imName_i(1:end-lengthFormat-1),['Segm_Label'  '.png']))
imwrite2(imBox,fullfile(expFold_p,'Results',...
    imName_i(1:end-lengthFormat-1),['imBox'  '.png']))
logit(expFold_p,'End')
end