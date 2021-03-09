%This function calculates the SWI for each derivation

function [Stat] = SingleDerStats(Det,Recording,artifactsTimeIn,artifactsTimeOut)

Stat.SecWithSpike = 0;
Stat.NumSW = 0;
timeIn = sort([Recording.timeIn;artifactsTimeOut]);
timeOut = sort([Recording.timeOut;artifactsTimeIn]);

for EpochNbr=1:length(timeIn)
    if  ~isempty(Det.Epoch(EpochNbr).DetectedTime) %(length(Det) >= EpochNbr) && (length(Det.Epoch(EpochNbr).DetectedTime) > 2) && (length(Det.Epoch(EpochNbr).DetectedTime(:,1)) > 2)
        IndexSec = timeIn(EpochNbr);
        Stat.LocalSecWithSpike(EpochNbr).Sec = 0;

        for NumDetSpikes = 1:length(Det.Epoch(EpochNbr).DetectedTime(:,1))
            Stat.NumSW = Stat.NumSW + 1;
            SWBeg = Det.Epoch(EpochNbr).DetectedTime(NumDetSpikes,1);

            if floor(SWBeg/1000) > IndexSec 
                IndexSec = floor(SWBeg/1000);
                Stat.SecWithSpike = Stat.SecWithSpike + 1;
                Stat.LocalSecWithSpike(EpochNbr).Sec = Stat.LocalSecWithSpike(EpochNbr).Sec + 1;
            end
        end
    else
        Stat.LocalSecWithSpike(EpochNbr).Sec = 0;
    end
end
Stat.RecordingTime = 0;
for EpochNbr=1:length(timeIn)
    Stat.RecordingTime = Stat.RecordingTime + timeOut(EpochNbr)-timeIn(EpochNbr);
    Stat.LocalSWI(EpochNbr) = Stat.LocalSecWithSpike(EpochNbr).Sec/(timeOut(EpochNbr)-timeIn(EpochNbr));
end
Stat.SWI = Stat.SecWithSpike/Stat.RecordingTime;