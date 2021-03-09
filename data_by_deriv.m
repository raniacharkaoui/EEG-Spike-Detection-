function [avg_vpp_spikes,avg_amplitude_spikes,avg_std_spikes,std_signal] = data_by_deriv(file,nrElectrodeLeft,nrElectrodeRight,same_spikes_deriv)
% This function returns the average vpp, amplitude and standard deviation 
%of the spikes in the list same_spikes_deriv of one derivation. 
%It also returns the standard deviation of the derivation.
% Author : Kevin Nzeyimana (kevin.nzeyimana@reseau.eseo.fr)
data = [];
Recordings = file.Recordings;
DetectionParameters = file.DetectionParameters;
fileName = file.Name;
path = file.Recordings.path;
fileData = struct([]);
if endsWith(file.Name,'.mat')
    fileData = load([path '\' fileName]);
end


for k=1:length(Recordings.timeIn)
    [RawData] = GetData(Recordings.timeIn(k),Recordings.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Recordings.fname,DetectionParameters,fileData);
    data = [data;RawData];
    interval = length(data);
    time = linspace(Recordings.timeIn(1),Recordings.timeOut(length(Recordings.timeOut)),interval); %In seconds
    timeIn = same_spikes_deriv(:,1);
    timeOut = same_spikes_deriv(:,2);
    standard_dev = zeros(length(timeIn),1);
    Vpp = zeros(length(timeIn),1);
    amplitude = zeros(length(timeIn),1);
    for timeSpikes=1:length(same_spikes_deriv(:,1))
        if same_spikes_deriv(timeSpikes,1) ~= 0
            x = find(time>=timeIn(timeSpikes) & time<=timeOut(timeSpikes));
            spike = data(x(1):x(end));
            %spike = RawData(same_spikes_deriv(timeSpikes,1):same_spikes(timeSpikes,2));
           %figure;plot(spike)
            Vpp(timeSpikes) = peak2peak(spike);
            standard_dev(timeSpikes) = std(spike);
            amplitude(timeSpikes) = mean(spike);
        end
    end
    avg_vpp_spikes = mean(Vpp(:));
    avg_std_spikes = mean(standard_dev(:)); 
    avg_amplitude_spikes = mean(amplitude(:)); 
    std_signal = std(data);
end