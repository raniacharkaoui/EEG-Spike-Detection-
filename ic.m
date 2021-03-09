%%%When the main function is launched,  automatically the spike detection
%%%algo runs and saves the detected spikes, the raw_data and some parameters 
%in a file named algo_spikes
%%%Then again many buttons allows to choose some experts to compare with the
%%%algorithm and to launch a display

function Main2(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current)    
    load('Spikes.mat','file');
    
    DBPath = path;

    % ***********************
    %  Detection parameters *
    % ***********************


    % General parameters
    DetectionParameters.MinimumDistance2Spikes = 75; % ms
    DetectionParameters.WindowLength = 300; % ms

    % Generic spike detection parameters
    DetectionParameters.GenericCrossCorrelationThresh = 0.5; % Cross-correlation threshold
    DetectionParameters.GenericFeaturesThresh = 0.3; % Features threshold
    DetectionParameters.GenericTemplateAmplitude = 130;

    % Patient Specific spike detection parameters
    DetectionParameters.PatientSpecificCrossCorrelationThresh = 0.7; % Cross-correlation threshold
    DetectionParameters.PatientSpecificFeaturesThresh = 0.5; % Features threshold
    DetectionParameters.PatientSpecificMinimumSWI = 0.1;
    DetectionParameters.ClusterSelectionThresh = 0.07;
    
    for i=1:length(file)
        [Recordings] = AttribuePat(DBPath,file(i).Name,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight);
        file(i).Recordings = Recordings;
        file(i).DetectionParameters = DetectionParameters;
    end
    save('Spikes.mat','file');

     
    if isa(fileName,'char') % If it's only one file
        answer = questdlg(['Would you like to change the default settings for ' fileName '?'],'Change settings','Yes','No','No') ;
        switch answer 
        case 'No'
            windowSpikeDetection();
        case 'Yes'
            windowParameters(DetectionParameters);
        end
        file(1).Done = true;
    end
    if isa(fileName,'cell') % If it's many files
        answer = questdlg(['Would you like to change the default settings for ' fileName{1} '?'],'Change settings','Yes','No','No') ;
        switch answer 
        case 'No'
            windowSpikeDetection();
        case 'Yes'
            windowParameters(DetectionParameters);
        end
        for CurrentRecording=1:length(fileName)
            file(CurrentRecording).Done = false;
        end
        file(1).Done = true;
    end
    
    
    save('Spikes.mat','file');
    setappdata(gcf,'current',current);
end

