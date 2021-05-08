function Characteristics(current,fileName,fileData,path,changeChar)
%%This is the launch of the second interface
%%%There is the initialization of many buttons and the possibility to fill
%%%the Atributpat file for each file 
%%It launchs the main function

name = ['Choose characteristics for ' fileName];

h1 = figure(...
    'Position',[200 130 850 500],...
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


select = uicontrol(h1,'style','checkbox',... %Bipolar longitudinal montage
             'Units','normalized',...
             'Position',[0.07 0.4 0.5 0.05],... 
             'String','Longitudinal montage (default)',...
             'Value',1,...
             'callback',@selectAll_v,...
             'tag','boutonSelectAll');
         
horizontalanalysis = uicontrol(h1,'style','checkbox',...%Bipolar longitudinal montage with horizontal analysis (phase opposition)
             'Units','normalized',...
             'Position',[0.35 0.4 0.5 0.05],... 
             'String','Longitudinal montage (horizontal analysis)',...
             'Value',0,...
             'callback',@Horizontal_analysis,...
             'tag','boutonhorizontalanalysis');
         
select_H = uicontrol(h1,'style','checkbox',... %Bipolar transverse montage
             'Units','normalized',...
             'Position',[0.65 0.4 0.5 0.05],... 
             'String','Transverse montage',...
             'Value',0,...
             'callback',@selectAll_h,...
             'tag','boutonSelectAll_h');


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
             'Position',[0.15 0.35 0.5 0.05],... 
             'String','F4-C4',...
             'tag','F4C4',...
             'callback',@getButton3); 
         


handles.ch(7) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.15 0.30 0.5 0.05],... 
             'String','F7-T3',...
             'tag','F7T3',...
             'callback',@getButton9); 
         

handles.ch(8) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.15 0.25 0.5 0.05],...
             'String','T3-T5',...
             'tag','T3T5',...
             'callback',@getButton10)  ;
         


handles.ch(9) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.15 0.20 0.5 0.05],... 
             'String','T5-O1',...
             'tag','T5O1',...
             'callback',@getButton11);
         
         


handles.ch(10) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.15 0.15 0.5 0.05],... 
             'String','T4-T6',...
             'tag','T4T6',...
             'callback',@getButton7); 
         


handles.ch(11) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.25 0.35 0.5 0.05],... 
             'String','T6-O2',...
             'tag','T6O2',...
             'callback',@getButton8); 
         
         

handles.ch(12) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.25 0.3 0.5 0.05],... 
             'String','Fz-Cz',...
             'tag','FzCz',...
             'callback',@getButton12); 
         
         
        

handles.ch(13) = uicontrol(h1,'style','checkbox',...
             'Units','normalized',...
             'Position',[0.25 0.25 0.5 0.05],... 
             'String','Cz-Pz',...
             'tag','CzPz',...
             'callback',@getButton13); 
 
handles.ch(14) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.25 0.2 0.5 0.05], ...
                        'String','F9-T9',...
                        'tag','F9T9',...
                        'callback',@getButton14);

handles.ch(15) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.25 0.15 0.5 0.05], ...
                        'String','T9-P9',...
                        'tag','T9P9',...
                        'callback',@getButton15);
                    
handles.ch(16) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.35 0.35 0.5 0.05], ...
                        'String','F10-T10',...
                        'callback',@getButton16,...
                        'tag','F10T10');

handles.ch(17) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.35 0.3 05 0.05],...
                        'String','T10-P10',...
                        'callback',@getButton17,...
                        'tag','T10P10');
                    
handles.ch(18) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.35 0.25 05 0.05],...
                        'String','Fp1-F7',...
                        'callback',@getButton18,...
                        'tag','Fp1F7');  
         
handles.ch(19) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.35 0.2 05 0.05],...
                        'String','Fp2-F8',...
                        'callback',@getButton19,...
                        'tag','Fp2F8');  
 
handles.ch(20) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.35 0.15 05 0.05],...
                        'String','F8-T4',...
                        'callback',@getButton20,...
                        'tag','F8T4');  

handles.ch(21) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.45 0.35 05 0.05],...
                        'String','C4-P4',...
                        'callback',@getButton21,...
                        'tag','C4P4');            

handles.ch(22) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.45 0.3 05 0.05],...
                        'String','P4-O2',...
                        'callback',@getButton22,...
                        'tag','P4O2');
 handles.ch(23) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.45 0.25 0.5 0.05],...
                        'String','Fp1-Fp2',...
                        'callback',@getButton23,...
                        'tag','Fp1Fp2');

                    %BIPOLAR TRANVERSAL MONTAGE
                    
 handles.ch(24) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.45 0.2 0.5 0.05],...
                        'String','F9-F7',...
                        'callback',@getButton24,...
                        'tag','F9F7');

 
handles.ch(25) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.45 0.15 0.5 0.05],...
                        'String','F7-F3',...
                        'callback',@getButton25,...
                        'tag','F7F3');
                    
