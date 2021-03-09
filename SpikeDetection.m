function [DetectedSpikes] = SpikeDetection(File,DetectionParameters,ReferenceSpike,nrElectrodeLeft,nrElectrodeRight,fileData,artifactsTimeIn,artifactsTimeOut)
    Fs = DetectionParameters.Fs;
    DetectedSpikes = [];
    DetectedSpikes.NoGoodFeatures = [];
    SpikeIndex = 1;
    Index = 1;
    Recording = File.Recordings;


    %Delete the parts with the alpha waves
    backgroundTimes = sort([Recording.timeIn Recording.timeOut;artifactsTimeOut artifactsTimeIn]);
    Recording.timeIn = backgroundTimes(:,1);
    Recording.timeOut = backgroundTimes(:,2);

    for k=1:length(Recording.timeIn)

        % Data length must be larger than 15 samples so the the difference
        % between Time out and Time In must be greater than min_time
        min_time = 15/Fs;
        if (Recording.timeIn(k) < Recording.timeOut(k)) && (Recording.timeOut(k) - Recording.timeIn(k) > min_time)
            [RawData] = GetData(Recording.timeIn(k),Recording.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Recording.fname,DetectionParameters,fileData);
            [ProcessedData] = PreProcessing(RawData,DetectionParameters);    
            signal = ProcessedData;
            if length(signal) >= ReferenceSpike.TemplateLength %the signal must be the same size or larger than TEMPLATE.

                VprodScNorm = normxcorr2(ReferenceSpike.Template,signal);
                VprodScNorm = VprodScNorm(ReferenceSpike.TemplateLength:end);

                minpeakh = ReferenceSpike.CorrelationThreshold;
                minpeakdist = round(DetectionParameters.MinimumDistance2Spikes/1000*DetectionParameters.Fs);

                warning('off','all'); %Stop displaying warning if no data points greater than MinPeakHeight
                [~,locs] = findpeaks(VprodScNorm,'MINPEAKHEIGHT',minpeakh,'MINPEAKDISTANCE',minpeakdist);
                warning('on','all');
                % Alternative to findpeaks function which is much faster
                %[locs ,~] = peakseek(VprodScNorm,minpeakdist,minpeakh);


                EpochSpikeIndex = 1;
                while EpochSpikeIndex <= length(locs)
                    CurrentSpike = signal(locs(EpochSpikeIndex):min([locs(EpochSpikeIndex)+ReferenceSpike.TemplateLength-1,length(signal)]));
                    [RisingSlope,PositionRisingSlope] = max(CurrentSpike);
                    [~,posRS] = find(signal==RisingSlope);
                    RisingSlope = sqrt(abs(RisingSlope));
                    [FallingSlope,PositionFallingSlope] = min(CurrentSpike);
                    [~,posFS] = find(signal==FallingSlope);
                    FallingSlope = -sqrt(abs(FallingSlope));
                    Curvature = abs((RisingSlope - FallingSlope)/(PositionRisingSlope - PositionFallingSlope)); 
                    ampCC = RisingSlope-FallingSlope;

                    if ampCC >= (ReferenceSpike.RisingSlopeThreshold-ReferenceSpike.FallingSlopeThreshold) && ampCC >= 5 && Curvature>ReferenceSpike.CurvatureThreshold && (length(CurrentSpike)==ReferenceSpike.TemplateLength)
                        DetectedSpikes.ProcessedSpikes(SpikeIndex,:) = CurrentSpike;
                        DetectedSpikes.RisingSlope(SpikeIndex) = RisingSlope;
                        DetectedSpikes.PositionRisingSlope(SpikeIndex) = posRS;
                        DetectedSpikes.FallingSlope(SpikeIndex) = FallingSlope;
                        DetectedSpikes.PositionFallingSlope(SpikeIndex) = posFS;
                        DetectedSpikes.Curvature(SpikeIndex) = Curvature;
                        SpikeIndex = SpikeIndex + 1;
                        EpochSpikeIndex = EpochSpikeIndex + 1;
                    else
                        % DetectedSpikes.NoGoodFeatures.ProcessedSpikes(Index,:) = CurrentSpike;
                        DetectedSpikes.NoGoodFeatures.RisingSlope(Index) = RisingSlope;
                        DetectedSpikes.NoGoodFeatures.PositionRisingSlope(Index) = posRS;
                        DetectedSpikes.NoGoodFeatures.FallingSlope(Index) = FallingSlope;
                        DetectedSpikes.NoGoodFeatures.PositionFallingSlope(Index) = posFS;
                        DetectedSpikes.NoGoodFeatures.Curvature(Index) = Curvature;
                        noGoodFeaturesLocs(1,Index) = locs(EpochSpikeIndex);
                        Index=Index+1;
                        locs(EpochSpikeIndex) = [];
                    end
                end

                if ~isempty(DetectedSpikes.NoGoodFeatures)
                    %DetectedSpikes.NoGoodFeatures.ProcessedSpikes = DetectedSpikes.ProcessedSpikes(1:Index-1,:);
                    DetectedSpikes.NoGoodFeatures.RisingSlope = DetectedSpikes.NoGoodFeatures.RisingSlope(1:Index-1);
                    DetectedSpikes.NoGoodFeatures.PositionRisingSlope = DetectedSpikes.NoGoodFeatures.PositionRisingSlope(1:Index-1);
                    DetectedSpikes.NoGoodFeatures.FallingSlope = DetectedSpikes.NoGoodFeatures.FallingSlope(1:Index-1);
                    DetectedSpikes.NoGoodFeatures.PositionFallingSlope = DetectedSpikes.NoGoodFeatures.PositionFallingSlope(1:Index-1);
                    DetectedSpikes.NoGoodFeatures.Curvature = DetectedSpikes.NoGoodFeatures.Curvature(1:Index-1);
                    DetectedSpikes.NoGoodFeatures.Epoch.DetectedTime = [1000*Recording.timeIn(k)+round(1000/DetectionParameters.Fs)*noGoodFeaturesLocs' 1000*Recording.timeIn(k)+round(1000/DetectionParameters.Fs)*(noGoodFeaturesLocs+ReferenceSpike.TemplateLength)'];
                end

                if length(fieldnames(DetectedSpikes))>1
                    DetectedSpikes.ProcessedSpikes = DetectedSpikes.ProcessedSpikes(1:SpikeIndex-1,:);
                    DetectedSpikes.RisingSlope = DetectedSpikes.RisingSlope(1:SpikeIndex-1);
                    DetectedSpikes.PositionRisingSlope = DetectedSpikes.PositionRisingSlope(1:SpikeIndex-1);
                    DetectedSpikes.FallingSlope = DetectedSpikes.FallingSlope(1:SpikeIndex-1);
                    DetectedSpikes.PositionFallingSlope = DetectedSpikes.PositionFallingSlope(1:SpikeIndex-1);
                    DetectedSpikes.Curvature = DetectedSpikes.Curvature(1:SpikeIndex-1);
                    DetectedSpikes.Epoch(k).DetectedTime = [1000*Recording.timeIn(k)+round(1000/DetectionParameters.Fs)*locs' 1000*Recording.timeIn(k)+round(1000/DetectionParameters.Fs)*(locs+ReferenceSpike.TemplateLength)'];
                else
                    DetectedSpikes.ProcessedSpikes = [];
                    DetectedSpikes.RisingSlope = [];
                    DetectedSpikes.PositionRisingSlope = [];
                    DetectedSpikes.FallingSlope = [];
                    DetectedSpikes.PositionFallingSlope = [];
                    DetectedSpikes.Curvature = [];
                    DetectedSpikes.Epoch(k).DetectedTime = [];
                end
            end
        end
    end
    if length(DetectedSpikes.Epoch) ~= k
        DetectedSpikes.Epoch(k).DetectedTime = [];
    end
end
