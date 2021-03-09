function Characteristics(current,fileName,fileData,path,changeChar)
%%This is the launch of the second interface
%%%There is the initialization of many buttons and the possibility to fill
%%%the Atributpat file for each file 
%%It launchs the main function

name = ['Choose characteristics for ' fileName];

h1 = figure(...
    'Position',[450 130 500 500],...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Name',name);


% Choose the timing of the experiment 
uicontrol(h1,'style','text',...
             'Units','normalized',...
             'Position',[.05 .9 0.5 0.05],... 
             'String','Time at which the analysis begins (sec):');
         
uicontrol(h1,'style','edit',...
             'Units','normalized',...
             'Position',[.5 .9 0.2 0.05],... 
             'tag','TimeIn');
         
uicontrol(h1,'style','pushbutton',...
     'units','normalized',...
     'position',[0.72 0.9 0.2 0.05],... 
     'string','Add time in',...
     'callback',@addTimeIn,...
     'tag','tagTimeIn');
 
 % Delete Time in 
uicontrol(h1,'style','pushbutton',...
     'units','normalized',...
     'position',[0.72 0.83 0.2 0.05],... 
     'string','Delete time In',...
     'callback',@deleteTimeIn,...
     'tag','tagTimeOut');
 
uicontrol(h1,'style','text',...
             'Units','normalized',...
             'Position',[.05 .8 0.3 0.05],... 
             'String','Time in list:'); 

uicontrol(h1,'style','text',...
             'Units','normalized',...
             'Position',[.25 .8 0.42 0.05],... 
             'String','[]',...
             'tag','getTimeInList'); 
         
uicontrol(h1,'style','text',...
             'Units','normalized',...
             'Position',[.05 .65 0.5 0.05],... 
             'String','Time at which the analysis ends (sec):');
         
uicontrol(h1,'style','edit',...
             'Units','normalized',...
             'Position',[.5 .65 0.2 0.05],... 
             'String','',...
             'tag','TimeOut');
         
uicontrol(h1,'style','text',...
             'Units','normalized',...
             'Position',[.05 .55 0.3 0.05],... 
             'String','Time out list:');
         
uicontrol(h1,'style','pushbutton',...
     'units','normalized',...
     'position',[0.72 0.65 0.2 0.05],... 
     'string','Add time Out',...
     'callback',@addTimeOut,...
     'tag','tagTimeOut');
 % Delete Time out
uicontrol(h1,'style','pushbutton',...
     'units','normalized',...
     'position',[0.72 0.58 0.2 0.05],... 
     'string','Delete time Out',...
     'callback',@deleteTimeOut,...
     'tag','tagTimeOut');
 
uicontrol(h1,'style','text',...
             'Units','normalized',...
             'Position',[.25 .55 0.42 0.05],... 
             'String','[]',...
             'tag','getTimeOutList');

% Choose the channels of the experiment

uicontrol(h1,'style','text',...
             'Units','normalized',...
             'Position',[.05 .44 0.5 0.05],... 
             'String','Choose the channel(s) of the experiment:');  


select = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.07 0.4 0.5 0.05],... 
             'String','Select/Deselect All',...
             'Value',1,...
             'callback',@selectAll,...
             'tag','boutonSelectAll');  



handles.ch(1) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.05 0.35 0.5 0.05],... 
             'String','Fp1-F3',...
             'tag','Fp1F3',...
             'callback',@getButton1);    

        
         
handles.ch(2) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.05 0.3 0.5 0.05],...
             'String','F3-C3',...
             'tag','F3C3',...
             'callback',@getButton4);  
         
         


handles.ch(3) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.05 0.25 0.5 0.05],...
             'String','C3-P3',...
             'tag','C3P3',...
             'callback',@getButton5);  
         
         


handles.ch(4) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.05 0.2 0.5 0.05],... 
             'String','P3-O1',...
             'tag','P3O1',...
             'callback',@getButton6);
         
 

handles.ch(5) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.05 0.15 0.5 0.05],... 
             'String','Fp2-F4',...
             'tag','Fp4Fp2',...
             'callback',@getButton2);   
         


handles.ch(6) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.3 0.35 0.5 0.05],... 
             'String','F4-C4',...
             'tag','F4C4',...
             'callback',@getButton3); 
         


handles.ch(7) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.3 0.30 0.5 0.05],... 
             'String','F7-T3',...
             'tag','F7T3',...
             'callback',@getButton9); 
         

handles.ch(8) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.3 0.25 0.5 0.05],...
             'String','T3-T5',...
             'tag','T3T5',...
             'callback',@getButton10)  ;
         


handles.ch(9) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.3 0.20 0.5 0.05],... 
             'String','T5-O1',...
             'tag','T5O1',...
             'callback',@getButton11);
         
         


handles.ch(10) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.3 0.15 0.5 0.05],... 
             'String','T4-T6',...
             'tag','T4T6',...
             'callback',@getButton7); 
         


handles.ch(11) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.55 0.35 0.5 0.05],... 
             'String','T6-O2',...
             'tag','T6O2',...
             'callback',@getButton8); 
         
         

handles.ch(12) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.55 0.3 0.5 0.05],... 
             'String','Fz-Cz',...
             'tag','FzCz',...
             'callback',@getButton12); 
         
         
        

handles.ch(13) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.55 0.25 0.5 0.05],... 
             'String','Cz-Pz',...
             'tag','CzPz',...
             'callback',@getButton13); 
 
handles.ch(14) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.55 0.2 0.5 0.05], ...
                        'String','F9-T9',...
                        'tag','F9T9',...
                        'callback',@getButton14);

handles.ch(15) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.55 0.15 0.5 0.05], ...
                        'String','T9-P9',...
                        'tag','T9P9',...
                        'callback',@getButton15);
                    
handles.ch(16) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.8 0.35 0.5 0.05], ...
                        'String','F10-T10',...
                        'callback',@getButton16,...
                        'tag','F10T10');

