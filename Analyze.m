function Analyze()
   load('Spikes.mat','file');
   
    for CurrentRecording = 1:length(file)
        tic;
        DetectionParameters = file(CurrentRecording).DetectionParameters;
        Recordings = file(CurrentRecording).Recordings;
        fileName = file(CurrentRecording).Name;
        path = file(CurrentRecording).Recordings.path;
        %% Spikes detected by the experts beetween the time In and the time Out entered by the user
            timeIn = Recordings.timeIn;
            timeOut = Recordings.timeOut;
            windowLength = DetectionParameters.WindowLength;
            if ~isequal(file(CurrentRecording).nbExp,0)
                % Expert 1
                ExpTimeIn1 = [];
                ExpTimeOut1 = [];
                Exp1_timeIn = file(CurrentRecording).Exp_timeIn.Expert1;
                Exp1_timeOut = file(CurrentRecording).Exp_timeIn.Expert1 + windowLength ;
                for k=1:length(timeIn) 
                    ExpTimeIn1 = [ExpTimeIn1;Exp1_timeIn(Exp1_timeIn>=(timeIn(k)*1000) & Exp1_timeIn<=(timeOut(k)*1000))];
                    ExpTimeOut1 = [ExpTimeOut1;Exp1_timeOut(Exp1_timeOut>=(timeIn(k)*1000) & Exp1_timeOut<=(timeOut(k)*1000))];
                    if ~isequal(length(ExpTimeIn1),length(ExpTimeOut1)) % if there is a spike which overlaps timeIn or timeOut
                        if length(ExpTimeIn1) < length(ExpTimeOut1) % if there is a spike which overlaps timeIn or timeOut
                            ExpTimeIn1 = [ExpTimeIn1;0];  
                            for n = 1:length(ExpTimeOut1)
                                  if ~isequal(ExpTimeOut1(n)-windowLength,ExpTimeIn1(n))
                                      ExpTimeIn1(n) = ExpTimeOut1(n)-windowLength;
                                  end
                            end
                        else
                            ExpTimeOut1 = [ExpTimeOut1;0];
                            for n =1:length(ExpTimeOut1)
                                if ~isequal(ExpTimeIn1(n)+windowLength,ExpTimeOut1(n))
                                    ExpTimeOut1(n) = ExpTimeIn1(n)+windowLength;
                                end
                            end
                        end
                    end
                end
                file(CurrentRecording).Exp_timeIn.Expert1 = ExpTimeIn1;
                file(CurrentRecording).Exp_timeOut.Expert1 =  ExpTimeOut1;

                % Expert 2
                ExpTimeIn2 = [];
                ExpTimeOut2 = [];
                Exp2_timeIn = file(CurrentRecording).Exp_timeIn.Expert2;
                Exp2_timeOut = file(CurrentRecording).Exp_timeIn.Expert2 + windowLength;
                for k=1:length(timeIn) 
                    ExpTimeIn2 = [ExpTimeIn2;Exp2_timeIn(Exp2_timeIn>=(timeIn(k)*1000) & Exp2_timeIn<=(timeOut(k)*1000))];
                    ExpTimeOut2 = [ExpTimeOut2;Exp2_timeOut(Exp2_timeOut>=(timeIn(k)*1000) & Exp2_timeOut<=(timeOut(k)*1000))];
                    if ~isequal(length(ExpTimeIn2),length(ExpTimeOut2))
                        if length(ExpTimeIn2) < length(ExpTimeOut2) % if there is a spike which overlaps timeIn or timeOut
                            ExpTimeIn2 = [ExpTimeIn2;0];  
                            for n = 1:length(ExpTimeOut2)
                                  if ~isequal(ExpTimeOut2(n)-windowLength,ExpTimeIn2(n))
                                      ExpTimeIn2(n) = ExpTimeOut2(n)-windowLength;
                                  end
                            end
                        else
                            ExpTimeOut2 = [ExpTimeOut2;0];
                            for n =1:length(ExpTimeOut2)
                                if ~isequal(ExpTimeIn2(n)+windowLength,ExpTimeOut2(n))
                                    ExpTimeOut2(n) = ExpTimeIn2(n)+windowLength;
                                end
                            end
                        end             
                    end
                end

                file(CurrentRecording).Exp_timeIn.Expert2 = ExpTimeIn2;
                file(CurrentRecording).Exp_timeOut.Expert2 =  ExpTimeOut2;

                % if there are 3 experts
                if isequal(file(CurrentRecording).nbExp,3)
                    ExpTimeIn3 = [];
                    ExpTimeOut3 = [];
                    Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
                    Exp3_timeOut = file(CurrentRecording).Exp_timeIn.Expert3 + windowLength;
                    for k=1:length(timeIn) 
                        ExpTimeIn3 = [ExpTimeIn3;Exp3_timeIn(Exp3_timeIn>=(timeIn(k)*1000) & Exp3_timeIn<=(timeOut(k)*1000))];
                        ExpTimeOut3 = [ExpTimeOut3;Exp3_timeOut(Exp3_timeOut>=(timeIn(k)*1000) & Exp3_timeOut<=(timeOut(k)*1000))];
                        if ~isequal(length(ExpTimeIn3),length(ExpTimeOut3)) % if there is a spike which overlaps timeIn or timeOut
                            if length(ExpTimeIn3) < length(ExpTimeOut3) 
                                ExpTimeIn3 = [ExpTimeIn3;0];  
                                for n = 1:length(ExpTimeOut3)
                                      if ~isequal(ExpTimeOut3(n)-windowLength,ExpTimeIn3(n))
                                          ExpTimeIn3(n) = ExpTimeOut3(n)-windowLength;
                                      end
                                end
                            else
                                ExpTimeOut3 = [ExpTimeOut3;0];
                                for n =1:length(ExpTimeOut3)
                                    if ~isequal(ExpTimeIn3(n)+windowLength,ExpTimeOut3(n))
                                        ExpTimeOut3(n) = ExpTimeIn3(n)+windowLength;
                                    end
                                end
                            end
                        end
                    end
                    file(CurrentRecording).Exp_timeIn.Expert3 = ExpTimeIn3;
                    file(CurrentRecording).Exp_timeOut.Expert3 =  ExpTimeOut3;
                end
                % If there are 4 experts
                if isequal(file(CurrentRecording).nbExp,4)
                    % Expert 3
                    ExpTimeIn3 = [];
                    ExpTimeOut3 = [];
                    Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
                    Exp3_timeOut = file(CurrentRecording).Exp_timeIn.Expert3 + windowLength;
                    for k=1:length(timeIn) 
                        ExpTimeIn3 = [ExpTimeIn3;Exp3_timeIn(Exp3_timeIn>=(timeIn(k)*1000) & Exp3_timeIn<=(timeOut(k)*1000))];
                        ExpTimeOut3 = [ExpTimeOut3;Exp3_timeOut(Exp3_timeOut>=(timeIn(k)*1000) & Exp3_timeOut<=(timeOut(k)*1000))];
                        if ~isequal(length(ExpTimeIn3),length(ExpTimeOut3)) % if there is a spike which overlaps timeIn or timeOut
                            if length(ExpTimeIn3) < length(ExpTimeOut3) 
                                ExpTimeIn3 = [ExpTimeIn3;0];  
                                for n = 1:length(ExpTimeOut3)
                                      if ~isequal(ExpTimeOut3(n)-windowLength,ExpTimeIn3(n))
                                          ExpTimeIn3(n) = ExpTimeOut3(n)-windowLength;
                                      end
                                end
                            else
                                ExpTimeOut3 = [ExpTimeOut3;0];
                                for n =1:length(ExpTimeOut3)
                                    if ~isequal(ExpTimeIn3(n)+windowLength,ExpTimeOut3(n))
                                        ExpTimeOut3(n) = ExpTimeIn3(n)+windowLength;
                                    end
                                end
                            end
                        end
                    end
                    file(CurrentRecording).Exp_timeIn.Expert3 = ExpTimeIn3;
                    file(CurrentRecording).Exp_timeOut.Expert3 =  ExpTimeOut3;

                    %Expert 4
                    ExpTimeIn4 = [];
                    ExpTimeOut4 = [];
                    Exp4_timeIn = file(CurrentRecording).Exp_timeIn.Expert4;
                    Exp4_timeOut = file(CurrentRecording).Exp_timeIn.Expert4 + windowLength;
                    for k=1:length(timeIn) 
                        ExpTimeIn4 = [ExpTimeIn4;Exp4_timeIn(Exp4_timeIn>=(timeIn(k)*1000) & Exp4_timeIn<=(timeOut(k)*1000))];
                        ExpTimeOut4 = [ExpTimeOut4;Exp4_timeOut(Exp4_timeOut>=(timeIn(k)*1000) & Exp4_timeOut<=(timeOut(k)*1000))];
                        if ~isequal(length(ExpTimeIn4),length(ExpTimeOut4)) % if there is a spike which overlaps timeIn or timeOut
                            if length(ExpTimeIn4) < length(ExpTimeOut4) 
                                ExpTimeIn4 = [ExpTimeIn4;0];  
                                for n = 1:length(ExpTimeOut4)
                                      if ~isequal(ExpTimeOut4(n)-windowLength,ExpTimeIn4(n))
                                          ExpTimeIn4(n) = ExpTimeOut4(n)-windowLength;
                                      end
                                end
                            else
                                ExpTimeOut4 = [ExpTimeOut4;0];
                                for n =1:length(ExpTimeOut4)
                                    if ~isequal(ExpTimeIn4(n)+windowLength,ExpTimeOut4(n))
                                        ExpTimeOut4(n) = ExpTimeIn4(n)+windowLength;
                                    end
                                end
                            end
                        end
                    end
                    file(CurrentRecording).Exp_timeIn.Expert4 = ExpTimeIn4;
                    file(CurrentRecording).Exp_timeOut.Expert4 =  ExpTimeOut4;
                end
                save('Spikes.mat','file');
            end

        %% Detection
        fileData = struct([]);
        if endsWith(file(CurrentRecording).Name,'.mat')
            fileData = load([path '\' fileName]);
        end
        NumDerivation =length(Recordings.nrElectrodeLeft(:,1));
        PatientSpecificDetSpikes(NumDerivation).Det = []; % preallocation for speed

        %Retrieve the frequency
        if isa(fileName,'char') % If it's only one file
            Spikes(CurrentRecording).Name = fileName;
            if endsWith(fileName,'.edf') || endsWith(fileName,'.EDF')
                [header] = edfread([path '\' fileName]);
                freq = header.samples(2);
            end
            if endsWith(fileName,'.mat')
                freq = fileData.Data.ChDesc(1).Fs ; 
            end
        end
        if(freq ==400)
            DetectionParameters.Fs = freq/2; %%% in the header the sampling frequency is 400 but the code works with a frequency of 200 for this file...
        else
            DetectionParameters.Fs = freq;
        end
        file(CurrentRecording).DetectionParameters = DetectionParameters;


        %Launch artefacts detection
        %Comment the next functions if you don't want to detect artifacts.
         AlphaWaveDetection(file,CurrentRecording);
         if file(CurrentRecording).Name=="AD_ErasmeData.mat" % ECG detection is only made for AD
            ECGArtifactDetection(CurrentRecording);
         end
         
         load('Spikes.mat','file');
         [MuscleArtifactsTimeIn,MuscleArtifactsTimeOut] = MuscleArtifactDetection(file(CurrentRecording));
         %CardiacArtifactsTimeIn=[];
         %CardiacArtifactsTimeOut=[];
         %if file.Name=="AD_ErasmeData.mat"
             %[CardiacArtifactsTimeIn,CardiacArtifactsTimeOut] = ECGArtifactDetection(file(CurrentRecording));
         %end
%         MuscleArtifactsTimeIn = [];
%         MuscleArtifactsTimeOut = [];

        msg = ['Spikes detection for ' fileName ' is launched ...'];
        disp(msg);
        SWI = -1*ones(NumDerivation,1);
        NumClusters = -1*ones(NumDerivation,1);
        for Derivation = 1:NumDerivation  
            %retrieve alpha waves time
            AlphaWaves_TimeIn = file(CurrentRecording).AlphaWaves(round(Derivation/2)).DetectedTime(:,1);
            AlphaWaves_TimeOut = file(CurrentRecording).AlphaWaves(round(Derivation/2)).DetectedTime(:,2);
            
            if file(CurrentRecording).Name=="AD_ErasmeData.mat"
                % retrive ECG artifacts time
                CardiacArtifactsTimeIn=file(CurrentRecording).cardiac_spike(round(Derivation/2)).DetectedTime(:,1);
                CardiacArtifactsTimeOut=file(CurrentRecording).cardiac_spike(round(Derivation/2)).DetectedTime(:,2);
            else
                CardiacArtifactsTimeIn=[];
                CardiacArtifactsTimeOut=[];
            end
            
            % Gather all timings 
            artifactsTimeIn = sort([AlphaWaves_TimeIn;MuscleArtifactsTimeIn;CardiacArtifactsTimeIn]);
            artifactsTimeOut = sort([AlphaWaves_TimeOut;MuscleArtifactsTimeOut;CardiacArtifactsTimeOut]);
            
            %retrieve electrodes
            nrElectrodeLeft = deblank(Recordings.nrElectrodeLeft(Derivation,:));
            nrElectrodeRight = deblank(Recordings.nrElectrodeRight(Derivation,:));
            % First step: generic spike detection
            [GenericTemplate,GenDetectedSpikes] = GenericDetection(file(CurrentRecording),DetectionParameters,nrElectrodeLeft,nrElectrodeRight,fileData,artifactsTimeIn,artifactsTimeOut);
            GenericSpike(Derivation) = GenericTemplate;
            % Statistics and SWI for first detection
            StatGenDet = SingleDerStats(GenDetectedSpikes,Recordings,artifactsTimeIn,artifactsTimeOut);            
            SWI(Derivation)=StatGenDet.SWI;
            % Patient-specific detection
            if StatGenDet.SWI>=DetectionParameters.PatientSpecificMinimumSWI
                [Clusters] = ClustersFromDetect(DetectionParameters.ClusterSelectionThresh,GenDetectedSpikes);
                NumClusters(Derivation) = Clusters.NumClusters;
    %             disp(CurrentRecording)
    %             disp(nrElectrodeLeft)
    %             disp(StatGenDet.SWI)
    %             disp(Clusters)
                PatientSpecificDetSpikes(Derivation).Det = SecDetFromClusters(file(CurrentRecording),DetectionParameters,Clusters,nrElectrodeLeft,nrElectrodeRight,fileData,artifactsTimeIn,artifactsTimeOut);
            else
                PatientSpecificDetSpikes(Derivation).Det = GenDetectedSpikes;
            end
        end
        
        file(CurrentRecording).PatientSpecificDetSpikes = PatientSpecificDetSpikes;
        file(CurrentRecording).DetectionParameters = DetectionParameters;
        file(CurrentRecording).GenericSpike = GenericSpike ;
        file(CurrentRecording).SWI = SWI ;
        file(CurrentRecording).NumClusters = NumClusters ;
        
        str = ['Spikes detection for ' fileName ' is finished.'];
        disp(str);
        file(CurrentRecording).Duration = toc;
        toc
        save('Spikes.mat','file');
    end
    disp('The detection for the selected files is finished');
end
