function [DeuzDetAdj] = BegEndSpikeAdujstment(DeuzDet,Pat,NumDerivation,DetectionParameters)

Fs = 200;
windowBegPlus = 0;
windowBegMinus = 20;
BegEndLength = 25;
windowEndPlus = 10;
windowEndMinus = 10;

for Derivation = 1:NumDerivation
        nrElectrodeLeft = deblank(Pat.nrElectrodeLeft(Derivation,:));
        nrElectrodeRight = deblank(Pat.nrElectrodeRight(Derivation,:));
    for k=1:length(Pat.timeIn)  
        [rawdata] = GetData(Pat.timeIn(k),Pat.timeOut(k),nrElectrodeLeft,nrElectrodeRight,Pat.fname,DetectionParameters); 

        if isempty(DeuzDet(Derivation).Det.Epoch(k))
        else
            for i=1:length(DeuzDet(Derivation).Det.Epoch(k).DetectedTime(:,1))

                BegSpike = round((DeuzDet(Derivation).Det.Epoch(k).DetectedTime(i,1)/1000-Pat.timeIn(k))*Fs); 
                BegWinSbeg = BegSpike-windowBegMinus;
                if BegWinSbeg<1
                    BegWinSbeg = 1;
                end
                EndWinSbeg = BegSpike+windowBegPlus;
                if EndWinSbeg>length(rawdata)
                    EndWinSbeg = length(rawdata);
                end
                if BegWinSbeg<EndWinSbeg
                    [Val pos] = min(rawdata(BegWinSbeg:EndWinSbeg));
                    BegSpikeAdj = BegSpike+pos-windowBegMinus-1;
                else
                    BegSpikeAdj = BegSpike;
                end

                BegWinSend = BegSpikeAdj+BegEndLength-windowEndMinus;
                if BegWinSend<1
                    BegWinSend = 1;
                end
                EndWinSend = BegSpike+BegEndLength+windowEndPlus;
                if EndWinSend>length(rawdata)
                    EndWinSend = length(rawdata);
                end
                if BegWinSend<EndWinSend
                    [Val pos] = min(rawdata(BegWinSend:EndWinSend));
                    EndSpikeAdj = BegSpikeAdj+BegEndLength+pos-windowEndMinus-1;
                else
                    EndSpikeAdj = EndWinSend;
                end

                DeuzDetAdj(Derivation).Det.Epoch(k).DetectedTime(i,1) = (BegSpikeAdj/Fs+Pat.timeIn(k))*1000;
               DeuzDetAdj(Derivation).Det.Epoch(k).DetectedTime(i,2) = (EndSpikeAdj/Fs+Pat.timeIn(k))*1000;
            end
        end
    end
end
            
            