handles.ch(17) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.8 0.3 05 0.05],...
                        'String','T10-P10',...
                        'callback',@getButton17,...
                        'tag','T10P10');
                    
handles.ch(18) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.8 0.25 05 0.05],...
                        'String','Fp1-F7',...
                        'callback',@getButton18,...
                        'tag','Fp1F7');  
         
handles.ch(19) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.8 0.2 05 0.05],...
                        'String','Fp2-F8',...
                        'callback',@getButton19,...
                        'tag','Fp2F8');  
 
handles.ch(20) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.8 0.15 05 0.05],...
                        'String','F8-T4',...
                        'callback',@getButton20,...
                        'tag','F8T4');  

handles.ch(21) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.8 0.1 05 0.05],...
                        'String','C4-P4',...
                        'callback',@getButton21,...
                        'tag','C4P4');            

handles.ch(22) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.8 0.05 05 0.05],...
                        'String','P4-O2',...
                        'callback',@getButton22,...
                        'tag','P4O2');
                    
% Creation of the object Uicontrol Start %startParam = 0
     uicontrol(h1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.45 0.05 0.25 0.05],...
     'string','Start Analysis (2)',...    
     'callback',@startAnalyze,...
     'tag','bouton_start');

 
 % Creation of the object Uicontrol parameter modification %startParam = 1
     uicontrol(h1,'style','pushbutton',...
     'units','normalized',...
     'FontWeight','bold',...
     'position',[0.1 0.05 0.25 0.05],...
     'string','Settings/Experts',...    
     'callback',@changeSettings,...
     'tag','bouton_paramStart');
 
% Update handles structure
    guidata(h1, handles);
    setappdata(gcf,'ch',handles.ch);
    data=guihandles(gcf);
    guidata(gcf,data);
    setappdata(gcf,'fileName',fileName);
    setappdata(gcf,'fileData',fileData);
    setappdata(gcf,'path',path);
    setappdata(gcf,'current',current);
    
    %part of the data showing if check_spikes should be used later
    isAllChecked = 0; %value will be set to 1 if check_spikes will be used later
    setappdata(gcf, 'isAllChecked', isAllChecked);

    %% following is used to input default parameters
    
    % ****************************
    % Characteristic time inputs *
    % ****************************
    
    % Add TimeIn = 0 and TimeOut = timeSpan of the whole analysis
    
    algo_timeIn = 0;
    algo_str = num2str(transpose(algo_timeIn));
    set(data.getTimeInList,'string',algo_str);
    setappdata(gcf,'Algo_timeIn',algo_timeIn);
    
    if endsWith(fileName,'.mat') %only if file is a .mat can we input default timeOut
        if isa(fileData,'cell') % If it's many files
            algo_timeOut = fileData{current,1}.Data.timeSpan;
        else
            algo_timeOut = fileData.Data.timeSpan;
        end
        algo_str = num2str(transpose(algo_timeOut));
        set(data.getTimeOutList,'string',algo_str);
        setappdata(gcf,'Algo_timeOut',algo_timeOut);
    elseif endsWith(fileName,'.EDF')
        % No example so cannot be accounted yet
        disp('edf file does not contain a default timeOut');
    end
    
    
    
    % *************************************
    % By default, all channels are chosen *
    % *************************************

    preselectAll(); %this function selects all values by default
    
    % Used to account for  multiple input files and start button (1)
    load('Spikes.mat','file');
    for i=1:length(file)
        file(i).changeChar = changeChar;
    end
    save('Spikes.mat','file');

    % In case we don't want to change the characteristics
    % Used to handle start button (1)
    if changeChar == 0
        startDirectAnalyze(changeChar);
    end
end

%% The user can add or delete many timeIn
function addTimeIn(obj,event)
    data = guidata(gcbf);
    algo_timeIn = getappdata(gcbf,'Algo_timeIn');
    timeIn = findobj(gcf,'tag','TimeIn');
    ti = timeIn.String;
    ti = str2num(ti);
    if (isempty(algo_timeIn))
        algo_timeIn = ti;
    else 
        algo_timeIn = [algo_timeIn;ti];
    end
    
    algo_str = num2str(transpose(algo_timeIn));
    set(data.getTimeInList,'string',algo_str);
    setappdata(gcf,'Algo_timeIn',algo_timeIn);
    guidata(gcbf,data);
end

function deleteTimeIn(obj,event)
    data = guidata(gcbf);
    algo_timeIn = getappdata(gcbf,'Algo_timeIn');
    timeIn = findobj(gcf,'tag','TimeIn');
    ti = timeIn.String;

        if ~isempty(algo_timeIn)
            algo_timeIn(end) = [];
        end
        
    algo_str = num2str(transpose(algo_timeIn));
    set(data.getTimeInList,'string',algo_str);
    setappdata(gcf,'Algo_timeIn',algo_timeIn);
    guidata(gcbf,data);
end

%% The user can add or delete many timeOut
function addTimeOut(obj,event)
    data = guidata(gcbf);
    algo_timeOut = getappdata(gcbf,'Algo_timeOut');
    timeOut = findobj(gcf,'tag','TimeOut');
    to = timeOut.String;
    to = str2num(to);
    if (length(algo_timeOut)==0)
        algo_timeOut = to;
    else 
        algo_timeOut = [algo_timeOut;to];
   
    end
    algo_str = num2str(transpose(algo_timeOut));
    set(data.getTimeOutList,'string',algo_str);
    setappdata(gcf,'Algo_timeOut',algo_timeOut);
    guidata(gcbf,data);
end

function deleteTimeOut(obj,event)
    data = guidata(gcbf);
    algo_timeOut = getappdata(gcbf,'Algo_timeOut');
    timeOut = findobj(gcf,'tag','TimeOut');
    to = timeOut.String;
    to = str2num(to);
        if ~isempty(algo_timeOut)
            algo_timeOut(end) = [];
        end
    algo_str = num2str(transpose(algo_timeOut));
    set(data.getTimeOutList,'string',algo_str);
    setappdata(gcf,'Algo_timeOut',algo_timeOut);
    guidata(gcbf,data);
