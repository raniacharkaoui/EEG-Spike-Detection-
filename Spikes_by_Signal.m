function Spikes_by_Signal()
load('Spikes.mat','file');
for current=1:length(file)
    NumDerivation = length(file(current).PatientSpecificDetSpikes)/2;
    Recordings = file(current).Recordings;
    %list of timeIn and timeOut of the spikes detected by the algo and the
    %experts P.S: You have to launch the script "Display_spikes.m" to have
    %the fields "same_spikes"
    same_spikes = file(current).same_spikes;
    %Find zeros which separate each derivation

    list_zeros = find(same_spikes(:,1) == 0);
    list_other = find(same_spikes(:,1) ~= 0);
    
   %List of derivations
    for i=1:length(file(current).PatientSpecificDetSpikes) 
        if i == 1
            nrElectrodeLeft_list(i,:) = Recordings.nrElectrodeLeft(i,:);
            nrElectrodeRight_list(i,:) = Recordings.nrElectrodeRight(i,:);
        elseif mod(i,2) ~= 0 % when it's odd
            nrElectrodeLeft_list(end+1,:) = Recordings.nrElectrodeLeft(i,:);
            nrElectrodeRight_list(end+1,:) = Recordings.nrElectrodeRight(i,:);
        end
    end
    

    avg_vpp_spikes = [];
    avg_amplitude_spikes = [];
    avg_std_spikes = [];
    std_signal = [];    
    for Derivation = 1:NumDerivation  
        nrElectrodeLeft = deblank(nrElectrodeLeft_list(Derivation,:));
        nrElectrodeRight = deblank(nrElectrodeRight_list(Derivation,:));
        % Retrieve the list of the spikes detected by both the expert and
        % the algorithm
        if Derivation==1
            if list_zeros(Derivation+1)-list_zeros(Derivation) > 1
                begin_derivation = 1;
                end_derivation = list_zeros(Derivation)-1; 
                same_spikes_deriv = same_spikes(begin_derivation:end_derivation,:);
                [avg_vpp_spikes_deriv,avg_amplitude_spikes_deriv,avg_std_spikes_deriv,std_signal_deriv] = data_by_deriv(file(current),nrElectrodeLeft,nrElectrodeRight,same_spikes_deriv);
            end
        elseif Derivation>1  
            if list_zeros(Derivation)-list_zeros(Derivation-1) > 1
                begin_derivation = list_zeros(Derivation-1)+1;
                end_derivation = list_zeros(Derivation)-1; 
                same_spikes_deriv = same_spikes(begin_derivation:end_derivation,:);
                [avg_vpp_spikes_deriv,avg_amplitude_spikes_deriv,avg_std_spikes_deriv,std_signal_deriv] = data_by_deriv(file(current),nrElectrodeLeft,nrElectrodeRight,same_spikes_deriv);
            
            end
        avg_vpp_spikes = [avg_vpp_spikes;avg_vpp_spikes_deriv];
        avg_std_spikes = [avg_std_spikes;avg_std_spikes_deriv]; 
        avg_amplitude_spikes = [avg_amplitude_spikes;avg_amplitude_spikes_deriv]; 
        std_signal = [std_signal;std_signal_deriv];
        
        end
    end

        
   

R = corr2(std_signal,avg_vpp_spikes);
R2 = corr2(std_signal,avg_amplitude_spikes);
R3 = corr2(std_signal,avg_std_spikes);
file(current).correlation_vpp = R;
file(current).correlation_amplitude = R2;
file(current).correlation_std = R3; 
name  = ['Correlations for the patient ' file(current).Name];
figure('Name',name);
subplot(2,2,1)
scatter(std_signal,avg_vpp_spikes);
vpp_line = refline;
x1 = vpp_line.XData;
y1 = vpp_line.YData;
file(current).slope_vpp = (y1(end) - y1(1))/(x1(end) - x1(1));
title('avg vpp spikes versus std signal');

subplot(2,2,2)
scatter(std_signal,avg_amplitude_spikes);
amplitude_line = refline;
x2 = amplitude_line.XData;
y2 = amplitude_line.YData;
file(current).slope_amplitude = (y2(end) - y2(1))/(x2(end) - x2(1));

title('avg amplitude spikes versus std signal');
subplot(2,2,3)
scatter(std_signal,avg_std_spikes);
std_line = refline;
x3 = std_line.XData;
y3 = std_line.YData;
file(current).slope_std = (y3(end) - y3(1))/(x3(end) - x3(1));
title('avg std spikes versus std signal');
end
save('Spikes.mat','file');
end