%% Window allowing to change the default settings
function windowParameters(DetectionParameters)

   handles.fig1 = figure('units','pixels',...
            'position',[550 250 500 450],...
            'numbertitle','off',...
            'name','Settings',...
            'menubar','none',...
            'tag','interface');

   handles.save = uicontrol(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [410 10 80 20], ...
    'String',   'Apply',...
    'Callback',@(obj,event)apply(obj));

   handles.pane(1) = uipanel(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [10 330 480 100], ...
    'Title', 'General Parameters', ...
    'BackgroundColor', get(handles.fig1, 'Color'));

    uicontrol(handles.pane(1),'style','text',...
         'Units','normalized',...
         'Position',[0 0.6 0.6 0.2],... 
         'String','Minimum distance between two spikes (ms) : ');

    handles.minDistance2Spikes = uicontrol(handles.pane(1),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.6 0.1 0.2],...
         'String',num2str(DetectionParameters.MinimumDistance2Spikes),...
         'tag','minDistance2Spikes');

    uicontrol(handles.pane(1),'style','text',...
         'Units','normalized',...
         'Position',[0 0.3 0.6 0.2],... 
         'String','Window length (ms) : ');

    handles.windowLength = uicontrol(handles.pane(1),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.3 0.1 0.2],...
         'String',num2str(DetectionParameters.WindowLength),...
         'tag','windowLength');

    handles.pane(2) = uipanel(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [10 200 480 120], ...
    'Title',    'Generic Spike Detection Parameters', ...
    'BackgroundColor', get(handles.fig1, 'Color'));

    uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.7 0.6 0.2],... 
         'String','Template amplitude (us) : ');

    handles.amplitude = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.75 0.1 0.15],...
         'String',num2str(DetectionParameters.GenericTemplateAmplitude),...
         'tag','amplitude');

    uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.4 0.6 0.2],... 
         'String','Cross-correlation threshold of the generic template : ');

    handles.crossCorrelationThresholdGT = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.45 0.1 0.15],...
         'String',num2str(DetectionParameters.GenericCrossCorrelationThresh),...
         'tag','crossCorrelationThresholdGT');

     uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.1 0.6 0.2],... 
         'String','Features threshold of the generic template : ');

    handles.featuresGT = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.15 0.1 0.15],...
         'String',num2str(DetectionParameters.GenericFeaturesThresh),...
         'tag','featuresGT');


    handles.pane(3) = uipanel(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [10 40 480 150], ...
    'Title',    'Patient Specific Spike Detection Parameters', ...
    'BackgroundColor', get(handles.fig1, 'Color'));

    uicontrol(handles.pane(3),'style','text',...
         'Units','normalized',...
         'Position',[0 0.7 0.7 0.2],... 
         'String','Cross-correlation threshold of the cluster specific template : ');

    handles.crossCorrelationThresholdST = uicontrol(handles.pane(3),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.77 0.1 0.12],...
         'String',num2str(DetectionParameters.PatientSpecificCrossCorrelationThresh),...
         'tag','crossCorrelationThresholdST');

    uicontrol(handles.pane(3),'style','text',...
         'Units','normalized',...
         'Position',[0 0.5 0.6 0.2],... 
         'String','Features threshold of the cluster specific template : ');

    handles.featuresST = uicontrol(handles.pane(3),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.57 0.1 0.12],...
         'String',num2str(DetectionParameters.PatientSpecificFeaturesThresh),...
         'tag','featuresST');

     uicontrol(handles.pane(3),'style','text',...
         'Units','normalized',...
         'Position',[0 0.3 0.6 0.2],... 
         'String','Minimum SWI : ');

    handles.minSWI = uicontrol(handles.pane(3),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.37 0.1 0.12],...
         'String',num2str(DetectionParameters.PatientSpecificMinimumSWI),...
         'tag','minSWI');

    uicontrol(handles.pane(3),'style','text',...
         'Units','normalized',...
         'Position',[0 0.1 0.6 0.2],... 
         'String','Minimum percentage of spikes in a cluster : ');

    handles.clusterSelectionThresh = uicontrol(handles.pane(3),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.17 0.1 0.12],...
         'String',num2str(DetectionParameters.ClusterSelectionThresh),...
         'tag','clusterSelectionThresh');

     
    % Update handles structure
    guidata(handles.fig1, handles); 
end

%% Apply the parameters choosed in windowParameters
function apply(obj,event)

    handles = guihandles(gcbf);
    current = getappdata(gcf,'current');
    if exist('Spikes.mat','file') == 2 %to check if there is already a file and if so, load it
        load('Spikes.mat','file');
    end
    
    % General parameters
    file(current).DetectionParameters.MinimumDistance2Spikes = str2num(get(handles.minDistance2Spikes,'String')); % ms
    file(current).DetectionParameters.WindowLength = str2num(get(handles.windowLength,'String')); % ms

    % Generic spike detection parameters
    file(current).DetectionParameters.GenericCrossCorrelationThresh = str2num(get(handles.crossCorrelationThresholdGT,'String')); % Cross-correlation threshold
    file(current).DetectionParameters.GenericFeaturesThresh = str2num(get(handles.featuresGT,'String')); % Features threshold
    file(current).DetectionParameters.GenericTemplateAmplitude = str2num(get(handles.amplitude,'String'));

    % Patient Specific spike detection parameters
    file(current).DetectionParameters.PatientSpecificCrossCorrelationThresh = str2num(get(handles.crossCorrelationThresholdST,'String')); % Cross-correlation threshold
    file(current).DetectionParameters.PatientSpecificFeaturesThresh = str2num(get(handles.featuresST,'String')); % Features threshold
    file(current).DetectionParameters.PatientSpecificMinimumSWI = str2num(get(handles.minSWI,'String'));
    file(current).DetectionParameters.ClusterSelectionThresh = str2num(get(handles.clusterSelectionThresh,'String'));

    close(gcf);
    windowSpikeDetection();
    file(1).Done = true;
    save('Spikes.mat','file');
    setappdata(gcf,'current',current);