handles.ch(26) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.55 0.35 0.5 0.05],...
                        'String','F3-FZ',...
                        'callback',@getButton26,...
                        'tag','F7F3');
                    
handles.ch(27) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.55 0.3 0.5 0.05],...
                        'String','Fz-F4',...
                        'callback',@getButton27,...
                        'tag','FzF4');
handles.ch(28) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.55 0.25 0.5 0.05],...
                        'String','F4-F8',...
                        'callback',@getButton28,...
                        'tag','F4F8');
                    
handles.ch(29) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.55 0.2 0.5 0.05],...
                        'String','F8-F10',...
                        'callback',@getButton29,...
                        'tag','F8F10');
                    
handles.ch(30) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.55 0.15 0.5 0.05],...
                        'String','T9-T3',...
                        'callback',@getButton30,...
                        'tag','T9T3')
                     
handles.ch(31) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.65 0.35 0.5 0.05],...
                        'String','T3-C3',...
                        'callback',@getButton31,...
                        'tag','T3C3');
                    
handles.ch(32) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.65 0.3 0.5 0.05],...
                        'String','C3-Cz',...
                        'callback',@getButton32,...
                        'tag','C3Cz');
                    
handles.ch(33) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.65 0.25 0.5 0.05],...
                        'String','Cz-C4',...
                        'callback',@getButton33,...
                        'tag','CzC4');
                    
handles.ch(34) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.65 0.2 0.5 0.05],...
                        'String','C4-T4',...
                        'callback',@getButton34,...
                        'tag','C4T4');                    
                    
handles.ch(35) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.65 0.15 0.5 0.05],...
                        'String','T4-T10',...
                        'callback',@getButton35,...
                        'tag','T4T10');
                   
 
handles.ch(36) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.75 0.35 0.5 0.05],...
                        'String','P9-T5',...
                        'callback',@getButton36,...
                        'tag','P9T5');
                    
handles.ch(37) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.75 0.3 0.5 0.05],...
                        'String','T5-P3',...
                        'callback',@getButton37,...
                        'tag','T5P3');
                  
handles.ch(38) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.75 0.25 0.5 0.05],...
                        'String','P3-Pz',...
                        'callback',@getButton38,...
                        'tag','P3Pz');
                 
handles.ch(39) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.75 0.2 0.5 0.05],...
                        'String','Pz-P4',...
                        'callback',@getButton39,...
                        'tag','PzP4'); 
                    
handles.ch(40) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.75 0.15 0.5 0.05],...
                        'String','P4-T6',...
                        'callback',@getButton40,...
                        'tag','P4T6');
                    
handles.ch(41) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.85 0.3 0.5 0.05],...
                        'String','T6-P10',...
                        'callback',@getButton41,...
                        'tag','T6P10');
                    
handles.ch(42) = uicontrol(h1,'Style', 'checkbox',...
                        'Units','normalized',...
                        'Position',[0.85 0.25 0.5 0.05],...
                        'String','O1-O2',...
                        'callback',@getButton42,...
                        'tag','O1O2');
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
    isAllChecked_v = 0; %value will be set to 1 if check_spikes will be used later
    setappdata(gcf, 'isAllChecked_v', isAllChecked_v);
    isAllChecked_h = 0; %value will be set to 1 if check_spikes_horizontal will be used later
    setappdata(gcf, 'isAllChecked_h', isAllChecked_h);
    transversalMontage = 0;
    setappdata(gcf, 'transversalMontage', transversalMontage);

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

    preselectAll_v(); %this function selects all values by default
    
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


%% Allow the user to select/deselect all the channels for a bipolar longitudinal montage
function selectAll_v(obj, event)
    % Get figure handles
    data=guidata(gcbf);
    fileName = getappdata(gcbf,'fileName');
    fileData = getappdata(gcbf,'fileData');
    data.ch = getappdata(gcf,'ch');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    
    %part of the code that activates the check_spikes function that will be
    %used
    isAllChecked_v = getappdata(gcbf, 'isAllChecked_v'); %for check_spikes
    isAllChecked_h = getappdata(gcbf, 'isAllChecked_h');%for check_spikes_horizontal
    transversalMontage = getappdata(gcbf, 'transversalMontage');%for check_spikes_transversal
    
    selectV = get(obj,'Value');
    
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
        set(obj, 'value', 0);
    else
        if selectV == 0
            
            isAllChecked_v = 0; %Check_spikes will not be used
            isAllChecked_h = 0;%Check_spikes_horizontal will not be used
            transversalMontage = 0; %Check_spikes_transversal will not be used
            
            set(data.ch, 'value', 0);

            nrElectrodeLeft=cell2mat(nrElectrodeLeft);
            nrElectrodeLeft = [];
            nrElectrodeRight=cell2mat(nrElectrodeRight);
            nrElectrodeRight = [];

            disp(size(nrElectrodeLeft));
            disp(size(nrElectrodeRight));


        end
        if selectV == 1
            
            isAllChecked_v = 1; %Check_spikes will be used
            isAllChecked_h = 0; %Check_spikes_horizontal will not be used
            transversalMontage = 0; %Check_spikes_transversal will not be used
            
            set(data.ch(1:23), 'value', 1); %channels in bipolar longitudinal montage
            set(data.ch(24:42), 'value', 0);%channels in bipolar transversal montage
            channel = zeros(44,7);
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
    setappdata(gcbf, 'isAllChecked_v', isAllChecked_v);
    setappdata(gcbf, 'isAllChecked_h', isAllChecked_h);
    setappdata(gcbf, 'transversalMontage', transversalMontage);
    guidata(gcbf,data);
