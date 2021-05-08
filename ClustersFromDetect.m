function [Clusters] = ClustersFromDetect(ClusterSelectionThresh,DetectedSpikes)

if isempty(DetectedSpikes)
    NumDetectedSpikes = 0;
else
    NumDetectedSpikes = length(DetectedSpikes.ProcessedSpikes(:,1));
end

if NumDetectedSpikes>1
    % Sort spikes as a function of energies for IC. 
    SpikeEngergy = std(DetectedSpikes.ProcessedSpikes,0,2);
    SortedSpikes = sortrows([SpikeEngergy' ; DetectedSpikes.ProcessedSpikes']',1);
    SortedSpikes(:,1) = [];
    
    % Starting from one single cluster, the number of clusters increases until one
    % or more clusters contain less than 5% of the spikes
    NumClusters = 0;
    MinClustr = NumDetectedSpikes;
    while (MinClustr/NumDetectedSpikes > ClusterSelectionThresh) && (NumClusters<NumDetectedSpikes)
        NumClusters = NumClusters + 1;
        
        % Divide spikes in classes as a function of energies for IC. 
        for i = 1:NumClusters
            LowerBound = ceil((i-1)*(NumDetectedSpikes-1)/NumClusters+1);
            UpperBound = floor(i*(NumDetectedSpikes-1)/NumClusters+1);
            IC(i,:) = mean(SortedSpikes(LowerBound:UpperBound,:));
        end
        
        % Clustering
        warning('off','all'); % Stop display warning in case of empty cluster
        [ClusterIndices,Centroids] = kmeans(DetectedSpikes.ProcessedSpikes,NumClusters,'distance','correlation','start',IC,'emptyaction','drop');
        warning('on','all');
        
        countClust = histc(ClusterIndices,1:NumClusters);
        MinClustr = min(countClust);
    end
    
%     figure ; plot(IC(1,:));
%     figure ; plot(IC(2,:));
%     figure ; plot(IC(3,:));
%     figure ; plot(IC(4,:));
%     figure ; plot(IC(5,:));
%     figure ; plot(IC(6,:));
    % Removing empty clusters
    tempClusterIndices = ClusterIndices;
    tempCluster = 0;
    for i = 1:NumClusters
        if countClust(i) > 0
            tempCluster = tempCluster +1;
            tempCentroids(tempCluster,:) = Centroids(i,:);
        else
            for j = 1:length(tempClusterIndices)
                if tempClusterIndices(j) >= i
                    tempClusterIndices(j) = tempClusterIndices(j) - 1;
                end
            end
        end
    end
    Centroids = tempCentroids;
    NumClusters = tempCluster;
    ClusterIndices = tempClusterIndices;
        
    % The cluster, or the clusters, showing less than 5% of spikes are
    % discarded.
    countClust = histc(ClusterIndices,1:NumClusters);
    RejectedClusters = [];
%     disp(countClust)
%     disp(NumDetectedSpikes)
   
    for i = 1:NumClusters
        if  countClust(i)/NumDetectedSpikes < ClusterSelectionThresh
            RejectedClusters = [RejectedClusters i];
        end
    end
        
    for i = 1:NumClusters
        SpikeIndex = 1;
        for j = 1:length(ClusterIndices)
             if ClusterIndices(j) == i
                 FeatureCluster(i).RisingSlope(SpikeIndex) = DetectedSpikes.RisingSlope(j);
                 FeatureCluster(i).FallingSlope(SpikeIndex) = DetectedSpikes.FallingSlope(j);
                 FeatureCluster(i).Curvature(SpikeIndex) = DetectedSpikes.Curvature(j);
                 SpikeIndex = SpikeIndex + 1;
             end
        end
    end
else
    Clusters = [];
end

Clusters.Centroids = Centroids;
Clusters.RejectedClusters = RejectedClusters;
Clusters.NumClusters = NumClusters;
Clusters.FeatureCluster = FeatureCluster;