%This function has been created in order to
%not count many times the same spike
%Author : Emelyne Vignon
%Contact : emelyne.vignon@reseau.eseo.fr

function [AlgoFusionTimeIn,AlgoFusionTimeOut] = DerivationFusion(Algo_timeIn,Algo_timeOut,File,algo)
    
%Initialization 
    AlgoFusionTimeIn = [];
    AlgoFusionTimeOut = [];
    Algo_timeIn = Algo_timeIn/1000; %to allow the comparison with time in seconds
    Algo_timeOut = Algo_timeOut/1000;
    Recordings = File.Recordings;
    NumDerivation = length(Recordings.nrElectrodeLeft(:,1));
    DetectionParameters = File.DetectionParameters;
    windowLength = DetectionParameters.WindowLength/1000;
    fileData = struct([]);
    if endsWith(File.Name,'.mat')
        fileData = load([Recordings.path '/' File.Name]);
    end
    nrElectrodeLeft = deblank(Recordings.nrElectrodeLeft(1,:));
    nrElectrodeRight = deblank(Recordings.nrElectrodeRight(1,:));
    data = [];
    
    %Data to initialize the matrix and time
    for k=1:length(Recordings.timeIn)
        [raw_data] = GetData(Recordings.timeIn(k),Recordings.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Recordings.fname,DetectionParameters,fileData);
        data = [data;raw_data];
    end
    interval = length(data);
    time = linspace(Recordings.timeIn(1),Recordings.timeOut(length(Recordings.timeOut)),interval); %In seconds
        
    mat = zeros(NumDerivation/2,interval);
    
    %Find zeros which separate each derivation
    x0 = find(~Algo_timeOut);
    x1 = find(Algo_timeOut);
    
    %Replace 0 by 1 if there is a spike
    if algo == true
        for Derivation=1:NumDerivation/2
            for n=1:length(x0)
                if Derivation == n
                    if Derivation==1 && x0(n) ~= 1
                        for timeSpikes=1:x1(x0(n)-1)
                            x = find(time>=Algo_timeIn(timeSpikes) & time<=Algo_timeOut(timeSpikes));
                            mat(Derivation,x(1):x(end)) = 1;
                        end
                    elseif Derivation>1
                        beginDerivation = x0(n-1)+1;
                        endDerivation = x0(n)-1;
                        if x0(n)-x0(n-1) > 1
                            for timeSpikes=beginDerivation:endDerivation
                                x = find(time>=Algo_timeIn(timeSpikes) & time<=Algo_timeOut(timeSpikes));
                                mat(Derivation,x(1):x(end)) = 1;
                            end
                        end
                    end
                end
            end
        end
    elseif algo == false
        for n=1:length(x0)
            if n==1 && x0(n) ~= 1
                for timeSpikes=1:x1(x0(n)-1)
                    x = find(time>=Algo_timeIn(timeSpikes) & time<=Algo_timeOut(timeSpikes));
                    mat(n,x(1):x(end)) = 1;
                end
            elseif n>1
                beginDerivation = x0(n-1)+1;
                endDerivation = x0(n)-1;
                if x0(n)-x0(n-1) > 1
                    for timeSpikes=beginDerivation:endDerivation
                        x = find(time>=Algo_timeIn(timeSpikes) & time<=Algo_timeOut(timeSpikes));
                        mat(n,x(1):x(end)) = 1;
                    end
                end
            end
        end
    end
    
    %Create a matrix which sum all the spikes of 1 patient
    S = sum(mat);
    %figure; plot(time,S);

    %List of timeIn/timeOut if a spike is detected at least by 2 derivations
    for i=2:length(S)-1
       if (S(i-1)==0 || S(i-1)==1) && S(i)>1
            AlgoFusionTimeIn = [AlgoFusionTimeIn;time(i)];
       end
       if S(i)>1 && (S(i+1)==0 || S(i+1)==1)
           AlgoFusionTimeOut = [AlgoFusionTimeOut;time(i)];
       end
    end
    
    % If there is a spike detected at the first second or at the last
    % second
    if ~isequal(length(AlgoFusionTimeIn),length(AlgoFusionTimeOut))
        if length(AlgoFusionTimeIn) > length(AlgoFusionTimeOut)
            AlgoFusionTimeOut(end+1) = AlgoFusionTimeIn(end) + windowLength;
        else
            beg = AlgoFusionTimeOut(1) - windowLength;
            AlgoFusionTimeIn = [beg;AlgoFusionTimeIn];
        end
    end
    
    
    %Centered the spike's window
    AlgoFusionTimeIn2 = [];
    AlgoFusionTimeOut2 = [];
    for j=1:length(AlgoFusionTimeIn)
       if AlgoFusionTimeOut(j)-AlgoFusionTimeIn(j)>windowLength || AlgoFusionTimeOut(j)-AlgoFusionTimeIn(j)<windowLength
           nbSpikes = (AlgoFusionTimeOut(j)-AlgoFusionTimeIn(j))/windowLength;
           if floor(nbSpikes) == 0
                middle = (AlgoFusionTimeIn(j)+AlgoFusionTimeOut(j))/2;
                AlgoFusionTimeIn2 = [AlgoFusionTimeIn2;middle - (windowLength/2)];
                AlgoFusionTimeOut2 = [AlgoFusionTimeOut2;middle + (windowLength/2)];
           else
               kIn = 0 ;
               kOut = floor(nbSpikes)-1;
               for k=1:floor(nbSpikes)
                middle = ((AlgoFusionTimeOut(j)-(kOut*windowLength))+(AlgoFusionTimeIn(j)+(kIn*windowLength)))/2;
                AlgoFusionTimeIn2 = [AlgoFusionTimeIn2;middle - (windowLength/2)];
                AlgoFusionTimeOut2 = [AlgoFusionTimeOut2;middle + (windowLength/2)];
                kIn = kIn+1;
                kOut = kOut-1;
               end
           end
       end
    end
    AlgoFusionTimeIn = AlgoFusionTimeIn2*1000;
    AlgoFusionTimeOut = AlgoFusionTimeOut2*1000;
end