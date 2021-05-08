function [Algo_timeIn_hCopy,Algo_timeOut_hCopy] = Check_spikes_horizontal(CurrentRecording)

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

NumDerivation = length(Recording.nrElectrodeLeft(1:44,1));
order_channels = [9 1 5 13 19 10 2 17 6 14 21 20 11 3 18 7 15 22 12 4 8 16];
order_electrodes = [17 18 1 2 9 10 25 26 37 38 19 29 3 4 33 34 11 12 27 28 41 42 39 40 21 22 5 6 35 36 13 14 29 30 43 44 23 24 7 8 15 16 31 32 ];
index_start = [9 19 20 12];
index_stop = [13 21 22 16];

%Take spikes detected after the specific detection for the analyzed file
PatientSpecificDetSpikes1 = file(CurrentRecording).PatientSpecificDetSpikes(:,1:44);

%Put them into two lists with the times of beginning and end of the window
%where spikes are detected. There is a 0 between each channel.
[Algo_timeInCopy,Algo_timeOutCopy] = Check_spikes(CurrentRecording);
% [Algo_timeIn,Algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes1);
%List with the position of zeros in Algo_timeOut in order to see when we
%switch from one channel to another
% x0 = find(~Algo_timeOutCopy);
x0 = find(~Algo_timeOutCopy);
%Create a big matrix retrieving all signals (time-amplitude) where each column = one derivation 
[MatDataTot]=zeros(DetectionParameters.Fs*(Recording.timeOut(length(Recording.timeOut))-Recording.timeIn(1)),NumDerivation/2);


for Derivation=1:2:NumDerivation-1
    
    Index = order_electrodes(Derivation);
    nrElectrodeLeft = deblank(Recording.nrElectrodeLeft(Index,:));
    nrElectrodeRight = deblank(Recording.nrElectrodeRight(Index,:));
    
    dataTot = GetData(Recording.timeIn(1),Recording.timeOut(length(Recording.timeOut)),nrElectrodeRight,nrElectrodeLeft,Recording.fname,DetectionParameters,fileData);
    %Put the data for one derivation in the matrix
    MatDataTot(:,ceil(Derivation/2))=dataTot;
      
end

%Create the two vectors which will be filled with the spikes kept
Algo_timeIn_h = zeros();
Algo_timeOut_h = zeros();

a = 1;
for i = 1 : 1 : length(order_channels)
        index = order_channels(i);
        x0_h(i) = x0(index); %list of values for next channels
        stop = x0_h(i)-1;
        if index == 1
            start = 1;
        else
            start = x0(index-1)+1;
        end
        
        for i = start : 1 : stop 
%             b = Algo_timeInCopy(i);
%             c = Algo_timeOutCopy(i);
            b = Algo_timeInCopy(i);
            c = Algo_timeOutCopy(i);
            Algo_timeIn_h(a) = b;
            Algo_timeOut_h(a) = c;
            a = a + 1;           
        end
        Algo_timeIn_h(a)= 0;              %Put a 0 in the list containing times of spikes checked when a derivation is finished 
        Algo_timeOut_h(a)= 0; 
%         Algo_timeInCopy(a)= 0;              %Put a 0 in the list containing times of spikes checked when a derivation is finished 
%         Algo_timeOutCopy(a)= 0;             %to keep the same structure as AlgotimeIn
        a = a + 1;  
end
x1 = find(~Algo_timeOut_h);
x1 = x1.';
nr = length(x1);

Algo_timeIn_hCopy = zeros();
Algo_timeOut_hCopy = zeros();

sum = 1;        %Index to save the previous position in ListDeriv 1->4 then 5->8,...
p=1;            %index to increment in the arrays Algo_TimeInCopy and Algo_timeOutCopy
ListDerivh = [4,7,7,4];

for t = 1:1:length(ListDerivh)                     %Browse the ListDeriv
    
    for j=1:1:ListDerivh(t)                        %j browses derivation per derivation

        
        if j==1 && t==1                           %In the first derivation in the first raw
            for i=1:1:x1(sum)-1                   %Browse all times of spikes in the first derivation
%                  disp(i)
%                  disp(sum)
                indexIn  = round(Algo_timeIn_h(i)/4); %Retrieve timeIn where spikes are detected 
                indexOut  = round(Algo_timeOut_h(i)/4 - 1); %Retrieve timeOut where spikes are detected
                %Divided by 4 because 1 second to 250 ms (data are in a scale of 250ms)
                % -1 to not count two times the same time (end of the previous window and beginning of the next one)
                
                [data1] = MatDataTot(indexIn:indexOut,sum);       %Retrieve amplitudes of the first derivation for the window defined
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
                    Algo_timeIn_hCopy(p)=Algo_timeIn_h(i);              %Put in AlgotimeInCopy the good spikes (their times)
                    Algo_timeOut_hCopy(p)=Algo_timeOut_h(i);
                    p=p+1;                                          %Increment in the arrays Algo_TimeInCopy and Algo_timeOutCopy
                    
                else
                    %fprintf("Spike NON /n")                        %Don't keep the times of spikes beacuse not a phase opposition
                end     
            end
        end
        
        
        if j==1 && t>1                                 %For first derivation not in the first raw in order to not compare with a fake neighbour
                                                  %which is in the previous raw
            for i=x1(sum-1)+1:1:x1(sum)-1                %Browse all times of spikes in the first derivation