end

%Window allowing to choose the type of data and the experts for each
%patient
function windowSpikeDetection()

 % Create handles.figure
    handles.fig = figure(...
        'DockControl','off', ...
        'NumberTitle','off', ...
        'Menubar','none', ...
        'Toolbar','none', ...
        'Name', 'Spike Detection - Confusion Matrix', ...
        'UserData', 1, ...
        'Units', 'pixels', ...
        'Position', [0 0 400 300]);
    movegui(handles.fig,'center');

    % Create Next button
    handles.next = uicontrol(...
        'Parent',   handles.fig, ...
        'Units',    'pixels', ...
        'Position', [310 10 80 20], ...
        'String',   'Next', ...
        'Callback', @(obj,evt) Next(obj));

    % Create Prev button
    handles.prev = uicontrol(...
        'Parent',   handles.fig, ...
        'Units',    'pixels', ...
        'Position', [220 10 80 20], ...
        'String',   'Prev', ...
        'Callback', @(obj,evt) Prev(obj));

    % Create first panel
    handles.pane(1) = uipanel(...
        'Parent',   handles.fig, ...
        'Units',    'pixels', ...
        'Position', [10 40 380 240], ...
        'Title',    'Choose the type of data', ...
        'BackgroundColor', get(handles.fig, 'Color'), ...
        'Visible',  'off');

    bg1 = uibuttongroup(handles.pane(1));
    
    uicontrol(bg1,'style','radiobutton',...
     'units','normalized',...
     'position',[0.1 0.6 0.5 0.1],... 
     'string','Example data',...
     'callback',@choose_TypeExample,...
     'tag','typeExample');
    
      uicontrol(bg1,'style','radiobutton',...
     'units','normalized',...
     'position',[0.1 0.5 0.5 0.1],... 
     'string','Erasme data',...
     'callback',@choose_TypeErasme,...
     'tag','typeErasme');
    
    % Create second panel
    handles.pane(2) = uipanel(...
        'Parent',   handles.fig, ...
        'Units',    'pixels', ...
        'Position', [10 40 380 240], ...
        'Title',    'Choose the number of experts', ...
        'BackgroundColor', get(handles.fig, 'Color'), ...
        'Visible',  'off');
    
   % Creation of the "chose number of expert" text
    uicontrol(handles.pane(2),'style','text',...
             'Units','normalized',...
             'Position',[0 .8 0.4 0.15],... 
             'String','Number of experts : ');
         
