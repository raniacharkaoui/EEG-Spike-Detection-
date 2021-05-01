% ECG artifact detection
function [transmisionLineArtifactsTimeIn,TransmisionLineArtifactsTimeOut] = TransmisionLineDetection(file,CurrentRecording)
    
    load('Spikes.mat','file'); % get the file that has just been modified by the AlphawavesDetection
    fileName = file(CurrentRecording).Name;
    
    msg = ['Transmision line detection for ' fileName ' is launched ...'];
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
    
    for j=1:electrodeRow 
        [RawData] = GetData(timeIn,timeOut,electrode(j,:),electrodeRef,Recordings.fname,DetectionParameters,fileData); 
%% Bandpass filter
        % Network noise correction (band filter) "Fre" can be 50 (EU) or 60 (US) Hz.
        fre = 50; 
        w=fre/(DetectionParameters.Fs/2);
        bw=w/35;
        [d,c]=iirnotch(w,bw);
        filterNet=filter(d,c,RawData);
        ProcessedData=filtfilt(d,c,filterNet);
        
        interval = length(RawData); % number of samples in the data
        time = linspace(timeIn,timeOut,interval); % linearize (in seconds) the time from timIn to timeOut with the number of samples

        listArtifacts = [];
        for i=1:length(ProcessedData)
            
            % The threshold varies depending on the signal
            if ProcessedData(i)>=10
                listArtifacts = [listArtifacts;time(ProcessedData == ProcessedData(i))];
            end
        end
    end
    listArtifacts = sort(listArtifacts);
    if ~isempty(listArtifacts)     %if not empty
        transmisionLineArtifactsTimeIn = listArtifacts(1);
        TransmisionLineArtifactsTimeOut = [];
        for i=1:length(listArtifacts)-1
            if listArtifacts(i+1)-listArtifacts(i) > (0.6)
                TransmisionLineArtifactsTimeOut = [TransmisionLineArtifactsTimeOut;listArtifacts(i)];
                transmisionLineArtifactsTimeIn = [transmisionLineArtifactsTimeIn;listArtifacts(i+1)];
            end
        end
        TransmisionLineArtifactsTimeOut = [TransmisionLineArtifactsTimeOut;listArtifacts(end)];
    else
        transmisionLineArtifactsTimeIn = [];
        TransmisionLineArtifactsTimeOut = [];   
    end
    msg = ['Transmision line detection for ' fileName ' is finsished ...'];
    disp(msg);
end
