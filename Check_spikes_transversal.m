%Authors : Selene Argyrakis, Rym Ouachi and Lisa Woby Mfongou
function [Algo_timeInCopy,Algo_timeOutCopy] = Check_spikes_transversal(CurrentRecording)

%Function equivalent to Check_spikes but with a horizontal montage

load('Spikes.mat','file');    %Beginnig from the file Spikes.mat which possesses all times of spikes detected (AlgotimeIn, AlgotimeOut)

fileName = file(CurrentRecording).Name;     %Pass all the parameters from the current file analyzed
Recording = file(CurrentRecording).Recordings;
DetectionParameters = file(CurrentRecording).DetectionParameters;
path = Recording.path;
fileData = struct([]);
threshold = DetectionParameters.CheckThresh; %Threshold for the negative cross-correlation for the phase opposition 
if endsWith(fileName,'.mat')
    fileData = load([path '\' fileName]);
end

% Retrieve number of EEG derivations (channels on horizontal montage)
NumDerivation = length(Recording.nrElectrodeLeft(1:40,1));

%List containing the numbers of channels for one raw to compare good neighbours

ListDerivh = [1,6,6,6,1];


%Take spikes detected after the specific detection for the analyzed file
PatientSpecificDetSpikes1 = file(CurrentRecording).PatientSpecificDetSpikes;


%Put them into two lists with the times of beginning and end of the window
%where spikes are detected. There is a 0 between each channel.
[Algo_timeIn,Algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes1);



%List with the position of zeros in Algo_timeOut in order to see when we
%switch from one channel to another
x0 = find(~Algo_timeOut);
s = length(x0);


%Create a big matrix retrieving all signals (time-amplitude) where each column = one derivation 
[MatDataTot]=zeros(DetectionParameters.Fs*(Recording.timeOut(length(Recording.timeOut))-Recording.timeIn(1)),NumDerivation/2);

%Browse the different derivation by step of 2 because of the two ways
for Derivation=1:2:NumDerivation-1
    
    nrElectrodeLeft = deblank(Recording.nrElectrodeLeft(Derivation,:));
    nrElectrodeRight = deblank(Recording.nrElectrodeRight(Derivation,:));
    
    %Signal time-amplitude for one derivation
    dataTot = GetData(Recording.timeIn(1),Recording.timeOut(length(Recording.timeOut)),nrElectrodeRight,nrElectrodeLeft,Recording.fname,DetectionParameters,fileData);
    
    
    %Put the data for one derivation in the matrix
    MatDataTot(:,ceil(Derivation/2))=dataTot;
end
% 
% [lin,col] = size(MatDataTot)

threshold = 0.1;

nb_min_same_pics = 2;
[Algo_timeInCopy,Algo_timeOutCopy] = Check_Same_SpikeDetected(Algo_timeIn,Algo_timeOut, threshold, nb_min_same_pics);

sum = 1;        %Index to save the previous position in ListDeriv 1->4 then 5->8,...
p=1;            %index to increment in the arrays Algo_TimeInCopy and Algo_timeOutCopy

for t = 1:1:length(ListDerivh)                     %Browse the ListDeriv
    
    for j=1:1:ListDerivh(t)                        %j browses derivation per derivation
        
         if t == 1                         %In the first derivation in the first row : only one channel             
            for i=1:1:x0(sum)-1                   %Browse all times of spikes in the first derivation

                    Algo_timeInCopy(p)=Algo_timeIn(i);              %Put in AlgotimeInCopy the good spikes (their times)
                    Algo_timeOutCopy(p)=Algo_timeOut(i);
                    p=p+1;                                          %Increment in the arrays Algo_TimeInCopy and Algo_timeOutCopy
                    
                    
            end
         end 
        
        
        if (t==2 | t ==3 | t==4) && j == 1             %For first derivation not in the first row in order to not compare with a fake neighbour
                                                       %which is in the previous row
            for i=x0(sum-1)+1:1:x0(sum)-1              %Browse all times of spikes in the first derivation
%                  disp(i)
                indexIn  = round(Algo_timeIn(i)/4);
                indexOut  = round(Algo_timeOut(i)/4 - 1);
                
                [data1] = MatDataTot(indexIn:indexOut,sum);        
                [data2] = MatDataTot(indexIn:indexOut,sum+1);
                [data3] = MatDataTot(indexIn:indexOut,sum+2);
                
                
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
        
        if (t==2 | t ==3 | t==4) && j==6            %For the last derivation of each row
            
            for i=x0(sum-1)+1:1:x0(sum)-1         %Browse the times where spikes are detected in the last derivation in order to
                                                  %not compare with a fake neighbour which is in the next row
                indexIn  = round(Algo_timeIn(i)/4);
                indexOut  = round(Algo_timeOut(i)/4 - 1);
                
                [data1] = MatDataTot(indexIn:indexOut,sum);
                [data2] = MatDataTot(indexIn:indexOut,sum-1);     %Data of the previous channel
                if ListDerivh(t)>2
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
        if  (t==2 | t ==3 | t==4) && 1<j<6        %For derivations which are not the first or the last
            
            for i=x0(sum-1)+1:1:x0(sum)-1%Browse times where spikes are detected in the derivation
                
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
        
        if t == 5 
            for i = x0(sum-1)+1:1:x0(sum) - 1
                    Algo_timeInCopy(p)=Algo_timeIn(i);              %Put in AlgotimeInCopy the good spikes (their times)
                    Algo_timeOutCopy(p)=Algo_timeOut(i);
                    p=p+1;
            end  
        end
        Algo_timeInCopy(p)= 0;              %Put a 0 in the list containing times of spikes checked when a derivation is finished 
        Algo_timeOutCopy(p)= 0;             %to keep the same structure as AlgotimeIn
        p=p+1;
        sum = sum + 1   ;                 %Increment for the ListDerivh 
    end
end
Algo_timeInCopy = Algo_timeInCopy.' ;       %Change the arrays from line to column to keep the same structure
Algo_timeOutCopy = Algo_timeOutCopy.';

end