end


%% Allow the user to select/deselect all the channels
function selectAll(obj, event)
    % Get figure handles
    data=guidata(gcbf);
    fileName = getappdata(gcbf,'fileName');
    fileData = getappdata(gcbf,'fileData');
    data.ch = getappdata(gcf,'ch');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    
    %part of the code that activates the check_spikes function
    isAllChecked = getappdata(gcbf, 'isAllChecked');
    
    selectV = get(obj,'Value');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
        set(obj, 'value', 0);
    else
        if selectV == 0
            
            isAllChecked = 0; %Check_spikes will not be used
            
            set(data.ch, 'value', 0);

            nrElectrodeLeft=cell2mat(nrElectrodeLeft);
            nrElectrodeLeft = [];
            nrElectrodeRight=cell2mat(nrElectrodeRight);
            nrElectrodeRight = [];

            disp(size(nrElectrodeLeft));
            disp(size(nrElectrodeRight));


        end
        if selectV == 1
            
            isAllChecked = 1; %Check_spikes will be used
            
            set(data.ch, 'value', 1);
            channel = zeros(34,7);
            channel(1,:) = Get_Channel(path,fileName,'Fp1',fileData);
            if (channel(1,:) == 0)
                    channel(1,:) = Get_Channel(path,fileName,'FP1',fileData);
            end
            channel(2,:) = [Get_Channel(path,fileName,'F3',fileData) ' '];
            channel(3,:) = [Get_Channel(path,fileName,'F3',fileData) ' '];
            channel(4,:) = [Get_Channel(path,fileName,'C3',fileData) ' '];
            channel(5,:) = [Get_Channel(path,fileName,'C3',fileData) ' '];
            channel(6,:) = [Get_Channel(path,fileName,'P3',fileData) ' '];
            channel(7,:) = [Get_Channel(path,fileName,'P3',fileData) ' '];
            channel(8,:) = [Get_Channel(path,fileName,'O1',fileData) ' '];
            channel(9,:) = Get_Channel(path,fileName,'Fp2',fileData);
            if (channel(9,:) == 0)
                channel(9,:) = Get_Channel(path,fileName,'FP2',fileData);
            end
            channel(10,:) = [Get_Channel(path,fileName,'F4',fileData) ' '];

            channel(11,:) = [Get_Channel(path,fileName,'F4',fileData) ' '];
            channel(12,:) = [Get_Channel(path,fileName,'C4',fileData) ' '];
            channel(13,:) = [Get_Channel(path,fileName,'C4',fileData) ' '];
            channel(14,:) = [Get_Channel(path,fileName,'P4',fileData) ' '];
            channel(15,:) = [Get_Channel(path,fileName,'P4',fileData) ' '];
            channel(16,:) = [Get_Channel(path,fileName,'O2',fileData) ' '];
            channel(17,:) = Get_Channel(path,fileName,'Fp1',fileData);
            if (channel(17,:) == 0)
                channel(17,:) = Get_Channel(path,fileName,'FP1',fileData);
            end
            channel(18,:) = [Get_Channel(path,fileName,'F7',fileData) ' '];
            channel(19,:) = [Get_Channel(path,fileName,'F7',fileData) ' '];
            channel(20,:) = [Get_Channel(path,fileName,'T3',fileData) ' '];
            channel(21,:) = [Get_Channel(path,fileName,'T3',fileData) ' '];
            channel(22,:) = [Get_Channel(path,fileName,'T5',fileData) ' '];
            channel(23,:) = [Get_Channel(path,fileName,'T5',fileData) ' '];
            channel(24,:) = [Get_Channel(path,fileName,'O1',fileData) ' '];
            channel(25,:) = Get_Channel(path,fileName,'Fp2',fileData);
            if (channel(25,:) == 0)
                channel(25,:) = Get_Channel(path,fileName,'FP2',fileData);
            end
            channel(26,:) = [Get_Channel(path,fileName,'F8',fileData) ' '];
            channel(27,:) = [Get_Channel(path,fileName,'F8',fileData) ' '];
            channel(28,:) = [Get_Channel(path,fileName,'T4',fileData) ' '];
            channel(29,:) = [Get_Channel(path,fileName,'T4',fileData) ' '];
            channel(30,:) = [Get_Channel(path,fileName,'T6',fileData) ' '];
            channel(31,:) = [Get_Channel(path,fileName,'T6',fileData) ' '];
            channel(32,:) = [Get_Channel(path,fileName,'O2',fileData) ' '];
            channel(33,:) = [Get_Channel(path,fileName,'Fz',fileData) ' '];
            channel(34,:) = [Get_Channel(path,fileName,'Cz',fileData) ' '];
            channel(35,:) = [Get_Channel(path,fileName,'Cz',fileData) ' '];
            channel(36,:) = [Get_Channel(path,fileName,'Pz',fileData) ' '];
            channel(37,:) = [Get_Channel(path,fileName,'F9',fileData) ' '];
            channel(38,:) = [Get_Channel(path,fileName,'T9',fileData) ' '];
            channel(39,:) = [Get_Channel(path,fileName,'T9',fileData) ' '];
            channel(40,:) = [Get_Channel(path,fileName,'P9',fileData) ' '];
            channel(41,:) = Get_Channel(path,fileName,'F10',fileData);
            channel(42,:) = Get_Channel(path,fileName,'T10',fileData);
            channel(43,:) = Get_Channel(path,fileName,'T10',fileData);
            channel(44,:) = Get_Channel(path,fileName,'P10',fileData);
            channel = char(channel);

            
            for i=1:44
                if i==1
                    nrElectrodeLeft{i} = char(channel(i,:));
                else
                    nrElectrodeLeft{end+1} = char(channel(i,:));
                end

            end

            for i=1:44 %List of nrElectrodeRight
                if mod(i,2) ~= 0 % when it's odd
                    nrElectrodeRight{i} = char(channel(i+1,:));
                elseif mod(i,2) == 0 % when it's pair
                    nrElectrodeRight{i} = char(channel(i-1,:));
                end
            end

