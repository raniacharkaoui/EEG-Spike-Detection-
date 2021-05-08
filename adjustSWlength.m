function [SWBeg_Adj SWEnd_Adj] = adjustSWlength(SWBeg,SWEnd,data_init,timeIn,datafilt,fs)

Deb = round((SWBeg/1000-timeIn)*fs); 
Fin = round((SWEnd/1000-timeIn)*fs);
if Deb<1
    Deb = 1;
end
if Fin>length(data_init)
    Fin = length(data_init);
end

% figure
% hold on 
% plot(data_init);
% plot(datafilt,'k');
% plot(Deb:Fin,data_init(Deb:Fin),'g');
% hold off

% We're looking for a spike and a wave, so two maximums

if Fin>Deb
    [pks,locs] = findpeaks(datafilt(Deb:Fin));
else
    locs = 0;
end

if length(locs) == 2
    SpikeAmplOld = pks(1);
    SpikeLoc = locs(1);
    Soffset = 1;
    while (Deb+SpikeLoc-Soffset-1>0) && (datafilt(Deb+SpikeLoc-Soffset-1)<= SpikeAmplOld)
        SpikeAmplOld = datafilt(Deb+SpikeLoc-Soffset-1);
        Soffset = Soffset +1;
    end
    Soffset = Soffset - SpikeLoc;
    WaveAmplOld = pks(2);
    WaveLoc = locs(2);
    Woffset = 1;
    while (Deb+WaveLoc+Woffset-1 < length(datafilt)) &&(datafilt(Deb+WaveLoc+Woffset-1)<= WaveAmplOld)
        WaveAmplOld = datafilt(Deb+WaveLoc+Woffset-1);
        Woffset = Woffset +1;
    end
    Woffset = Woffset - ((Fin-Deb) - WaveLoc) -1;
else
    Soffset = 0;
    Woffset = 0;
end;

SWBeg_Adj = SWBeg - round(Soffset*1000/fs);
SWEnd_Adj = SWEnd + round(Woffset*1000/fs);