% Creation of the "chose number of expert" box     
    yourcell={'2','3','4'};
    uicontrol(handles.pane(2),'style','popupmenu',...
             'Units','normalized',...
             'Position',[.35 .8 0.2 0.17],... 
             'callback',@choose_NumberOfExpert,...
             'String',yourcell,...
             'tag','popup1');  
         
            % Creation of the object Uitcontrol Expert(s)
    % Expert 1 
    handles.exp1 = uicontrol(handles.pane(2),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.62 0.2 0.05],... 
     'string','Expert 1',...
     'Enable','off',...
     'callback',@choose_ExpertData1,...
     'tag','tagExp1');
    
    handles.FileExp1 = uicontrol(handles.pane(2),'style','text',...
     'units','normalized',...
     'position',[0.25 0.62 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'string','',...
     'Enable','off',...
     'tag','FileExp1');
 
    % Expert 2 
    handles.exp2 = uicontrol(handles.pane(2),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.54 0.2 0.05],... 
     'string','Expert 2',...
     'Enable','off',...
     'callback',@choose_ExpertData2,...
     'tag','tagExp2');
    
    handles.FileExp2 = uicontrol(handles.pane(2),'style','text',...
     'units','normalized',...
     'position',[0.25 0.54 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'string','',...
     'Enable','off',...
     'tag','FileExp2');
 
    % Expert 3
     handles.exp3 = uicontrol(handles.pane(2),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.46 0.2 0.05],... 
     'string','Expert 3',...
     'Enable','off',...
     'callback',@choose_ExpertData3,...
     'tag','tagExp3');
    
    handles.FileExp3 = uicontrol(handles.pane(2),'style','text',...
     'units','normalized',...
     'position',[0.25 0.46 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'string','',...
     'Enable','off',...
     'tag','FileExp3');  
 
    % Expert 4
     handles.exp4 = uicontrol(handles.pane(2),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.38 0.2 0.05],... 
     'string','Expert 4',...
     'Enable','off',...
     'callback',@choose_ExpertData4,...
     'tag','tagExp4');
    
    handles.FileExp4 = uicontrol(handles.pane(2),'style','text',...
     'units','normalized',...
     'position',[0.25 0.38 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'Enable','off',...
     'string','',...
     'tag','FileExp4');   
 
 % Creation of the object Uicontrol Validation
    handles.valid = uicontrol(handles.pane(2),'style','pushbutton',...
        'units','normalized',...
        'FontWeight','bold',...
        'position',[0.35 0.2 0.3 0.05],...
        'string','Validate',...
        'callback',@Validate,...
        'tag', 'bouton_validate');
         
    % Update handles structure
    guidata(handles.fig, handles);

    % Update display
    UpdateDisplay(handles);
end

function UpdateDisplay(handles)
 
% Get current selected panel
current_selected = get(handles.fig, 'UserData');

% Get number of panels
panel_nb = length(handles.pane);
 
% Hide all panels
set(handles.pane, 'Visible', 'off');
 
% Unhide selected panel
set(handles.pane(current_selected), 'Visible', 'on');
 
    % Verify if Next button as to be displayed
    if (current_selected == panel_nb)
        set(handles.next, 'Enable', 'off');
    else
        set(handles.next, 'Enable', 'on');
    end
 
    % Verify if Next button as to be displayed
    if (current_selected == 1)
        set(handles.prev, 'Enable', 'off');
    else
        set(handles.prev, 'Enable', 'on');
    end
end

function Prev(hObject)
 
% Get figure handles
handles = guidata(hObject);

% Change current selected panel
set(handles.fig, 'UserData', get(handles.fig, 'UserData')-1);
 
% Update display
UpdateDisplay(handles);
end

function Next(hObject)
 
% Get figure handles
handles = guidata(hObject);

% Change current selected panel
set(handles.fig, 'UserData', get(handles.fig, 'UserData')+1);

% Update display
UpdateDisplay(handles)
end

%% Validate type of data and experts choosed by the user for each patient
function Validate(obj,event)
    load('Spikes.mat','file');
    current = getappdata(gcf,'current');
    close(gcf);
    actual = 1;
    exit = 0;
    finished = false;
    fileData = struct([]);
    for CurrentRecording=1:length(file)
        if endsWith(file(CurrentRecording).Name,'.mat')
            fileData = load(file(CurrentRecording).Name);
        end
        if isequal(file(CurrentRecording).Done,false)
            if actual <= length(file)
                current = current +1 ;
                Characteristics(CurrentRecording,file(CurrentRecording).Name,fileData,file(CurrentRecording).Recordings.fname);
                file(CurrentRecording).Done = true;
                save('Spikes.mat','file');
                exit = 1 ;
                actual = actual +1;
            end
        elseif (isequal(file(length(file)).Done,true)) % When all the files has been treated
            finished = true;
        end
        if exit == 1
            break;
        end
    end
    if finished == true % When the treatment of all the files is finished
        Analyze();
        windowAnalyze();
    end
end

%% Choose the number of experts
function choose_NumberOfExpert(obj,event)
    load('Spikes.mat','file')
    data = guidata(gcbf);
    current = getappdata(gcf,'current');
    nbExp = get(obj, 'value') + 1;
    file(current).nbExp = nbExp;
    save('Spikes.mat','file')
    setappdata(gcbf,'nbExp',nbExp);
    Exp1_timeIn = 0; 
    Exp1_timeOut = 0; 
    Exp2_timeIn = 0; 
    Exp2_timeOut = 0; 
    Exp3_timeIn = 0; 
    Exp3_timeOut = 0; 
    Exp4_timeIn = 0; 
    Exp4_timeOut = 0; 
    setappdata(gcbf,'TimeIn1',Exp1_timeIn);
    setappdata(gcbf,'TimeOut1',Exp1_timeOut);
    setappdata(gcbf,'TimeIn2',Exp2_timeIn);
    setappdata(gcbf,'TimeOut2',Exp2_timeOut);
    setappdata(gcbf,'TimeIn3',Exp3_timeIn);
    setappdata(gcbf,'TimeOut3',Exp3_timeOut);
    setappdata(gcbf,'TimeIn4',Exp4_timeIn);
    setappdata(gcbf,'TimeOut4',Exp4_timeOut);
    guidata(gcbf,data);
    
    display_Experts(); 
end

% Choice of the type of data
function choose_TypeExample(obj,event)
    data=guidata(gcbf);
    Type = get(obj, 'string');
    setappdata(gcbf,'Type',Type);
    guidata(gcbf,data);    
end

function choose_TypeErasme(obj,event)
    data=guidata(gcbf);
    Type = get(obj, 'string');
    setappdata(gcbf,'Type',Type);
    guidata(gcbf,data);    
end
    
function display_Experts()
% Getting the number of patients 
   data=guidata(gcbf);
   nbExp = getappdata(gcbf,'nbExp');
   display_Expert1(nbExp);
   guidata(gcbf,data);
end

%% Enable the different buttons according to the number of experts
function display_Expert1(nbExp) 
 
    handles = guidata(gcf);

    set(handles.exp1,'Enable','off');
    set(handles.exp2,'Enable','off');
    set(handles.exp3,'Enable','off');
    set(handles.exp4,'Enable','off');
    
% If there are 2 experts and 1 patient 
    if nbExp==2
        set(handles.exp1,'Enable','on');
        set(handles.exp2,'Enable','on');
    end 

% If there are 3 experts and 1 patient 
    if nbExp == 3
        set(handles.exp1,'Enable','on');
        set(handles.exp2,'Enable','on');
        set(handles.exp3,'Enable','on');
    end         

% If there are 4 experts and 1 patient 
    if nbExp == 4
        set(handles.exp1,'Enable','on');
        set(handles.exp2,'Enable','on');
        set(handles.exp3,'Enable','on');
        set(handles.exp4,'Enable','on');
    end  
end    
 
%% Set Patient A Expert 1 
function choose_ExpertData1(obj,event)
    load('Spikes.mat','file')
    current = getappdata(gcf,'current');
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    load(fileExpert);
    
    Type = getappdata(gcbf,'Type');
    if isempty(Type)
        Type = 'Example data' ;
    end
    Exp1_timeIn = getappdata(gcbf,'TimeIn1');
    Exp1_timeOut = getappdata(gcbf,'TimeOut1');
   
    if isequal(Type,'Erasme data')
        Events = Data.Events;
        [Exp1_timeIn,Exp1_timeOut] = Get_timeExp(Events);
        file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;
    end 
    if isequal(Type,'Example data')    
         Exp1_timeIn = sauvg.Pocs(:,1);
         Exp1_timeOut = sauvg.Pocs(:,2);
    end


    file(current).Exp_timeIn.Expert1 = Exp1_timeIn;
    file(current).Exp_timeOut.Expert1 =  Exp1_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp1,'string',fileExpert);
