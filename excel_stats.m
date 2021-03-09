%% Creates an excel file with relevant statistics of the spikes.mat file
%%% Authors: Mathieu Biava, Ahmed Bader, 
%%% ULB      David Perez, Alain Zheng


function excel_stats()
    disp('Creating Excel file...');
    count_spikes(); %function that computes the number of spikes per derivation
    load('Spikes.mat','file');
    for CurrentRecording = 1:length(file)
        if file(CurrentRecording).ChosenFile == 1
            folder = 'ExcelData';
            if exist(folder) ~= 7 % if folder does not exist
                mkdir 'ExcelData'
            end
            fileName = [folder '/' strcat(file(CurrentRecording).Name(1:5),'_stats','.xlsx')];
            names = {'Derivation','Spikes','Spikes_sec','Spikes_min'};
            data = struct2cell(file(CurrentRecording).channels); %structure with the information of the number of spikes per derivation
            data=permute(data,[3,1,2]); 
            SWI = file(CurrentRecording).SWI;
            NumClusters = file(CurrentRecording).NumClusters;
            DerivName = strings(length(file(CurrentRecording).PatientSpecificDetSpikes),1); %setting an array with the names of the derivations
            
            for i=1:length(file(CurrentRecording).PatientSpecificDetSpikes) %filling of the array 
                name = [file(CurrentRecording).Recordings.nrElectrodeLeft(i,:) ' ' file(CurrentRecording).Recordings.nrElectrodeRight(i,:)];
                DerivName(i) = [name(5:7) ' - ' name(12:end)];
            end
            
            xlswrite(fileName,names);
            xlswrite(fileName,data(:,:),1,'A2');
            xlswrite(fileName,{'Derivation'},1,'F1');            
            xlswrite(fileName,DerivName,1,'F2');
            xlswrite(fileName,{'SWI'},1,'G1');
            xlswrite(fileName,SWI,1,'G2');
            xlswrite(fileName,{'Number of clusters'},1,'H1');
            xlswrite(fileName,NumClusters,1,'H2');
            xlswrite(fileName,{'-1 indicates derivations for which clusters are not computed' },1,'J1');            
            winopen(fileName); %just opens the file
            disp(['Finished creating ' erase(fileName,'.mat')]);

        end
    end
end
