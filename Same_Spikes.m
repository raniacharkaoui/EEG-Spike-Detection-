 
% Caclulate the sensisivity

function [Same_spikes_timeIn,Same_spikes_timeOut , Solo_ExpA_timeIn,Solo_ExpA_timeOut] = Same_Spikes(ExpA_timeIn,ExpA_timeOut,ExpB_timeIn,ExpB_timeOut)
% B is the gold standard 
	Same_spikes_timeIn = [];
    Same_spikes_timeOut = []; % Number of spikes counted by both the experts (TP)
	Solo_ExpA_timeIn= [];
    Solo_ExpA_timeOut= [];
    ExpA_timeOut2 = nonzeros(ExpA_timeOut);
    ExpA_timeIn2 = nonzeros(ExpA_timeIn);
    if ~isempty(ExpA_timeOut) && ~isempty(ExpA_timeOut2)
        windowLength = ExpA_timeOut2(1)-ExpA_timeIn2(1);
    end
    
    for SlideSec=1:length(ExpA_timeIn) %  Go through the number of spikes beginning counted by the expert B
        CommonOneSpike = 0;
        if ExpA_timeIn(SlideSec)==0
            Same_spikes_timeIn = [Same_spikes_timeIn;0];
            Same_spikes_timeOut = [Same_spikes_timeOut;0];
        else
            % Initialization of the number of spikes counted by A
            for SecInIndex = 1:length(ExpB_timeIn)
                diff = abs(ExpA_timeOut(SlideSec)-ExpB_timeOut(SecInIndex));
                if diff>=0 && diff<=windowLength
                    CommonOneSpike = CommonOneSpike+1;
                end
                if (CommonOneSpike == 1) %Count the number of spikes counted by A AND B
                    Same_spikes_timeIn = [Same_spikes_timeIn;ExpB_timeIn(SecInIndex)];
                    Same_spikes_timeOut = [Same_spikes_timeOut;ExpB_timeOut(SecInIndex)];
                    CommonOneSpike	= CommonOneSpike+1;
                end

            end
        end
        if (CommonOneSpike == 0)
         Solo_ExpA_timeIn= [Solo_ExpA_timeIn;ExpA_timeIn(SlideSec)];
         Solo_ExpA_timeOut = [Solo_ExpA_timeOut;ExpA_timeOut(SlideSec)];
        end
    end  
end 