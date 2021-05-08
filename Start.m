
function Start()
%%This is the launch of the first interface
%%%There is the initialization of many buttons and the possibility to fill
%%%the Atributpat file 
%%It launchs the main function    


if exist('Spikes.mat','file') ~= 0 
    delete('Spikes.mat');
end
  
% Graphical interface  
fig = figure('units','pixels',...
    'position',[550 250 500 200],...
    'numbertitle','off',...
    'Name','Spike detection',...
    'menubar','none',...
    'tag','interface');

movegui(fig,'center');

% Choose the file
uicontrol('style','pushbutton',...
     'units','normalized',...
     'position',[0.02 0.5 0.4 0.3],... 
     'string','Choose file(s) to analyze : ',...
     'callback',@choose_file,...
     'tag','tagEDFMat');
    
uicontrol('style','text',...
     'units','normalized',...
     'position',[0.45 0.5 0.5 0.3],...
     'Backgroundcolor',[1 1 1],...
     'string','',...
     'tag','fileEDFMat');



 
% Creation of the object Uicontrol choose characteristics. 
     uicontrol('style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.05 0.1 0.25 0.2],...
     'string','Choose Characteristics',...    
     'callback',@Go,...
     'tag','bouton_Start');
 
% Creation of the object Uicontrol Start 
     uicontrol('style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.65 0.1 0.25 0.2],...
     'string','Start Analysis (1)',...    
     'callback',@StartAnalysis,...
     'tag','bouton_Startanalysis');
 
 % Creation of the object Uicontrol getPreviousAnalysis
     uicontrol('style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.35 0.1 0.25 0.2],...
     'string','Get Previous Analysis',...    
     'callback',@GetPreviousAnalysis,...
     'tag','bouton_GetPrevious');
 
 data=guihandles(gcf);
 guidata(gcf,data);
end


%% Allow the user to choose EDF or Mat file(s) that will be analyzed by the
% algorithm 
function choose_file(~,~)
    data=guidata(gcbf);
    %filePath = [pwd '\Data\'] ; %useful to have a shortcut
    [fileName, path] = uigetfile(...
        {'*.edf;*.mat','Accepted files (*.edf,*.mat)';...
        '*.edf','EDF-files (*.edf)';...
        '*.mat','MAT-files (*.mat)';...
        '*.*',  'All Files (*.*)'},...
        'Choose the file:',...
        'MultiSelect','on');%,filePath);
    if  ~isequal(fileName,0) % in case we don't choose a file
        fileData = cell(length(fileName));
        if isa(fileName,'cell')
            for i=1:length(fileName)
                file(i).Name = fileName{i};
                file(i).Done = false;
                if endsWith(fileName{i},'.mat')
                    fileData{i} = load([path '\' fileName{i}]);
                end
            end
        else
                file.Name = fileName;
                file.Done = false;
            if endsWith(fileName,'.mat')
                fileData = load([path '/' fileName]);
            end
        end 
        save('Spikes.mat','file');
        setappdata(gcbf,'fileData',fileData);
        setappdata(gcf,'path',path);
        setappdata(gcf,'fileName',fileName);
        set(data.fileEDFMat,'string',fileName);
        guidata(gcbf,data);
    else
        disp('No file(s) selected')
    end
end

%% Launch the characteristics window
function Go(~,~)
load('Spikes.mat','file');
fileData = getappdata(gcf,'fileData');
path = getappdata(gcf,'path');
close(gcf);
changeChar = 1; % 1 = true we want to change parameter, open next window
for CurrentRecording=1:length(file)
    if file(CurrentRecording).Done == false
        Characteristics(CurrentRecording,file(CurrentRecording).Name,fileData,path,changeChar);
        file(CurrentRecording).Done = true;
        exit=1;
    end
    if exit == 1
        break;
    end
end

end

%% Launch Start Analysis 1 with default parameters: 
%%%  all channels chosen, timeIn = 0, TimeOut total timespan
%%% default analysis settings, no experts
function StartAnalysis(~,~)
load('Spikes.mat','file');
for i=1:length(file) % used to handle the case where we quickstart a edf file
    fileName = file(i).Name;
    if endsWith(fileName, '.mat')
        fileData = getappdata(gcf,'fileData');
        path = getappdata(gcf,'path');
        close(gcf);
        changeChar = 0; % 0 = false, we don't want to change the parameters
        for CurrentRecording=1:length(file)
            if file(CurrentRecording).Done == false && endsWith(file(CurrentRecording).Name, '.mat')
                Characteristics(CurrentRecording,file(CurrentRecording).Name,fileData,path,changeChar);
                file(CurrentRecording).Done = true;
                exit=1;
            end
            if exit == 1
                break;
            end
        end
    elseif endsWith(fileName, '.EDF')
        disp('No quickstart for edf files implemented')
    end
end

end

%% Launch the previous analysis, only when the "SpikesPreviousAnalysis.mat"
%%% file is present in the working folder. The file is created in Main.m
%%% after analyze() is executed;
function GetPreviousAnalysis(~,~)

if exist('SpikesPreviousAnalysis.mat','file')
    close(gcf);

    disp('Loading previous analysis...');
    
    load('SpikesPreviousAnalysis.mat','file'); % get previous .mat file
    save('Spikes.mat','file'); % save it in Spikes.mat
    
    %following parameters are not necessary for this analysis 
    path = '';fileName = '';timeIn=0;timeOut=0;timeDebrec=0;
    nrElectrodeLeft=0;nrElectrodeRight=0; changeSettings = 0;  
    current=0; %if equal to 0, get result of previous analysis 
    Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings)
else
    disp('No previous analysis detected');
end


end