%             disp(size(nrElectrodeLeft));
%             disp(size(nrElectrodeRight));

        end
    end
    
    %% Check if the algorithm above works
%     disp(nrElectrodeLeft);
%     disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    setappdata(gcbf, 'isAllChecked', isAllChecked);
    guidata(gcbf,data);
end

%% Allow to preselect all the channels
function preselectAll()
    % Get figure handles
    data = guidata(gcf);
    fileName = getappdata(gcf,'fileName');
    fileData = getappdata(gcf,'fileData');
    data.ch = getappdata(gcf,'ch');
    path = getappdata(gcf,'path');
    nrElectrodeLeft = getappdata(gcf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcf,'nrElectrodeRight');
    
    %part of the code that activates the check_spikes function
    isAllChecked = getappdata(gcf, 'isAllChecked');
    
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
        set(obj, 'value', 0);
    else
        isAllChecked = 1;
        set(data.ch, 'value', 1);
        channel = zeros(34,7);
        channel(1,:) = Get_Channel(path,fileName,'Fp1',fileData);
        if (channel(1,:) == 0)
                channel(1,:) = Get_Channel(path,fileName,'FP1',fileData);
        end
        channel(2,:) = [Get_Channel(path,fileName,'F3',fileData) ' '];
        channel(3,:) = [Get_Channel(path,fileName,'F3',fileData) ' '];
        channel(4,:) = [Get_Channel(path,fileName,'C3',fileData) ' '];
        channel(5,:) = [Get_Channel(path,fileName,'C3',fileData) ' '];
        channel(6,:) = [Get_Channel(path,fileName,'P3',fileData) ' '];
        channel(7,:) = [Get_Channel(path,fileName,'P3',fileData) ' '];
        channel(8,:) = [Get_Channel(path,fileName,'O1',fileData) ' '];
        channel(9,:) = Get_Channel(path,fileName,'Fp2',fileData);
        if (channel(9,:) == 0)
            channel(9,:) = Get_Channel(path,fileName,'FP2',fileData);
        end
        channel(10,:) = [Get_Channel(path,fileName,'F4',fileData) ' '];

        channel(11,:) = [Get_Channel(path,fileName,'F4',fileData) ' '];
        channel(12,:) = [Get_Channel(path,fileName,'C4',fileData) ' '];
        channel(13,:) = [Get_Channel(path,fileName,'C4',fileData) ' '];
        channel(14,:) = [Get_Channel(path,fileName,'P4',fileData) ' '];
        channel(15,:) = [Get_Channel(path,fileName,'P4',fileData) ' '];
        channel(16,:) = [Get_Channel(path,fileName,'O2',fileData) ' '];
        channel(17,:) = Get_Channel(path,fileName,'Fp1',fileData);
        if (channel(17,:) == 0)
            channel(17,:) = Get_Channel(path,fileName,'FP1',fileData);
        end
        channel(18,:) = [Get_Channel(path,fileName,'F7',fileData) ' '];
        channel(19,:) = [Get_Channel(path,fileName,'F7',fileData) ' '];
        channel(20,:) = [Get_Channel(path,fileName,'T3',fileData) ' '];
        channel(21,:) = [Get_Channel(path,fileName,'T3',fileData) ' '];
        channel(22,:) = [Get_Channel(path,fileName,'T5',fileData) ' '];
        channel(23,:) = [Get_Channel(path,fileName,'T5',fileData) ' '];
        channel(24,:) = [Get_Channel(path,fileName,'O1',fileData) ' '];
        channel(25,:) = Get_Channel(path,fileName,'Fp2',fileData);
        if (channel(25,:) == 0)
            channel(25,:) = Get_Channel(path,fileName,'FP2',fileData);
        end
        channel(26,:) = [Get_Channel(path,fileName,'F8',fileData) ' '];
        channel(27,:) = [Get_Channel(path,fileName,'F8',fileData) ' '];
        channel(28,:) = [Get_Channel(path,fileName,'T4',fileData) ' '];
        channel(29,:) = [Get_Channel(path,fileName,'T4',fileData) ' '];
        channel(30,:) = [Get_Channel(path,fileName,'T6',fileData) ' '];
        channel(31,:) = [Get_Channel(path,fileName,'T6',fileData) ' '];
        channel(32,:) = [Get_Channel(path,fileName,'O2',fileData) ' '];
        channel(33,:) = [Get_Channel(path,fileName,'Fz',fileData) ' '];
        channel(34,:) = [Get_Channel(path,fileName,'Cz',fileData) ' '];
        channel(35,:) = [Get_Channel(path,fileName,'Cz',fileData) ' '];
        channel(36,:) = [Get_Channel(path,fileName,'Pz',fileData) ' '];
        channel(37,:) = [Get_Channel(path,fileName,'F9',fileData) ' '];
        channel(38,:) = [Get_Channel(path,fileName,'T9',fileData) ' '];
        channel(39,:) = [Get_Channel(path,fileName,'T9',fileData) ' '];
        channel(40,:) = [Get_Channel(path,fileName,'P9',fileData) ' '];
        channel(41,:) = Get_Channel(path,fileName,'F10',fileData);
        channel(42,:) = Get_Channel(path,fileName,'T10',fileData);
        channel(43,:) = Get_Channel(path,fileName,'T10',fileData);
        channel(44,:) = Get_Channel(path,fileName,'P10',fileData);
        channel = char(channel);
        for i=1:44 %List of nrElectrodeLeft
            if i==1
                nrElectrodeLeft{i} = char(channel(i,:));
            else
                nrElectrodeLeft{end+1} = char(channel(i,:));
            end
        end
        for i=1:44 %List of nrElectrodeRight
            if mod(i,2) ~= 0 % when it's odd
                nrElectrodeRight{i} = char(channel(i+1,:));
            elseif mod(i,2) == 0 % when it's pair
                nrElectrodeRight{i} = char(channel(i-1,:));
            end
        end
