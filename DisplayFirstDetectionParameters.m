%This function is used in order to analyze each polarity of derivation for
%each patient for the first detection
%It only works for the whole recording and without the detection of artifacts
%Use breakpoints !
%Author : Emelyne Vignon
%Contact : emelyne.vignon@reseau.eseo.fr

function DisplayFirstDetectionParameters()

    load('Spikes.mat','file');

    for CurrentRecording = 1 : length(file)
        DetectionParameters = file(CurrentRecording).DetectionParameters;
        Recordings = file(CurrentRecording).Recordings;
        fileName = file(CurrentRecording).Name;
        path = file(CurrentRecording).Recordings.path;
        fileData = struct([]);
        if endsWith(file(CurrentRecording).Name,'.mat')
            fileData = load([path '\' fileName]);
        end
        NumDerivation = length(Recordings.nrElectrodeLeft(:,1));
        
        for Derivation = 1:NumDerivation  
            nrElectrodeLeft = deblank(Recordings.nrElectrodeLeft(Derivation,:));
            nrElectrodeRight = deblank(Recordings.nrElectrodeRight(Derivation,:));
            DetectedSpikes = file(CurrentRecording).PatientSpecificDetSpikes(Derivation).Det;
            ReferenceSpike = file(CurrentRecording).GenericSpike(Derivation) ; 
        

            %Set figure to full screen
            f = figure;
            set(f, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
            set(f,'NumberTitle','off') %don't show the figure number
            Channel = [nrElectrodeLeft '-' nrElectrodeRight];
            set(f,'Name',['Display for ' Recordings.fname ' : Derivation ' Channel])
            uicontrol(f,'Units', 'Normalized',...
                'style','text',...
                'string',['Derivation : ' Channel],...
                'Position',[0.05 0.93 0.2 0.05],...
                'FontSize',11,...
                'FontWeight','bold');

            index=1;
            DetectedSpikesExp = ExpFeatures(file(CurrentRecording),Recordings,DetectionParameters,nrElectrodeLeft,nrElectrodeRight,fileData);
            GenericCrossCorrelation = DetectionParameters.GenericCrossCorrelationThresh;
            data = [];

            %Data to plot
            for k=1:length(Recordings.timeIn)
                [raw_data] = GetData(Recordings.timeIn(k),Recordings.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Recordings.fname,DetectionParameters,fileData); %Read EEG data
                data = [data;raw_data];
            end
            interval = length(data);
            time = linspace(Recordings.timeIn(1),Recordings.timeOut(length(Recordings.timeOut)),interval); %In seconds
            [ProcessedData] = PreProcessing(data,DetectionParameters); 
            VprodScNorm = normxcorr2(ReferenceSpike.Template,ProcessedData);
            VprodScNorm = VprodScNorm(ReferenceSpike.TemplateLength:end);

            %Display of Raw Data
            rawDataPlot = subplot(5,3,[1,2,3]); plot(time,data');title('Raw Data');
            DisplayPatch(800);
            ylim([-800 800]);
            xlim([Recordings.timeIn(1) Recordings.timeOut(length(Recordings.timeOut))]);
            grid on;

            %Display of Correlation
            correlationPlot = subplot(5,3,[4,5,6]);plot(time,VprodScNorm);title('Correlation');
            hline = refline([0 GenericCrossCorrelation]);
            hline.Color = 'r';
            DisplayPatch(2);
            ylim([-1 1]);
            xlim([Recordings.timeIn(1) Recordings.timeOut(length(Recordings.timeOut))]);
            grid on;

            %Display of Processed Data
            processedDataPlot = subplot(5,3,[7,8,9]);plot(time,ProcessedData);title('Processed Data');
            DisplayPatch(800);
            ylim([-800 800]);
            xlim([Recordings.timeIn(1) Recordings.timeOut(length(Recordings.timeOut))]);
            grid on;

            %Display features
            x1 = []; y1 = []; x2 = []; y2 = []; x3 = []; y3 = []; x4 = []; y4 = [];
            features = subplot(5,3,[10,11,12]);
            for i=1:length(DetectedSpikes.NoGoodFeatures.RisingSlope)
                y1(i) = DetectedSpikes.NoGoodFeatures.RisingSlope(i);
                y2(i) = DetectedSpikes.NoGoodFeatures.FallingSlope(i);
                x1(i) = time(DetectedSpikes.NoGoodFeatures.PositionRisingSlope(i));
                x2(i) = time(DetectedSpikes.NoGoodFeatures.PositionFallingSlope(i));
            end
            scatter(x1,y1,'.');
            hold on;
            scatter(x2,y2,'.');
            if ~isempty(DetectedSpikes.ProcessedSpikes)
                for i=1:length(DetectedSpikes.ProcessedSpikes(:,1))
                    y3(i) = DetectedSpikes.RisingSlope(i);
                    y4(i) = DetectedSpikes.FallingSlope(i);
                    x3(i) = time(DetectedSpikes.PositionRisingSlope(i));
                    x4(i) = time(DetectedSpikes.PositionFallingSlope(i));
                end
                scatter(x3,y3);
                scatter(x4,y4);
            end
            RisingSlopeThresholdRef = refline([0 ReferenceSpike.RisingSlopeThreshold]);
            RisingSlopeThresholdRef.Color = [0.9290 0.6940 0.1250];
            FallingSlopeThresholdRef = refline([0 ReferenceSpike.FallingSlopeThreshold]);
            FallingSlopeThresholdRef.Color = [0.4940 0.1840 0.5560];
            RisingSlopeThresholdMeanExp = refline([0 DetectedSpikesExp.RisingSlopeMean]);
            FallingSlopeThresholdMeanExp = refline([0 DetectedSpikesExp.FallingSlopeMean]);
            RisingSlopeThresholdMeanExp.Color = 'k';
            FallingSlopeThresholdMeanExp.Color = 'k';
            title('Features');
            % legend('Bad rising slope','Bad falling slope',...
            %     'Good rising slope','Good falling slope',...
            %     'RisingSlopeThresholdRef','FallingSlopeThresholdRef',...
            %     'Location','south',...
            %     'Orientation','horizontal');
            % legend('boxoff');
            hold off;
            DisplayPatch(25);
            xlim([Recordings.timeIn(1) Recordings.timeOut(length(Recordings.timeOut))]);
            ylim([-25 25]);
            xlabel('Time (s)');
            grid on;

            %Table with Good Features
            subplot(5,3,13);
            pos1=get(subplot(5,3,13),'Position'); un1=get(subplot(5,3,13),'Units');
            delete(subplot(5,3,13));
            t1 = uitable(f);
            set(t1, 'ColumnName',{'Spike detected','RisingSlope','FallingSlope','Curvature'});
            set(t1,'Tag','t1');
            set(t1,'Units', un1);
            set(t1, 'Position', pos1);
            uicontrol(f,'style','text','string','Table 1 : Good Features','Units', un1,'Position',[0.08 0 0.33 0.1],'FontWeight','bold');
            if ~isempty(DetectedSpikes.ProcessedSpikes)
                tab1 = cell(length(DetectedSpikes.ProcessedSpikes(:,1)),4);
                for spikes=1:length(DetectedSpikes.ProcessedSpikes(:,1))
                        tab1(index,:) = {DetectedSpikes.Epoch.DetectedTime(spikes,1)/1000,...
                            DetectedSpikes.RisingSlope(spikes),...
                            DetectedSpikes.FallingSlope(spikes),...
                            DetectedSpikes.Curvature(spikes)};
                        set(t1,'Data',tab1);
                        index=index+1;
                end
            else
                tab1 = {};
                set(t1,'Data',tab1);
            end

            %Table with experts features
            subplot(5,3,14);
            pos2=get(subplot(5,3,14),'Position'); un2=get(subplot(5,3,14),'Units');
            delete(subplot(5,3,14))
            t2 = uitable(f);
            set(t2, 'RowName', {'Amp CC min','Amp CC max','RisingSlopeMean','FallingSlopeMean','CurvatureMean'});
            set(t2,'Units', un2);
            set(t2, 'Position', pos2);
            uicontrol(f,'style','text','string','Table 2 : Experts Features','Units', un2,'Position',[0.36 0 0.33 0.1],'FontWeight','bold');
            tab2(:,1) = {DetectedSpikesExp.AmpCCMin,...
                DetectedSpikesExp.AmpCCMax,...
                DetectedSpikesExp.RisingSlopeMean,...
                DetectedSpikesExp.FallingSlopeMean,...
                DetectedSpikesExp.CurvatureMean};
            set(t2,'Data',tab2);

            %Table with Bad Features
            subplot(5,3,15);
            pos3=get(subplot(5,3,15),'Position'); un3=get(subplot(5,3,15),'Units');
            delete(subplot(5,3,15));
            t3 = uitable(f);
            set(t3, 'ColumnName',{'Spike detected','RisingSlope','FallingSlope','Curvature'});
            set(t3,'Units', un3);
            set(t3, 'Position', pos3);
            set(t3,'Tag','t2');
            uicontrol(f,'style','text','string','Table 3 : Bad Features','Units', un3,'Position',[0.64 0 0.33 0.1],'FontWeight','bold');
            tab3 = cell(length(DetectedSpikes.NoGoodFeatures.RisingSlope),4);
            index=1;
            for spikes=1:length(DetectedSpikes.NoGoodFeatures.RisingSlope)
                    tab3(index,:) = {DetectedSpikes.NoGoodFeatures.Epoch.DetectedTime(spikes,1)/1000,...
                        DetectedSpikes.NoGoodFeatures.RisingSlope(spikes),...
                        DetectedSpikes.NoGoodFeatures.FallingSlope(spikes),...
                        DetectedSpikes.NoGoodFeatures.Curvature(spikes)};
                    set(t3,'Data',tab3);
                    index=index+1;
            end
            t1.CellSelectionCallback = @UpdateDisplay;
            t3.CellSelectionCallback = @UpdateDisplay;
            xline1 = 0 ; xline2 = 0; xline3 = 0; xline4 = 0;
        end
    end
        %Allow to display the spikes detected by the algorithm and which respect the
        %good features
        function DisplayPatch(nb)
            if ~isempty(DetectedSpikes.Epoch.DetectedTime)
                for n=1:length(DetectedSpikes.Epoch.DetectedTime(:,1))
                   ti1=DetectedSpikes.Epoch.DetectedTime(n,1)/1000;
                   to1=DetectedSpikes.Epoch.DetectedTime(n,2)/1000;
                   p=patch([ti1 to1 to1 ti1],[nb nb -nb -nb],'g','facealpha',.2,'Tag','patchGoodFeatures');
                   p.Annotation.LegendInformation.IconDisplayStyle = 'off';
                end
            end
        end

        %Allow to zoom the plot when a spike is selected in a table
        function UpdateDisplay(obj,event)
            if xline1~=0 || xline2~=0 || xline3~=0 || xline4~=0
                delete(xline1);
                delete(xline2);
                delete(xline3);
                delete(xline4);
            end
            dataTable_row = event.Indices(1);
            if strcmp(obj.Tag,t1.Tag)==1
                timeIn = DetectedSpikes.Epoch.DetectedTime(dataTable_row,1)/1000;
            elseif strcmp(obj.Tag,t3.Tag)==1
                timeIn = DetectedSpikes.NoGoodFeatures.Epoch.DetectedTime(dataTable_row,1)/1000;
            end
            processedDataPlot.XLim = [timeIn-5 timeIn+5];
            rawDataPlot.XLim = [timeIn-5 timeIn+5];
            features.XLim = [timeIn-5 timeIn+5];
            correlationPlot.XLim = [timeIn-5 timeIn+5];
            xline1 = line(correlationPlot,[timeIn,timeIn],[-1,1],'LineWidth',2,'Color',[0.4660 0.6740 0.1880]);
            xline2 = line(rawDataPlot,[timeIn,timeIn],[-800,800],'LineWidth',2,'Color',[0.4660 0.6740 0.1880]);
            xline3 = line(processedDataPlot,[timeIn,timeIn],[-800,800],'LineWidth',2,'Color',[0.4660 0.6740 0.1880]);
            xline4 = line(features,[timeIn,timeIn],[-25,25],'LineWidth',2,'Color',[0.4660 0.6740 0.1880]);
            xline4.DisplayName = 'Time in selected';
            linkaxes([rawDataPlot,processedDataPlot,correlationPlot,features],'x');
        end
end