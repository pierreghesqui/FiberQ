clear
addpath(genpath(fullfile('..','sharedfunctions')))
pathTemporal = {'..\..\temporalImages\10 min',
'..\..\temporalImages\20 min',
'..\..\temporalImages\30 min',
'..\..\temporalImages\40 min',
'..\..\temporalImages\50',
'..\..\temporalImages\60',
'..\..\temporalImages\70',
'..\..\temporalImages\80',
'..\..\temporalImages\90'};
pathValidationExp = {'..\..\dna2\_97For Pierre\Exp6\20170910_50EtOH_noHU_1',
    '..\..\dna2\_97For Pierre\Exp6\20170831_50EtOH_HU_3',
    '..\..\dna2\_97For Pierre\Exp8\HeLa_0HU_0HG',
    '..\..\dna2\_97For Pierre\Exp8\HeLa_200HU_02HG',
    '..\..\dna2\Mary_2_20180308\2HG',
    '..\..\dna2\Mary_2_20180308\DMSO'};
allPath = {pathTemporal{:},pathValidationExp{:}}';
pathValidationExp=pathValidationExp';
pathTemporal=pathTemporal';
%% path Manual
