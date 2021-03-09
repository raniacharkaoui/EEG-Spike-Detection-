%%%This function allows to retrieve the time_In et time_Out of the detected
%%%spikes for the Erasme experts (definition of Nicolas Gaspard)

function [Expert_timeIn ,Expert_timeOut] = Get_timeExp(Events,current)
 load('Spikes.mat','file');
 Expert_timeIn = [];
 for i=1:length(Events)
     if(Events(i).Type == 1 && Events(i).Subtype == 1)
         Time_deb = Events(i).Time;
     end
 end

 for i=1:length(Events)
     if(Events(i).Type == 32768 && Events(i).Subtype == 32790)
         if(i==1)
            Time_ms =( Events(i).Time-Time_deb)/1000;
            if(Time_ms > 0)
                Expert_timeIn = Time_ms;
            end
         else
            Time_ms =( Events(i).Time- Time_deb)/1000;
            if (Time_ms > 0)
                Expert_timeIn = [Expert_timeIn ; Time_ms];
            end
         end
     end
 end
 Expert_timeIn =floor( Expert_timeIn );
 Expert_timeOut = Expert_timeIn(:)+file(current).DetectionParameters.WindowLength;