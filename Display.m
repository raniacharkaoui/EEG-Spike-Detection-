 %This function displays the EEGs signals for each derivation


function [] = Display(File,Solo_algo_timeIn,Solo_algo_timeOut,Solo_Exp_timeIn,Solo_Exp_timeOut,Same_spikes_timeIn,Same_spikes_timeOut,Alpha_timeIn, Alpha_timeOut)
 
 %%%color code:
 % only the algo  : red
 % expert+algo : green
 % Only the expert: blue
 
fileName = File.Name;
Recording = File.Recordings;
DetectionParameters = File.DetectionParameters;
path = Recording.path;
fileData = struct([]);
if endsWith(fileName,'.mat')
    fileData = load([path '/' fileName]);
end 

indexPlan = 1 ;
indexDerivation = 1 ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Retrieve number of EEG derivations (channels)
NumDerivation = length(Recording.nrElectrodeLeft(:,1)); 

% Store channel names in arrays
electrodeLeft=Recording.nrElectrodeLeft(:,:);
electrodeRight=Recording.nrElectrodeRight(:,:);


%Set figure to full screen
f = figure;

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
set(gcf,'NumberTitle','off') %don't show the figure number
set(gcf,'Name',['Display for ' fileName])
m1 = uimenu(f,'Label','Display ...');
handles.mitem = uimenu(m1,'Label','spikes from algo only','Checked','on','Callback',@algo);
        uimenu(m1,'Label','spikes from experts only','Checked','on','Callback',@exp);
        uimenu(m1,'Label','spikes from algo and experts','Checked','on','Callback',@algoAndExp);
        uimenu(m1,'Label','Alpha Waves','Checked','on','Callback',@alpha_waves);

m2 = uimenu(f,'Label','Timescale');
handles.timescale1 = uimenu(m2,'Label','Whole recording','Callback',@timescaleWholeRecord);
handles.timescale2 = uimenu(m2,'Label','10 sec/page','Callback',@timescaleTenSecPage);
        
    function timescaleWholeRecord(~,~)
        xlim([Recording.timeIn(1) Recording.timeOut(length(Recording.timeOut))]);
    end
    function timescaleTenSecPage(~,~)
        XTarget = get(ax(1),'cameratarget');
        xlim([XTarget(1)-5 XTarget(1)+5]);
    end   

% Graph colors
CM = jet(NumDerivation);  % jet is a colormap


