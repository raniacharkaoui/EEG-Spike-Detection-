%%%This function works on Matlab V2016 and more!!
%%%Otherwise the function "contains" doesn't exist

%This function compares the channel selected in Start with the channel
%contained in, either the header if the selected file is a .edf, or in the
%datas if the selected file is a .mat

function Channel = Get_Channel(path,fileName,channel,fileData)

    if isa(fileData,'struct') % In case there is only one file selected
        if endsWith(fileName,'.edf') || endsWith(fileName,'.EDF')
            [edfFile] = edfread([path '\' fileName]);
            x = edfFile.label;
            k = find(contains(x,channel));
            if(k ~= 0)
                Channel = x{k};
            else
                Channel = 0;
            end
        elseif endsWith(fileName,'.mat')
            list = [];
            dataCh = fileData.Data.ChDesc;
            for i=1:length(dataCh)
                if i==1
                    list1 = dataCh(1).Name;
                    list = list1;
                else
                    list1 = dataCh(i).Name;
                    list = [list list1] ;
                end
                list = cellstr(list);
            end
            k = find(contains(list,channel),1,'first'); %need to have O2 before SaO2
            if(k ~= 0)
                Channel = ['EEG ' list{k}];
            else
                Channel = 0;
            end
        end
    elseif isa(fileData,'cell') % In case there is many files selected
        for i=1:length(fileName)
            if endsWith(fileName,'.edf') || endsWith(fileName,'.EDF')
                [edfFile] = edfread([path '\' fileName]);
                x = edfFile.label;
                k = find(contains(x,channel));
                if(k ~= 0)
                    Channel = x{k};
                else
                    Channel = 0;
                end
            elseif endsWith(fileName,'.mat')
                list = [];
                for j=1:length(fileData)
                    if ~isempty(fileData{j})
                        dataCh = fileData{j}.Data.ChDesc;
                        for i=1:length(dataCh)
                            if i==1
                                list1 = dataCh(1).Name;
                                list = list1;
                            else
                                list1 = dataCh(i).Name;
                                list = [list list1] ;
                            end
                            list = cellstr(list);
                        end
                    end
                end
                k = find(contains(list,channel),1,'first'); %need to have O2 before SaO2
                if(k ~= 0)
                    Channel = ['EEG ' list{k}];
                else
                    Channel = 0;
                end
            end
        end
    end