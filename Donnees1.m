   clear all
  close all
  load('algo_spikes.mat');
[algo_timeIn,algo_timeOut] = Changes_algo_values(PatientSpecificDetSpikes);
 
 close all
 load('AD_ErasmeData.mat');
 Events = Data.Events;
[Expert_timeIn , Expert_timeOut] = Get_timeExp(Events);


Precision = Count_Precision( Expert_timeOut,Expert_timeOut, algo_timeIn, algo_timeOut);
Sensitivity= Count_Sensitivity(Expert_timeIn, Expert_timeOut, algo_timeIn, algo_timeIn);

  
  
  
  
  
  %Real_Sensitivity = (Sensitivity+ Sensitivity2)/2;
  %Real_Precision = (Precision + Precision2)/2;
  
  