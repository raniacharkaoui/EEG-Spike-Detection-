%This function is used in order to analyze the impact 
%of the different detection parameters on the algorithm
%Author : Emelyne Vignon
%Contact : emelyne.vignon@reseau.eseo.fr

function AnalyzeParam()
    load('Spikes.mat','file');

    for CurrentRecording = 1 : length(file)
        AnalyzeParamFile(CurrentRecording).Name = file(CurrentRecording).Name;
        DetectionParameters = file(CurrentRecording).DetectionParameters;
        AnalyzeParamFile(CurrentRecording).Detail.DetectionParameters = DetectionParameters;

        Recordings = file(CurrentRecording).Recordings;
        fileName = file(CurrentRecording).Name;
        path = file(CurrentRecording).Recordings.path;
        fileData = struct([]);
        if endsWith(fileName,'.mat')
            fileData = load([path '/' fileName]);
        end
        NumDerivation = length(Recordings.nrElectrodeLeft(:,1));
        PatientSpecificDetSpikes(NumDerivation).Det = []; % preallocation for speed


        nbExp = file(CurrentRecording).nbExp;
        Exp1_timeIn = file(CurrentRecording).Exp_timeIn.Expert1;
        Exp2_timeIn = file(CurrentRecording).Exp_timeIn.Expert2;

        %Browse the detection parameters and change one parameter at a time
        %with the values given by the interval
        for detectParam=1:8
%             if detectParam == 1
%                 for paramMin2Spikes=20:20:160
%                     i = length(AnalyzeParamFile(CurrentRecording).Detail);
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.MinimumDistance2Spikes = paramMin2Spikes;
%                     param = 'Min2Spikes = %d';
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramMin2Spikes);
%                 end
%             if detectParam == 2
%                 for paramWindowLength=400:100:700
%                     i = length(AnalyzeParamFile(CurrentRecording).Detail);
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.WindowLength = paramWindowLength;
%                     param = 'WindowLength = %d';
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramWindowLength);
%                 end
%             if detectParam == 3
%                 for paramGCrossCorrelation=0.1:0.1:0.7
%                     i = length(AnalyzeParamFile(CurrentRecording).Detail);
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.GenericCrossCorrelationThresh = paramGCrossCorrelation;
%                     param = 'GCrossCorrelationThresh = %d';
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramGCrossCorrelation);
%                 end
%             if detectParam == 4
%                 for paramGFeatures=0.1:0.05:0.8
%                     i = length(AnalyzeParamFile(CurrentRecording).Detail);
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.GenericFeaturesThresh = paramGFeatures;
%                     param = 'GFeatures = %d';
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramGFeatures);
%                 end
%             elseif detectParam == 5
%                 for paramPSCrossCorrelation=0.1:0.1:1
%                     i = length(AnalyzeParamFile(CurrentRecording).Detail);
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.PatientSpecificCrossCorrelationThresh = paramPSCrossCorrelation;
%                     param = 'PSCrossCorrelationThresh = %d';
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramPSCrossCorrelation);
%                 end
            if detectParam == 6
                for paramPSFeatures=0.4:0.05:0.8
                    i = length(AnalyzeParamFile(CurrentRecording).Detail);
                    AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
                    AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.PatientSpecificFeaturesThresh = paramPSFeatures;
                    param = 'PSFeatures = %d';
                    AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramPSFeatures);
                end
