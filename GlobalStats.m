function [Stat TimeLineSWI] = GlobalStats(DetectedSpikes,Recording,NumDerivation)

Stat.SecWithSpike = 0;
Stat.NumSW = 0;
timeIn = Recording.timeIn;
timeOut = Recording.timeOut;

for CurrentEpoch=1:length(timeIn)
    TimeLineSWI(CurrentEpoch).list = [];
    SWICount = 0;
    IndexSec = timeIn(CurrentEpoch)-1;
    LocalSecWithSpike(CurrentEpoch).Sec = 0;

    % Both the beginning and the end of one spike count for SWI
    % (seconds presenting one or more spikes)
    for Derivation = 1:NumDerivation
        Epoch = DetectedSpikes(Derivation).Det.Epoch;
        if (length(Epoch) >= CurrentEpoch) && (length(Epoch(CurrentEpoch).DetectedTime) > 2) && (length(Epoch(CurrentEpoch).DetectedTime(:,1)) > 2)
            ThereAreSpikes(Derivation) = 1;
            EndSpikes(Derivation) = 2*length(Epoch(CurrentEpoch).DetectedTime(:,1));
            Stot = [Epoch(CurrentEpoch).DetectedTime(:,1) ; Epoch(CurrentEpoch).DetectedTime(:,2)];
            SpikeBeg(Derivation).Epoch = sort(Stot);  
        else
            ThereAreSpikes(Derivation) = 0;
        end;
    end
    
    SpikesCount = ones(1,NumDerivation);
    FirstSipke = ones(1,NumDerivation)*inf;
    while sum(ThereAreSpikes)>0
        
        % Spike index in each derivation
        for Derivation = 1:NumDerivation
            if ThereAreSpikes(Derivation) == 1
                FirstSipke(Derivation) = SpikeBeg(Derivation).Epoch(SpikesCount(Derivation));
                if SpikesCount(Derivation) == EndSpikes(Derivation)
                    ThereAreSpikes(Derivation) = 0;
                    FirstSipke(Derivation) = inf;
                end
            end
        end
        
        % First spike among derivations
        VeryFrist = min(FirstSipke);
        
        % Updating a new second that include one or more spikes
        if floor(VeryFrist/1000) > IndexSec
            IndexSec = floor(VeryFrist/1000);
            Stat.SecWithSpike = Stat.SecWithSpike + 1;
            LocalSecWithSpike(CurrentEpoch).Sec = LocalSecWithSpike(CurrentEpoch).Sec + 1;
            SWICount = SWICount+1;
            TimeLineSWI(CurrentEpoch).list(SWICount) = IndexSec-timeIn(CurrentEpoch);
        end
        
        % Incrementing cont for next spikes
        for Derivation = 1:NumDerivation
            while (ThereAreSpikes(Derivation) == 1) && (floor(FirstSipke(Derivation)/1000) <= IndexSec)
                if SpikesCount(Derivation) == EndSpikes(Derivation)
                    ThereAreSpikes(Derivation) = 0;
                    FirstSipke(Derivation) = inf;
                else
                    SpikesCount(Derivation) = SpikesCount(Derivation) + 1;
                    FirstSipke(Derivation) = SpikeBeg(Derivation).Epoch(SpikesCount(Derivation));
                end
            end
        end
    end
end

Stat.RecordingLength = 0;
for CurrentEpoch=1:length(timeIn)
    Stat.RecordingLength = Stat.RecordingLength + timeOut(CurrentEpoch)-timeIn(CurrentEpoch);
    Stat.LocalSWI(CurrentEpoch) = LocalSecWithSpike(CurrentEpoch).Sec/(timeOut(CurrentEpoch)-timeIn(CurrentEpoch));
end;
Stat.GlobalSWI = Stat.SecWithSpike/Stat.RecordingLength;