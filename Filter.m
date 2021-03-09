 function [ProcessedData] = Filter(RawData,DetectionParameters)

Fc_LP = 35; 
Fc_HP = 1; 

Wn = Fc_LP/(DetectionParameters.Fs/2); 
[Blp,Alp] = butter(5,Wn); 
RawData = filtfilt(Blp,Alp,RawData); 

Wn = Fc_HP/(DetectionParameters.Fs/2); 
[Bhp,Ahp] = butter(5,Wn,'high'); 
ProcessedData = filtfilt(Bhp,Ahp,RawData); 