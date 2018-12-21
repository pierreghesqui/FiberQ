function ImageProcessing_FiberQ (imPath_i,WhichChannelIsWhat,EOPs)
%IMAGEPROCESSING_FIBERQ is the main function of fiberQ. It loads the image,
%processes it, saves the result images and builds the result spreadsheet.

%---impPath_i : path of the image 
%---WhichChannelIsWhat : parameter given by the function "buildFiberQ_options"
%to know which channel is IdU and CldU and which nucleotide analogue is the
%first pulse. All those parameters have been written by the user in the
%interface.
%---EOPs : list of all the Experimentally Optimised parameters (see article). They can be
%modified in the user interface (see parameters or advanced parameters)

expFold_p = strsplit(imPath_i,filesep);
expFold_p = fullfile(expFold_p{1:end-1});
imName_i = splitAfterLastFileSep(imPath_i);
splittedName = strsplit(imName_i,'.');lengthFormat = length(splittedName{end});

%----------Create Result Folders--------------
if~exist(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1)),'dir')
    mkdir(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1)))
end
%----------LoadImage --------------------------
logit(expFold_p,'Load Image')
[I_rg] = loadIm(imPath_i,WhichChannelIsWhat);
logit(expFold_p,'Load Image Done')

%% Pre-Processing

[I_rgN,s,...
    grayImage,PSF] = PreprocessingFiber (I_rg,EOPs);
logit(expFold_p,'Preprocessing Done')

%% First fiber segmentation
param = Metric(PSF,EOPs);

%---Edge detection method ---
[BW_rough] = EdgeDetectionMethod(grayImage,param,...
    1);
logit(expFold_p,'Edge detection Done')

%--- if the image is empty, exit the algo:
if ~any(BW_rough(:))
    return
end

%---remove large shapes---
[BW_roughf]=deleteLargeShape(BW_rough,param);%figure; imshowpair(BW_rough,BW_roughf)
logit(expFold_p,'deleteLargeShape Done')


%% Fiber Splicing

%---Separate object in two categories : 1- Blobs (small fat objects) and
%2-Strands (long thin objects)
[imStrand,imBlob] = separateSkelvsBlob(BW_roughf,param);%figure; imshowpair(imSkel,imBlob)
logit(expFold_p,'separateSkelvsBlob Done')

%CheckpointSaving (if you want to debug the code from here without starting afresh)
save(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
    'checkpointBeforeMainFiberSplice.mat'));

%--- Fiber Splicing-----
logit(expFold_p,'FiberSplicing...')
listSkel = mainFiberSplice(imStrand,imBlob,BW_rough,grayImage,param,...
    fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1)));
%Important Tip : to observe listkel, use the function "segm2Im"...
%...example : figure; imshow(segm2Im(listSkel,'',0))
logit(expFold_p,'FiberSplicing Done')
save(fullfile(expFold_p,'Results',imName_i(1:end-lengthFormat-1),...
     'listSkelAfterMainFiberSplice.mat'),'listSkel');

%--- Write the maximum density on each fiber segmented (eg. see
%listSkel{1}.maxDensity)
listSkel = setDensityOnSkel(listSkel,BW_rough,param);

%% Step : Color assignment
intIm = imgaussfilt(I_rgN,param.thicknessFib/5,'Padding','symmetric');
listSkel = findRedAndGreenLimit(listSkel,intIm,param);
logit(expFold_p,'Color assignment Done')

%% Build the result spreadsheet
[listSkel,Results_AllFibers] = buildResultTable(...
    listSkel, imName_i,WhichChannelIsWhat);%figure; imshow(segm2Im(listSkel,'',0))
[Results_BicolorFibers]=buildResultTableForBicolorFiber(...
    Results_AllFibers,WhichChannelIsWhat);
indBico = Results_AllFibers.nb_Of_Parts==2;

%% SAVE RESULT IMAGES AND SPREADSHEET IN THE RESULT FOLDER
% For this part you need the computer vision toolbox
skelSegm      = segm2Im(listSkel,'',0); 
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