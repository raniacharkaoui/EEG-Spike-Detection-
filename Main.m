%%%When the main function is launched,  automatically the spike detection
%%%algo runs and saves the detected spikes, the raw_data and some parameters 
%in a file named algo_spikes
%%%Then again many buttons allows to choose some experts to compare with the
%%%algorithm and to launch a display



function Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings, isAllChecked)    
    if current == 0 % used to recover previous analysis
        windowAnalyze(); 
    else
        load('Spikes.mat','file');
        DBPath = path;

        % ***********************
        %  Detection parameters *
        % ***********************


        % General parameters
        DetectionParameters.MinimumDistance2Spikes = 120; % ms
        DetectionParameters.WindowLength = 420; % ms

        % Generic spike detection parameters
        DetectionParameters.GenericCrossCorrelationThresh = 0.6; % Cross-correlation threshold
        DetectionParameters.GenericFeaturesThresh = 0.4; % Features threshold

        % Patient Specific spike detection parameters
        DetectionParameters.PatientSpecificCrossCorrelationThresh = 0.7; % Cross-correlation threshold
        DetectionParameters.PatientSpecificFeaturesThresh = 0.4; % Features threshold
        DetectionParameters.PatientSpecificMinimumSWI = 0.01; %Seconds With Interictals
        DetectionParameters.ClusterSelectionThresh = 0.07;
        DetectionParameters.CheckThresh = -0.6; % Threshold for the negative cross-correlation which shows the opposition
    
        
        
        % *********************************
        %  popup for modifying parameters *
        % *********************************
    
    if current == 1
        for i=1:length(file)
            [Recordings] = AttribuePat(DBPath,file(i).Name,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,i, isAllChecked);
            if i==1
                file(1).Recordings = Recordings;
                file(1).DetectionParameters = DetectionParameters;
            else
                file(i).Recordings.name = Recordings.name;
                file(i).Recordings.path = Recordings.path;
                file(i).Recordings.debrec = Recordings.debrec;
                file(i).Recordings.fname = Recordings.fname;
                file(i).DetectionParameters = DetectionParameters;
            end
        end
        
    else
        [Recordings] = AttribuePat(DBPath,file(current).Name,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current, isAllChecked);
        file(current).Recordings = Recordings;
        file(current).DetectionParameters = DetectionParameters;
    end
    
        if isa(fileName,'char') % If it's only one file
            if changeSettings == 1 % equals 1 if we need to change parameters
                windowParameters(DetectionParameters);

            end
            file(current).Done = true;
        end

        if isa(fileName,'cell') % If it's many files
            if changeSettings == 1 % equals 1 if we need to change parameters
                windowParameters(DetectionParameters);
            end
            for CurrentRecording=1:length(fileName)
                file(CurrentRecording).Done = false;
            end
            file(1).Done = true;
        end

        save('Spikes.mat','file');
        setappdata(gcf,'current',current);

        if changeSettings == 0 % used to handle start button (2)
            Validate(); 
        end
    end
end

