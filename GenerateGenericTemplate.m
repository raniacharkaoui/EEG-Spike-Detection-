%Generate the template and its features
%allowing the spike detection later

function [GenericTemplate] =  GenerateGenericTemplate(DetectionParameters,Recording,nrElectrodeLeft,nrElectrodeRight,fileData)

EndWindow = round(DetectionParameters.Fs*DetectionParameters.WindowLength/1000);
MidSpike = round(DetectionParameters.Fs*20/1000); % 20ms
EndSpike = round(DetectionParameters.Fs*40/1000); % 40ms

V(round(1.33*EndWindow))=0; 
data = [];

%The amplitude of the generic spike has been chosen according to an
%analysis. See the report on optimization of the algorithm for more details
for k=1:length(Recording.timeIn)
    [raw_data] = GetData(Recording.timeIn(k),Recording.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Recording.fname,DetectionParameters,fileData); %Read EEG data
    data = [data;raw_data];
end
GenericTemplateAmplitude = 9.3*std(Filter(data',DetectionParameters))-21.76;

for i = 1:1:MidSpike
    V(i) = round(i*GenericTemplateAmplitude/MidSpike);
end

for i = MidSpike:1:EndSpike
    V(i) = round(GenericTemplateAmplitude-(i-MidSpike)*GenericTemplateAmplitude/MidSpike);
end

ProcessedData = PreProcessing(V',DetectionParameters);
ProcessedData = ProcessedData(1:EndWindow);
GenericTemplate.Exists = 1;
GenericTemplate.Template = ProcessedData;
GenericTemplate.TemplateLength = length(ProcessedData);
GenericTemplate.TemplateNorm = norm(ProcessedData);
[GenericTemplate.RisingSlope,PositionRisingSlope] = max(ProcessedData);
GenericTemplate.RisingSlope = sqrt(abs(GenericTemplate.RisingSlope));
[GenericTemplate.FallingSlope,PositionFallingSlope] = min(ProcessedData);
GenericTemplate.FallingSlope = -sqrt(abs(GenericTemplate.FallingSlope));
GenericTemplate.Curvature = abs((GenericTemplate.RisingSlope - GenericTemplate.FallingSlope)/(PositionRisingSlope - PositionFallingSlope)); 

GenericTemplate.RisingSlopeThreshold = GenericTemplate.RisingSlope*DetectionParameters.GenericFeaturesThresh; 
GenericTemplate.FallingSlopeThreshold = GenericTemplate.FallingSlope*DetectionParameters.GenericFeaturesThresh; 
GenericTemplate.CurvatureThreshold = GenericTemplate.Curvature*DetectionParameters.GenericFeaturesThresh; 
GenericTemplate.CorrelationThreshold = DetectionParameters.GenericCrossCorrelationThresh;
GenericTemplate.Amplitude = peak2peak(Filter(V',DetectionParameters));
GenericTemplate.AmplitudeSTD = std(Filter(V',DetectionParameters));