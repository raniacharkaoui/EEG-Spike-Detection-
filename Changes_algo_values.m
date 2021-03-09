%%%This function is needed to put all the spikes detected on each channel
%%%on a list of time_In et time_Out without duplicates


function [algo_timeIn,algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes)

    algo_timeIn = [];
    algo_timeOut = [];
    
     for i=1:2:length(PatientSpecificDetSpikes)-1 %%% put all the times of detections on two lists
        timeIn_1 = [];
        timeOut_1 = [];
        timeIn_2 = [];
        timeOut_2 = [];
        
         %The spikes time for the first polarity
         if(length(fieldnames(PatientSpecificDetSpikes(i).Det)) > 1)
             for j=1:length(PatientSpecificDetSpikes(i).Det.Epoch)
                if ~isempty(PatientSpecificDetSpikes(i).Det.Epoch(j).DetectedTime)
                    timeIn_1 = [timeIn_1;PatientSpecificDetSpikes(i).Det.Epoch(j).DetectedTime(:,1)];
                    timeOut_1 = [timeOut_1;PatientSpecificDetSpikes(i).Det.Epoch(j).DetectedTime(:,2)];
                end
             end
         else
             for j=1:length(PatientSpecificDetSpikes(i).Det)
                 if ~isempty(PatientSpecificDetSpikes(i).Det(j).Det)
                    timeIn_1 = [timeIn_1;PatientSpecificDetSpikes(i).Det(j).Det(:,1)];
                    timeOut_1 = [timeOut_1;PatientSpecificDetSpikes(i).Det(j).Det(:,2)];
                 end
             end
         end
         %The spikes time for the second polarity
         if (length(fieldnames(PatientSpecificDetSpikes(i+1).Det)) > 1)
             for j=1:length(PatientSpecificDetSpikes(i+1).Det.Epoch)
                if ~isempty(PatientSpecificDetSpikes(i+1).Det.Epoch(j).DetectedTime)
                    timeIn_2 = [timeIn_2;PatientSpecificDetSpikes(i+1).Det.Epoch(j).DetectedTime(:,1)];
                    timeOut_2 = [timeOut_2;PatientSpecificDetSpikes(i+1).Det.Epoch(j).DetectedTime(:,2)];
                end
             end
         else
             for j=1:length(PatientSpecificDetSpikes(i+1).Det)
                 if ~isempty(PatientSpecificDetSpikes(i+1).Det(j).Det)
                     timeIn_2 = [timeIn_2;PatientSpecificDetSpikes(i+1).Det(j).Det(:,1)];
                     timeOut_2 = [timeOut_2;PatientSpecificDetSpikes(i+1).Det(j).Det(:,2)];
                 end
             end
         end
            [Same_spikes_timeIn,Same_spikes_timeOut,Solo_first_timeIn,Solo_first_timeOut] = Same_Spikes(timeIn_1,timeOut_1,timeIn_2,timeOut_2);
            [~,~ , Solo_second_timeIn,Solo_second_timeOut] = Same_Spikes(timeIn_2,timeOut_2,timeIn_1,timeOut_1);

            algoTimeIn1 = unique([Same_spikes_timeIn;Solo_first_timeIn;Solo_second_timeIn]);
            algoTimeOut1 = unique([Same_spikes_timeOut;Solo_first_timeOut;Solo_second_timeOut]);
            algo_timeIn = [algo_timeIn;algoTimeIn1;0];
            algo_timeOut = [algo_timeOut;algoTimeOut1;0];
    end
end