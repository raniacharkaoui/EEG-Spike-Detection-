%%%To get the potential difference between the two electrodes for each
%%%channel

function [data] = GetData(timeIn,timeOut,nrElectrodeLeft,nrElectrodeRight,fname,DetectionParameters,fileData)

if endsWith(fname,'.edf') || endsWith(fname,'.EDF')
    if strcmp(nrElectrodeRight,'')
        [xL,Fs] = ReadedfTest(timeIn,timeOut,nrElectrodeLeft,fname); 
        data = xL;
    else
        [xL] = ReadedfTest(timeIn,timeOut,nrElectrodeLeft,fname); 
        [xR,Fs] = ReadedfTest(timeIn,timeOut,nrElectrodeRight,fname); 
        data = xL-xR;
    end
    if Fs ~= DetectionParameters.Fs
        data = resample(data,200,Fs);
    end
    
elseif endsWith(fname,'.mat')
    Fs = fileData.Data.ChDesc(1).Fs;
    if strcmp(nrElectrodeRight,'')
        [xL] = GetEEG(Fs,timeIn,timeOut,fileData,nrElectrodeLeft); 
        data = xL;
    else
        [xL] = GetEEG(Fs,timeIn,timeOut,fileData,nrElectrodeLeft); 
        [xR] = GetEEG(Fs,timeIn,timeOut,fileData,nrElectrodeRight); 
        data = xL-xR;
   end
end