end

%% Allow to preselect all the channels
function preselectAll_v()
    % Get figure handles
    data = guidata(gcf);
    fileName = getappdata(gcf,'fileName');
    fileData = getappdata(gcf,'fileData');
    data.ch = getappdata(gcf,'ch');
    path = getappdata(gcf,'path');
    nrElectrodeLeft = getappdata(gcf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcf,'nrElectrodeRight');
    
    %part of the code that activates the "check_spikes" functions
    isAllChecked_v = getappdata(gcf, 'isAllChecked_v'); %vertical montage and vertical analysis
    isAllChecked_h = getappdata(gcf, 'isAllChecked_h'); %vertical montage and horizontal analysis
    transversalMontage = getappdata(gcf, 'transversalMontage'); %horizontal montage and horizontal analysis
    
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
        set(obj, 'value', 0);
    else
        isAllChecked_v = 1;
        isAllChecked_h = 0;
        transversalMontage = 0;
        set(data.ch(1:23), 'value', 1);
        set(data.ch(24:42), 'value', 0);
        channel = zeros(84,7);
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
    setappdata(gcf, 'isAllChecked_v', isAllChecked_v);
    setappdata(gcf, 'isAllChecked_h', isAllChecked_h);
    setappdata(gcf,'transversalMontage',transversalMontage);

    guidata(gcf,data);
end
%% 
function Horizontal_analysis(obj, event)
    % Get figure handles
    data=guidata(gcbf);
    fileName = getappdata(gcbf,'fileName');
    fileData = getappdata(gcbf,'fileData');
    data.ch = getappdata(gcf,'ch');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    
    
    %part of the code that activates the check_spikes function
    isAllChecked_v = getappdata(gcbf, 'isAllChecked_v');
    isAllChecked_h = getappdata(gcbf, 'isAllChecked_h');
    transversalMontage = getappdata(gcbf, 'transversalMontage');
    
    selectV = get(obj,'Value');
    
    
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
        set(obj, 'value', 0);
    else
        if selectV == 0
            
            isAllChecked_v = 0; %Check_spikes will not be used
            isAllChecked_h = 0;%Check_spikes_horizontal will not be used
            transversalMontage = 0;%Check_spikes_transversal will not be used
            
            set(data.ch, 'value', 0);

            nrElectrodeLeft=cell2mat(nrElectrodeLeft);
            nrElectrodeLeft = [];
            nrElectrodeRight=cell2mat(nrElectrodeRight);
            nrElectrodeRight = [];

            disp(size(nrElectrodeLeft));
            disp(size(nrElectrodeRight));


        end
        if selectV == 1
            
            isAllChecked_v = 0; %Check_spikes will not be used
            isAllChecked_h = 1;%Check_spikes_horizontal will be used
            transversalMontage = 0;%Check_spikes_transversal will not be used
            
            set(data.ch(1:23), 'value', 1);
            set(data.ch(24:42), 'value', 0);
            channel = zeros(44,7);
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
    setappdata(gcbf, 'isAllChecked_v', isAllChecked_v);
    setappdata(gcbf, 'isAllChecked_h', isAllChecked_h);
    setappdata(gcbf, 'transversalMontage', transversalMontage);
    guidata(gcbf,data);
