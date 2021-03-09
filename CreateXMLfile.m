%% Exports the detected spikes events to xml file
%%% Authors: Mathieu Biava, Ahmed Bader, 
%%% ULB      David Perez, Alain Zheng


function CreateXMLfile(CurrentRecording)
   disp('Creating XML file to export...');
   
   load('Spikes.mat','file');
   path = file(CurrentRecording).Recordings.path;
   fileName = file(CurrentRecording).Name;
   load([path fileName],'Data');
   isAllChecked = file(CurrentRecording).Recordings.isAllchecked; %determines if Check_spikes must intervene
   
    for event=1:length(Data.Events)
        if (Data.Events(event).Type==1 && Data.Events(event).Subtype==1)
            absTime = Data.Events(event).Time;
            break
        end
    end

    docNode = com.mathworks.xml.XMLUtils.createDocument('BrainRTResult');
    % Define XML structure suitable with BrainRT app
    
    BrainRTResult = docNode.getDocumentElement;
    ResultElements = docNode.createElement('ResultElements');
    BrainRTResult.appendChild(ResultElements);
    EventsResultElement = docNode.createElement('EventsResultElement');
    ResultElements.appendChild(EventsResultElement);
    UserDefinedEvents = docNode.createElement('UserDefinedEvents');
    EventsResultElement.appendChild(UserDefinedEvents);
    Events = docNode.createElement('Events');
    EventsResultElement.appendChild(Events);
    
    if isAllChecked == 1
        [algo_timeIn,algo_timeOut] = Check_spikes(1);
    else
        PatientSpecificDetSpikes = file(CurrentRecording).PatientSpecificDetSpikes;
        [algo_timeIn,algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes);
    end

     Channel=1;
     ChannelLeftLabel = num2str(file(CurrentRecording).Recordings.nrElectrodeLeft(Channel,:));
     LeftChannel = erase(ChannelLeftLabel,'EEG ') ;
     ChannelRightLabel = num2str(file(CurrentRecording).Recordings.nrElectrodeRight(Channel,:));
     RightChannel = erase(ChannelRightLabel,'EEG ') ;
    

     for j=1:length(algo_timeIn)
          if (algo_timeIn(j)==0)
              Channel = Channel + 2;
              if (Channel<=length(file(CurrentRecording).Recordings.nrElectrodeLeft))
                ChannelLeftLabel = num2str(file(CurrentRecording).Recordings.nrElectrodeLeft(Channel,:));
                LeftChannel = erase(ChannelLeftLabel,'EEG ') ;
                ChannelRightLabel = num2str(file(CurrentRecording).Recordings.nrElectrodeRight(Channel,:));
                RightChannel = erase(ChannelRightLabel,'EEG ') ;
              end
          else
             Event = docNode.createElement('Event');

             Type = docNode.createElement('Type');
             Type.appendChild(docNode.createTextNode('32768'));
             Event.appendChild(Type);

             SubType = docNode.createElement('SubType');
             SubType.appendChild(docNode.createTextNode('32790'));
             Event.appendChild(SubType);

             Validated = docNode.createElement('Validated');
             Validated.appendChild(docNode.createTextNode('false'));
             Event.appendChild(Validated);

             Start = docNode.createElement('Start');
             Start.appendChild(docNode.createTextNode(ApplyTimeFormat(absTime, algo_timeIn(j))));
             Event.appendChild(Start);

             End = docNode.createElement('End');
             End.appendChild(docNode.createTextNode(ApplyTimeFormat(absTime, algo_timeOut(j))));
             Event.appendChild(End);

             CH1 = docNode.createElement('CH1');
             CH1.appendChild(docNode.createTextNode(LeftChannel));
             Event.appendChild(CH1);

             CH2 = docNode.createElement('CH2');
             CH2.appendChild(docNode.createTextNode(RightChannel));
             Event.appendChild(CH2);

             Events.appendChild(Event);
          end
     end

    % write differences between 2 files
    
    folder = 'XMLData';
    if exist(folder) ~= 7 % if folder does not exist
        mkdir 'XMLData'
    end

    xmlwrite([folder '\' erase(fileName,'.mat') '.xml'],docNode);
    winopen([folder '\' erase(fileName,'.mat') '.xml']); %opens the file
    %type([folder '\' erase(fileName,'.mat') '.xml']); % show the file in cmd window
    disp(['Finished creating ' folder '\'  erase(fileName,'.mat') '.xml']);

end