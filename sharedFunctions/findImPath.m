function  [imName,imPath] = findImPath(Operation,expFold_p)
if~exist(fullfile(expFold_p,'Results'),'dir')
    mkdir(fullfile(expFold_p,'Results'))
end
if  strcmp(Operation,'manual')
    
    imName =  dir(expFold_p); imName = {imName.name};imName=imName(3:end);
    imName(contains(imName,'COLOR_BLIND'))=[];
    imName = imName(contains(imName,'hela'));
    imPath = fullfile(expFold_p,imName);
elseif strcmp(Operation,'timeExp')
    imName =  dir(expFold_p); imName = {imName.name};imName=imName(3:end);
    imName(find(strcmp(imName,'Results'))) = [];
    imName(find(strcmp(imName,'AnalysisStrand'))) = [];
    imName(find(strcmp(imName,'imParam.mat'))) = [];
    imName(find(strcmp(imName,'AE.txt'))) = [];
    imPath = fullfile(expFold_p,imName);
elseif strcmp(Operation,'validation')
    [imPath,imName] = loadPathToValidationImages;
elseif strcmp(Operation,'JF')
    imName =  dir([expFold_p '\*.tif']);imName={imName.name};
    imPath = fullfile(expFold_p,imName);
elseif strcmp(Operation,'Mary')
    imName =  dir([expFold_p '\*.dv']);imName={imName.name};
    imPath = fullfile(expFold_p,imName);
end