%% Window allowing to change the default settings
function windowParameters(DetectionParameters)

   
   handles.fig1 = figure('units','pixels',...
            'position',[450 130 500 450],...
            'numbertitle','off',...
            'name','Settings',...
            'menubar','none',...
            'tag','interface');

   handles.save = uicontrol(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [280 10 160 20], ...
    'String',   'Start Analysis (3)',...
    'Callback',@(obj,event)(cellfun(@(x)feval(x,obj,event),...
    {@(obj,event)apply(obj),...
    @Validate})));

    handles.save = uicontrol(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [60 10 160 20], ...
    'String',   'Choose Experts',...
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

    handles.pane(1) = uipanel(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [10 200 480 120], ...
    'Title',    'Generic Spike Detection Parameters', ...
    'BackgroundColor', get(handles.fig1, 'Color'));


    uicontrol(handles.pane(1),'style','text',...
         'Units','normalized',...
         'Position',[0 0.7 0.6 0.2],... 
         'String','Cross-correlation threshold of the generic template : ');

    handles.crossCorrelationThresholdGT = uicontrol(handles.pane(1),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.75 0.1 0.15],...
         'String',num2str(DetectionParameters.GenericCrossCorrelationThresh),...
         'tag','crossCorrelationThresholdGT');

     uicontrol(handles.pane(1),'style','text',...
         'Units','normalized',...
         'Position',[0 0.4 0.6 0.2],... 
         'String','Features threshold of the generic template : ');

    handles.featuresGT = uicontrol(handles.pane(1),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.45 0.1 0.15],...
         'String',num2str(DetectionParameters.GenericFeaturesThresh),...
         'tag','featuresGT');


    handles.pane(2) = uipanel(...
    'Parent',   handles.fig1, ...
    'Units',    'pixels', ...
    'Position', [10 40 480 150], ...
    'Title',    'Patient Specific Spike Detection Parameters', ...
    'BackgroundColor', get(handles.fig1, 'Color'));

    uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.75 0.7 0.2],... 
         'String','Cross-correlation threshold of the cluster specific template : ');

    handles.crossCorrelationThresholdST = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.82 0.1 0.12],...
         'String',num2str(DetectionParameters.PatientSpecificCrossCorrelationThresh),...
         'tag','crossCorrelationThresholdST');

    uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.57 0.6 0.2],... 
         'String','Features threshold of the cluster specific template : ');

    handles.featuresST = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.64 0.1 0.12],...
         'String',num2str(DetectionParameters.PatientSpecificFeaturesThresh),...
         'tag','featuresST');

     uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.39 0.6 0.2],... 
         'String','Minimum SWI : ');

    handles.minSWI = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.46 0.1 0.12],...
         'String',num2str(DetectionParameters.PatientSpecificMinimumSWI),...
         'tag','minSWI');

    uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.21 0.6 0.2],... 
         'String','Minimum percentage of spikes in a cluster : ');

    handles.clusterSelectionThresh = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.28 0.1 0.12],...
         'String',num2str(DetectionParameters.ClusterSelectionThresh),...
         'tag','clusterSelectionThresh');
     
     uicontrol(handles.pane(2),'style','text',...
         'Units','normalized',...
         'Position',[0 0.03 0.6 0.2],... 
         'String','Threshold for the phase opposition : ');

    handles.CheckThresh = uicontrol(handles.pane(2),...
         'style','edit',...
         'Units','normalized',...
         'Position',[0.75 0.1 0.1 0.12],...
         'String',num2str(DetectionParameters.CheckThresh),...
         'tag','CheckThresh');

     
%    Update handles structure
    guidata(handles.fig1, handles); 
end

%% Apply the parameters choosed in windowParameters
function apply(~,~)

    handles = guihandles(gcbf);
    current = getappdata(gcf,'current');
    if exist('Spikes.mat','file') == 2 %to check if there is already a file and if so, load it
        load('Spikes.mat','file');
    end
    
    % General parameters
    file(current).DetectionParameters.MinimumDistance2Spikes = str2double(get(handles.minDistance2Spikes,'String')); % ms
    file(current).DetectionParameters.WindowLength = str2double(get(handles.windowLength,'String')); % ms

    % Generic spike detection parameters
    file(current).DetectionParameters.GenericCrossCorrelationThresh = str2double(get(handles.crossCorrelationThresholdGT,'String')); % Cross-correlation threshold
    file(current).DetectionParameters.GenericFeaturesThresh = str2double(get(handles.featuresGT,'String')); % Features threshold

    % Patient Specific spike detection parameters
    file(current).DetectionParameters.PatientSpecificCrossCorrelationThresh = str2double(get(handles.crossCorrelationThresholdST,'String')); % Cross-correlation threshold
    file(current).DetectionParameters.PatientSpecificFeaturesThresh = str2double(get(handles.featuresST,'String')); % Features threshold
    file(current).DetectionParameters.PatientSpecificMinimumSWI = str2double(get(handles.minSWI,'String'));
    file(current).DetectionParameters.ClusterSelectionThresh = str2double(get(handles.clusterSelectionThresh,'String'));
    file(current).DetectionParameters.CheckThresh = str2double(get(handles.CheckThresh,'String'));
    
    close(gcf);
    windowChooseExperts();
    file(1).Done = true;
    save('Spikes.mat','file');
    setappdata(gcf,'current',current);
end

%% Window allowing to choose the experts for each patient
function windowChooseExperts()