end
function selectAll_h(obj, event)
    % Get figure handles
    data=guidata(gcbf);
    fileName = getappdata(gcbf,'fileName');
    fileData = getappdata(gcbf,'fileData');
    data.ch = getappdata(gcf,'ch');
    path = getappdata(gcbf,'path');
    nrElectrodeLeft = getappdata(gcbf,'nrElectrodeLeft');
    nrElectrodeRight = getappdata(gcbf,'nrElectrodeRight');
    
    %part of the code that activates the check_spikes function
    isAllChecked_v = getappdata(gcbf, 'isAllChecked_v');
    isAllChecked_h = getappdata(gcbf, 'isAllChecked_h');
    transversalMontage = getappdata(gcbf,'transervalMontage');
    
    selectV = get(obj,'Value');
    
    if isa(fileName,'double') % If there is no file selected
        errordlg('Please choose a file','File Error');
        set(data.ch, 'value', 0);
        set(obj, 'value', 0);
    else
        if selectV == 0
            
            isAllChecked_v = 0; %Check_spikes will not be used
            isAllChecked_h = 0;%Check_spikes_horizontal will not be used
            transversalMontage = 0;%Check_spikes_transversal will not be used
            
            set(data.ch, 'value', 0);

            nrElectrodeLeft=cell2mat(nrElectrodeLeft);
            nrElectrodeLeft = [];
            nrElectrodeRight=cell2mat(nrElectrodeRight);
            nrElectrodeRight = [];

            disp(size(nrElectrodeLeft));
            disp(size(nrElectrodeRight));


        end
        if selectV == 1
            
            isAllChecked_v = 0; %Check_spikes will not be used
            isAllChecked_h = 0;%Check_spikes_horizontal will not be used
            transversalMontage = 1;%Check_spikes_transversal will be used
            
            set(data.ch(1:22), 'value', 0);
            set(data.ch(23:42), 'value', 1); %channels in bipolar transversal montage
            channel = zeros(40,7);
           
            channel(1,:) = Get_Channel(path,fileName,'Fp1',fileData) ;
            if (channel(1,:) == 0)
                channel(1,:) = Get_Channel(path,fileName,'Fp1',fileData);
            end
            channel(2,:) = Get_Channel(path,fileName,'Fp2',fileData) ;
            channel(3,:) = [Get_Channel(path,fileName,'F9',fileData) ' '];
            if (channel(3,:) == 0)
                channel(3,:) = [Get_Channel(path,fileName,'F9',fileData) ' '];
            end
            channel(4,:) = [Get_Channel(path,fileName,'F7',fileData) ' '];
            channel(5,:) = [Get_Channel(path,fileName,'F7',fileData) ' '];
            channel(6,:) = [Get_Channel(path,fileName,'F3',fileData) ' '];
            channel(7,:) = [Get_Channel(path,fileName,'F3',fileData) ' '];
            channel(8,:) = [Get_Channel(path,fileName,'Fz',fileData) ' '];
            channel(9,:) = [Get_Channel(path,fileName,'Fz',fileData) ' '];
            channel(10,:) = [Get_Channel(path,fileName,'F4',fileData) ' '];
            channel(11,:) = [Get_Channel(path,fileName,'F4',fileData) ' '];
            channel(12,:) = [Get_Channel(path,fileName,'F8',fileData) ' '];
            channel(13,:) = [Get_Channel(path,fileName,'F8',fileData) ' '];
            channel(14,:) = Get_Channel(path,fileName,'F10',fileData);
            channel(15,:) = [Get_Channel(path,fileName,'T9',fileData) ' '];
            if (channel(15,:) == 0)
                channel(15,:) = [Get_Channel(path,fileName,'T9',fileData) ' '];
            end
            channel(16,:) = [Get_Channel(path,fileName,'T3',fileData) ' '];
            channel(17,:) = [Get_Channel(path,fileName,'T3',fileData) ' '];
            channel(18,:) = [Get_Channel(path,fileName,'C3',fileData) ' '];
            channel(19,:) = [Get_Channel(path,fileName,'C3',fileData) ' '];
            channel(20,:) = [Get_Channel(path,fileName,'Cz',fileData) ' '];
            channel(21,:) = [Get_Channel(path,fileName,'Cz',fileData) ' '];
            channel(22,:) = [Get_Channel(path,fileName,'C4',fileData) ' '];
            channel(23,:) = [Get_Channel(path,fileName,'C4',fileData) ' '];
            channel(24,:) = [Get_Channel(path,fileName,'T4',fileData) ' '];
            channel(25,:) = [Get_Channel(path,fileName,'T4',fileData) ' '];
            channel(26,:) = Get_Channel(path,fileName,'T10',fileData);
            channel(27,:) = [Get_Channel(path,fileName,'P9',fileData) ' '];
            if (channel(27,:) == 0)
                channel(27,:) = [Get_Channel(path,fileName,'P9',fileData) ' '];
            end
            channel(28,:) = [Get_Channel(path,fileName,'T5',fileData) ' '];
            channel(29,:) = [Get_Channel(path,fileName,'T5',fileData) ' '];
            channel(30,:) = [Get_Channel(path,fileName,'P3',fileData) ' '];
            channel(31,:) = [Get_Channel(path,fileName,'P3',fileData) ' '];
            channel(32,:) = [Get_Channel(path,fileName,'Pz',fileData) ' '];
            channel(33,:) = [Get_Channel(path,fileName,'Pz',fileData) ' '];
            channel(34,:) = [Get_Channel(path,fileName,'P4',fileData) ' '];
            channel(35,:) = [Get_Channel(path,fileName,'P4',fileData) ' '];
            channel(36,:) = [Get_Channel(path,fileName,'T6',fileData) ' '];
            channel(37,:) = [Get_Channel(path,fileName,'T6',fileData) ' '];
            channel(38,:) = Get_Channel(path,fileName,'P10',fileData);
            channel(39,:) = [Get_Channel(path,fileName,'O1',fileData) ' '];
            channel(40,:) = [Get_Channel(path,fileName,'O2',fileData) ' '];
            channel = char(channel);

            
            for i=1:40
                if i==1
                    nrElectrodeLeft{i} = char(channel(i,:));
                else
                    nrElectrodeLeft{end+1} = char(channel(i,:));
                end

            end

            for i=1:40 %List of nrElectrodeRight
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
    setappdata(gcbf, 'isAllChecked_v', isAllChecked_v);
    setappdata(gcbf, 'isAllChecked_h', isAllChecked_h);
    setappdata(gcbf, 'transversalMontage', transversalMontage);
    guidata(gcbf,data);
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
function getButton23(obj,event)
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
            if strcmp(Fct,'Fp1-Fp2') ==1
                channel1 = Get_Channel(path,fileName,'Fp1',fileData);
                channel9 = Get_Channel(path,fileName,'Fp2',fileData);
                nrElectrodeLeft{end+1} = [channel1 ' '];
                nrElectrodeLeft{end+2} = [channel9 ' '];
                nrElectrodeRight{end+1} = [channel9 ' '];
                nrElectrodeRight{end+2} = [channel1 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'Fp1-Fp2') ==1
                channel1 = Get_Channel(path,fileName,'Fp1',fileData);
                channel9 = Get_Channel(path,fileName,'Fp2',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel1 ' ']) && isequal(nrElectrodeRight{i}, [channel9 ' '])) || (isequal(nrElectrodeLeft{i}, [channel9 ' ']) && isequal(nrElectrodeRight{i}, [channel1 ' ']))
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

