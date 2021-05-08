function [PatientSpecificDetSpikes] = SecDetFromClusters(File,DetectionParameters,Clusters,nrElectrodeLeft,nrElectrodeRight,fileData,artifactsTimeIn,artifactsTimeOut)

PatientSpecificDetSpikesCluster(Clusters.NumClusters).Det = []; 

for CurrentCluster = 1:Clusters.NumClusters
    
    Clusters.PatientSpecificDetSpikesResult(CurrentCluster).SpikeRawData = [];
    if sum(CurrentCluster == Clusters.RejectedClusters)==0

        PatientSpecificDetectionParameters.Template = Clusters.Centroids(CurrentCluster,:);
        PatientSpecificDetectionParameters.TemplateLength = length(PatientSpecificDetectionParameters.Template);
        PatientSpecificDetectionParameters.TemplateNorm = norm(PatientSpecificDetectionParameters.Template);

        PatientSpecificDetectionParameters.RisingSlopeThreshold = mean(Clusters.FeatureCluster(CurrentCluster).RisingSlope)*DetectionParameters.PatientSpecificFeaturesThresh;
        PatientSpecificDetectionParameters.FallingSlopeThreshold = mean(Clusters.FeatureCluster(CurrentCluster).FallingSlope)*DetectionParameters.PatientSpecificFeaturesThresh;
        PatientSpecificDetectionParameters.CurvatureThreshold = mean(Clusters.FeatureCluster(CurrentCluster).Curvature)*DetectionParameters.PatientSpecificFeaturesThresh;
        PatientSpecificDetectionParameters.CorrelationThreshold = DetectionParameters.PatientSpecificCrossCorrelationThresh;

        PatientSpecificDetSpikesCluster(CurrentCluster).Det = SpikeDetection(File,DetectionParameters,PatientSpecificDetectionParameters,nrElectrodeLeft,nrElectrodeRight,fileData,artifactsTimeIn,artifactsTimeOut);

    end
end
timeIn = sort([File.Recordings.timeIn;artifactsTimeIn]);
PatientSpecificDetSpikes = AddAndSortDetect(PatientSpecificDetSpikesCluster,round(DetectionParameters.MinimumDistance2Spikes/1000*DetectionParameters.Fs),timeIn);
