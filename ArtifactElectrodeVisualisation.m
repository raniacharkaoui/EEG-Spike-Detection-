%This function is used to observed the "bonus" electrodes
%that is to say, ECG, SaO2, EOG and EMG signals on every patients.
%Author : Emelyne Vignon
%Contact : emelyne.vignon@reseau.eseo.fr

function ArtifactElectrodeVisualisation()
    load('Spikes.mat','file');

    
    electrode = {'ECG';'SaO2';'RSO';'LIO';'EMG RA';'EMG LA'};
    %Sometimes, it is necessary to have a reference electrode
    %Either it is Cz or Pz depending on how the signal is sensible
    %to noise or others activities in the brain
    electrodeRef = '';

    for CurrentRecording = 1 : length(file)
        Recordings = file(CurrentRecording).Recordings;
        timeIn = Recordings.timeIn(1);
        timeOut = Recordings.timeOut(length(Recordings.timeOut));
        DetectionParameters = file(CurrentRecording).DetectionParameters;
        fileName = file(CurrentRecording).Name;
        path = file(CurrentRecording).Recordings.path;
        fileData = struct([]);
        if endsWith(file(CurrentRecording).Name,'.mat')
            fileData = load([path '/' fileName]);
        end
        f = figure;
        set(f,'Name',fileName)

        index = 1;
        for k=1:length(electrode)
            if k==4
                index = 7;
            end
            if strcmp(electrode(k),'ECG') || strcmp(electrode(k),'SaO2')
                [RawData] = GetData(timeIn,timeOut,electrode(k),'',Recordings.fname,DetectionParameters,fileData);
            else
                [RawData] = GetData(timeIn,timeOut,electrode(k),electrodeRef,Recordings.fname,DetectionParameters,fileData);
            end
            
            Wn = 30/(DetectionParameters.Fs/2); 
            [Bhp,Ahp] = butter(5,Wn,'high'); 
            ProcessedData = filtfilt(Bhp,Ahp,RawData); 
            
            interval = length(RawData);
            time = linspace(timeIn,timeOut,interval); %In seconds

            rawDataPlot=subplot(4,3,index);plot(time,RawData');title(electrode(k));
            processedDataPlot=subplot(4,3,index+3);plot(time,ProcessedData);
            linkaxes([rawDataPlot,processedDataPlot],'x');
            index = index+1;
        end
    end
end