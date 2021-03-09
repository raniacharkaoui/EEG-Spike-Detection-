%This function allows to have details about spikes detected by experts
%Author : Emelyne Vignon
%Contact : emelyne.vignon@reseau.eseo.fr

function [DetectedSpikesExp] = ExpFeatures(File,Recordings,DetectionParameters,nrElectrodeLeft,nrElectrodeRight,fileData)

    [raw_data] = GetData(0,fileData.Data.timeSpan,nrElectrodeLeft,nrElectrodeRight,Recordings.fname,DetectionParameters,fileData); %Read EEG data
    interval = length(raw_data);
    time = linspace(0,fileData.Data.timeSpan,interval); %In seconds

    [ProcessedData] = PreProcessing(raw_data,DetectionParameters); 

    nbExp = File.nbExp;

    if nbExp == 2 || nbExp == 0
      [Exp_timeIn,Exp_timeOut,~,~] = Same_Spikes(File.Exp_timeIn.Expert1,File.Exp_timeOut.Expert1,File.Exp_timeIn.Expert2,File.Exp_timeOut.Expert2);
    elseif nbExp == 3
        [Exp12_timeIn,Exp12_timeOut,~,~] = Same_Spikes(File.Exp_timeIn.Expert1,File.Exp_timeOut.Expert1,File.Exp_timeIn.Expert2,File.Exp_timeOut.Expert2);
        [Exp23_timeIn,Exp23_timeOut,~,~] = Same_Spikes(File.Exp_timeIn.Expert2,File.Exp_timeOut.Expert2,File.Exp_timeIn.Expert3,File.Exp_timeOut.Expert3);
        [Exp31_timeIn,Exp31_timeOut,~,~] = Same_Spikes(File.Exp_timeIn.Expert3,File.Exp_timeOut.Expert3,File.Exp_timeIn.Expert1,File.Exp_timeOut.Expert1);

        Exp_timeIn = unique([Exp12_timeIn;Exp23_timeIn;Exp31_timeIn]);
        Exp_timeOut = unique([Exp12_timeOut;Exp23_timeOut;Exp31_timeOut]);
%         Exp_timeIn = [File.Exp_timeIn.Expert1;0;File.Exp_timeIn.Expert2;0;File.Exp_timeIn.Expert3;0];
%         Exp_timeOut = [File.Exp_timeOut.Expert1;0;File.Exp_timeOut.Expert2;0;File.Exp_timeOut.Expert3;0];
%         
%         [Exp_timeIn,Exp_timeOut] = DerivationFusion(Exp_timeIn,Exp_timeOut,File,false)
    end

    SpikeIndex = 1;
    risingSlopeTot = 0;
    fallingSlopeTot = 0;
    curvatureTot = 0;

    for i=1:length(Exp_timeIn)
        x=find(time>=Exp_timeIn(i)/1000 & time<=Exp_timeOut(i)/1000);
        CurrentSpike = ProcessedData(x(1):x(end));

        [RisingSlope,PositionRisingSlope] = max(CurrentSpike);
        [~,posRS] = find(ProcessedData==RisingSlope);
        RisingSlope = sqrt(abs(RisingSlope));
        [FallingSlope,PositionFallingSlope] = min(CurrentSpike);
        [~,posFS] = find(ProcessedData==FallingSlope);
        FallingSlope = -sqrt(abs(FallingSlope));
        Curvature = abs((RisingSlope - FallingSlope)/(PositionRisingSlope - PositionFallingSlope));

        risingSlopeTot = risingSlopeTot + RisingSlope;
        fallingSlopeTot = fallingSlopeTot + FallingSlope;
        curvatureTot = curvatureTot + Curvature;

        ampCC = RisingSlope + abs(FallingSlope);
        if i==1
            ampCCMin = ampCC;
            ampCCMax = ampCC;
        else
            ampCCMin = min(ampCCMin,ampCC);
            ampCCMax = max(ampCCMax,ampCC);
        end

        DetectedSpikesExp.ProcessedSpikes(SpikeIndex,:) = CurrentSpike;
        DetectedSpikesExp.RisingSlope(SpikeIndex) = RisingSlope;
        DetectedSpikesExp.PositionRisingSlope(SpikeIndex) = posRS;
        DetectedSpikesExp.FallingSlope(SpikeIndex) = FallingSlope;
        DetectedSpikesExp.PositionFallingSlope(SpikeIndex) = posFS;
        DetectedSpikesExp.Curvature(SpikeIndex) = Curvature;
        SpikeIndex = SpikeIndex + 1;
    end

    DetectedSpikesExp.AmpCCMin = ampCCMin;
    DetectedSpikesExp.AmpCCMax = ampCCMax;
    DetectedSpikesExp.RisingSlopeMean = risingSlopeTot/length(DetectedSpikesExp.RisingSlope);
    DetectedSpikesExp.FallingSlopeMean = fallingSlopeTot/length(DetectedSpikesExp.FallingSlope);
    DetectedSpikesExp.CurvatureMean = curvatureTot/length(DetectedSpikesExp.Curvature);
end