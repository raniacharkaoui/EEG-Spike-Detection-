function [GenericTemplate,PremDet] = GenericDetection(File,DetectionParameters,nrElectrodeLeft,nrElectrodeRight,fileData,AlphaWaves_TimeIn,AlphaWaves_TimeOut)

% ************************************************************************
% Fonction principale de détection des SW  par patient et par dérivation.
% ************************************************************************
        
% A generic template is used
[GenericTemplate] = GenerateGenericTemplate(DetectionParameters,File.Recordings,nrElectrodeLeft,nrElectrodeRight,fileData);

% Première lecture
PremDet = SpikeDetection(File,DetectionParameters,GenericTemplate,nrElectrodeLeft,nrElectrodeRight,fileData,AlphaWaves_TimeIn,AlphaWaves_TimeOut);