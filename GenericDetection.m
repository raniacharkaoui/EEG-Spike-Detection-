function [GenericTemplate,PremDet] = GenericDetection(File,DetectionParameters,nrElectrodeLeft,nrElectrodeRight,fileData,AlphaWaves_TimeIn,AlphaWaves_TimeOut)

% ************************************************************************
% Fonction principale de d�tection des SW  par patient et par d�rivation.
% ************************************************************************
        
% A generic template is used
[GenericTemplate] = GenerateGenericTemplate(DetectionParameters,File.Recordings,nrElectrodeLeft,nrElectrodeRight,fileData);

% Premi�re lecture
PremDet = SpikeDetection(File,DetectionParameters,GenericTemplate,nrElectrodeLeft,nrElectrodeRight,fileData,AlphaWaves_TimeIn,AlphaWaves_TimeOut);