function [imPath,imName] =   loadPathToValidationImages
imPath = {...
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp1\293-0-HU\293-0-HU_16_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp1\293-50-HU\293-HU50_16_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp1\293_100uM_HU\293-100-HU_25_R3D.dv'%%%
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp1\293_100uM_HU\293-100-HU_30_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp2\1366_HU\1366_HU_dd_38_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp2\1366_HU_mirin\1366_HU_m_dd_16_R3D.dv'%%%
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp2\3248_HU\3248_HU_dd_50_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp2\3284_HU_mirin\3248_HU_m_dd_02_R3D.dv'%%%
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp3\WM35_HU\WM35_HU34_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp3\WM278_HU\WM278_HU32_R3D.dv'%10
    %'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp3\WM35_HU_RI1\WM35_HU_RI1_29_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp4\WM1341D_HU\WM1341D_HU02_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp4\WM1617_HU\WM1617_HU05_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp6\20170828_HeLa100EtOHHU_7\20170828_HeLa100EtOHHU_7_11_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp6\20170828_HeLa100MLHU_8\20170828_HeLa100MLHU_8_29_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp7\0409_HU\0409_HU_1_03_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp7\GINS_HU\GINS_HU_1_27_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp7\0409_no\0409_no_2_33_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp7\GINS_no\GINS_no_13_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp7\20170919_58350016_HU\20170919_58350016_no_1_20_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp7\20170919_58350016_no\20170919_58350016_no_act_11check_54_R3D.dv'%%20
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp8\HeLa_0HU_0HG\HeLa_0HU_02HG_50_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp8\HeLa_0HU_4mM2HG\HeLa_0HU_4mM2HG_27_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp8\HeLa_200HU_02HG\HeLa_200HU_02HG_22_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp8\HeLa_200HU_4mM2HG\HeLa_200HU_4mM2HG_23_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp9\DMSO1\20171101_DMSO1_43_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp9\2HG1\20171101_2HG1_77_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp10\NHA_DMSO\20171130_NHA_DMSO_B_14_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp10\NHA_DMSO\20171130_NHA_DMSO_B_12_R3D.dv'%%%
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp10\NHA_DMSO\20171130_NHA_DMSO_A_20_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp11\HeLa_DMSO_1\HeLa_DMSO_1_A_06_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\Exp11\HeLa_mirin\HeLa_mirin_1_A_27_R3D.dv'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\1.png'%%%
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\2.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\3.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\4.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\5.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\6.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\7.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\8.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\9.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv gfp uv\11.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\12.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\13.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\14.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\15.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\16.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\17.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\18.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\19.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\20.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\21.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\22.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\_97For Pierre\xpv-rpa-gfp\xpv-rpa-uv\23.png'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 HU\D1.tif'%D1
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 HU\D2.tif'%D2
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 HU\D3.tif'%D3
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 HU\D4.tif'%D4
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 HU\D5.tif'%D5
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 T0\A1.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 T0\A2.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 T0\A3.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 T0\A4.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL3 T0\A5.tif'%A5
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 HU\I1.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 HU\I2.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 HU\I3.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 HU\I4.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 HU\I5.tif'%I5
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 T0\F1.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 T0\F2.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 GFP CL4 T0\F3.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 HU\B1.tif'%B1
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 HU\B3.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 HU\B4.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 HU\B5.tif'%B5
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 T0\J1.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 T0\J2.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 T0\J3.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 T0\J4.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL6 T0\J5.tif'%J5
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 HU\H1.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 HU\H2.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 HU\H3.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 HU\H4.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 HU\H5.tif'%H5
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 T0\C1.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 T0\C2.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 T0\C3.tif'
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL11 T0\C4.tif'%C4
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 HU\G1.tif'%G1
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 HU\G2.tif'%G2
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 HU\G3.tif'%G3
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 HU\G4.tif'%G4
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 HU\G5.tif'%G5
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 T0\E1.tif'%E1
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 T0\E2.tif'%E2
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 T0\E3.tif'%E3
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 T0\E4.tif'%E4
    'P:\Desktop\Dropbox (Biophotonics)\ADN\dna2\Pour Pierre\OV1946 RPA CL12 T0\E5.tif'%E5
    };
impath2 = {};
for i = 1 :size(imPath,1)
C =  strsplit(imPath{i},'ADN');
str = C{2};
impath2 = {impath2{:},['..\..\..\' str(2:end)]};
end
imPath = impath2;
imName = {};
for i = 1 :size(imPath,2)
C =  strsplit(imPath{i},'\');
str = C{end};
imName = {imName{:},str};
end
imPath =imPath';
imName = imName';
end
  
    
    
    
    
    
    
    
    
    
    
    
    