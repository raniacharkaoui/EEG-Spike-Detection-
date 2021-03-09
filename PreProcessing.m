function [ProcessedData] = PreProcessing(RawData,DetectionParameters)

LengthData = length(RawData);
RawData = Filter(RawData,DetectionParameters);

% First derivation estimation
Der(1) = (2*RawData(1))./8;
Der(2) = (2*RawData(2)+RawData(1))./8;
Der(3) = (2*RawData(3)+RawData(2))./8;
Der(4) = (2*RawData(4)+RawData(3)-RawData(1))./8;
Der(5:LengthData) = (2*RawData(5:LengthData,:)+RawData(4:LengthData-1,:)-RawData(2:LengthData-3,:)-2*RawData(1:LengthData-4,:))./8;

% Squaring
Der = (Der.^2).*sign(Der);

% Smoothing
AverageWindow = round(DetectionParameters.Fs/20);
ProcessedData(AverageWindow,LengthData) = 0;

% % On calcule la moyenne sur 10 points du signal
% tempY = Y;
% 
% Y = zeros(1, length(tempY));
% 
% Y(1) = tempY(1);
% Y(length(tempY)) = tempY(end);
% 
% % On doit faire un traitement spécial pour les bords
% for i=2:4
%     curLength = (i-1)*2+1;
%     Y(i) = sum(tempY(1:curLength)) / curLength;
% end
% 
% for i=5:length(tempY)-5
%     Y(i) = sum(tempY(i-4:i+4)) / 9;
% end
% 
% for i=length(tempY)-4:length(tempY)-1
%     curLength = length(Y) - (length(Y) - i)*2;
%     Y(i) = sum(tempY(curLength:length(tempY))) / (length(tempY) - curLength);
% end

% for n=1:AverageWindow
%     ProcessedData(n,:)=circshift(Der',n-1);
% end;

ProcessedData(1,:)=Der';
newElem = Der(1);
for n=2:AverageWindow
    ProcessedData(n,:)=[newElem ProcessedData(n-1,1:end-1)];
end
ProcessedData=sum(ProcessedData)/AverageWindow;

% % Smoothing
% % Fc = (0.443 / Number of Point ) * Fsampling 
% % Fc = 0.443/10*200 = 8.8600 more or less 10Hz.
% Fc_LP = 10; 
% 
% Wn = Fc_LP/(DetectionParameters.Fs/2); 
% [Blp,Alp] = butter(1,Wn); 
% ProcessedData = filtfilt(Blp,Alp,Der); 