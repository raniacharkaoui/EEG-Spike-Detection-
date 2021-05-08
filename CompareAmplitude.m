% This function creates a window for each patient 
% in which we can find a table with all the data 
% about each derivation and two graphics.
% See the report on the analyze of amplitude for more details
% Author : Emelyne Vignon


function CompareAmplitude()

    load('Spikes.mat','file');
    %Subjective list of the background amplitude for each patient
    listBG = [40 40 40 40 40 40 40 25 35 40 20 40 40 20 40 20 40; 
              100 100 100 80 70 60 100 80 100 50 80 100 50 60 70 70 80;
              30 30 30 30 40 30 60 60 30 40 40 40 40 20 40 15 50;
              60 60 55 70 40 50 70 60 80 100 80 60 50 50 100 30 80] ;
    
    for CurrentRecording = 1 : length(file)
      % Initialization of the different variables
        DetectionParameters = file(CurrentRecording).DetectionParameters;
        Recordings = file(CurrentRecording).Recordings;
        fileName = file(CurrentRecording).Name;
        path = file(CurrentRecording).Recordings.path;
        fileData = struct([]);
        if endsWith(file(CurrentRecording).Name,'.mat')
            fileData = load([path '/' fileName]);
        end
        NumDerivation = length(Recordings.nrElectrodeLeft(:,1));
        % Times for the true positive spikes
        timeIn = file(CurrentRecording).same_spikes(:,1);
        timeOut = file(CurrentRecording).same_spikes(:,2);

        %Find zeros which separate each derivation
        x0 = find(~timeOut);
        x1 = find(timeOut);
        indexDerivation = 1;
        tab = cell(NumDerivation/2,9); %initialization of data size
        f = figure;
        subplot(2,2,[1,2]);
        pos1=get(subplot(2,2,[1,2]),'Position'); un1=get(subplot(2,2,[1,2]),'Units');
        delete(subplot(2,2,[1,2]));
        t = uitable(f);
        set(t, 'ColumnName',{'Derivation','std(signal)','estimated BG','6*rms(BG)','Vpp(GenericSpike)','std(GenericSpike)','Vpp(TP)','std(spike)'});
        set(t,'Units', un1);
        set(t, 'Position', pos1);
        sub1 = subplot(2,2,3);
        
        for Derivation = 1:2:NumDerivation
            nrElectrodeLeft = deblank(Recordings.nrElectrodeLeft(Derivation,:));
            nrElectrodeRight = deblank(Recordings.nrElectrodeRight(Derivation,:));
            
            % Collect the time in and time out for the current derivation
            for n=1:length(x0)
                if indexDerivation == n
                    if indexDerivation==1 && x0(n) ~= 1
                        timeInDerivation = timeIn(1:x1(x0(n)-1));
                        timeOutDerivation = timeOut(1:x1(x0(n)-1));
                    elseif indexDerivation>1
                        beginDerivation = x0(n-1)+1;
                        endDerivation = x0(n)-1;
                        if x0(n)-x0(n-1) > 1
                            timeInDerivation = timeIn(beginDerivation:endDerivation);
                            timeOutDerivation = timeOut(beginDerivation:endDerivation);
                        end
                    else
                        timeInDerivation = [];
                        timeOutDerivation = [];
                    end
                end
            end
            
            %backgroundTimes = sort([Recordings.timeIn Recordings.timeOut;timeOutDerivation timeInDerivation]);
            
            % Collect the data for the entire signal and for the signal
            % without artifacts and filter it 
            [RawData] = GetData(Recordings.timeIn(1),Recordings.timeOut(length(Recordings.timeOut)),nrElectrodeLeft,nrElectrodeRight,Recordings.fname,DetectionParameters,fileData);
            [FilteredData] = Filter(RawData,DetectionParameters);
            data = [];
            for k=1:length(Recordings.timeIn)
                [RawDataConcatenated] = GetData(Recordings.timeIn(k),Recordings.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Recordings.fname,DetectionParameters,fileData);
                data = [data;RawDataConcatenated];
            end
            
            [FilteredDataConcatenated] = Filter(data,DetectionParameters);

            
            interval = length(FilteredData);
            time = linspace(Recordings.timeIn(1),Recordings.timeOut(length(Recordings.timeOut)),interval); %In seconds
            %figure;plot(time,FilteredData);
            
            % Collect the data about each true positive spike on current derivation
            indexVpp = 1;
            spikeVpp = [];
            spikeSTD = [];
            if ~isempty(timeInDerivation)
                for timeSpikes=1:length(timeInDerivation)
                    x = find(time>=timeInDerivation(timeSpikes) & time<=timeOutDerivation(timeSpikes));
                    spikeFiltered = FilteredData(x(1):x(end));
                    spikeVpp(indexVpp) = peak2peak(spikeFiltered);
                    spikeSTD(indexVpp) = std(spikeFiltered);
                    indexVpp = indexVpp+1;
                end
            else
                spikeVpp(indexVpp) = 0;
                spikeSTD(indexVpp) = 0;
            end
 
            avgSpikeVpp = mean(spikeVpp);
            avgSpikeSTD = mean(spikeSTD);
            % Data on the generic spike of the current derivation
            GenericVpp = file(CurrentRecording).GenericSpike.Amplitude;
            GenericSTD = file(CurrentRecording).GenericSpike.AmplitudeSTD;
            
            % Add a line on the table
            nrElectrodeLeft=(erase(nrElectrodeLeft,'EEG '));
            nrElectrodeRight=(erase(nrElectrodeRight,'EEG '));
            tab(indexDerivation,:) = {[nrElectrodeLeft '-' nrElectrodeRight],...
                        std(FilteredDataConcatenated),...
                        listBG(CurrentRecording,indexDerivation),...
                        6*rms(FilteredDataConcatenated),...
                        GenericVpp,...
                        GenericSTD,...
                        avgSpikeVpp,...
                        avgSpikeSTD,...
                        avgSpikeVpp-GenericVpp};
            set(t,'Data',tab);
            
            if CurrentRecording == 1
                a = 11.6;
                b = -25.25;
            elseif CurrentRecording == 2
                a = 8.8;
                b = -22.45;
            elseif CurrentRecording == 3
                a = 4.78;
                b = 7.39;
            else
                a = 7.5;
                b = -17.59;
            end
            
            listSTD(indexDerivation,CurrentRecording) = std(FilteredDataConcatenated);
            listGS(indexDerivation,CurrentRecording) = a*std(FilteredDataConcatenated)+b;
            listGSFinal(indexDerivation,CurrentRecording) = 9.3*std(FilteredDataConcatenated)-21.76;
            listTP(indexDerivation,CurrentRecording) = avgSpikeVpp;
            listCoef(indexDerivation) = avgSpikeVpp/std(FilteredDataConcatenated);
            indexDerivation = indexDerivation+1;
        end 
        disp(mean(listSTD(:,CurrentRecording)))
        % Creation of two graphics
        scatter(sub1,listGS(:,CurrentRecording),listTP(:,CurrentRecording),'.');
        xlabel('Vpp(GS)');ylabel('Vpp(TP)');
        lsline;
        sub2 = subplot(2,2,4);
        scatter(sub2,listSTD(:,CurrentRecording),listTP(:,CurrentRecording),'.');
        xlabel('std(signal)');ylabel('Vpp(TP)');
        lsline;
    end
    figure; subplot(2,1,1);
    scatter(listGS(:,1),listTP(:,1),'.');
    hold on
    scatter(listGS(:,2),listTP(:,2),'.');
    scatter(listGS(:,4),listTP(:,4),'.');
    scatter(listGS(:,3),listTP(:,3),'.');
    
    l = lsline;
    l(:,1).Color = [0 0.4470 0.7410];
    l(:,1).Annotation.LegendInformation.IconDisplayStyle = 'off';
    l(:,2).Color = [0.8500 0.3250 0.0980];
    l(:,2).Annotation.LegendInformation.IconDisplayStyle = 'off';
    l(:,3).Color = [0.9290 0.6940 0.1250];
    l(:,3).Annotation.LegendInformation.IconDisplayStyle = 'off';
    l(:,4).Color = [0.4940 0.1840 0.5560];
    l(:,4).Annotation.LegendInformation.IconDisplayStyle = 'off';
    xlabel('Vpp(GenericSpike)');ylabel('Vpp(TP)');
    legend('AD','GF','VV','JP','Location','northwest');
    subplot(2,1,2);
    scatter(listGSFinal(:,1),listTP(:,1),'.');
    hold on
    scatter(listGSFinal(:,2),listTP(:,2),'.');
    scatter(listGSFinal(:,4),listTP(:,4),'.');
    scatter(listGSFinal(:,3),listTP(:,3),'.');
    plot([0 200],[0 200]);
    l = lsline;
    l(:,4).Color = [0 0.4470 0.7410];
    l(:,4).Annotation.LegendInformation.IconDisplayStyle = 'off';
    l(:,3).Color = [0.8500 0.3250 0.0980];
    l(:,3).Annotation.LegendInformation.IconDisplayStyle = 'off';
    l(:,2).Color = [0.9290 0.6940 0.1250];
    l(:,2).Annotation.LegendInformation.IconDisplayStyle = 'off';
    l(:,1).Color = [0.4940 0.1840 0.5560];
    l(:,1).Annotation.LegendInformation.IconDisplayStyle = 'off';
    xlabel('Vpp(GenericSpikeFinal)');ylabel('Vpp(TP)');
    legend('AD','GF','VV','JP','Location','northwest');
end