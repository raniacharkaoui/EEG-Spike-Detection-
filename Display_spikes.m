%This function is used to call the Display function
%It allows to display a window for every patient

function Display_spikes()

load('Spikes.mat','file');

for CurrentRecording=1:length(file) % Display for each file
    if file(CurrentRecording).ChosenFile == 1
        nbExp = file(CurrentRecording).nbExp;
        Exp1_timeIn = file(CurrentRecording).Exp_timeIn(1).Expert1;
        Exp1_timeOut = file(CurrentRecording).Exp_timeOut(1).Expert1;
        Exp2_timeIn = file(CurrentRecording).Exp_timeIn.Expert2;
        Exp2_timeOut = file(CurrentRecording).Exp_timeOut.Expert2;
        isAllChecked_v = file(CurrentRecording).Recordings.isAllchecked_v;
        isAllChecked_h = file(CurrentRecording).Recordings.isAllchecked_h;
        transversalMontage = file(CurrentRecording).Recordings.transversalMontage;
        
        PatientSpecificDetSpikes1 = file(CurrentRecording).PatientSpecificDetSpikes;
        
        if isAllChecked_v == 1 && isAllChecked_h == 0 && transversalMontage == 0
        [Algo_timeIn,Algo_timeOut] = Check_spikes(CurrentRecording);%Check_spikes is used only if all channels in longitudinal montage are chosen
        elseif isAllChecked_v == 0 && isAllChecked_h == 1 && transversalMontage == 0 %Check_spikes_horizontal is used only if all channels in longitudinal montage are chosen and the "horizontal analysis" option is ticked
            [Algo_timeIn,Algo_timeOut] = Check_spikes_horizontal(CurrentRecording);
        elseif  isAllChecked_v == 0 && isAllChecked_h == 0 && transversalMontage == 1 %Check_spikes_transversal will be used only if the bipolar transversal montage is chosen
            [Algo_timeIn,Algo_timeOut] = Check_spikes_transversal(CurrentRecording);
        else
            [Algo_timeIn,Algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes1);
        end
        
        if length(PatientSpecificDetSpikes1)>2
            [AlgoFusion_timeIn,AlgoFusion_timeOut] = DerivationFusion(Algo_timeIn,Algo_timeOut,file(CurrentRecording),true);
            [Algo_timeIn,Algo_timeOut,~,~] = Same_Spikes(Algo_timeIn,Algo_timeOut,AlgoFusion_timeIn,AlgoFusion_timeOut);
        end
        
        if nbExp == 2 || nbExp == 0
            [Exp_timeIn,Exp_timeOut,~,~] = Same_Spikes(Exp1_timeIn,Exp1_timeOut,Exp2_timeIn,Exp2_timeOut);
        elseif nbExp == 3
            Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
            Exp3_timeOut = file(CurrentRecording).Exp_timeOut.Expert3;
            
            %         [Exp12_timeIn,Exp12_timeOut,~,~] = Same_Spikes(Exp1_timeIn,Exp1_timeOut,Exp2_timeIn,Exp2_timeOut);
            %         [Exp23_timeIn,Exp23_timeOut,~,~] = Same_Spikes(Exp2_timeIn,Exp2_timeOut,Exp3_timeIn,Exp3_timeOut);
            %         [Exp31_timeIn,Exp31_timeOut,~,~] = Same_Spikes(Exp3_timeIn,Exp3_timeOut,Exp1_timeIn,Exp1_timeOut);
            %
            %         Exp_timeIn = unique([Exp12_timeIn;Exp23_timeIn;Exp31_timeIn]);
            %         Exp_timeOut = unique([Exp12_timeOut;Exp23_timeOut;Exp31_timeOut]);
            
            Exp_timeIn = [Exp1_timeIn;0;Exp2_timeIn;0;Exp3_timeIn;0];
            Exp_timeOut = [Exp1_timeOut;0;Exp2_timeOut;0;Exp3_timeOut;0];
            
            [Exp_timeIn,Exp_timeOut] = DerivationFusion(Exp_timeIn,Exp_timeOut,file(CurrentRecording),false);
            
        elseif nbExp == 4
            %         Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
            %         Exp3_timeOut = file(CurrentRecording).Exp_timeOut.Expert3;
            %         Exp4_timeIn = file(CurrentRecording).Exp_timeIn.Expert4;
            %         Exp4_timeOut = file(CurrentRecording).Exp_timeOut.Expert4;
            %Change if 4 experts needed
            [Exp_timeIn,Exp_timeOut,~,~] = Same_Spikes(Exp1_timeIn,Exp1_timeOut,Exp2_timeIn,Exp2_timeOut);
        end
        
        Exp_timeIn = floor(Exp_timeIn);
        Exp_timeOut = floor(Exp_timeOut);
        
        [~,~ , Solo_Exp_timeIn,Solo_Exp_timeOut] = Same_Spikes(Exp_timeIn,Exp_timeOut,Algo_timeIn,Algo_timeOut);
        [Same_spikes_timeIn,Same_spikes_timeOut , Solo_algo_timeIn,Solo_algo_timeOut] = Same_Spikes(Algo_timeIn,Algo_timeOut,Exp_timeIn,Exp_timeOut);
        
        Same_spikes_timeIn = Same_spikes_timeIn/1000;
        Same_spikes_timeOut =Same_spikes_timeOut/1000; %Divided by 1000 to be in seconds
        Solo_Exp_timeIn = Solo_Exp_timeIn/1000;
        Solo_Exp_timeOut = Solo_Exp_timeOut/1000;
        Solo_algo_timeIn = Solo_algo_timeIn/1000;
        Solo_algo_timeOut = Solo_algo_timeOut/1000;
        
        if Exp_timeIn==0
            Same_spikes_timeIn = 0;
            Same_spikes_timeOut = 0;
            Solo_Exp_timeIn = 0;
            Solo_Exp_timeOut = 0;
        end
        same_spike_list = zeros(length(Same_spikes_timeIn),2);
        same_spike_list(:,1) = Same_spikes_timeIn;
        same_spike_list(:,2) = Same_spikes_timeOut;
        file(CurrentRecording).same_spikes = same_spike_list;
        save('Spikes.mat','file');
        % Alpha Waves
        Alpha_timeIn = [];
        Alpha_timeOut = [];
        for i=1:length(file(CurrentRecording).AlphaWaves)
            Alpha_timeIn = [Alpha_timeIn;file(CurrentRecording).AlphaWaves(i).DetectedTime(:,1);0];
            Alpha_timeOut = [Alpha_timeOut;file(CurrentRecording).AlphaWaves(i).DetectedTime(:,2);0];
        end
        
        
        % % Display on GUI
        Display(file(CurrentRecording),Solo_algo_timeIn,Solo_algo_timeOut,Solo_Exp_timeIn,Solo_Exp_timeOut,Same_spikes_timeIn,Same_spikes_timeOut,Alpha_timeIn, Alpha_timeOut);
    end
end
end