function getButton24(obj,event)
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
            if strcmp(Fct,'F9-F7') ==1
                channel37 = Get_Channel(path,fileName,'F9',fileData);
                channel18 = Get_Channel(path,fileName,'F7',fileData);
                nrElectrodeLeft{end+1} = [channel37 ' '];
                nrElectrodeLeft{end+2} = [channel18 ' '];
                nrElectrodeRight{end+1} = [channel18 ' '];
                nrElectrodeRight{end+2} = [channel37 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'F9-F7') ==1
                channel37 = Get_Channel(path,fileName,'F9',fileData);
                channel1 = Get_Channel(path,fileName,'F7',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel37 ' ']) && isequal(nrElectrodeRight{i}, [channel18 ' '])) || (isequal(nrElectrodeLeft{i}, [channe37 ' ']) && isequal(nrElectrodeRight{i}, [channel18 ' ']))
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
%% 
function getButton25(obj,event)
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
            if strcmp(Fct,'F7-F3') ==1
                channel18 = Get_Channel(path,fileName,'F7',fileData);
                channel3 = Get_Channel(path,fileName,'F3',fileData);
                nrElectrodeLeft{end+1} = [channel18 ' '];
                nrElectrodeLeft{end+2} = [channel3 ' '];
                nrElectrodeRight{end+1} = [channel3 ' '];
                nrElectrodeRight{end+2} = [channel18 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'F7-F3') ==1
                channel18 = Get_Channel(path,fileName,'F7',fileData);
                channel3 = Get_Channel(path,fileName,'F3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel18 ' ']) && isequal(nrElectrodeRight{i}, [channel3 ' '])) || (isequal(nrElectrodeLeft{i}, [channel3 ' ']) && isequal(nrElectrodeRight{i}, [channel18 ' ']))
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
%% 
function getButton26(obj,event)
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
            if strcmp(Fct,'F3-Fz') ==1
                channel3 = Get_Channel(path,fileName,'F3',fileData);
                channel33 = Get_Channel(path,fileName,'Fz',fileData);
                nrElectrodeLeft{end+1} = [channel3 ' '];
                nrElectrodeLeft{end+2} = [channel33 ' '];
                nrElectrodeRight{end+1} = [channel33 ' '];
                nrElectrodeRight{end+2} = [channel3 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'F3-Fz') ==1
                channel3 = Get_Channel(path,fileName,'F3',fileData);
                channel33 = Get_Channel(path,fileName,'Fz',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel3 ' ']) && isequal(nrElectrodeRight{i}, [channel33 ' '])) || (isequal(nrElectrodeLeft{i}, [channel33 ' ']) && isequal(nrElectrodeRight{i}, [channel3 ' ']))
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
%% 
function getButton27(obj,event)
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
            if strcmp(Fct,'Fz-F4') ==1
                channel33 = Get_Channel(path,fileName,'Fz',fileData);
                channel4 = Get_Channel(path,fileName,'F4',fileData);
                nrElectrodeLeft{end+1} = [channel33 ' '];
                nrElectrodeLeft{end+2} = [channel4 ' '];
                nrElectrodeRight{end+1} = [channel4 ' '];
                nrElectrodeRight{end+2} = [channel33 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'Fz-F4') ==1
                channel33 = Get_Channel(path,fileName,'Fz',fileData);
                channel4 = Get_Channel(path,fileName,'F4',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel33 ' ']) && isequal(nrElectrodeRight{i}, [channel4 ' '])) || (isequal(nrElectrodeLeft{i}, [channel4 ' ']) && isequal(nrElectrodeRight{i}, [channel33 ' ']))
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
%% 
function getButton28(obj,event)
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
            if strcmp(Fct,'F4-F8') ==1
                channel4 = Get_Channel(path,fileName,'F4',fileData);
                channel26 = Get_Channel(path,fileName,'F8',fileData);
                nrElectrodeLeft{end+1} = [channel4 ' '];
                nrElectrodeLeft{end+2} = [channel26 ' '];
                nrElectrodeRight{end+1} = [channel26 ' '];
                nrElectrodeRight{end+2} = [channel4 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'F4-F8') ==1
                channel4 = Get_Channel(path,fileName,'F4',fileData);
                channel26 = Get_Channel(path,fileName,'F8',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel4 ' ']) && isequal(nrElectrodeRight{i}, [channel26 ' '])) || (isequal(nrElectrodeLeft{i}, [channel26 ' ']) && isequal(nrElectrodeRight{i}, [channel4 ' ']))
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
%% 
function getButton29(obj,event)
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
            if strcmp(Fct,'F8-F10') ==1
                channel26 = Get_Channel(path,fileName,'F8',fileData);
                channel41 = Get_Channel(path,fileName,'F10',fileData);
                nrElectrodeLeft{end+1} = [channel26 ' '];
                nrElectrodeLeft{end+2} = [channel41 ' '];
                nrElectrodeRight{end+1} = [channel41 ' '];
                nrElectrodeRight{end+2} = [channel26 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'F8-F10') ==1
                channel26 = Get_Channel(path,fileName,'F8',fileData);
                channel41 = Get_Channel(path,fileName,'F10',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel26 ' ']) && isequal(nrElectrodeRight{i}, [channel41 ' '])) || (isequal(nrElectrodeLeft{i}, [channel41 ' ']) && isequal(nrElectrodeRight{i}, [channel26 ' ']))
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
%% 
function getButton30(obj,event)
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
            if strcmp(Fct,'T9-T3') ==1
                channel57 = Get_Channel(path,fileName,'T9',fileData);
                channel58 = Get_Channel(path,fileName,'T3',fileData);
                nrElectrodeLeft{end+1} = [channel57 ' '];
                nrElectrodeLeft{end+2} = [channel58 ' '];
                nrElectrodeRight{end+1} = [channel58 ' '];
                nrElectrodeRight{end+2} = [channel57 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T9-T3') ==1
                channel57 = Get_Channel(path,fileName,'T9',fileData);
                channel58 = Get_Channel(path,fileName,'T3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel57 ' ']) && isequal(nrElectrodeRight{i}, [channel58 ' '])) || (isequal(nrElectrodeLeft{i}, [channel58 ' ']) && isequal(nrElectrodeRight{i}, [channel57 ' ']))
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

%% 
function getButton31(obj,event)
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
            if strcmp(Fct,'T3-C3') ==1
                channel59 = Get_Channel(path,fileName,'T3',fileData);
                channel60 = Get_Channel(path,fileName,'C3',fileData);
                nrElectrodeLeft{end+1} = [channel59 ' '];
                nrElectrodeLeft{end+2} = [channel60 ' '];
                nrElectrodeRight{end+1} = [channel60 ' '];
                nrElectrodeRight{end+2} = [channel59 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T3-C3') ==1
                channel59 = Get_Channel(path,fileName,'T3',fileData);
                channel60 = Get_Channel(path,fileName,'C3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel59 ' ']) && isequal(nrElectrodeRight{i}, [channel60 ' '])) || (isequal(nrElectrodeLeft{i}, [channel60 ' ']) && isequal(nrElectrodeRight{i}, [channel59 ' ']))
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
%% 
function getButton32(obj,event)
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
            if strcmp(Fct,'C3-Cz') ==1
                channel61 = Get_Channel(path,fileName,'T3',fileData);
                channel62 = Get_Channel(path,fileName,'C3',fileData);
                nrElectrodeLeft{end+1} = [channel61 ' '];
                nrElectrodeLeft{end+2} = [channel62 ' '];
                nrElectrodeRight{end+1} = [channel62 ' '];
                nrElectrodeRight{end+2} = [channel61 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'C3-Cz') ==1
                channel61 = Get_Channel(path,fileName,'C3',fileData);
                channel62 = Get_Channel(path,fileName,'Cz',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel61 ' ']) && isequal(nrElectrodeRight{i}, [channel62 ' '])) || (isequal(nrElectrodeLeft{i}, [channel62 ' ']) && isequal(nrElectrodeRight{i}, [channel61 ' ']))
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
%% 
function getButton33(obj,event)
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
            if strcmp(Fct,'Cz-C4') ==1
                channel63 = Get_Channel(path,fileName,'Cz',fileData);
                channel64 = Get_Channel(path,fileName,'C4',fileData);
                nrElectrodeLeft{end+1} = [channel63 ' '];
                nrElectrodeLeft{end+2} = [channel64 ' '];
                nrElectrodeRight{end+1} = [channel64 ' '];
                nrElectrodeRight{end+2} = [channel63 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'Cz-C4') ==1
                channel63 = Get_Channel(path,fileName,'C3',fileData);
                channel64 = Get_Channel(path,fileName,'Cz',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel63 ' ']) && isequal(nrElectrodeRight{i}, [channel64 ' '])) || (isequal(nrElectrodeLeft{i}, [channel64 ' ']) && isequal(nrElectrodeRight{i}, [channel63 ' ']))
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