%                 disp(i)
%                 disp(sum)
                indexIn  = round(Algo_timeIn_h(i)/4);
                indexOut  = round(Algo_timeOut_h(i)/4 - 1);
                
                [data1] = MatDataTot(indexIn:indexOut,sum);        
                [data2] = MatDataTot(indexIn:indexOut,sum+1);
                if ListDerivh(t)>2                      %Because not needed to compare with a third channel if only two channels in the row
                    [data3] = MatDataTot(indexIn:indexOut,sum+2);
                end
                
                a = xcorr(data1,0);
                b = xcorr(data2,0);
                c = xcorr(data3,0);
                resultab = xcorr(data1, data2,0)/((a*b)^(1/2));
                resultac = xcorr(data1, data3,0)/((a*c)^(1/2));
                
                if resultab <= threshold || resultac <= threshold
                    %fprintf("Spike OK /n")
                    Algo_timeIn_hCopy(p)=Algo_timeIn_h(i);
                    Algo_timeOut_hCopy(p)=Algo_timeOut_h(i);
                    p=p+1;
                    
                else
                    %fprintf("Spike NON /n")
                end
                
            end
        end
        if  j>1 && j<ListDerivh(t)          %For derivations which are not the first or the last
%             disp(i)
%             disp(sum)
            for i=(x1(sum-1))+1:1:x1(sum)-1%Browse times where spikes are detected in the derivation
                
                indexIn  = round(Algo_timeIn_h(i)/4);
                indexOut  = round(Algo_timeOut_h(i)/4 - 1);
                
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
                    Algo_timeIn_hCopy(p)=Algo_timeIn_h(i);
                    Algo_timeOut_hCopy(p)=Algo_timeOut_h(i);
                    p=p+1;
                    
                else
                    %fprintf("Spike NON /n")
                end
            end
        end
        
        if j==ListDerivh(t)                        %For the last derivation
            
            for i=x1(sum-1)+1:1:x1(sum)-1       %Browse the times where spikes are detected in the last derivation in order to
%                 disp(i)
%                 disp(sum)                                  %not compare with a fake neighbour which is in the next raw
                indexIn  = round(Algo_timeIn_h(i)/4);
                indexOut  = round(Algo_timeOut_h(i)/4 - 1);
                
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
                    Algo_timeIn_hCopy(p)=Algo_timeIn_h(i);
                    Algo_timeOut_hCopy(p)=Algo_timeOut_h(i);
                    p=p+1;
                    
                else
                    %fprintf("Spike NON /n")
                end
            end
        end

        Algo_timeIn_hCopy(p)= 0;              %Put a 0 in the list containing times of spikes checked when a derivation is finished 
        Algo_timeOut_hCopy(p)= 0;             %to keep the same structure as AlgotimeIn
        p=p+1;
        sum = sum + 1;                      %Increment for the ListDeriv 
    end
end
% Algo_timeIn_hCopy = Algo_timeIn_hCopy.';        %Change the arrays from line to column to keep the same structure
% Algo_timeOut_hCopy = Algo_timeOut_hCopy.';

Algo_timeIn_v = zeros();
Algo_timeOut_v = zeros();

x = 1;
x3 = find(~Algo_timeOut_hCopy);
x3 = x3.';
disp(length(x3));
for i = 1 : 1 : length(order_channels)
        index = order_channels(i);
        x2(index) = x3(i); %list of values for next channels
        stop = x3(index)-1;
        if index == 1
            start = 1;
        else
            start = x3(index-1)+1;
        end
        
        for i = start : 1 : stop 
            b = Algo_timeIn_hCopy(i);
            c = Algo_timeOut_hCopy(i);
            Algo_timeIn_v(x) = b;
            Algo_timeOut_v(x) = c;
            x = x + 1;           
        end
         Algo_timeIn_v(x)= 0;              %Put a 0 in the list containing times of spikes checked when a derivation is finished 
         Algo_timeOut_v(x)= 0;             %to keep the same structure as AlgotimeIn
         x = x + 1;  
end
Algo_timeIn_v = Algo_timeIn_v.'
Algo_timeIn_v = Algo_timeOut_v.';
x4 = find(~Algo_timeIn_v);
disp(length(x4))
end
    