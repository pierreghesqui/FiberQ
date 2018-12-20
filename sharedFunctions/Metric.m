classdef Metric < handle
    %PSF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PSF
        maxDiameterForSkel
        maxDist4ConnectionS
        maxDist4ConnectionB
        DensityStd
        minLength4Skeleton
        maxSmoothRange
        endDistAnalysis
        threshDensity
        alpha4window = 18;
        minLength4SkeletonBefore
        thicknessFib
        sizeLoGFilter
        sizeCannyDil
        minPulseLength
    end
    
    methods
        function obj =Metric(PSF,EOPs)
            %run(fullfile(path2Param,'FASTParameters.m'));
%             EOP1=8; %Set the size of the area used to calculate fiber density
%             EOP2=0.17; % Normalised density threshold
%             EOP3=3.6; %Set Maximum fiber Width
%             EOP4=1; %Set the kernel size of the Laplacian of Gaussian filter
%             EOP5=2; %Set the length of the structural element for dilating Canny's edge
%             EOP6=9; %Set the minimum length for a Strand
%             EOP7=6; %Set the Set the spanning length of the 1st degree polynomial for smoothing fiber skeletons
%             EOP8=13.5; %Set the maximum splicing width
%             EOP9=15; %Set the minimum length of a fiber after splicing
%             EOP10=6; %Set the minimum length of a pulse section within a fiber
            EOP1 = EOPs.EOP1;
            EOP2 = EOPs.EOP2;
            EOP3 = EOPs.EOP3;
            EOP4 = EOPs.EOP4;
            EOP5 = EOPs.EOP5;
            EOP6 = EOPs.EOP6;
            EOP7 = EOPs.EOP7;
            EOP8 = EOPs.EOP8;
            EOP9 = EOPs.EOP9;
            EOP10 = EOPs.EOP10;
            thickness = round(3*PSF);
            obj.thicknessFib = thickness;
            obj.PSF = PSF;
            obj.DensityStd=round(EOP1*PSF);%EOP1
            obj.threshDensity = EOP2;%EOP2
            obj.maxDiameterForSkel=EOP3*PSF;%EOP3
            obj.sizeLoGFilter = EOP4*PSF;%EOP4 ROUND ?
            obj.sizeCannyDil = EOP5*PSF; %EOP5 ROUND?
            obj.minLength4SkeletonBefore=round(EOP6*PSF);%EOP6
            obj.maxSmoothRange = round(EOP7*PSF);%EOP7
            obj.maxDist4ConnectionS=round(EOP8*PSF);%EOP8
            obj.maxDist4ConnectionB=round((EOP8+1.5)*PSF);%EOP8
            obj.minLength4Skeleton=round(EOP9*PSF);%EOP9
            obj.endDistAnalysis = round(1.5*thickness);
            obj.minPulseLength = round(EOP10*PSF);%EOP10

        end
   
    end
end

