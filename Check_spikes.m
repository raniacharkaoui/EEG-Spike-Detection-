%Authors : Zineeb Smine & Rania Charkaoui 

function [Algo_timeInCopy,Algo_timeOutCopy] = Check_spikes(CurrentRecording)

%Summary of this function goes here
%Function which checks all spikes detected before by the spike detection
%algorithm,in order to verify if there is a phase opposition or not
%If yes -> keep spikes
%If not -> don't keep them

%Arguments
%Current recording -> If there is more than one file to analyze
%Algo_timeInCopy,Algo_timeOutCopy -> List of the times when spikes confirmed are
%detected 

%Takes spikes detected in input file and verifies if they're real spikes,
%if so, puts them in output vectors

load('Spikes.mat','file');    %Beginnig from the file Spikes.mat which possesses all times of spikes detected (AlgotimeIn, AlgotimeOut)

fileName = file(CurrentRecording).Name;     %Pass all the parameters from the current file analyzed
Recording = file(CurrentRecording).Recordings;
DetectionParameters = file(CurrentRecording).DetectionParameters;
path = Recording.path;
fileData = struct([]);
threshold = DetectionParameters.CheckThresh; %Threshold for the negative cross-correlation for the phase opposition 
%ListDeriv = Recording.ListDeriv;             %List containing the numbers of channels for one raw to compare good neighbours
if endsWith(fileName,'.mat')
    fileData = load([path '/' fileName]);
end

% Retrieve number of EEG derivations (channels)
NumDerivation = length(Recording.nrElectrodeLeft(:,1));

%Store channel names in arrays
%electrodeLeft=Recording.nrElectrodeLeft(:,:);
%electrodeRight=Recording.nrElectrodeRight(:,:);

%List containing the numbers of channels for one raw to compare good neighbours
ListDeriv = [4,4,4,4,2,2,2];


%Take spikes detected after the specific detection for the analyzed file
PatientSpecificDetSpikes1 = file(CurrentRecording).PatientSpecificDetSpikes;


%Put them into two lists with the times of beginning and end of the window
%where spikes are detected. There is a 0 between each channel.
[Algo_timeIn,Algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes1);

%List with the position of zeros in Algo_timeOut in order to see when we
%switch from one channel to another
x0 = find(~Algo_timeOut);
%x1 = find(Algo_timeOut);

%Create a big matrix retrieving all signals (time-amplitude) where each column = one derivation 
[MatDataTot]=zeros(DetectionParameters.Fs*(Recording.timeOut(length(Recording.timeOut))-Recording.timeIn(1)),NumDerivation/2);

%Browse the different derivation by step of 2 because of the two ways
%(F3-P3 and P3-F3)
for Derivation=1:2:NumDerivation-1
    
    nrElectrodeLeft = deblank(Recording.nrElectrodeLeft(Derivation,:));
    nrElectrodeRight = deblank(Recording.nrElectrodeRight(Derivation,:));
    
    %Signal time-amplitude for one derivation
    dataTot = GetData(Recording.timeIn(1),Recording.timeOut(length(Recording.timeOut)),nrElectrodeRight,nrElectrodeLeft,Recording.fname,DetectionParameters,fileData);
    %interval = length(dataTot);
    
    %Put the data for one derivation in the matrix
    MatDataTot(:,ceil(Derivation/2))=dataTot;
    
end
%Create the two vectors which will be filled with the spikes kept
%Algo_timeInCopy = zeros();
%Algo_timeOutCopy = zeros();
threshold = 0.1;

nb_min_same_pics = 2;
[Algo_timeInCopy,Algo_timeOutCopy] = Check_Same_SpikeDetected(Algo_timeIn,Algo_timeOut, threshold, nb_min_same_pics);

sum = 1;        %Index to save the previous position in ListDeriv 1->4 then 5->8,...
p=1;            %index to increment in the arrays Algo_TimeInCopy and Algo_timeOutCopy

