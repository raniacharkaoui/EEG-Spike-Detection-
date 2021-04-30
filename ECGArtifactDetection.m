% ECG artifact detection
function ECGArtifactDetection(CurrentRecording)
    
    load('Spikes.mat','file'); % get the file that has just been modified by the AlphawavesDetection
    fileName = file(CurrentRecording).Name;
    
    msg = ['ECG  detection for ' fileName ' is launched ...'];
    disp(msg);
    
    Recordings = file(CurrentRecording).Recordings;
    DetectionParameters = file(CurrentRecording).DetectionParameters;
    fileName = file(CurrentRecording).Name;
    path = file(CurrentRecording).Recordings.path;
    fileData = struct([]);
    if endsWith(fileName,'.mat') % .mat files have always been used in matlab
        fileData = load([path '\' fileName]);
    end
    if endsWith(fileName,'.edf') || endsWith(fileName,'.EDF') 
        electrode = {'ECG'};
        
    elseif endsWith(fileName,'.mat') 
        electrode = {'ECG'};  % The ECG electrode is selected
    end
    electrode=cell2mat(electrode);
    [electrodeRow,~]=size(electrode); % number of electrodes ( only 1 here )
    electrodeRef = '';

    timeIn = Recordings.timeIn(1); % get the recordings starting time ( in seconds)
    timeOut = Recordings.timeOut(length(Recordings.timeOut)); % get the recordings starting time ( in seconds )

%% FIRST METHOD TO DETECT THE CARDIAC ARTIFACTS (QRS PEAKS). Pre-processing first and detecting based on derivatives. (Less sensitive to threshold's variation)

    for j=1:electrodeRow 
        [RawData] = GetData(timeIn,timeOut,electrode(j,:),electrodeRef,Recordings.fname,DetectionParameters,fileData); % get the data of the ECG electrode

        % Filter the ECG signal artifacts

        % Base line correction, high pass filter
        Wn = 1/(DetectionParameters.Fs/2); % sampling frequency Fs=250 Hz , cuttof frequency Wn=1Hz to filter offsets
        [Bhp,Ahp] = butter(5,Wn,'high'); % butterworth filter of order 5 and cuttof frequecny Wn=1Hz
        ProcessedData = filtfilt(Bhp,Ahp,RawData); % filter the ECG signal with the butterworth filter   

        interval = length(RawData); % number of samples in the data
        time = linspace(timeIn,timeOut,interval); %% linearize (in seconds) the time from timIn to timeOut with the number of samples
         % Network noise correction (band filter) "Fre" can be 50 or 60 Hz.
        fre = 50; 
        w=fre/(DetectionParameters.Fs/2);
        bw=w/35;
        [d,c]=iirnotch(w,bw);
        filterNet=filter(d,c,ProcessedData);
        ProcessedData_2=filtfilt(d,c,filterNet);

        % Low pass filter to reduce high frequency noises as EMG.
        % Resisting patient normal values of ECG is between 60-90
        freq = 90;
        N = 5;
        [e,f] = butter(N,freq/(DetectionParameters.Fs/2),'low');
        ProcessedData_3=filtfilt (e,f,ProcessedData_2);
        [QRS,Npeaks,listArtifacts]= ECG_det_dif(ProcessedData_3, DetectionParameters.Fs,0.6);
    end

%% SECOND MANNER TO DETECT THE CARDIAC ARTIFACTS (THRESHOLDING)
%    for j=1:electrodeRow 
%        [RawData] = GetData(timeIn,timeOut,electrode(j,:),electrodeRef,Recordings.fname,DetectionParameters,fileData); % get the data of the ECG electrode
%
%        Wn = 1/(DetectionParameters.Fs/2); % sampling frequency Fs=250 Hz , cuttof frequency Wn=1Hz to filter offsets
%        [Bhp,Ahp] = butter(5,Wn,'high'); % butterworth filter of order 5 and cuttof frequecny Wn=1Hz
%        ProcessedData = filtfilt(Bhp,Ahp,RawData); % filter the ECG signal with the butterworth filter   
%
%        interval = length(RawData); % number of samples in the data
%        time = linspace(timeIn,timeOut,interval); % linearize (in seconds) the time from timIn to timeOut with the number of samples
%
%        listArtifacts = []; % list of the times at which the signal crosses 300 micro Volts
%        for i=1:length(ProcessedData)
%            if ProcessedData(i)>=300 % if the signal goes higher than 300 micro Volts at some time
%                listArtifacts = [listArtifacts;time(ProcessedData == ProcessedData(i))]; % the time is stored in listArtifacts
%            end
%        end
%    end
    
    
    listArtifacts = sort(listArtifacts); % sort the times in chronological order (just in case it wasn't already)
    if ~isempty(listArtifacts) % if the list isn't empty
        % artifactTimeIn and artifactTimeOut are the lists of all starting
        % and endings of the cardiac artifacts 
        artifactTimeIn = listArtifacts(1); % artifactTimeIn stores the first timing of listArtifacts
        artifactTimeOut = listArtifacts(1)+0.02 ; % artifactTimeOut stores the time 0.02 seconds after the first timing of listArtifacts
        for i=1:length(listArtifacts)-1 % for all the timings of listArtifacts
            if listArtifacts(i+1)-listArtifacts(i) > 0.5 % if two successive times i and i+1 are separated by more than 0.5 seconds
                artifactTimeIn = [artifactTimeIn;listArtifacts(i+1)-0.06]; % time i+1 - 0.06 seconds is stored in artifactTimeIn
                artifactTimeOut = [artifactTimeOut;listArtifacts(i+1)+0.1];% time i+1 +0.1 seconds is stored in artifactTimeOut
        
            end
        end
    else
        artifactTimeIn = [];
        artifactTimeOut = [];
    end
    
    %% select the right derivations
    
    NumDerivation = length(Recordings.nrElectrodeLeft(:,:))/2; % Number of electrode derivations in EEG
    
    %List of derivations
    for i=1:length(Recordings.nrElectrodeLeft) % for all derivations
        if i == 1 % for the first derivation
            nrElectrodeLeft_list(i,:) = Recordings.nrElectrodeLeft(i,:);
            nrElectrodeRight_list(i,:) = Recordings.nrElectrodeRight(i,:);
        elseif mod(i,2) ~= 0 % when it's odd ( avoid duplicata of derivations )
            nrElectrodeLeft_list(end+1,:) = Recordings.nrElectrodeLeft(i,:);
            nrElectrodeRight_list(end+1,:) = Recordings.nrElectrodeRight(i,:);
        end
    end
    
    
    
    for Derivation=1:NumDerivation
        
        file(CurrentRecording).cardiac_spike(Derivation).DetectedTime = []; % creates a structure called cardiac_spike in the file for each derivation
        
        nrElectrodeLeft = deblank(nrElectrodeLeft_list(Derivation,:)); % string of the left electrone name
        nrElectrodeRight = deblank(nrElectrodeRight_list(Derivation,:)); % string of the right electrone name
        
        derivation_name=[nrElectrodeLeft ' - ' nrElectrodeRight]; % name of the derivation
        
        if isequal(derivation_name,'EEG T9 - EEG P9')||isequal(derivation_name,'EEG T10 - EEG P10')...
                ||isequal(derivation_name,'EEG P3 - EEG O1')||isequal(derivation_name,'EEG P4 - EEG O2')...
                ||isequal(derivation_name,'EEG T6 - EEG 02')||isequal(derivation_name,'EEG C3 - EEG P3')
            % if the derivation is one of those derivations mentioned ( the
            % ones visually influenced by ECG artifacts), the artifacts
            % timings are stored in the cardiac_spike structure for that
            % specific derivation
            file(CurrentRecording).cardiac_spike(Derivation).DetectedTime(:,1)= artifactTimeIn;
            file(CurrentRecording).cardiac_spike(Derivation).DetectedTime(:,2)= artifactTimeOut;
        else
            % if the derivation isn't any of the mentioned derivations, no
            % no artifacts timings are stored in that derivation
            file(CurrentRecording).cardiac_spike(Derivation).DetectedTime = [0,0]; 
        end
        % the name of the derivation is stored in the cardiac_spike
        % structure of that derivation 
        file(CurrentRecording).cardiac_spike(Derivation).der_name = [nrElectrodeLeft ' - ' nrElectrodeRight];
    end
    str = ['ECG Detection for ' fileName ' is finished.'];
    disp(str);
    save('Spikes.mat','file'); % the filed is saved into 'Spike.mat'
end
