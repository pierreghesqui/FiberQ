function expFold = loadFilesPath(Operation)
if  strcmp(Operation,'manual')
    rootFolder = '..\imageToSegment2';
    [ expFold ] = findSubfolders( rootFolder );
%     expFold = dir(rootFolder);tag = [expFold.isdir]; expFold={expFold.name};expFold(~tag)=[];expFold=expFold(3:end);%end-3
%     expFold = fullfile(rootFolder,expFold);

elseif strcmp(Operation,'timeExp')
    rootFolder = '..\dna2';
    expFold = findSubfolders(rootFolder);
    expFold([5,6,14:length(expFold)]) = [];
elseif strcmp(Operation,'validation')
    expFold = {'..\dna2\_97For Pierre'};

elseif strcmp(Operation,'JF')
    expFold = {};
    rootFolder1 = '..\dna2\2018-02-29 - DNA Fibers - siRNA - UVC - HU';
    rootFolder2 = '..\dna2\2018-02-29 - DNA Fibers - siRNA - UVC - HU2';
    subFold1 =  findSubfolders( rootFolder1 );
    subFold2 = findSubfolders( rootFolder2 );
    subFold = {subFold1{:},subFold2{:}};
    for i = 1:length(subFold)
        subsubFold = findSubfolders( subFold{i} );
        expFold = {expFold{:},subsubFold{:}};
        
    end
    expFold = expFold';


elseif strcmp(Operation,'Mary')
    expFold = {'..\dna2\Mary_2_20180308\DMSO',...
        '..\dna2\Mary_2_20180308\2HG'};
    
    expFold = expFold';
end
end