%          disp(size(nrElectrodeLeft));
%          disp(size(nrElectrodeRight));
    end
    
    %% Check if the algorithm above works
%     disp(nrElectrodeLeft);
%     disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcf,'nrElectrodeRight',nrElectrodeRight);
    setappdata(gcf, 'isAllChecked', isAllChecked);

    guidata(gcf,data);
end

%% Each button correspond to a channel
function getButton1(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'Fp1-F3') == 1
                channel1 = Get_Channel(path,fileName,'Fp1',fileData);
                if (channel1 == 0)
                    channel1 = Get_Channel(path,fileName,'FP1',fileData);
                end  
                channel2 = Get_Channel(path,fileName,'F3',fileData);
                nrElectrodeLeft{end+1} =channel1;
                nrElectrodeLeft{end+2}= [channel2 ' '];

                nrElectrodeRight{end+1} = [channel2 ' '];
                nrElectrodeRight{end+2} = channel1;

                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));           
            end
        end
        %% When the button is unchecked
        if value == 0
            if strcmp(Fct,'Fp1-F3') == 1
                channel1 = Get_Channel(path,fileName,'Fp1',fileData);
                if (channel1 == 0)
                    channel1 = Get_Channel(path,fileName,'FP1',fileData);
                end
                channel2 = Get_Channel(path,fileName,'F3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, channel1)  && isequal(nrElectrodeRight{i}, [channel2 ' '])) || (isequal(nrElectrodeLeft{i}, [channel2 ' ']) && isequal(nrElectrodeRight{i}, channel1))

                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end
            end

        end
         %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
%     disp(nrElectrodeLeft);
%     disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton2(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    path = getappdata(gcbf,'path');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'Fp2-F4')==1
            channel3 = Get_Channel(path,fileName,'Fp2',fileData);
            if (channel3 == 0)
                channel3 = Get_Channel(path,fileName,'FP2',fileData);
            end  
            channel4 = Get_Channel(path,fileName,'F4',fileData);
            channel4 = [channel4 ' '];
            nrElectrodeLeft{end+1} = channel3;
            nrElectrodeLeft{end+2} = channel4;

            nrElectrodeRight{end+1}= channel4;
            nrElectrodeRight{end+2}= channel3;
            end
        end
        %% When the button is unchecked
        if value == 0
            if strcmp(Fct,'Fp2-F4') == 1
                channel3 = Get_Channel(path,fileName,'Fp2',fileData);
                if (channel3 == 0)
                    channel3 = Get_Channel(path,fileName,'FP2',fileData);
                end
                channel4 = Get_Channel(path,fileName,'F4',fileData);
                channel4 = [channel4 ' '];
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, channel3) && isequal(nrElectrodeRight{i}, channel4))|| (isequal(nrElectrodeLeft{i},channel4) && isequal(nrElectrodeRight{i}, channel3))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end
            end
        end
         %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton3(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'F4-C4')==1
                channel5 = Get_Channel(path,fileName,'F4',fileData);
                channel6 = Get_Channel(path,fileName,'C4',fileData);
                nrElectrodeLeft{end+1} = [channel5 ' '];
                nrElectrodeLeft{end+2} = [channel6 ' '];
                nrElectrodeRight{end+1} = [channel6 ' '];
                nrElectrodeRight{end+2} = [channel5 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end

        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'F4-C4') == 1
                channel5 = Get_Channel(path,fileName,'F4',fileData);
                channel6 = Get_Channel(path,fileName,'C4',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel5 ' ']) && isequal(nrElectrodeRight{i}, [channel6 ' '])) || (isequal(nrElectrodeLeft{i}, [channel6 ' ']) && isequal(nrElectrodeRight{i}, [channel5 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton4(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'F3-C3')==1
                channel7 = Get_Channel(path,fileName,'F3',fileData);
                channel8 = Get_Channel(path,fileName,'C3',fileData);
                nrElectrodeLeft{end+1} = [channel7 ' '];
                nrElectrodeLeft{end+2} = [channel8 ' '];
                nrElectrodeRight{end+1} = [channel8 ' '];
                nrElectrodeRight{end+2} = [channel7 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'F3-C3')==1
                channel7 = Get_Channel(path,fileName,'F3',fileData);
                channel8 = Get_Channel(path,fileName,'C3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel7 ' ']) && isequal(nrElectrodeRight{i}, [channel8 ' '])) || (isequal(nrElectrodeLeft{i}, [channel8 ' ']) && isequal(nrElectrodeRight{i}, [channel7 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton5(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'C3-P3')==1
                channel9 = Get_Channel(path,fileName,'C3',fileData);
                channel10 = Get_Channel(path,fileName,'P3',fileData);
                nrElectrodeLeft{end+1} = [channel9 ' '];
                nrElectrodeLeft{end+2} = [channel10 ' '];
                nrElectrodeRight{end+1} = [channel10 ' '];
                nrElectrodeRight{end+2} = [channel9 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'C3-P3')==1
                channel9 = Get_Channel(path,fileName,'C3',fileData);
                channel10 = Get_Channel(path,fileName,'P3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel9 ' ']) && isequal(nrElectrodeRight{i}, [channel10 ' '])) || (isequal(nrElectrodeLeft{i}, [channel10 ' ']) && isequal(nrElectrodeRight{i}, [channel9 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end

            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton6(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'P3-O1')==1
                channel11 = Get_Channel(path,fileName,'P3',fileData);
                channel12 = Get_Channel(path,fileName,'O1',fileData);
                nrElectrodeLeft{end+1} = [channel11 ' '];
                nrElectrodeLeft{end+2} = [channel12 ' '];
                nrElectrodeRight{end+1} = [channel12 ' '];
                nrElectrodeRight{end+2} = [channel11 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'P3-O1')==1
                channel11 = Get_Channel(path,fileName,'P3',fileData);
                channel12 = Get_Channel(path,fileName,'O1',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel11 ' ']) && isequal(nrElectrodeRight{i}, [channel12 ' '])) || (isequal(nrElectrodeLeft{i}, [channel12 ' ']) && isequal(nrElectrodeRight{i}, [channel11 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton7(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'T4-T6') == 1
                channel13 = Get_Channel(path,fileName,'T4',fileData);
                channel14 = Get_Channel(path,fileName,'T6',fileData);
                nrElectrodeLeft{end+1} = [channel13 ' '];
                nrElectrodeLeft{end+2} = [channel14 ' '];
                nrElectrodeRight{end+1} = [channel14 ' '];
                nrElectrodeRight{end+2} = [channel13 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));

            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T4-T6') == 1
                channel13 = Get_Channel(path,fileName,'T4',fileData);
                channel14 = Get_Channel(path,fileName,'T6',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel13 ' ']) && isequal(nrElectrodeRight{i}, [channel14 ' '])) || (isequal(nrElectrodeLeft{i}, [channel14 ' ']) && isequal(nrElectrodeRight{i}, [channel13 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton8(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'T6-O2') == 1
                channel15 = Get_Channel(path,fileName,'T6',fileData);
                channel16 = Get_Channel(path,fileName,'O2',fileData);
                nrElectrodeLeft{end+1} = [channel15 ' '];
                nrElectrodeLeft{end+2} = [channel16 ' '];
                nrElectrodeRight{end+1} = [channel16 ' '];
                nrElectrodeRight{end+2} = [channel15 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T6-O2') == 1
                channel15 = Get_Channel(path,fileName,'T6',fileData);
                channel16 = Get_Channel(path,fileName,'O2',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel15 ' ']) && isequal(nrElectrodeRight{i}, [channel16 ' '])) || (isequal(nrElectrodeLeft{i}, [channel16 ' ']) && isequal(nrElectrodeRight{i}, [channel15 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton9(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'F7-T3') ==1
                channel17 = Get_Channel(path,fileName,'F7',fileData);
                channel18 = Get_Channel(path,fileName,'T3',fileData);
                nrElectrodeLeft{end+1} = [channel17 ' '];
                nrElectrodeLeft{end+2} = [channel18 ' '];
                nrElectrodeRight{end+1} = [channel18 ' '];
                nrElectrodeRight{end+2} = [channel17 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'F7-T3') ==1
                channel17 = Get_Channel(path,fileName,'F7',fileData);
                channel18 = Get_Channel(path,fileName,'T3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel17 ' ']) && isequal(nrElectrodeRight{i}, [channel18 ' '])) || (isequal(nrElectrodeLeft{i}, [channel18 ' ']) && isequal(nrElectrodeRight{i}, [channel17 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
         %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton10(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'T3-T5') ==1
                channel19 = Get_Channel(path,fileName,'T3',fileData);
                channel20 = Get_Channel(path,fileName,'T5',fileData);
                nrElectrodeLeft{end+1} = [channel19 ' '];
                nrElectrodeLeft{end+2} = [channel20 ' '];
                nrElectrodeRight{end+1} = [channel20 ' '];
                nrElectrodeRight{end+2} = [channel19 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T3-T5') ==1
                channel19 = Get_Channel(path,fileName,'T3',fileData);
                channel20 = Get_Channel(path,fileName,'T5',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel19 ' ']) && isequal(nrElectrodeRight{i}, [channel20 ' '])) || (isequal(nrElectrodeLeft{i}, [channel20 ' ']) && isequal(nrElectrodeRight{i}, [channel19 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton11(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'T5-O1') ==1 
                channel21 = Get_Channel(path,fileName,'T5',fileData);
                channel22 = Get_Channel(path,fileName,'O1',fileData);
                nrElectrodeLeft{end+1} = [channel21 ' '];
                nrElectrodeLeft{end+2} = [channel22 ' '];
                nrElectrodeRight{end+1} = [channel22 ' '];
                nrElectrodeRight{end+2} = [channel21 ' '];
                %% Delete the empty cells
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T5-O1') ==1 
                channel21 = Get_Channel(path,fileName,'T5',fileData);
                channel22 = Get_Channel(path,fileName,'O1',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel21 ' ']) && isequal(nrElectrodeRight{i}, [channel22 ' '])) || (isequal(nrElectrodeLeft{i}, [channel22 ' ']) && isequal(nrElectrodeRight{i}, [channel21 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton12(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'Fz-Cz') ==1
                channel23 = Get_Channel(path,fileName,'Fz',fileData);
                channel24 = Get_Channel(path,fileName,'Cz',fileData);
                nrElectrodeLeft{end+1} = [channel23 ' '];
                nrElectrodeLeft{end+2} = [channel24 ' '];
                nrElectrodeRight{end+1} = [channel24 ' '];
                nrElectrodeRight{end+2} = [channel23 ' '];
                %% Delete the empty cells
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'Fz-Cz') ==1
                channel23 = Get_Channel(path,fileName,'Fz',fileData);
                channel24 = Get_Channel(path,fileName,'Cz',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel23 ' ']) && isequal(nrElectrodeRight{i}, [channel24 ' '])) || (isequal(nrElectrodeLeft{i}, [channel24 ' ']) && isequal(nrElectrodeRight{i}, [channel23 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton13(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'Cz-Pz') == 1
                channel25 = Get_Channel(path,fileName,'Cz',fileData);
                channel26 = Get_Channel(path,fileName,'Pz',fileData);
                nrElectrodeLeft{end+1} = [channel25 ' '];
                nrElectrodeLeft{end+2} = [channel26 ' '];
                nrElectrodeRight{end+1} = [channel26 ' '];
                nrElectrodeRight{end+2} = [channel25 ' '];
                %% Delete the empty cells
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'Cz-Pz') == 1
                channel25 = Get_Channel(path,fileName,'Cz',fileData);
                channel26 = Get_Channel(path,fileName,'Pz',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel25 ' ']) && isequal(nrElectrodeRight{i}, [channel26 ' '])) || (isequal(nrElectrodeLeft{i}, [channel26 ' ']) && isequal(nrElectrodeRight{i}, [channel25 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton14(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
    %% When the button is checked
        if value == 1
            if strcmp(Fct,'F9-T9') == 1
                channel27 = Get_Channel(path,fileName,'F9',fileData);
                channel28 = Get_Channel(path,fileName,'T9',fileData);
                nrElectrodeLeft{end+1} = [channel27 ' '];
                nrElectrodeLeft{end+2} = [channel28 ' '];
                nrElectrodeRight{end+1} = [channel28 ' '];
                nrElectrodeRight{end+2} = [channel27 ' '];
                %% Delete the empty cells
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'F9-T9') == 1
                channel27 = Get_Channel(path,fileName,'F9',fileData);
                channel28 = Get_Channel(path,fileName,'T9',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel27 ' ']) && isequal(nrElectrodeRight{i}, [channel28 ' '])) || (isequal(nrElectrodeLeft{i}, [channel28 ' ']) && isequal(nrElectrodeRight{i}, [channel27 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton15(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'T9-P9') == 1
                channel29 = Get_Channel(path,fileName,'T9',fileData);
                channel30 = Get_Channel(path,fileName,'P9',fileData);
                nrElectrodeLeft{end+1} = [channel29 ' '];
                nrElectrodeLeft{end+2} = [channel30 ' '];
                nrElectrodeRight{end+1} = [channel30 ' ']; 
                nrElectrodeRight{end+2} = [channel29 ' '];
                %% Delete the empty cells
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'T9-P9') == 1
                channel29 = Get_Channel(path,fileName,'T9',fileData);
                channel30 = Get_Channel(path,fileName,'P9',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel29 ' ']) && isequal(nrElectrodeRight{i}, [channel30 ' '])) || (isequal(nrElectrodeLeft{i}, [channel30 ' ']) && isequal(nrElectrodeRight{i}, [channel29 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
    %% Delete the empty cells
    nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
    nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton16(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'F10-T10') == 1
                channel31 = Get_Channel(path,fileName,'F10',fileData);
                channel32 = Get_Channel(path,fileName,'T10',fileData);
                nrElectrodeLeft{end+1} = channel31;
                nrElectrodeLeft{end+2} = channel32;
                nrElectrodeRight{end+1} = channel32;
                nrElectrodeRight{end+2} = channel31;
                %% Delete the empty cells
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));

            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'F10-T10') == 1
                channel31 = Get_Channel(path,fileName,'F10',fileData);
                channel32 = Get_Channel(path,fileName,'T10',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, channel31) && isequal(nrElectrodeRight{i},channel32)) || (isequal(nrElectrodeLeft{i}, channel32) && isequal(nrElectrodeRight{i},channel31))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
    %% Delete the empty cells
    nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
    nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton17(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'T10-P10') == 1
                channel33 = Get_Channel(path,fileName,'T10',fileData);
                channel34 = Get_Channel(path,fileName,'P10',fileData);
                nrElectrodeLeft{end+1} = channel33;
                nrElectrodeLeft{end+2} = channel34;
                nrElectrodeRight{end+1} = channel34;
                nrElectrodeRight{end+2} = channel33;
                %% Delete the empty cells
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
            if strcmp(Fct,'T10-P10') == 1
                channel33 = Get_Channel(path,fileName,'T10',fileData);
                channel34 = Get_Channel(path,fileName,'P10',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, channel33) && isequal(nrElectrodeRight{i}, channel34)) || (isequal(nrElectrodeLeft{i}, channel34) && isequal(nrElectrodeRight{i}, channel33))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        
        %% Delete the empty cells
    nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
    nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end
    
function getButton18(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'Fp1-F7') == 1
                channel35 = Get_Channel(path,fileName,'Fp1',fileData);
                if (channel35 == 0)
                    channel35 = Get_Channel(path,fileName,'FP1',fileData);
                end  
                channel2 = Get_Channel(path,fileName,'F7',fileData);
                nrElectrodeLeft{end+1} =channel35;
                nrElectrodeLeft{end+2}= [channel36 ' '];

                nrElectrodeRight{end+1} = [channel36 ' '];
                nrElectrodeRight{end+2} = channel35;

                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));           
            end
        end
        %% When the button is unchecked
        if value == 0
            if strcmp(Fct,'Fp1-F7') == 1
                channel35 = Get_Channel(path,fileName,'Fp1',fileData);
                if (channel35 == 0)
                    channel35 = Get_Channel(path,fileName,'FP1',fileData);
                end
                channel36 = Get_Channel(path,fileName,'F7',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, channel35)  && isequal(nrElectrodeRight{i}, [channel36 ' '])) || (isequal(nrElectrodeLeft{i}, [channel36 ' ']) && isequal(nrElectrodeRight{i}, channel35))

                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end
            end

        end
         %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton19(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    path = getappdata(gcbf,'path');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'Fp2-F8')==1
            channel37 = Get_Channel(path,fileName,'Fp2',fileData);
            if (channel37 == 0)
                channel37 = Get_Channel(path,fileName,'FP2',fileData);
            end  
            channel38 = Get_Channel(path,fileName,'F8',fileData);
            channel38 = [channel38 ' '];
            nrElectrodeLeft{end+1} = channel37;
            nrElectrodeLeft{end+2} = channel38;

            nrElectrodeRight{end+1}= channel38;
            nrElectrodeRight{end+2}= channel37;
            end
        end
        %% When the button is unchecked
        if value == 0
            if strcmp(Fct,'Fp2-F8') == 1
                channel37 = Get_Channel(path,fileName,'Fp2',fileData);
                if (channel37 == 0)
                    channel37 = Get_Channel(path,fileName,'FP2',fileData);
                end
                channel38 = Get_Channel(path,fileName,'F8',fileData);
                channel38 = [channel38 ' '];
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, channel37) && isequal(nrElectrodeRight{i}, channel38))|| (isequal(nrElectrodeLeft{i},channel38) && isequal(nrElectrodeRight{i}, channel37))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end
            end
        end
         %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton20(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'F8-T4') ==1
                channel39 = Get_Channel(path,fileName,'F8',fileData);
                channel40 = Get_Channel(path,fileName,'T4',fileData);
                nrElectrodeLeft{end+1} = [channel39 ' '];
                nrElectrodeLeft{end+2} = [channel40 ' '];
                nrElectrodeRight{end+1} = [channel40 ' '];
                nrElectrodeRight{end+2} = [channel39 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'F8-T4') ==1
                channel39 = Get_Channel(path,fileName,'F8',fileData);
                channel40 = Get_Channel(path,fileName,'T4',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel39 ' ']) && isequal(nrElectrodeRight{i}, [channel40 ' '])) || (isequal(nrElectrodeLeft{i}, [channel40 ' ']) && isequal(nrElectrodeRight{i}, [channel39 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton21(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'C4-P4') ==1
                channel41 = Get_Channel(path,fileName,'C4',fileData);
                channel42 = Get_Channel(path,fileName,'P4',fileData);
                nrElectrodeLeft{end+1} = [channel41 ' '];
                nrElectrodeLeft{end+2} = [channel42 ' '];
                nrElectrodeRight{end+1} = [channel42 ' '];
                nrElectrodeRight{end+2} = [channel41 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'C4-P4') ==1
                channel41 = Get_Channel(path,fileName,'C4',fileData);
                channel42 = Get_Channel(path,fileName,'P4',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel41 ' ']) && isequal(nrElectrodeRight{i}, [channel42 ' '])) || (isequal(nrElectrodeLeft{i}, [channel42 ' ']) && isequal(nrElectrodeRight{i}, [channel41 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

function getButton22(obj,event)
    data=guidata(gcbf);
    Fct = get(obj,'String');
    value = get(obj,'Value');
    fileData = getappdata(gcbf,'fileData');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    fileName = getappdata(gcbf,'fileName');
    path = getappdata(gcbf,'path');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
    else
        %% When the button is checked
        if value == 1
            if strcmp(Fct,'P4-O2') ==1
                channel43 = Get_Channel(path,fileName,'P4',fileData);
                channel44 = Get_Channel(path,fileName,'O2',fileData);
                nrElectrodeLeft{end+1} = [channel43 ' '];
                nrElectrodeLeft{end+2} = [channel44 ' '];
                nrElectrodeRight{end+1} = [channel44 ' '];
                nrElectrodeRight{end+2} = [channel43 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'P4-O2') ==1
                channel43 = Get_Channel(path,fileName,'P4',fileData);
                channel44 = Get_Channel(path,fileName,'O2',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel43 ' ']) && isequal(nrElectrodeRight{i}, [channel44 ' '])) || (isequal(nrElectrodeLeft{i}, [channel44 ' ']) && isequal(nrElectrodeRight{i}, [channel43 ' ']))
                        nrElectrodeLeft{i} = {};
                        nrElectrodeRight{i} = {};
                    end
                end 
            end
        end
        %% Delete the empty cells
        nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
        nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
    end
    %% Check if the algorithm above works
    disp(nrElectrodeLeft);
    disp(nrElectrodeRight);
    %% Update the data
    setappdata(gcbf,'nrElectrodeLeft',nrElectrodeLeft);
    setappdata(gcbf,'nrElectrodeRight',nrElectrodeRight);
    guidata(gcbf,data);
end

%% used to handle start button (2)
function startAnalyze(obj,event)
    timeIn = getappdata(gcbf,'Algo_timeIn');
    timeOut = getappdata(gcbf,'Algo_timeOut');
    timeDebrec = getappdata(gcbf,'Algo_timeDebrec');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    path = getappdata(gcbf,'path');
    fileName = getappdata(gcbf,'fileName');
    current = getappdata(gcf,'current');
    isAllChecked = getappdata(gcbf, "isAllChecked");
    close(gcf);

    changeSettings = 0; % = false, don't want to change settings and experts
    Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings, isAllChecked);
end

%% if file needs to change analysis settings 
function changeSettings(obj,event)
    timeIn = getappdata(gcbf,'Algo_timeIn');
    timeOut = getappdata(gcbf,'Algo_timeOut');
    timeDebrec = getappdata(gcbf,'Algo_timeDebrec');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    path = getappdata(gcbf,'path');
    fileName = getappdata(gcbf,'fileName');
    current = getappdata(gcf,'current');
    isAllChecked = getappdata(gcf, 'isAllChecked');
    close(gcf);
    changeSettings = 1; % = true, we want to change settings and experts
    Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings, isAllChecked);
end

%% used to handle/follow up start button (1) for quickstart
function startDirectAnalyze(changeChar)
    timeIn = getappdata(gcf,'Algo_timeIn');
    timeOut = getappdata(gcf,'Algo_timeOut');
    timeDebrec = getappdata(gcf,'Algo_timeDebrec');
    nrElectrodeLeft = getappdata(gcf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcf,'nrElectrodeRight');
    path = getappdata(gcf,'path');
    fileName = getappdata(gcf,'fileName');
    current = getappdata(gcf,'current');
    isAllChecked = getappdata(gcf, 'isAllChecked');
    close(gcf);
    changeSettings = changeChar; % equals 0, no need to change settings
    Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings, isAllChecked);

end
