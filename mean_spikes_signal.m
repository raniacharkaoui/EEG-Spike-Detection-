function mean_spikes_signal()
load('Spikes.mat','file');
nrElectrodeLeft = file.Recordings.nrElectrodeLeft;
nrElectrodeRight = file.Recordings.nrElectrodeRight;

%List of electrodes
for i=1:length(file.PatientSpecificDetSpikes) 
    if i == 1
        nrElectrodeLeft_list(i,:) = nrElectrodeLeft(i,:);
        nrElectrodeRight_list(i,:) = nrElectrodeRight(i,:);
    elseif mod(i,2) ~= 0 % when it's odd
        nrElectrodeLeft_list(end+1,:) = nrElectrodeLeft(i,:);
        nrElectrodeRight_list(end+1,:) = nrElectrodeRight(i,:);
    end
end
%List of derivations
for i=1:length(nrElectrodeLeft_list)
    derivations(i,:) = [nrElectrodeLeft_list(i,:) ' - ' nrElectrodeRight_list(i,:)];
end
spikes(1).timeIn = [187.2;304.5;309.0;418.0;424.5;543.8;545.6;674.0;678.6;785.7;828.3];
spikes(1).timeOut = [187.6;305.0;309.5;418.5;425;544.2;546.1;674.4;678.82;786.2;828.7];
spikes(2).timeIn = [83.2;251.0;304.6;418.1;454.3;468.9;543.8;545.7;550.4;577.0;1118.3];
spikes(2).timeOut = [83.6;251.4;305.0;418.6;454.7;469.3;544.2;546.1;550.8;577.4;1118.7];
spikes(3).timeIn = [57.1;205.1;309.1;418.1;454.3;552.2;678.6;760.1;761.4;872.9;1013.1;1014.1];
spikes(3).timeOut = [57.5;205.5;309.5;418.5;454.7;552.6;679;760.5;761.8;873.3;1013.5;1014.5];
spikes(4).timeIn = [];
spikes(4).timeOut = [];
spikes(5).timeIn = [52.3;57.1;83.1;187.2;205.1;309.1;454.3;468.9;495.3;550.4;1013.0];
spikes(5).timeOut = [52.7;57.5;83.5;187.6;205.5;309.5;454.7;469.3;495.7;550.8;1013.4];
spikes(6).timeIn = [57.1;83.2;306.0;309.1;418.1;424.6;550.4;570.1;577.0;578.0;859.3;865.1];
spikes(6).timeOut = [57.5;83.6;306.4;309.5;418.4;425.0;550.8;570.5;577.4;578.4;859.7;865.5];
spikes(7).timeIn = [];
spikes(7).timeOut = [];
spikes(8).timeIn = [];
spikes(8).timeOut = [];
spikes(9).timeIn = [52.3;59.3;83.1;205.1;305.2;309.1;418.1;496;545.6;1023.6];
spikes(9).timeOut = [52.7;59.7;83.5;205.5;305.6;309.5;418.5;496.5;546.1;1024.0];
spikes(10).timeIn = [57.1;83.1;187.2;251;306.2;309.1;418.1;454.3;468.9;543.8;828.3];
spikes(10).timeOut = [57.5;83.5;187.6;251.4;306.6;309.5;418.5;454.7;469.3;544.2;828.7];
spikes(11).timeIn = [251.0;418.1;543.8;674.0;760.1];
spikes(11).timeOut = [251.4;418.5;544.2;674.4;760.5];
spikes(12).timeIn = [52.3;57.1;83.1;190.3;205.1;251;495.3;496;496.7;497.4;545.7];
spikes(12).timeOut = [52.7;57.5;83.5;190.7;205.5;251.4;495.7;496.4;497.1;497.8;546.1];
spikes(13).timeIn = [52.3;57.1;83.1;190.3;205.1;251;495.3;496;496.7;497.4;545.7];
spikes(13).timeOut = [52.7;57.5;83.5;190.7;205.5;251.4;495.7;496.4;497.1;497.8;546.1];
spikes(14).timeIn = [];
spikes(14).timeOut = [];
spikes(15).timeIn = [];
spikes(15).timeOut = [];
spikes(16).timeIn = [674.0;1024.3;1108.4];
spikes(16).timeOut = [674.4;1024.7;1108.8];
spikes(17).timeIn = [];
spikes(17).timeOut = [];

avg_vpp_spikes = [];
avg_amplitude_spikes = [];
avg_std_spikes = [];
std_signal = [];    
for Derivation = 1:17 
    nrElectrodeLeft = deblank(nrElectrodeLeft_list(Derivation,:));
    nrElectrodeRight = deblank(nrElectrodeRight_list(Derivation,:));
    for i=1:length(spikes(Derivation).timeIn)
        same_spikes_deriv(i,1) = spikes(Derivation).timeIn(i);
        same_spikes_deriv(i,2) = spikes(Derivation).timeOut(i);
    end
    [avg_vpp_spikes_deriv,avg_amplitude_spikes_deriv,avg_std_spikes_deriv,std_signal_deriv] = data_by_deriv(file,nrElectrodeLeft,nrElectrodeRight,same_spikes_deriv);
    avg_vpp_spikes = [avg_vpp_spikes;avg_vpp_spikes_deriv];
    avg_std_spikes = [avg_std_spikes;avg_std_spikes_deriv]; 
    avg_amplitude_spikes = [avg_amplitude_spikes;avg_amplitude_spikes_deriv]; 
    std_signal = [std_signal;std_signal_deriv];
end

R = corr2(std_signal,avg_vpp_spikes);
R2 = corr2(std_signal,avg_amplitude_spikes);
R3 = corr2(std_signal,avg_std_spikes);
figure;
subplot(2,2,1)
plot(std_signal,avg_vpp_spikes,'x');
title('avg_vpp spikes versus std_signal');
subplot(2,2,2)
plot(std_signal,avg_amplitude_spikes,'x');
title('avg_amplitude_spikes versus std_signal');
subplot(2,2,3)
plot(std_signal,avg_std_spikes,'x');
title('avg_std spikes versus std_signal');
end







