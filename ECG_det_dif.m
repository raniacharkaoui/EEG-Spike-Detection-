%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ECG_det_dif takes as an input a ECG signal and sends as an ouput the
% timmings where the QRS peak, or cardiac artifact in this case is detected
% and the total number of peaks.
%
% Input parameters:
% ECG: input signal as a column vector. 
% fs: sampling frequency of the signal
% thr: threshold value for the detection
% 
%
% Output parameters:
% QRS: pulse signal, high amplitude when a cardiac peak is detected
% Npeaks: number of peaks detected
% listArtifacts: list of the times at which the signal has a QRS complex
% (cardiac artifact for the EEG)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [QRS, Npeaks, listArtifacts] = ECG_det_dif(ECG, fs, thr)

    y = ECG/max(abs(ECG));  % Signal normalization
    t = linspace(0,length(y)/fs,length(y)); % signal time vector

    % First derivative method
    b1=[1 0 -1];
    a=1;
    ECG_diff=abs(filtfilt(b1,a,y));

    % First and second derivative method
     b2=[1 0 -2 0 1];
     ECG_diff_s=abs(filtfilt(b2,a,y));
     
    % Linear combination
     ECG_diff_sum= 1.3*ECG_diff + 1.1*ECG_diff_s;

    % Signal average
     N3=8;
     b3=(1/N3)*ones(1,N3);
     yf=filtfilt(b3,a,ECG_diff_sum);

    % Detection
     F=find(thr<yf);
     QRS = zeros(1,length(yf));
     if F
        QRS(F)=0.6;
     end
    
    % Compute the number of peaks and  save the timings in which a peak is detected
    % listArtifacts is the list of the times at which the signal has a QRS complex
    [Npeaks,listArtifacts]=findpeaks(QRS,t);
    
    hold off
        
end