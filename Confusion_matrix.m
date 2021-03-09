%Display the confusion matrix after the analysis is finished
%It also allow to save the confusion matrix as a pdf/jpg/png file

function Confusion_matrix()

    load('Spikes.mat','file');
    index = 1; 
    
    fig=figure('units','pixels',...
    'position',[550 250 480 300],...
    'numbertitle','off',...
    'name','Spike Detection - Result',...
    'menubar', 'none',...
    'tag','result');

   % Creation of a menu bar to save file
    menu1 = uimenu( fig, 'label' , 'Save...' );
    uimenu( menu1 , 'label' , 'Save as PDF' , 'callback' , @save_PDF );
    data = cell(3*length(file),4); %initialization of data size
    
    for CurrentRecording=1:length(file) % Display a confusion matrix for each file
        nbExp = file(CurrentRecording).nbExp;
        Exp1_timeIn = file(CurrentRecording).Exp_timeIn.Expert1;
        Exp1_timeOut = file(CurrentRecording).Exp_timeOut.Expert1;
        Exp2_timeIn = file(CurrentRecording).Exp_timeIn.Expert2;
        Exp2_timeOut = file(CurrentRecording).Exp_timeOut.Expert2;
        
        isAllChecked = file(CurrentRecording).Recordings.isAllchecked; %Checking if check_spikes function can be used
        
        PatientSpecificDetSpikes1 = file(CurrentRecording).PatientSpecificDetSpikes;
        
        if isAllChecked == 1
            [Algo_timeIn,Algo_timeOut] = Check_spikes(CurrentRecording); %Check_spikes is used only if all channels are chosen
        else
            [Algo_timeIn,Algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes1);
        end
        
        if length(PatientSpecificDetSpikes1)>2
           [Algo_timeIn,Algo_timeOut] = DerivationFusion(Algo_timeIn,Algo_timeOut,file(CurrentRecording),true);
        end
        
        if nbExp == 2 || nbExp == 0
        % Calculation of precision and sensitivity - Inter Expert 
        [SensitivityA,PrecisionA,PearsonCoefExp] = StatMesures_Two(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut);

        % Calculation of precision and sensitivity - Algo VS Experts  
        [SensitivityAlgo,PrecisionAlgo,PearsonCoefAlgo] = StatMesures_algo_Two(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut, Algo_timeIn, Algo_timeOut);
            
        elseif nbExp == 3
            Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
            Exp3_timeOut = file(CurrentRecording).Exp_timeOut.Expert3;
            
            % Calculation of precision and sensitivity - Inter Expert
            [SensitivityA,PrecisionA,PearsonCoefExp] = StatMesures_Three(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut,Exp3_timeIn,Exp3_timeOut);

             % Calculation of precision and sensitivity - Algo VS Experts
            [SensitivityAlgo,PrecisionAlgo,PearsonCoefAlgo] = StatMesures_algo_Three(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut, Exp3_timeIn, Exp3_timeOut, Algo_timeIn, Algo_timeOut);
                
        elseif nbExp == 4
            Exp3_timeIn = file(CurrentRecording).Exp_timeIn.Expert3;
            Exp3_timeOut = file(CurrentRecording).Exp_timeOut.Expert3;
            Exp4_timeIn = file(CurrentRecording).Exp_timeIn.Expert4;
            Exp4_timeOut = file(CurrentRecording).Exp_timeOut.Expert4;
            
            % Calculation of precision and sensitivity - Inter Expert
            [SensitivityA,PrecisionA,PearsonCoefExp] = StatMesures_Four(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut,Exp3_timeIn,Exp3_timeOut,Exp4_timeIn,Exp4_timeOut);

            % Calculation of precision and sensitivity - Algo VS Experts 
            [SensitivityAlgo,PrecisionAlgo,PearsonCoefAlgo] = StatMesures_algo_Four(Exp1_timeIn, Exp1_timeOut, Exp2_timeIn,Exp2_timeOut,Exp3_timeIn,Exp3_timeOut,Exp4_timeIn,Exp4_timeOut,Algo_timeIn,Algo_timeOut);
            
        end
        patientName = ['Patient : ' file(CurrentRecording).Name];
        data(index:index+2,:) = {patientName, 'Sensitivity', SensitivityA, SensitivityAlgo;...
            '', 'Precision', PrecisionA, PrecisionAlgo;...
            '', 'Pearson Correlation ',PearsonCoefExp ,PearsonCoefAlgo};
        

        % Displaying the results 
        if CurrentRecording==1
            t = uitable(fig);
            set(t,'Data',data);
            set(t, 'RowName', []);
            set(t, 'ColumnName', {'Patients','Parameters','Experts','Algorithm'});
            set(t, 'Position', [1 0 500 300]);
            set(t,'ColumnWidth', {150 110 110 110 110});
            index=index+3;
        else
            set(t,'Data',data);
            index=index+3;
        end
    end
    %To obtain the Pearson correlation coefficient
    %meanSens = mean(SensitivityAlgorithm)
    %meanPrec = mean(PrecisionAlgorithm)
end