% Create handles.figure
    handles.fig = figure(...
        'DockControl','off', ...
        'NumberTitle','off', ...
        'Menubar','none', ...
        'Toolbar','none', ...
        'Name', 'Choose Experts', ...
        'UserData', 1, ...
        'Units', 'pixels', ...
        'Position', [0 0 400 300]);
    movegui(handles.fig,'center');

    % Create panel
    handles.pane(1) = uipanel(...
        'Parent',   handles.fig, ...
        'Units',    'pixels', ...
        'Position', [10 40 380 240], ...
        'Title',    'Choose the number of experts', ...
        'BackgroundColor', get(handles.fig, 'Color'), ...
        'Visible',  'off');
    
   % Creation of the "choose number of expert" text
    uicontrol(handles.pane(1),'style','text',...
             'Units','normalized',...
             'Position',[0 .8 0.4 0.15],... 
             'String','Number of experts : ');
         
    % Creation of the "choose number of expert" box     
    yourcell={'0','2','3','4'};
    uicontrol(handles.pane(1),'style','popupmenu',...
             'Units','normalized',...
             'Position',[.35 .8 0.2 0.17],... 
             'callback',@choose_NumberOfExpert,...
             'String',yourcell,...
             'tag','popup1');  
         
            % Creation of the object Uitcontrol Expert(s)
    % Expert 1 
    handles.exp1 = uicontrol(handles.pane(1),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.62 0.2 0.05],... 
     'string','Expert 1',...
     'Enable','off',...
     'callback',@choose_ExpertData1,...
     'tag','tagExp1');
    
    handles.FileExp1 = uicontrol(handles.pane(1),'style','text',...
     'units','normalized',...
     'position',[0.25 0.62 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'string','',...
     'Enable','off',...
     'tag','FileExp1');
 
    % Expert 2 
    handles.exp2 = uicontrol(handles.pane(1),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.54 0.2 0.05],... 
     'string','Expert 2',...
     'Enable','off',...
     'callback',@choose_ExpertData2,...
     'tag','tagExp2');
    
    handles.FileExp2 = uicontrol(handles.pane(1),'style','text',...
     'units','normalized',...
     'position',[0.25 0.54 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'string','',...
     'Enable','off',...
     'tag','FileExp2');
 
    % Expert 3
     handles.exp3 = uicontrol(handles.pane(1),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.46 0.2 0.05],... 
     'string','Expert 3',...
     'Enable','off',...
     'callback',@choose_ExpertData3,...
     'tag','tagExp3');
    
    handles.FileExp3 = uicontrol(handles.pane(1),'style','text',...
     'units','normalized',...
     'position',[0.25 0.46 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'string','',...
     'Enable','off',...
     'tag','FileExp3');  
 
    % Expert 4
     handles.exp4 = uicontrol(handles.pane(1),'style','pushbutton',...
     'units','normalized',...
     'position',[0.05 0.38 0.2 0.05],... 
     'string','Expert 4',...
     'Enable','off',...
     'callback',@choose_ExpertData4,...
     'tag','tagExp4');
    
    handles.FileExp4 = uicontrol(handles.pane(1),'style','text',...
     'units','normalized',...
     'position',[0.25 0.38 0.2 0.05],...
     'Backgroundcolor',[1 1 1],...
     'Enable','off',...
     'string','',...
     'tag','FileExp4');   
 
 % Creation of the object Uicontrol Validation
    handles.valid = uicontrol(handles.pane(1),'style','pushbutton',...
        'units','normalized',...
        'FontWeight','bold',...
        'position',[0.35 0.1 0.3 0.15],...
        'string','Start Analysis (4)',...
        'callback',@Validate,...
        'tag', 'bouton_validate');
         
    % Update handles structure
    guidata(handles.fig, handles);

    % Update display
    UpdateDisplay(handles);
end

%% Update the display when choosing experts
function UpdateDisplay(handles)
 
% Get current selected panel
current_selected = get(handles.fig, 'UserData');

% Get number of panels
panel_nb = length(handles.pane);
 
% Hide all panels
set(handles.pane, 'Visible', 'off');
 
% Unhide selected panel
set(handles.pane(current_selected), 'Visible', 'on');
 
end

%% Choose the number of experts
function choose_NumberOfExpert(obj,~)
    load('Spikes.mat','file')
    data = guidata(gcbf);
    current = getappdata(gcf,'current');
    nbExp = get(obj, 'value');
    if isempty(nbExp) || nbExp==1
        nbExp=0;
    end
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

%% Displays the number of experts
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
function choose_ExpertData1(~,~)
    load('Spikes.mat','file')
    current = getappdata(gcf,'current');
    %fileExpert = expNameList(1,:)
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    
    if endsWith(path,'\')% sometimes path name ends with '\'
        load([path fileExpert]);
    else
        load([path '\' fileExpert]);
    end
    Events = Data.Events;
    [Exp1_timeIn,Exp1_timeOut] = Get_timeExp(Events,current);
    file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;
    file(current).Exp_timeIn.Expert1 = Exp1_timeIn;
    file(current).Exp_timeOut.Expert1 =  Exp1_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp1,'string',fileExpert);
end

%% Set Patient A Expert 2
function choose_ExpertData2(~,~)
    load('Spikes.mat','file');
    current = getappdata(gcf,'current');
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    
    if endsWith(path,'\')
        load([path fileExpert]);
    else
        load([path '\' fileExpert]);
    end

    Events = Data.Events;
    [Exp2_timeIn,Exp2_timeOut] =Get_timeExp(Events,current);
    file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;

    file(current).Exp_timeIn.Expert2 = Exp2_timeIn;
    file(current).Exp_timeOut.Expert2 = Exp2_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp2,'string',fileExpert);
end

%% Set Patient A Expert 3     
function choose_ExpertData3(~,~)
    load('Spikes.mat','file')
    current = getappdata(gcf,'current');
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    
    if endsWith(path,'\')
        load([path fileExpert]);
    else
        load([path '\' fileExpert]);
    end

    Events = Data.Events;
    [Exp3_timeIn,Exp3_timeOut] =Get_timeExp(Events,current);
    file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;

    file(current).Exp_timeIn.Expert3 = Exp3_timeIn;
    file(current).Exp_timeOut.Expert3 = Exp3_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp3,'string',fileExpert);

end

%% Set Patient A Expert 4    
function choose_ExpertData4(~,~)
    load('Spikes.mat','file')
    current = getappdata(gcf,'current');
    handles=guidata(gcbf);
    [fileExpert, path] = uigetfile('*.mat','Choisir le fichier à ouvrir :');
    
    if endsWith(path,'\')
        load([path fileExpert]);
    else
        load([path '\' fileExpert]);
    end

    Events = Data.Events;
    [Exp4_timeIn,Exp4_timeOut] =Get_timeExp(Events,current);
    file(current).Recordings.timeOut = min(Data.timeSpan,file(current).Recordings.timeOut) ;

    file(current).Exp_timeIn.Expert4 = Exp4_timeIn;
    file(current).Exp_timeOut.Expert4 = Exp4_timeOut;
    
    save('Spikes.mat','file');
    set(handles.FileExp4,'string',fileExpert);

end

%% Validate type of data and experts choosed by the user for each patient
function Validate(~,~)
    load('Spikes.mat','file');
    current = getappdata(gcf,'current');
    close(gcf);
    actual = 1;
    exit = 0;
    finished = false;
    fileData = struct([]);
    if ~isfield(file(current),'nbExp') || isempty(file(current).nbExp)
        file(current).nbExp = 0;
    end
    save('Spikes.mat','file');
    
    for CurrentRecording=1:length(file)
        path = file(CurrentRecording).Recordings.path;
        fileName = file(CurrentRecording).Name ; 
        if endsWith(file(CurrentRecording).Name,'.mat')
            fileData = load([path '\' fileName]);
        end
        if file(CurrentRecording).nbExp == 0
            file(CurrentRecording).Exp_timeIn.Expert1 = 0;
            file(CurrentRecording).Exp_timeOut.Expert1 = 0;
            file(CurrentRecording).Exp_timeIn.Expert2 = 0;
            file(CurrentRecording).Exp_timeOut.Expert2 = 0;
        end
        save('Spikes.mat','file');
        % following handles multiple files
        if isequal(file(CurrentRecording).Done,false)
            if actual <= length(file)
                current = current + 1 ;                
                changeChar = file(current).changeChar;
                Characteristics(CurrentRecording,fileName,fileData,path,changeChar);
                file(CurrentRecording).Done = true;
                save('Spikes.mat','file');
                exit = 1 ;
                actual = actual + 1;
            end
        elseif (isequal(file(length(file)).Done,true)) % When all the files has been treated
            finished = true;
        end
        if exit == 1
            break;
        end
    end
    if finished == true % When the treatment of all the files is finished
        Analyze(); %% the analysis part, takes about ~200 - 400 seconds
        % creates a copy for getting result of previous analysis button
        load('Spikes.mat','file'); 
        save('SpikesPreviousAnalysis.mat','file'); % get previous .mat file
        windowAnalyze();
        disp('Everything works correctly');
    end
end

%% Window allowing to choose between Confusion Matrix, Display spikes, 
%%% changing parameters, 2D scalp view, export to XML file
%%% and excport statistics to excel file
function windowAnalyze()

handles.fig1 = figure('units','pixels',...
            'position',[550 250 380 380],...
            'numbertitle','off',...
            'Name','Spike detection',...
            'menubar','none',...
            'tag','interface');
        
% Creation of the object Uicontrol Confusion Matrix 
     handles.matrice = uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.1 0.75 0.3 0.2],...
     'string','Confusion Matrix',...
     'callback',@Matrix,...
     'Enable','on',...
     'tag','bouton_matrix');  

 
% Creation of the object Uicontrol Display 
     handles.display = uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.6 0.75 0.3 0.2],...
     'string','Display',...
     'callback',@DisplayAlgo,...
     'tag','bouton_display');
 
 
 % Creation of the object Uicontrol Change Parameters 
     handles.change = uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.1 0.5 0.3 0.2],...
     'string','Change parameters',...
     'callback',@changeParameters,...
     'tag','bouton_parameters');
 
 
 % Creation of the object Uicontrol graphical view in 2D 
 handles.view_2d = uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.6 0.5 0.3 0.2],...
     'string','Graphical view in 2D',...
     'callback',@view,...
     'tag','bouton_2D');

 
 % Creation of the object Uicontrol export to XML file
 uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.6 0.25 0.3 0.2],...
     'string','Export to XML File',...
     'callback',@createXML,...
     'tag','bouton_xml');
 
 
  % Creation of the object Uicontrol create excel file with statistics
  uicontrol(handles.fig1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.1 0.25 0.3 0.2],...
     'string','Excel statistics',...
     'callback',@excelStat,...
     'tag','bouton_excel');
 

load('Spikes.mat','file');

% enable confusion matrix if no experts and creates cells for listbox
 for i=1:length(file)
     if i == 1
        fileName = {[file(1).Name '  ' num2str(file(1).Duration) ' seconds']};
        file(1).ChosenFile = 1;
     else
        fileName = [fileName [file(i).Name '  ' num2str(file(i).Duration) ' seconds']];
        file(i).ChosenFile = 0;
     end
     if file(1).nbExp == 0
         if file(i).nbExp == 0
            set(handles.matrice,'Enable','off');
         else
             set(handles.matrice,'Enable','on');
         end
     end
 end
 
 save('Spikes.mat','file');

 % Creation of the object Uicontrol Listbox to choose the file to
 % manipulate

 uicontrol(handles.fig1,'Style', 'listbox',...
         'Units','normalized',...
         'Position',[0.1 0.05 0.8 0.15],... %[550 250 380 380]
         'string',fileName,... 
         'Callback', @ChangeCurrentFile);
 
end

%% Analyze the confusion matrix for all files
function Matrix(~,~)
    Confusion_matrix();  
end 
    
%% Analyze the different EEG to display for chosen file
function DisplayAlgo(~,~)
    tic;
    Display_spikes();
    toc
end

%% Launch a window to change parameters of all the files
function changeParameters(~,~)
    close(gcf);
    change_parameters();
end

%% Launch a window to display a graphic view in 2D for chosen file
function view(~,~) 
    %load('Spikes.mat','file');
    scalp();
end

%% Launch the CreateXMLfile function for chosen file
function createXML(~,~) 
    load('Spikes.mat','file');
    for CurrentRecording = 1:length(file)
        if (file(CurrentRecording).ChosenFile == 1)
            CreateXMLfile(CurrentRecording);
        end
    end
end

%% Create excel file with relevant statistics
function excelStat(~,~) 
    excel_stats();
end

%% Choose the current working file using the listbox
function ChangeCurrentFile(obj,event) 
    ChosenFile = get(obj,'value');
    load('Spikes.mat','file');
    for CurrentRecording = 1:length(file)
        if ChosenFile == CurrentRecording
            file(CurrentRecording).ChosenFile = 1;
        else
            file(CurrentRecording).ChosenFile = 0;
        end
    end
    save('Spikes.mat','file');
end
