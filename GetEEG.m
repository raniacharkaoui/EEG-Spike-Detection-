%%%Collect the amplitude of each derivation for the MAT files
%%%Author : Emelyne Vignon
%Contact : emelyne.vignon@reseau.eseo.fr

function [x] = GetEEG(Fs,timeIn,timeOut,fileData,channel)

    list = [];
    x = [];
    if timeIn==0
        timeIn = 1 ;
    else
        timeIn = round(Fs*timeIn);
    end
    if timeOut > fileData.Data.timeSpan
        timeOut = fileData.Data.timeSpan;
    end
    timeOut = round(Fs*timeOut);
    if isa(fileData,'cell')
        for j=1:length(fileData)
            if ~isempty(fileData{j})
                dataCh = fileData{j}.Data.ChDesc;
                for i=1:length(dataCh)
                    if i==1
                        list1 = dataCh(1).Name;
                        list = ['EEG ' list1];
                    else
                        list1 = ['EEG ' dataCh(i).Name];
                        list = [list list1] ;
                    end
                    list = cellstr(list);
                end
                file = fileData{j};
            end
        end
    else
        for j=1:length(fileData)
            dataCh = fileData(j).Data.ChDesc;
            for i=1:length(dataCh)
                if i==1
                    list1 = dataCh(1).Name;
                    list = ['EEG ' list1];
                else
                    list1 = ['EEG ' dataCh(i).Name];
                    list = [list list1] ;
                end
                list = cellstr(list);
            end
            file = fileData(j);
        end
    end
    posChannel = find(contains(list,channel),1,'first'); %need to have O2 before SaO2
    [~,dataCol] = size(file.Data.EEG);
    for numCol=1:dataCol 
        if posChannel == numCol
            x = file.Data.EEG(timeIn:timeOut,numCol);
        end
    end