end

%% Set Patient A Expert 2
function choose_ExpertData2(obj,event)
    load('Spikes.mat','file');
    current = getappdata(gcf,'current');
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    load(fileExpert);
    Type = getappdata(gcbf,'Type');
    if isempty(Type)
        Type = 'Example data' ;
    end
    Exp2_timeIn = getappdata(gcbf,'TimeIn2');
    Exp2_timeOut = getappdata(gcbf,'TimeOut2');
    
    if isequal(Type,'Erasme data')
        Events = Data.Events;
        [Exp2_timeIn,Exp2_timeOut] =Get_timeExp(Events);
        file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;
    end     
    if isequal(Type,'Example data')   
         Exp2_timeIn = sauvg.Pocs(:,1);
         Exp2_timeOut = sauvg.Pocs(:,2);    
    end
    file(current).Exp_timeIn.Expert2 = Exp2_timeIn;
    file(current).Exp_timeOut.Expert2 = Exp2_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp2,'string',fileExpert);
end

%% Set Patient A Expert 3     
function choose_ExpertData3(obj,event)
    load('Spikes.mat','file')
    current = getappdata(gcf,'current');
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    load(fileExpert);
    Type = getappdata(gcbf,'Type');
    if isempty(Type)
        Type = 'Example data' ;
    end
    Exp3_timeIn = getappdata(gcbf,'TimeIn3');
    Exp3_timeOut = getappdata(gcbf,'TimeOut3');
    if isequal(Type,'Erasme data')
        Events = Data.Events;
        [Exp3_timeIn,Exp3_timeOut] =Get_timeExp(Events);
        file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;
    end     
    if isequal(Type,'Example data')  
         Exp3_timeIn = sauvg.Pocs(:,1);
         Exp3_timeOut = sauvg.Pocs(:,2);
    end       
    file(current).Exp_timeIn.Expert3 = Exp3_timeIn;
    file(current).Exp_timeOut.Expert3 = Exp3_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp3,'string',fileExpert);

