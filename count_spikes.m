function count_spikes()
% This function counts the number of spikes and 
% spikes frequency (spikes per second & spikes per minutes)
% of each derivation and for each patient selected by the user 

% Author : Kevin Nzeyimana (kevin.nzeyimana@reseau.eseo.fr)
load('Spikes.mat','file');
for current=1:length(file)
%     PatientSpecificDetSpikes = file(current).PatientSpecificDetSpikes;
%     [algo_timeIn,algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes);
    for i=1:2:length(file(current).PatientSpecificDetSpikes)-1
        %% Recovery of the channels selected
        name = [file(current).Recordings.nrElectrodeLeft(i,:) ' ' file(current).Recordings.nrElectrodeRight(i,:)];
        file(current).channels(i).Name = [name(5:7) ' - ' name(12:end)];
        timeIn_1 = [];
        timeOut_1 = [];
        timeIn_2 = [];
        timeOut_2 = [];
        
         %The spikes time for the first polarity
         if(length(fieldnames(file(current).PatientSpecificDetSpikes(i).Det)) > 1)
             for j=1:length(file(current).PatientSpecificDetSpikes(i).Det.Epoch)
                if ~isempty(file(current).PatientSpecificDetSpikes(i).Det.Epoch(j).DetectedTime)
                    timeIn_1 = [timeIn_1;file(current).PatientSpecificDetSpikes(i).Det.Epoch(j).DetectedTime(:,1)];
                    timeOut_1 = [timeOut_1;file(current).PatientSpecificDetSpikes(i).Det.Epoch(j).DetectedTime(:,2)];
                end
             end
         else
             for j=1:length(file(current).PatientSpecificDetSpikes(i).Det)
                 if ~isempty(file(current).PatientSpecificDetSpikes(i).Det(j).Det)
                    timeIn_1 = [timeIn_1;file(current).PatientSpecificDetSpikes(i).Det(j).Det(:,1)];
                    timeOut_1 = [timeOut_1;file(current).PatientSpecificDetSpikes(i).Det(j).Det(:,2)];
                 end
             end
         end
         %The spikes time for the second polarity
         if (length(fieldnames(file(current).PatientSpecificDetSpikes(i+1).Det)) > 1)
             for j=1:length(file(current).PatientSpecificDetSpikes(i+1).Det.Epoch)
                if ~isempty(file(current).PatientSpecificDetSpikes(i+1).Det.Epoch(j).DetectedTime)
                    timeIn_2 = [timeIn_2;file(current).PatientSpecificDetSpikes(i+1).Det.Epoch(j).DetectedTime(:,1)];
                    timeOut_2 = [timeOut_2;file(current).PatientSpecificDetSpikes(i+1).Det.Epoch(j).DetectedTime(:,2)];
                end
             end
         else
             for j=1:length(file(current).PatientSpecificDetSpikes(i+1).Det)
                 if ~isempty(file(current).PatientSpecificDetSpikes(i+1).Det(j).Det)
                     timeIn_2 = [timeIn_2;file(current).PatientSpecificDetSpikes(i+1).Det(j).Det(:,1)];
                     timeOut_2 = [timeOut_2;file(current).PatientSpecificDetSpikes(i+1).Det(j).Det(:,2)];
                 end
             end
         end
        [Same_spikes_timeIn,~,Solo_first_timeIn,~] = Same_Spikes(timeIn_1,timeOut_1,timeIn_2,timeOut_2);
        [~,~ , Solo_second_timeIn,~] = Same_Spikes(timeIn_2,timeOut_2,timeIn_1,timeOut_1);
        nb_spikes = length(Same_spikes_timeIn) + length(Solo_first_timeIn) + length(Solo_second_timeIn);
        file(current).channels(i).spikes = nb_spikes;
    end
    channels = struct();
    for i=1:2:length(file(current).channels)
        if ~isempty(file(current).channels(i).Name)
            if i==1
                channels(i).Name = file(current).channels(i).Name;
                channels(i).spikes = file(current).channels(i).spikes;
            else
                channels(end+1).Name = file(current).channels(i).Name;
                channels(end).spikes = file(current).channels(i).spikes;
            end
        end
    end
    file(current).channels = channels;
    time =0;
    for k=1:length(file(current).Recordings.timeIn)
        time = time + file(current).Recordings.timeOut(k) - file(current).Recordings.timeIn(k); %seconds
    end
    time_2 = time/60; % minutes
    for k=1:length(file(current).channels)
        file(current).channels(k).spikes_sec = file(current).channels(k).spikes/time; % Spikes per seconds
        file(current).channels(k).spikes_min = file(current).channels(k).spikes/time_2; % Spikes per minutes
    end
end

    save('Spikes.mat','file');
end