%% 
function getButton34(obj,event)
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
            if strcmp(Fct,'C4-T4') ==1
                channel65 = Get_Channel(path,fileName,'C4',fileData);
                channel66 = Get_Channel(path,fileName,'T4',fileData);
                nrElectrodeLeft{end+1} = [channel65 ' '];
                nrElectrodeLeft{end+2} = [channel66 ' '];
                nrElectrodeRight{end+1} = [channel66 ' '];
                nrElectrodeRight{end+2} = [channel65 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'C4-T4') ==1
                channel65 = Get_Channel(path,fileName,'C4',fileData);
                channel66 = Get_Channel(path,fileName,'T4',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel65 ' ']) && isequal(nrElectrodeRight{i}, [channel66 ' '])) || (isequal(nrElectrodeLeft{i}, [channel66 ' ']) && isequal(nrElectrodeRight{i}, [channel65 ' ']))
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

%% 
function getButton35(obj,event)
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
            if strcmp(Fct,'T4-T10') ==1
                channel67 = Get_Channel(path,fileName,'T4',fileData);
                channel68 = Get_Channel(path,fileName,'T10',fileData);
                nrElectrodeLeft{end+1} = [channel67 ' '];
                nrElectrodeLeft{end+2} = [channel68 ' '];
                nrElectrodeRight{end+1} = [channel68 ' '];
                nrElectrodeRight{end+2} = [channel67 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T4-T10') ==1
                channel67 = Get_Channel(path,fileName,'T4',fileData);
                channel68 = Get_Channel(path,fileName,'T10',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel67 ' ']) && isequal(nrElectrodeRight{i}, [channel68 ' '])) || (isequal(nrElectrodeLeft{i}, [channel68 ' ']) && isequal(nrElectrodeRight{i}, [channel67 ' ']))
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
%% 
function getButton36(obj,event)
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
            if strcmp(Fct,'P9-T5') ==1
                channel71 = Get_Channel(path,fileName,'P9',fileData);
                channel72 = Get_Channel(path,fileName,'T5',fileData);
                nrElectrodeLeft{end+1} = [channel71 ' '];
                nrElectrodeLeft{end+2} = [channel72 ' '];
                nrElectrodeRight{end+1} = [channel72 ' '];
                nrElectrodeRight{end+2} = [channel71 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'P9-T5') ==1
                channel71 = Get_Channel(path,fileName,'P9',fileData);
                channel72 = Get_Channel(path,fileName,'T5',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel71 ' ']) && isequal(nrElectrodeRight{i}, [channel72 ' '])) || (isequal(nrElectrodeLeft{i}, [channel72 ' ']) && isequal(nrElectrodeRight{i}, [channel71 ' ']))
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