end

%% Set Patient A Expert 4    
function choose_ExpertData4(obj,event)
    load('Spikes.mat','file')
    current = getappdata(gcf,'current');
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    load(fileExpert);
    Type = getappdata(gcbf,'Type');
    if isempty(Type)
        Type = 'Example data' ;
    end
    Exp4_timeIn = getappdata(gcbf,'TimeIn4');
    Exp4_timeOut = getappdata(gcbf,'TimeOut4');
    if isequal(Type,'Erasme data')
        Events = Data.Events;
        [Exp4_timeIn,Exp4_timeOut] =Get_timeExp(Events);
        file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;
    end     
    if isequal(Type,'Example data')    
         Exp4_timeIn = sauvg.Pocs(:,1);
         Exp4_timeOut = sauvg.Pocs(:,2);
    end
    file(current).Exp_timeIn.Expert4 = Exp4_timeIn;
    file(current).Exp_timeOut.Expert4 = Exp4_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp4,'string',fileExpert);

end

%% Window allowing to choose between Confusion Matrix and Display
function windowAnalyze()

handles.fig1 = figure('units','pixels',...
            'position',[550 250 300 270],...
            'numbertitle','off',...
            'Name','Spike detection',...
            'menubar','none',...
            'tag','interface');
% Creation of the object Uicontrol Confusion Matrix 
     handles.matrice = uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.27 0.6 0.4 0.2],...
     'string','Confusion Matrix',...
     'callback',@Matrix,...
     'tag','bouton_matrix');  
 
% Creation of the object Uicontrol Display 
     handles.display = uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.27 0.35 0.4 0.2],...
     'string','Display',...
     'callback',@DisplayAlgo,...
     'tag','bouton_display');
end

%% Analyze the confusion matrix
function Matrix(obj,event)
    Confusion_matrix();  
end 
    
%% Analyze the different EEG to display
function DisplayAlgo(obj,event)
    Display_spikes();  
end