for Derivation=1:2:NumDerivation-1 %Loop that increments for each derivation

    nrElectrodeLeft = deblank(Recording.nrElectrodeLeft(Derivation,:));
    nrElectrodeRight = deblank(Recording.nrElectrodeRight(Derivation,:));
    
    %Data to plot
    data = [];
    dataTot = GetData(Recording.timeIn(1),Recording.timeOut(length(Recording.timeOut)),nrElectrodeRight,nrElectrodeLeft,Recording.fname,DetectionParameters,fileData);
    interval = length(dataTot);
    time = linspace(Recording.timeIn(1),Recording.timeOut(length(Recording.timeOut)),interval); %In seconds
    hold on;
    
    if length(Recording.timeIn)>1
        for k=1:length(Recording.timeIn)
            [raw_data] = GetData(Recording.timeIn(k),Recording.timeOut(k),nrElectrodeRight,nrElectrodeLeft,Recording.fname,DetectionParameters,fileData); %Read EEG data
            if k > 1
                a = find(time>=Recording.timeOut(k-1) & time<=Recording.timeIn(k));
                diff = GetData(time(a(1)+1),time(a(end)),nrElectrodeRight,nrElectrodeLeft,Recording.fname,DetectionParameters,fileData);
                z = zeros(length(diff),1); 
                if (length(data)+length(z)+length(raw_data))~=length(dataTot(1:find(raw_data(end))))
                    z2 = length(dataTot(1:find(raw_data(end)))) - (length(data)+length(z)+length(raw_data));
                    z = z + z2 ;
                end
                data = [data;z;raw_data];
            else
                data = [data;raw_data];
            end
        end
    else
        data = dataTot;
    end


    %Plot data for odd derivation because of the double polarity 
    y(Derivation,:) = data';
    if mod(Derivation,2)~=0
        if Derivation == 1
            ax(Derivation) = subplottight(NumDerivation/2,1,Derivation);
        else
            ax(Derivation-indexPlan) = subplottight(NumDerivation/2,1,Derivation-indexPlan);
            indexPlan = indexPlan+1 ;
        end
         plot(time,y(Derivation,:), 'color',CM(Derivation,:))
         set(gca,'color',[0.7 0.7 0.7]); %change the backgroung color in grey to better see the signals
         ylim([-200 200]);
         xlim([Recording.timeIn(1) Recording.timeOut(length(Recording.timeOut))]);
    end

    %Channel labels
    if mod(Derivation,2)~=0
        channel_label = [num2str(electrodeLeft(Derivation,:)), '- ' , num2str(electrodeRight(Derivation,:)),'    '];
        ylab = ylabel(erase(channel_label,'EEG '));
        set(get(gca,'YLabel'),'Rotation',0);
        set(ylab, 'fontsize',8); 
    end

    %Show spikes

    %Spikes from Expert
    for k=1:length(Recording.timeIn)
        if Solo_Exp_timeOut==0 
            handles.patchExp = findobj(gcf,'Tag','patchExp');
        else
            for n=1:length(Solo_Exp_timeOut)
               if(Solo_Exp_timeOut(n)< Recording.timeOut(k) && Solo_Exp_timeIn(n)> Recording.timeIn(k) ) % Only keeps the scores in the interval of time
                   ti1=Solo_Exp_timeIn(n);
                   to1=Solo_Exp_timeOut(n);
                   patch([ti1 to1 to1 ti1],[1000 1000 -1000 -1000],'b','facealpha',.2,'Tag','patchExp');
                   handles.patchExp = findobj(gcf,'Tag','patchExp');
               end
            end
        end
    end

    %Spikes from algo
    x0 = find(~Solo_algo_timeOut);
    x1 = find(Solo_algo_timeOut);

      for n=1:length(x0)
         if length(x0) > 1
             if indexDerivation == n
                 if indexDerivation==1 && x0(n) > 1
                    for i=1:x1(x0(n)-1)
                        ti2=Solo_algo_timeIn(i);
                        to2=Solo_algo_timeOut(i);
                        patch([ti2 to2 to2 ti2],[1000 1000 -1000 -1000],'r','facealpha',.2,'Tag','patchAlgo');
                    end
                 elseif indexDerivation>1
                     x1In = x0(n-1)+1;
                     x1Out = x0(n)-1;
                     if x0(n)-x0(n-1) > 1
                         for i=x1In:x1Out
                            ti2=Solo_algo_timeIn(i);
                            to2=Solo_algo_timeOut(i);
                            patch([ti2 to2 to2 ti2],[1000 1000 -1000 -1000],'r','facealpha',.2,'Tag','patchAlgo');
                         end
                     end
                 end
             end
         else
             for i=1:length(x1)
                ti2=Solo_algo_timeIn(i);
                to2=Solo_algo_timeOut(i);
                patch([ti2 to2 to2 ti2],[1000 1000 -1000 -1000],'r','facealpha',.2,'Tag','patchAlgo');
            end
         end
         handles.patchAlgo = findobj(gcf,'Tag','patchAlgo');
     end


    %Spikes from algo and expert

    if length(Same_spikes_timeIn)==1
        handles.patchAlgoExp = findobj(gcf,'Tag','patchAlgoExp');
    else
        v0 = find(Same_spikes_timeIn==0);
        v1 = find(Same_spikes_timeIn>0);

         for n=1:length(v0)
             if length(v0)>1
                 if indexDerivation == n && length(Same_spikes_timeIn)>1
                     if indexDerivation==1 && v0(n) > 1
                         Same_spikes_timeIn1 = unique(Same_spikes_timeIn(1:v1(v0(n)-1)),'stable');
                         Same_spikes_timeOut1 = unique(Same_spikes_timeOut(1:v1(v0(n)-1)),'stable');
                        for i=1:length(Same_spikes_timeOut1)
                            ti3=Same_spikes_timeIn1(i);
                            to3=Same_spikes_timeOut1(i);
                            patch([ti3 to3 to3 ti3],[1000 1000 -1000 -1000],'g','facealpha',.2,'Tag','patchAlgoExp');
                        end
                     elseif indexDerivation>1
                         v1In = v0(n-1)+1;
                         v1Out = v0(n)-1;
                         if v0(n)-v0(n-1) > 1
                             Same_spikes_timeIn1 = unique(Same_spikes_timeIn(v1In:v1Out),'stable');
                             Same_spikes_timeOut1 = unique(Same_spikes_timeOut(v1In:v1Out),'stable');
                             for i=1:length(Same_spikes_timeOut1)
                                ti3=Same_spikes_timeIn1(i);
                                to3=Same_spikes_timeOut1(i);
                                patch([ti3 to3 to3 ti3],[1000 1000 -1000 -1000],'g','facealpha',.2,'Tag','patchAlgoExp');
                             end
                         end
                     end
                 end
             else
                 for i=1:length(v1)
                    ti3=Same_spikes_timeIn(i);
                    to3=Same_spikes_timeOut(i);
                    patch([ti3 to3 to3 ti3],[1000 1000 -1000 -1000],'g','facealpha',.2,'Tag','patchAlgoExp');
                 end
             end
         end
         handles.patchAlgoExp = findobj(gcf,'Tag','patchAlgoExp');
    end

    %Alpha waves
    y0 = find(~Alpha_timeOut);
    y1 = find(Alpha_timeOut);

     for n=1:length(y0)
         if indexDerivation == n
             if indexDerivation==1 && y0(n+1)-y0(n) > 1 && y0(n) > 1
                for i=1:y1(y0(n)-1)
                    ti4=Alpha_timeIn(i);
                    to4=Alpha_timeOut(i);
                    patch([ti4 to4 to4 ti4],[1000 1000 -1000 -1000],'y','facealpha',.2,'Tag','patchAlpha');
                end
             elseif indexDerivation>1
                 y1In = y0(n-1)+1;
                 y1Out = y0(n)-1;
                 if y1Out-y1In > 1
                     for i=y1In:y1Out
                        ti4=Alpha_timeIn(i);
                        to4=Alpha_timeOut(i);
                        patch([ti4 to4 to4 ti4],[1000 1000 -1000 -1000],'y','facealpha',.2,'Tag','patchAlpha');
                     end
                 end
             end
             handles.patchAlpha = findobj(gcf,'Tag','patchAlpha');
         end
     end
    
    
    
    
    
    %Plot only bottom x axis and label
    if Derivation < NumDerivation && mod(Derivation,2)==0
        set(gca,'XTick',[]);
    elseif Derivation == NumDerivation-1
        xlabel('Time(s)')
    end
    indexDerivation = indexDerivation+1;
