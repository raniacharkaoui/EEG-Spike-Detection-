%% Computing the absolute time to the format accepted by brainRT
%%% a small artifact de calcul was used to account for matlab supporting
%%% only 15 significant digits calculus
%%% Authors: Mathieu Biava, Ahmed Bader, 
%%% ULB      David Perez, Alain Zheng

function [DateString] = ApplyTimeFormat(absTime, eventTime)
format long;
absTimeSec = floor(absTime/1e6); %get truncated time in sec
RemTotalTimeMicrosec = absTime - absTimeSec*1e6 + eventTime; % get remaining totaltime in microsec
TotalTimeSec = absTimeSec + floor(RemTotalTimeMicrosec/1e6); % in case microsec time exceed 1second 
RemTotalTimeMicrosec = RemTotalTimeMicrosec - floor(RemTotalTimeMicrosec/1e6)*1e6; % in case microsec time exceed 1second

Date = datetime([TotalTimeSec],'ConvertFrom','epochtime','Epoch','01-Jan-0000 00:00:00');

Year = num2str(year(Date));
Month = num2str(sprintf('%02d',month(Date)));
Day = num2str(sprintf('%02d',day(Date)));
Hour = num2str(sprintf('%02d',hour(Date)));
Minute = num2str(sprintf('%02d',minute(Date)));
Second = num2str(sprintf('%02d',second(Date)));
Microsec = num2str(sprintf('%06d',RemTotalTimeMicrosec));

%%% format YYYY-MM-DDThh:mm:ss:uuuuuu

DateString = [Year '-' Month '-' Day 'T' Hour ':' Minute ':' Second '.' Microsec];

end
