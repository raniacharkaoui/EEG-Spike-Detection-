%This function calculates the sensitivity and the precision

function [Sensitivity,Precision] = Count_Results(ExpA_timeIn,ExpA_timeOut,ExpB_timeIn,ExpB_timeOut)
% A is the gold standard 
	%CommonSpikes = 0; 
    AlgoSpikesOnly = 0; %Number of spikes counted only by the algorithm (FP)
    maxLength = max(length(ExpA_timeIn),length(ExpB_timeIn));
    SameSpikesList = zeros(maxLength,1); %List of spikes counted only by both the experts
    if ~isempty(ExpB_timeOut)
        windowLength = ExpB_timeOut(1)-ExpB_timeIn(1);
    end
    index=1;
    
    for SlideSec=1:length(ExpB_timeOut) %  Go through the number of spikes beginning counted by B
        CommonOneSpike = 0;    %%initiate the common spike at 0
        for SecInIndex = 1:length(ExpA_timeOut)
            diff = abs(ExpB_timeIn(SlideSec)-ExpA_timeIn(SecInIndex));
            if diff>=0 && diff<=windowLength
                CommonOneSpike = CommonOneSpike+1;
                SameSpikesList(index,1) = ExpA_timeIn(SecInIndex);
                %SameSpikesList(index,2) = ExpA_timeOut(SecInIndex);
                index = index+1;
            end
        end
        if CommonOneSpike==0
            AlgoSpikesOnly = AlgoSpikesOnly+1;
        end
    end 
    SameSpikesList = nonzeros(SameSpikesList);
    CommonSpikes = length(unique(SameSpikesList)); % Number of spikes counted by both the experts (TP)
    ExpSpikesOnly = length(ExpA_timeIn)-length(unique(SameSpikesList)); %Number of spikes counted only by one expert (FN)
	
    Precision = 100*CommonSpikes/(CommonSpikes+AlgoSpikesOnly);
    Sensitivity =  100*CommonSpikes/(CommonSpikes+ExpSpikesOnly);
end 