%             elseif detectParam == 7
%                 for paramSWI=0.01:0.01:0.13
%                     i = length(AnalyzeParamFile(CurrentRecording).Detail);
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.PatientSpecificMinimumSWI = paramSWI;
%                     param = 'MinSWI = %d';
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramSWI);
%                 end
%             else
%                 for paramCluster=0.01:0.01:0.1
%                     i = length(AnalyzeParamFile(CurrentRecording).Detail);
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters = DetectionParameters ;
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).DetectionParameters.ClusterSelectionThresh = paramCluster;
%                     param = 'ClusterSelectionThresh = %d';
%                     AnalyzeParamFile(CurrentRecording).Detail(i+1).ParamChanged = sprintf(param,paramCluster);
%                 end
            end
            save('AnalyzeParam.mat','AnalyzeParamFile');
        end
        %Analyze the file for each modified parameter
        for NumAnalyze=1:length(AnalyzeParamFile(CurrentRecording).Detail)
            %[MuscleArtifactsTimeIn,MuscleArtifactsTimeOut] = MuscleArtifactDetection(file(CurrentRecording));
            artifactsTimeIn = []; %MuscleArtifactsTimeIn;
            artifactsTimeOut = []; %MuscleArtifactsTimeOut;
            for Derivation = 1:NumDerivation  
                nrElectrodeLeft = deblank(Recordings.nrElectrodeLeft(Derivation,:));
                nrElectrodeRight = deblank(Recordings.nrElectrodeRight(Derivation,:));
                 DetectParamChanged = AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).DetectionParameters;
                % First step: generic spike detection
                [~,GenDetectedSpikes] = GenericDetection(file(CurrentRecording),DetectParamChanged,nrElectrodeLeft,nrElectrodeRight,fileData,artifactsTimeIn,artifactsTimeOut);
                % Statistics and SWI for first detection
                StatGenDet = SingleDerStats(GenDetectedSpikes,Recordings,artifactsTimeIn,artifactsTimeOut);

                % Patient-specific detection
                if false %StatGenDet.SWI>=DetectionParameters.PatientSpecificMinimumSWI
                    [Clusters] = ClustersFromDetect(DetectionParameters.ClusterSelectionThresh,GenDetectedSpikes);
                    PatientSpecificDetSpikes(Derivation).Det = SecDetFromClusters(file(CurrentRecording),DetectParamChanged,Clusters,nrElectrodeLeft,nrElectrodeRight,fileData,artifactsTimeIn,artifactsTimeOut);
                else
                    PatientSpecificDetSpikes(Derivation).Det = GenDetectedSpikes;
                end
                AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).PatientSpecificDetSpikes = PatientSpecificDetSpikes;
            end
            AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).PatientSpecificDetSpikes = PatientSpecificDetSpikes;


            PatientSpecificDetSpikes1 = AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).PatientSpecificDetSpikes;
            [Algo_timeIn,Algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes1);
            if length(PatientSpecificDetSpikes1)>2
                [Algo_timeIn,Algo_timeOut] = DerivationFusion(Algo_timeIn,Algo_timeOut,file(CurrentRecording),true);
            end

            Exp1_timeOut = Exp1_timeIn + DetectParamChanged.WindowLength;
            Exp2_timeOut = Exp2_timeIn + DetectParamChanged.WindowLength;

            if nbExp == 2 || nbExp == 0
                % Calculation of precision and sensitivity - Inter Expert 
            %[SensitivityA,PrecisionA] = StatMesures_Two(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut);

            % Calculation of precision and sensitivity - Algo VS Experts  
            [SensitivityAlgo,PrecisionAlgo] = StatMesures_algo_Two(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut, Algo_timeIn, Algo_timeOut);

            elseif nbExp == 3
                Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
                Exp3_timeOut = Exp3_timeIn + DetectParamChanged.WindowLength;

                % Calculation of precision and sensitivity - Inter Expert
                %[SensitivityA,PrecisionA] = StatMesures_Three(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut,Exp3_timeIn,Exp3_timeOut);

                 % Calculation of precision and sensitivity - Algo VS Experts
                [SensitivityAlgo,PrecisionAlgo] = StatMesures_algo_Three(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut, Exp3_timeIn, Exp3_timeOut, Algo_timeIn, Algo_timeOut);

%             elseif nbExp == 4
%                 Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
%                 Exp3_timeOut = file(CurrentRecording).Exp_timeOut.Expert3;
%                 Exp4_timeIn = file(CurrentRecording).Exp_timeIn.Expert4;
%                 Exp4_timeOut = file(CurrentRecording).Exp_timeOut.Expert4;
% 
%                 % Calculation of precision and sensitivity - Inter Expert
%                 [SensitivityA,PrecisionA] = StatMesures_Four(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut,Exp3_timeIn,Exp3_timeOut,Exp4_timeIn,Exp4_timeOut);
% 
%                 % Calculation of precision and sensitivity - Algo VS Experts 
%                 [SensitivityAlgo,PrecisionAlgo] = StatMesures_algo_Four(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut,Exp3_timeIn,Exp3_timeOut,Exp4_timeIn,Exp4_timeOut,Algo_timeIn,Algo_timeOut);
            end

%             AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).SensitivityExp = SensitivityA;
%             AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).PrecisionExp = PrecisionA;
            AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).SensitivityAlgo = SensitivityAlgo;
            AnalyzeParamFile(CurrentRecording).Detail(NumAnalyze).PrecisionAlgo = PrecisionAlgo;
            save('AnalyzeParam.mat','AnalyzeParamFile');
         end
    end 