for t = 1:1:length(ListDeriv)                     %Browse the ListDeriv
    
    for j=1:1:ListDeriv(t)                        %j browses derivation per derivation

        
        if j==1 && t==1                           %In the first derivation in the first raw
            for i=1:1:x0(sum)-1                   %Browse all times of spikes in the first derivation
                indexIn  = round(Algo_timeIn(i)/4); %Retrieve timeIn where spikes are detected 
                indexOut  = round(Algo_timeOut(i)/4 - 1); %Retrieve timeOut where spikes are detected
                %Divided by 4 because 1 second to 250 ms (data are in a scale of 250ms)
                % -1 to not count two times the same time (end of the previous window and beginning of the next one)
                
                [data1] = MatDataTot(indexIn:indexOut,sum);         %Retrieve amplitudes of the first derivation for the window defined
                [data2] = MatDataTot(indexIn:indexOut,sum+1);       %Amplitudes for the second derivation for the window defined
                [data3] = MatDataTot(indexIn:indexOut,sum+2);       %Amplitudes for the third derivation for the window defined
                
                a = xcorr(data1,0);         %Autocorrelation of data1
                b = xcorr(data2,0);         %Autocorrelation of data2
                c = xcorr(data3,0);         %Autocorrelation of data3
                resultab = xcorr(data1, data2,0)/((a*b)^(1/2));     %Cross-correlation between data1 and 2, normalized to have a result between -1 and 1
                resultac = xcorr(data1, data3,0)/((a*c)^(1/2));     %Cross-correlation between data1 and 3, normalized to have a result between -1 and 1
                
                if resultab <= threshold || resultac <= threshold   %Verify one of the two thresholds because there are two possibilities of phase opposition
                                                                    %-> Spike can be between two electrodes or on one electrode
                                                                
                    %fprintf("Spike OK /n")
                    Algo_timeInCopy(p)=Algo_timeIn(i);              %Put in AlgotimeInCopy the good spikes (their times)
                    Algo_timeOutCopy(p)=Algo_timeOut(i);
                    p=p+1;                                          %Increment in the arrays Algo_TimeInCopy and Algo_timeOutCopy
                    
                else
                    %fprintf("Spike NON /n")                        %Don't keep the times of spikes beacuse not a phase opposition
                end     
            end
        end
        
        
        if j==1 && t>1                                 %For first derivation not in the first raw in order to not compare with a fake neighbour
                                                       %which is in the previous raw
            for i=x0(sum-1)+1:1:x0(sum)-1                %Browse all times of spikes in the first derivation
                
                indexIn  = round(Algo_timeIn(i)/4);
                indexOut  = round(Algo_timeOut(i)/4 - 1);
                
                [data1] = MatDataTot(indexIn:indexOut,sum);        
                [data2] = MatDataTot(indexIn:indexOut,sum+1);
                if ListDeriv(t)>2                      %Because not needed to compare with a third channel if only two channels in the row
                    [data3] = MatDataTot(indexIn:indexOut,sum+2);
                end
                
                a = xcorr(data1,0);
                b = xcorr(data2,0);
                c = xcorr(data3,0);
                resultab = xcorr(data1, data2,0)/((a*b)^(1/2));
                resultac = xcorr(data1, data3,0)/((a*c)^(1/2));
                
                if resultab <= threshold || resultac <= threshold
                    %fprintf("Spike OK /n")
                    Algo_timeInCopy(p)=Algo_timeIn(i);
                    Algo_timeOutCopy(p)=Algo_timeOut(i);
                    p=p+1;
                    
                else
                    %fprintf("Spike NON /n")
                end
                
            end
        end
        
        if j==ListDeriv(t)                        %For the last derivation
            
            for i=(x0(sum-1))+1:1:x0(sum)-1         %Browse the times where spikes are detected in the last derivation in order to
                                                  %not compare with a fake neighbour which is in the next raw
                indexIn  = round(Algo_timeIn(i)/4);
                indexOut  = round(Algo_timeOut(i)/4 - 1);
                
                [data1] = MatDataTot(indexIn:indexOut,sum);
                [data2] = MatDataTot(indexIn:indexOut,sum-1);     %Data of the previous channel
                if ListDeriv(t)>2
                    [data3] = MatDataTot(indexIn:indexOut,sum-2); %Data of the second channel before
                end
                
                a = xcorr(data1,0);
                b = xcorr(data2,0);
                c = xcorr(data3,0);
                resultab = xcorr(data1, data2,0)/((a*b)^(1/2));
                resultac = xcorr(data1, data3,0)/((a*c)^(1/2));
                
                if resultab <= threshold || resultac <= threshold
                    %fprintf("Spike OK /n")
                    Algo_timeInCopy(p)=Algo_timeIn(i);
                    Algo_timeOutCopy(p)=Algo_timeOut(i);
                    p=p+1;
                    
                else
                    %fprintf("Spike NON /n")
                end
            end
        end
        if  j>1 && j<ListDeriv(t)          %For derivations which are not the first or the last
            
            for i=(x0(sum-1))+1:1:x0(sum)-1%Browse times where spikes are detected in the derivation
                
                indexIn  = round(Algo_timeIn(i)/4);
                indexOut  = round(Algo_timeOut(i)/4 - 1);
                
                [data1] = MatDataTot(indexIn:indexOut,sum);
                [data2] = MatDataTot(indexIn:indexOut,sum-1); %Data in the previous channel
                [data3] = MatDataTot(indexIn:indexOut,sum+1); %Data in the next channel
                
                
                a = xcorr(data1,0);
                b = xcorr(data2,0);
                c = xcorr(data3,0);
                resultab = xcorr(data1, data2,0)/((a*b)^(1/2));
                resultac = xcorr(data1, data3,0)/((a*c)^(1/2));
                
                if resultab <= threshold || resultac <= threshold
                    %fprintf("Spike OK /n")
                    Algo_timeInCopy(p)=Algo_timeIn(i);
                    Algo_timeOutCopy(p)=Algo_timeOut(i);
                    p=p+1;
                    
                else
                    %fprintf("Spike NON /n")
                end
            end
        end
        Algo_timeInCopy(p)= 0;              %Put a 0 in the list containing times of spikes checked when a derivation is finished 
        Algo_timeOutCopy(p)= 0;             %to keep the same structure as AlgotimeIn
        p=p+1;
        sum = sum + 1;                      %Increment for the ListDeriv 
    end
end
Algo_timeInCopy = Algo_timeInCopy.';        %Change the arrays from line to column to keep the same structure
Algo_timeOutCopy = Algo_timeOutCopy.';

%threshold est l'interval de temps dans lequel on considère que 2 pics
%sont les mêmes s'il sont tous les deux détectés dans cet interval
% threshold = 0.1;
% 
% % nb_min_same_pics est le nombre minimum de fois qu'un pic doit être détecté 
% % pour être accepté
% nb_min_same_pics = 2;
% disp("before")
% %disp(Algo_timeInCopy)
% [Algo_timeInCopy,Algo_timeOutCopy] = Check_delays(Algo_timeIn,Algo_timeOut, threshold, nb_min_same_pics);
% 
% disp("in")
% disp(Algo_timeInCopy)
% disp("out")
% disp(Algo_timeOutCopy)

end

