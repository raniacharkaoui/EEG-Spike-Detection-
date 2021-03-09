function AlphaWaveDetection(file,CurrentRecording)
%close all
% This function detects the alpha waves on each derivation and each
% patient selected by the user
% Author : Kevin Nzeyimana (kevin.nzeyimana@re seau.eseo.fr)

threshold = 18; % arbitrary threshold 

Recordings  = file(CurrentRecording).Recordings;
DetectionParameters = file(CurrentRecording).DetectionParameters;
NumDerivation = length(Recordings.nrElectrodeLeft(:,:))/2; % Number of electrode derivations in EEG
path = file(CurrentRecording).Recordings.path;
fileName = file(CurrentRecording).Name;
msg = ['Alpha waves detection for ' fileName ' is launched ...'];
disp(msg);
fileData = struct([]);

if endsWith(file(CurrentRecording).Name,'.mat')
    fileData = load([path '\' fileName]);
end

%List of derivations
for i=1:length(Recordings.nrElectrodeLeft) % for all derivations
    if i == 1 % for the first derivation
        nrElectrodeLeft_list(i,:) = Recordings.nrElectrodeLeft(i,:);
        nrElectrodeRight_list(i,:) = Recordings.nrElectrodeRight(i,:);
    elseif mod(i,2) ~= 0 % when it's odd ( avoid duplicata of derivations )
        nrElectrodeLeft_list(end+1,:) = Recordings.nrElectrodeLeft(i,:);
        nrElectrodeRight_list(end+1,:) = Recordings.nrElectrodeRight(i,:);
    end
end


for Derivation=1:NumDerivation
    % creates an AlphaWaves structure in the file for each derivation
    file(CurrentRecording).AlphaWaves(Derivation).locs =[]; 
    file(CurrentRecording).AlphaWaves(Derivation).per_power = [];
    file(CurrentRecording).AlphaWaves(Derivation).DetectedTime = [];


    nrElectrodeLeft = deblank(nrElectrodeLeft_list(Derivation,:)); % string of the left electrone name
    nrElectrodeRight = deblank(nrElectrodeRight_list(Derivation,:)); % string of the right electrone name
    signal = [];
    for k=1:length(Recordings.timeIn) %if there are many time In and time Out
        [RawData] = GetData(Recordings.timeIn(k),Recordings.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Recordings.fname,DetectionParameters,fileData);
        signal = [signal;RawData];
        Fs = DetectionParameters.Fs; % sampling frequency ( 250 Hz)

        %% Signal subdivision in step of 'stepsize' 

        step = 0.8*Fs; % seconds per divison * sampling frequency, it is the window size = 200 samples
        overlap = floor(0.2*Fs); % duration of overlapping between two successive windows = 50 samples
        Nwin = floor(length(signal)/(step-overlap)); % number of windows
        sigdiv = zeros(step, Nwin); % matrice of window size X number of windows
        left = 1; % first sample
       

        %bandwidth of the alpha waves
        Fband_low = 8; % 8 Hz
        Fband_high = 12; % 12 Hz
        
        % To see the signal in a window
%         time = (0:length(signal)-1)/Fs;
%         figure
%         subplot(211)
%         plot(time,signal,'k')
%         xlabel('Time (s)')
%         ylabel('Signal')
%         xlim([time(1), time(end)])
%         
        pband = zeros(Nwin,1);
        ptot = zeros(Nwin,1);
        per_power = zeros(Nwin,1);
        Time = zeros(Nwin,1);
        for win = 1:Nwin % for each window
            right = left + step; % last sample of the window
            if right<=length(signal)
                sigdiv(:,win) = signal(left:right-1);
            else
                fin = (length(signal)-left)+1;
                sigdiv((1:fin),win) = signal(left:length(signal));
            end
            
            % TO see each window
%             tps = (0:length(sigdiv(:,win))-1)/Fs;
%             subplot(212)
%             plot(tps,sigdiv(:,win),'k')
%             ylim('auto')

            % BANDPOWER computation for each time interval

            pband(win,1) = bandpower(sigdiv(:,win),Fs,[Fband_low Fband_high]); % computes power of window "win" in the frequency 8-12Hz
            ptot(win,1) = bandpower(sigdiv(:,win),Fs,[0 Fs/2]); % computes power of window win in the frequency 0-125Hz
            per_power(win,1) = 100*(pband(win)/ptot(win)); % fraction of power for window win
            Time(win,1) = Recordings.timeIn(k) + (left/Fs); %in seconds
            Time(win,2) = Recordings.timeIn(k) + (right/Fs); %in seconds
            left_2 = left/Fs; % to have the beginning in seconds
            left = right - overlap; % first sample of the following window
        end 
        file(CurrentRecording).AlphaWaves(Derivation).locs = find(per_power>threshold); % position of the AlphaWaves ( when the power of the signal exceeds the threshold 
        file(CurrentRecording).AlphaWaves(Derivation).per_power = per_power(per_power>threshold); % Value of the power fraction
        % timings of the Alpha waves
        file(CurrentRecording).AlphaWaves(Derivation).DetectedTime(:,1) = Time(file(CurrentRecording).AlphaWaves(Derivation).locs,1);
        file(CurrentRecording).AlphaWaves(Derivation).DetectedTime(:,2) = Time(file(CurrentRecording).AlphaWaves(Derivation).locs,2);

    end
    file(CurrentRecording).AlphaWaves(Derivation).der_name = [nrElectrodeLeft ' - ' nrElectrodeRight]; % name of the derivation is stored
end
str = ['Alpha Waves Detection for ' fileName ' is finished.'];
disp(str);
save('Spikes.mat','file');

end