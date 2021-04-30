%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ArtifactsStudy creates a text file in which it is explained the 
% number of overlaps between the Experts spikes and the artifacts. 
% It is necessary to select 3 Experts for this function to work. 
% The comparison will be done for each expert and artifact type. 
% Thus, all the artifacts that are overlapped with a spike marked 
% by an expert will be discarded, taking the algorithm to commit 
% a false negative detection of the event.
%
% Input parameters:
% file
% current recording
% MuscleArtifactsTimeIn: Muscular artifacts initial timings
% MuscleArtifactsTimeOut: Muscular artifacts output timings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = ArtifactsStudy(file,CurrentRecording,MuscleArtifactsTimeIn,MuscleArtifactsTimeOut)
    
    disp('The artifact study is started');

    load('Spikes.mat','file'); % get the file that has just been modified by the AlphawavesDetection
    Recordings  = file(CurrentRecording).Recordings;
    DetectionParameters = file(CurrentRecording).DetectionParameters;
    NumDerivation = length(Recordings.nrElectrodeLeft(:,:))/2; % Number of electrode derivations in EEG
    path = file(CurrentRecording).Recordings.path;
    fileName = file(CurrentRecording).Name;
    
    % Save the expert timings
    Exp1TimeIn = file(CurrentRecording).Exp_timeIn.Expert1;
    Exp1TimeOut = file(CurrentRecording).Exp_timeOut.Expert1;
    Exp2TimeIn = file(CurrentRecording).Exp_timeIn.Expert2;
    Exp2TimeOut = file(CurrentRecording).Exp_timeOut.Expert2;
    Exp3TimeIn = file(CurrentRecording).Exp_timeIn.Expert3;
    Exp3TimeOut = file(CurrentRecording).Exp_timeOut.Expert3;
    
    % TO DO: Check how many experts there are to avoid errors

    % Save the Alpha Waves timings (Detected in all derivations)
    AlphaTimings.Derivation.TimeIn = [];
    AlphaTimings.Derivation.TimeOut = [];
    
    % Save the Cardiac artifacts timings (Detected in all derivations).
    % Only if the patient is AD
    if file(CurrentRecording).Name=="AD_ErasmeData.mat"
        CardiacTimings.Derivation.TimeIn = [];
        CardiacTimings.Derivation.TimeOut = [];
        CardiacTimings.Derivation.der_name = [];
    end
    for Derivation=1:NumDerivation
        
        AlphaTimings.Derivation.TimeIn = file(1).AlphaWaves(Derivation).DetectedTime(:,1);
        AlphaTimings.Derivation.TimeOut = file(1).AlphaWaves(Derivation).DetectedTime(:,2);   
        
        if file(CurrentRecording).Name=="AD_ErasmeData.mat"
            % Save the cardiac Timings (only if the patient is AC). I know which
            % derivations they are 'EEG T9 - EEG P9','EEG T10 - EEG P10','EEG P3 - EEG O1'
            %'EEG P4 - EEG O2','EEG T6 - EEG 02','EEG C3 - EEG P3'
            CardiacTimings.Derivation.TimeIn = file(CurrentRecording).cardiac_spike(Derivation).DetectedTime(:,1);
            CardiacTimings.Derivation.TimeOut = file(CurrentRecording).cardiac_spike(Derivation).DetectedTime(:,2);
            % the name of the derivation is stored in the cardiac_spike structure of that derivation 
            CardiacTimings.Derivation.der_name = file(CurrentRecording).cardiac_spike(Derivation).der_name; 
        end
        % Muscular artifacts are an input of the function. The muscular artifact are deleted
        % from all the derivations. But detected in the eyes derivations. 

        
        %fid = fopen( 'ArtifactStudy.txt', 'wt' );
        %fprintf( fid, 'Derivation number %f \n', Derivation );
        %fprintf( fid, 'Aplha times in %f Aplha times out %f CardiactimingsDerivation %s \n'...
        %    ,AlphaTimings.Derivation.TimeIn,AlphaTimings.Derivation.TimeOut, CardiacTimings.Derivation.der_name );
        %fclose(fid);
        
        % As you only have the times of the skipes, and you don't know from
        % which derivation they are coming, at the point of deleting the
        % timings, you delet for example the muscular artifacts from all of
        % them. The cardiac are detected only if the patient is AC and they
        % are detected in some specific derivations and then deleted them
        % in the specific derivation in the spike detector. Shoudn't we do
        % the same with the musculars? It won't change the parameters of
        % sensitivity and precision but make more sense, right?
    end
    
    % This value come as an argument of the function
    MuscleArtifactsTimeIn = MuscleArtifactsTimeIn;
    MuscleArtifactsTimeOut = MuscleArtifactsTimeOut;
    
    if file(CurrentRecording).Name=="AD_ErasmeData.mat"
        CardiacArtifactsTimeIn = CardiacTimings.Derivation.TimeIn;
        CardiacArtifactsTimeOut = CardiacTimings.Derivation.TimeOut;
    end
    
    AlphaWavesTimeIn = AlphaTimings.Derivation.TimeIn;
    AlphaWavesTimeOut = AlphaTimings.Derivation.TimeOut;
    
    % Check if we are missing some real spike (SameSpikeList experts coincidences) due to the overlap
    % with an artifact detection. If there is a coincidence we are losing the spike. 
    
    % OVERLAPS WITH THE MUSCLE ARTIFACTS
    
    % Check the coincidences between the Expert1 with the MuscleArtifacts
    maxLength = max(length(Exp1TimeIn),length(MuscleArtifactsTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(MuscleArtifactsTimeOut)
        windowLength = MuscleArtifactsTimeOut(1)-MuscleArtifactsTimeIn(1);
    end
    index=1;
    
    for SlideSec=1:length(MuscleArtifactsTimeOut)  %  Go through the number of spikes beginning counted by the expert 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp1TimeOut)
            diff = abs(MuscleArtifactsTimeIn(SlideSec)-Exp1TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp1TimeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 
    
    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
	ExpSpikesOnly = length(Exp1TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert
    
%     disp('MUSCLE ARTIFACTS with EXPERT 1');
%     disp('muscle artifacts');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);

    fid = fopen( 'ArtifactsStudy.txt','wt' );
    fprintf( fid, 'Muscle Artifacts Expert 1: muscle artifacts: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);
    
    % Check the coincidences between the Expert2 with the MuscleArtifacts
    MissedSpikes = 0;
    maxLength = max(length(Exp2TimeIn),length(MuscleArtifactsTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(MuscleArtifactsTimeOut)
        windowLength = MuscleArtifactsTimeOut(1)-MuscleArtifactsTimeIn(1);
    end
    index=1;
    
    for SlideSec=1:length(MuscleArtifactsTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp2TimeOut)
            diff = abs(MuscleArtifactsTimeIn(SlideSec)-Exp2TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp2TimeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 
    
    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
	ExpSpikesOnly = length(Exp2TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert
    
%     disp('MUSCLE ARTIFACTS with EXPERT 2');
%     disp('muscle artifacts');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
    
    fid = fopen( 'ArtifactsStudy.txt','a+' );
    fprintf( fid, 'Muscle Artifacts Expert 2: muscle artifacts: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);
    
    % Check the coincidences between the Expert3 with the MuscleArtifacts
    MissedSpikes = 0;
    maxLength = max(length(Exp3TimeIn),length(MuscleArtifactsTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(MuscleArtifactsTimeOut)
        windowLength = MuscleArtifactsTimeOut(1)-MuscleArtifactsTimeIn(1);
    end
    index=1;
    
    for SlideSec=1:length(MuscleArtifactsTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp3TimeOut)
            diff = abs(MuscleArtifactsTimeIn(SlideSec)-Exp3TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp3TimeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 
    
    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
	ExpSpikesOnly = length(Exp3TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert
    
%     disp('MUSCLE ARTIFACTS with EXPERT 3');
%     disp('muscle artifacts');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
%     disp('The artifact study is finished');
    
    fid = fopen( 'ArtifactsStudy.txt','a+' );
    fprintf( fid, 'Muscle Artifacts Expert 3: muscle artifacts: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);
    
    % OVERLAPS WITH THE ALPHA WAVES
    
    % Check the coincidences between the Expert1 with the AlphaWaves
    MissedSpikes = 0;
    maxLength = max(length(Exp1TimeIn),length(AlphaWavesTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(AlphaWavesTimeOut)
        windowLength = AlphaWavesTimeOut(1)-AlphaWavesTimeIn(1);
    end
    index=1;
    
    for SlideSec=1:length(AlphaWavesTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp1TimeOut)
            diff = abs(AlphaWavesTimeIn(SlideSec)-Exp1TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp1TimeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 
    
    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
	ExpSpikesOnly = length(Exp1TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert
    
%     disp('Alpha Waves with EXPERT 1');
%     disp('Alpha waves');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
%     
    fid = fopen( 'ArtifactsStudy.txt','a+');
    fprintf( fid, 'Alpha waves Expert 1: alpha waves: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);
    
    % Check the coincidences between the Expert2 with the AlphaWaves
    MissedSpikes = 0;
    maxLength = max(length(Exp2TimeIn),length(AlphaWavesTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(AlphaWavesTimeOut)
        windowLength = AlphaWavesTimeOut(1)-AlphaWavesTimeIn(1);
    end
    index=1;
    
    for SlideSec=1:length(AlphaWavesTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp2TimeOut)
            diff = abs(AlphaWavesTimeIn(SlideSec)-Exp2TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp2TimeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 
    
    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
	ExpSpikesOnly = length(Exp2TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert
%     
%     disp('ALPHA WAVES with EXPERT 2');
%     disp('alpha waves');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
    
    fid = fopen( 'ArtifactsStudy.txt','a+' );
    fprintf( fid, 'Alpha waves Expert 2: alpha waves: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);
    
    % Check the coincidences between the Expert3 with the AlphaWaves
    MissedSpikes = 0;
    maxLength = max(length(Exp3TimeIn),length(AlphaWavesTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(AlphaWavesTimeOut)
        windowLength = AlphaWavesTimeOut(1)-AlphaWavesTimeIn(1);
    end
    index=1;
    
    for SlideSec=1:length(AlphaWavesTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp3TimeOut)
            diff = abs(AlphaWavesTimeIn(SlideSec)-Exp3TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp3TimeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 
    
    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
	ExpSpikesOnly = length(Exp3TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert
    
%     disp('ALPHA WAVES with EXPERT 3');
%     disp('alpha waves');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
    
    fid = fopen( 'ArtifactsStudy.txt','a+' );
    fprintf( fid, 'Alpha waves Expert 3: alpha waves: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);

    % OVERLAPS WITH THE CARDIAC ARTIFACTS

    % Check the coincidences between the Expert1 with the Cardiac Artifacts
    MissedSpikes = 0;
    maxLength = max(length(Exp1TimeIn),length(CardiacArtifactsTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(CardiacArtifactsTimeOut)
        windowLength = CardiacArtifactsTimeOut(1)-CardiacArtifactsTimeIn(1);
    end
    index=1;

    for SlideSec=1:length(CardiacArtifactsTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp1TimeOut)
            diff = abs(CardiacArtifactsTimeIn(SlideSec)-Exp1TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp1TimeIn(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 

    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
    ExpSpikesOnly = length(Exp1TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert

%     disp('Cardiac artifacts with EXPERT 1');
%     disp('Cardiac Artifacts');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
%     
    fid = fopen( 'ArtifactsStudy.txt','a+');
    fprintf( fid, 'Cardiac Artifacts Expert 1: Cardiac Artifacts: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);

    % Check the coincidences between the Expert2 with the Cardiac Artifacts
    MissedSpikes = 0;
    maxLength = max(length(Exp2TimeIn),length(CardiacArtifactsTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(CardiacArtifactsTimeOut)
        windowLength = CardiacArtifactsTimeOut(1)-CardiacArtifactsTimeIn(1);
    end
    index=1;

    for SlideSec=1:length(CardiacArtifactsTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp2TimeOut)
            diff = abs(CardiacArtifactsTimeIn(SlideSec)-Exp2TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp2TimeIn(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 

    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
    ExpSpikesOnly = length(Exp2TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert

%     disp('Cardiac artifacts with EXPERT 2');
%     disp('Cardiac Artifacts');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
    
    fid = fopen( 'ArtifactsStudy.txt','a+' );
    fprintf( fid, 'Cardiac Artifacts Expert 2: Cardiac Artifacts: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);

    % Check the coincidences between the Expert3 with the Cardiac Artifacts
    MissedSpikes = 0;
    maxLength = max(length(Exp3TimeIn),length(CardiacArtifactsTimeIn));
    ArtifactsOnly = 0; %Number of artifacts non coincident with the expert timings
    SameSpikesList = zeros(maxLength,1); %List of timings counted only by both the expert and the artifacts
    if ~isempty(CardiacArtifactsTimeOut)
        windowLength = CardiacArtifactsTimeOut(1)-CardiacArtifactsTimeIn(1);
    end
    index=1;

    for SlideSec=1:length(CardiacArtifactsTimeOut) 
        CommonOneSpike = 0;    %%initiate the common spike and artifact at 0
        for SecInIndex = 1:length(Exp3TimeOut)
            diff = abs(CardiacArtifactsTimeIn(SlideSec)-Exp3TimeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = Exp3TimeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            ArtifactsOnly = ArtifactsOnly+1;
        end
    end 

    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes that occurs at the same time as the artifact
    ExpSpikesOnly = length(Exp3TimeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by the expert

%     disp('Cardiac Artifacts with EXPERT 3');
%     disp('Cardiac artifacts');
%     disp(ArtifactsOnly);
%     disp('Expert spikes');
%     disp(ExpSpikesOnly);
%     disp('common timings');
%     disp(CommonSpikes);
    
    fid = fopen( 'ArtifactsStudy.txt','a+' );
    fprintf( fid, 'Cardiac Artifacts Expert 3: Cardiac Artifacts: %f ,Expert spikes: %f ,common timings %f: \n', ArtifactsOnly, ExpSpikesOnly, CommonSpikes);
    fclose(fid);
    
    disp('The artifact study is finished');

end