end


%Link axes of all subplots
%First, store axes in "link" array
%Then use 'linkaxes' and "link" to link all the subplot axes together
for j=1:NumDerivation/2
    link(j)=ax(j);
end
linkaxes(link)

 % to hide the title
 set(gcf,'NumberTitle','off');
 guidata(f,handles);
end

%Allow to display or not spikes from algo (red)
function algo(obj,~)
    handles = guidata(gcf);
    if strcmp(obj.Checked,'on')
            obj.Checked = 'off';
            set(handles.patchAlgo,'visible','off');
    else
        obj.Checked = 'on';
        set(handles.patchAlgo,'visible','on');
    end
end

%Allow to display or not alpha waves (yellow)
function alpha_waves(obj,~)
    handles = guidata(gcf);
    if strcmp(obj.Checked,'on')
            obj.Checked = 'off';
            set(handles.patchAlpha,'visible','off');
    else
        obj.Checked = 'on';
        set(handles.patchAlpha,'visible','on');
    end
end

%Allow to display or not spikes from expert (blue)
function exp(obj,~)
    handles = guidata(gcf);
    if strcmp(obj.Checked,'on')
            obj.Checked = 'off';
            set(handles.patchExp,'visible','off');
    else
        obj.Checked = 'on';
        set(handles.patchExp,'visible','on');
    end
end

%Allow to display or not spikes from algo and expert (green)
function algoAndExp(obj,~)
    handles = guidata(gcf);
    if strcmp(obj.Checked,'on')
            obj.Checked = 'off';
            set(handles.patchAlgoExp,'visible','off');
    else
        obj.Checked = 'on';
        set(handles.patchAlgoExp,'visible','on');
    end
end
    
function h = subplottight(n,m,i) %n : numDerivation, m = 1, i: Derivation
    n = n+1.5 ;
    [c,r] = ind2sub([m n], i);
    ax = subplot('Position', [(c-1)/m+0.07, 1-(r)/n-0.005, 1/m-0.07, 1/n]);
    if(nargout > 0)
      h = ax;
    end
end