%% 

function getButton37(obj,event)
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
            if strcmp(Fct,'T5-P3') ==1
                channel73 = Get_Channel(path,fileName,'T5',fileData);
                channel74 = Get_Channel(path,fileName,'P3',fileData);
                nrElectrodeLeft{end+1} = [channel73 ' '];
                nrElectrodeLeft{end+2} = [channel74 ' '];
                nrElectrodeRight{end+1} = [channel74 ' '];
                nrElectrodeRight{end+2} = [channel73 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T5-P3') ==1
                channel73 = Get_Channel(path,fileName,'T5',fileData);
                channel74 = Get_Channel(path,fileName,'P3',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel73 ' ']) && isequal(nrElectrodeRight{i}, [channel74 ' '])) || (isequal(nrElectrodeLeft{i}, [channel74 ' ']) && isequal(nrElectrodeRight{i}, [channel73 ' ']))
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
%% 
function getButton38(obj,event)
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
            if strcmp(Fct,'P3-Pz') ==1
                channel75 = Get_Channel(path,fileName,'P3',fileData);
                channel76 = Get_Channel(path,fileName,'Pz',fileData);
                nrElectrodeLeft{end+1} = [channel75 ' '];
                nrElectrodeLeft{end+2} = [channel76 ' '];
                nrElectrodeRight{end+1} = [channel76 ' '];
                nrElectrodeRight{end+2} = [channel75 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'P3-Pz') ==1
                channel75 = Get_Channel(path,fileName,'P3',fileData);
                channel76 = Get_Channel(path,fileName,'Pz',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel75 ' ']) && isequal(nrElectrodeRight{i}, [channel76 ' '])) || (isequal(nrElectrodeLeft{i}, [channel76 ' ']) && isequal(nrElectrodeRight{i}, [channel75 ' ']))
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
%% 
function getButton39(obj,event)
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
            if strcmp(Fct,'Pz-P4') ==1
                channel77 = Get_Channel(path,fileName,'Pz',fileData);
                channel78 = Get_Channel(path,fileName,'P4',fileData);
                nrElectrodeLeft{end+1} = [channel77 ' '];
                nrElectrodeLeft{end+2} = [channel78 ' '];
                nrElectrodeRight{end+1} = [channel78 ' '];
                nrElectrodeRight{end+2} = [channel77 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'Pz-P4') ==1
                channel77 = Get_Channel(path,fileName,'Pz',fileData);
                channel78 = Get_Channel(path,fileName,'P4',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel77 ' ']) && isequal(nrElectrodeRight{i}, [channel78 ' '])) || (isequal(nrElectrodeLeft{i}, [channel78 ' ']) && isequal(nrElectrodeRight{i}, [channel77 ' ']))
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
%% 
function getButton40(obj,event)
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
            if strcmp(Fct,'P4-T6') ==1
                channel79 = Get_Channel(path,fileName,'P4',fileData);
                channel80 = Get_Channel(path,fileName,'T6',fileData);
                nrElectrodeLeft{end+1} = [channel79 ' '];
                nrElectrodeLeft{end+2} = [channel80 ' '];
                nrElectrodeRight{end+1} = [channel80 ' '];
                nrElectrodeRight{end+2} = [channel79 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'P4-T6') ==1
                channel79 = Get_Channel(path,fileName,'P4',fileData);
                channel80 = Get_Channel(path,fileName,'T6',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel79 ' ']) && isequal(nrElectrodeRight{i}, [channel80 ' '])) || (isequal(nrElectrodeLeft{i}, [channel80 ' ']) && isequal(nrElectrodeRight{i}, [channel79 ' ']))
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

