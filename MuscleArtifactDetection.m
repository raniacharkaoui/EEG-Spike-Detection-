%This function allows the detection of muscle artifacts according to a
%threshold.
%Author :Laura 
%Contact : 

function [artifactTimeIn,artifactTimeOut] = MuscleArtifactDetection(File)

    Recordings = File.Recordings;
    DetectionParameters = File.DetectionParameters;
    fileName = File.Name;
    path = File.Recordings.path;
    fileData = struct([]);
    
    msg = ['Muscular artifact  detection for ' fileName ' is launched ...'];
    disp(msg);
    
    if endsWith(fileName,'.mat')
        fileData = load([path '/' fileName]);
    end
    if endsWith(fileName,'.edf') || endsWith(fileName,'.EDF')
        electrode = {'EOG RSO';'EOG LIO'};
        
    elseif endsWith(fileName,'.mat')
        electrode = {'RSO';'LIO'};
    end
    electrode=cell2mat(electrode);
    [electrodeRow,~]=size(electrode);
    electrodeRef = '';

    timeIn = Recordings.timeIn(1);   %on prend le premier timeIN et le dernier timeOut ? PQ ?
    timeOut = Recordings.timeOut(length(Recordings.timeOut));
    
    for j=1:electrodeRow
        [RawData] = GetData(timeIn,timeOut,electrode(j,:),electrodeRef,Recordings.fname,DetectionParameters,fileData);
        %[ProcessedData] = PreProcessing(RawData,DetectionParameters); 
 %% HighPass filter
 %This part of the function considers as artifact all the time intervals
 %where the signal of the EOG exceeds a certain threshold. 
 %As the artifacts usually have a frequency above 25Hz, a Highpass filter
 %of 30Hz is first applied to the data. 
 
        Wn = 30/(DetectionParameters.Fs/2);   
        [Bhp,Ahp] = butter(1,Wn,'high'); 
        ProcessedData = filtfilt(Bhp,Ahp,RawData); 

        interval = length(RawData);
        time = linspace(timeIn,timeOut,interval); %In seconds

        listArtifacts = [];
        for i=1:length(ProcessedData)
            if ProcessedData(i)>=10
                listArtifacts = [listArtifacts;time(ProcessedData == ProcessedData(i))];
            end
        end
        
  %% Bandpass filter
  %By analysing the signals in EDFBrowser, it can be observed that
  %oscillations of frequency 12-15Hz present in the EOGs impact the signal.
  %To remove them, they are first isolated by applying a bandpass filter
  %and then a threshold is applied. 
  %The threshold is defined in two ways: - fixed threshold for all the
  %patients, - adaptable threshold for each patient.
  
        Wn2 = 12/(DetectionParameters.Fs/2);  
        Wn3 = 15/(DetectionParameters.Fs/2);
        [Bhp2,Ahp2] = butter(1,[Wn2 Wn3],'bandpass'); 
        ProcessedData2 = filtfilt(Bhp2,Ahp2,ProcessedData);
        MProcessedData2=[];

        %%Fixed threshold: (comment if variable thresholds are used)
        for i=1:length(ProcessedData2)
            if ProcessedData2(i)>=3 
                j=i;
                while ProcessedData2(j)>=1.5 
                    listArtifacts = [listArtifacts;time(ProcessedData2 == ProcessedData2(j))];
                    j=j-1;
                end
                while ProcessedData2(j)>=1.5 
                    listArtifacts = [listArtifacts;time(ProcessedData2 == ProcessedData2(j))];
                    j=j+1;
                end
            end
        end
        
%         %%Variable threshold: (comment if fixed thresholds are used)
%         Max=max(abs(ProcessedData2)); % detects the maximum of the signal
%         
%         for k=1:length(ProcessedData2)
%             if abs(ProcessedData2(k))>0.75*Max  %Researchs the intervals where the signal is >0.75*Max
%                 MProcessedData2=[MProcessedData2; abs(ProcessedData2(k))];
%             end
%         end
%         Maximums=[];
%         if length(MProcessedData2)>20
%             for h=1:20
%                 [Maxi,I]=max(MProcessedData2);
%                 Maximums=[Maximums, Maxi];
%                 MProcessedData2(I)=[];
%             end
%         else
%             Maximums=MProcessedData2;
%         end    
%         M2=mean(Maximums); %Calculates the mean of the 20 max values of the signal
%         for i=1:length(ProcessedData2)
%             if ProcessedData2(i)>=M2/1.85
%                 j=i;
%                 while ProcessedData2(j)>=M2/3.70
%                     listArtifacts = [listArtifacts;time(ProcessedData2 == ProcessedData2(j))];
%                     j=j-1;
%                 end
%                 while ProcessedData2(j)>=M2/3.70
%                     listArtifacts = [listArtifacts;time(ProcessedData2 == ProcessedData2(j))];
%                     j=j+1;
%                 end
%             end
%         end
        
    end
    listArtifacts = sort(listArtifacts);
    if ~isempty(listArtifacts)     %if not empty
        artifactTimeIn = listArtifacts(1);
        artifactTimeOut = [];
        for i=1:length(listArtifacts)-1
            if listArtifacts(i+1)-listArtifacts(i) > (0.8)
                artifactTimeOut = [artifactTimeOut;listArtifacts(i)];
                artifactTimeIn = [artifactTimeIn;listArtifacts(i+1)];
            end
        end
        artifactTimeOut = [artifactTimeOut;listArtifacts(end)];
    else
        artifactTimeIn = [];
        artifactTimeOut = [];
    end
    
    msg = ['Muscular artifact  detection for ' fileName ' is finished ...'];
    disp(msg);
end