%% 
function getButton41(obj,event)
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
            if strcmp(Fct,'T6-P10') ==1
                channel81 = Get_Channel(path,fileName,'T6',fileData);
                channel82 = Get_Channel(path,fileName,'P10',fileData);
                nrElectrodeLeft{end+1} = [channel81 ' '];
                nrElectrodeLeft{end+2} = [channel82 ' '];
                nrElectrodeRight{end+1} = [channel82 ' '];
                nrElectrodeRight{end+2} = [channel81 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'T6-P10') ==1
                channel81 = Get_Channel(path,fileName,'T6',fileData);
                channel82 = Get_Channel(path,fileName,'P10',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel81 ' ']) && isequal(nrElectrodeRight{i}, [channel82 ' '])) || (isequal(nrElectrodeLeft{i}, [channel82 ' ']) && isequal(nrElectrodeRight{i}, [channel81 ' ']))
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

%% 
function getButton42(obj,event)
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
            if strcmp(Fct,'O1-O2') ==1
                channel86 = Get_Channel(path,fileName,'O1',fileData);
                channel85 = Get_Channel(path,fileName,'O2',fileData);
                nrElectrodeLeft{end+1} = [channel86 ' '];
                nrElectrodeLeft{end+2} = [channel85 ' '];
                nrElectrodeRight{end+1} = [channel85 ' '];
                nrElectrodeRight{end+2} = [channel86 ' '];
                nrElectrodeLeft = nrElectrodeLeft(~cellfun(@isempty,nrElectrodeLeft));
                nrElectrodeRight = nrElectrodeRight(~cellfun(@isempty,nrElectrodeRight));
            end
        end
        %%  When the button is unchecked
        if value == 0
           if strcmp(Fct,'O1-O2') ==1
                channel86 = Get_Channel(path,fileName,'O1',fileData);
                channel85 = Get_Channel(path,fileName,'O2',fileData);
                for i=1:length(nrElectrodeLeft)
                    if (isequal(nrElectrodeLeft{i}, [channel86 ' ']) && isequal(nrElectrodeRight{i}, [channel85 ' '])) || (isequal(nrElectrodeLeft{i}, [channel85 ' ']) && isequal(nrElectrodeRight{i}, [channel86 ' ']))
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
    isAllChecked_v = getappdata(gcbf, 'isAllChecked_v');
    isAllChecked_h = getappdata(gcbf, 'isAllChecked_h');
    transversalMontage = getappdata(gcbf,'transversalMontage');
    close(gcf);

    changeSettings = 0; % = false, don't want to change settings and experts
    Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings, isAllChecked_v,isAllChecked_h,transversalMontage);
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
    isAllChecked_v = getappdata(gcbf, 'isAllChecked_v');
    isAllChecked_h = getappdata(gcbf, 'isAllChecked_h');
    transversalMontage = getappdata(gcbf,'transversalMontage');
    close(gcf);
    changeSettings = 1; % = true, we want to change settings and experts
    Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings, isAllChecked_v,isAllChecked_h,transversalMontage);
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
    isAllChecked_v = getappdata(gcbf, 'isAllChecked_v');
    isAllChecked_h = getappdata(gcbf, 'isAllChecked_h');
    transversalMontage = getappdata(gcbf,'transversalMontage');
    close(gcf);
    changeSettings = changeChar; % equals 0, no need to change settings
    Main(path,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current,changeSettings, isAllChecked_v,isAllChecked_h,transversalMontage);

end
