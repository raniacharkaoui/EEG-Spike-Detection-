function [Pat] = AttribuePat(DBPath,fileName,timeIn,timeOut,timeDebrec,nrElectrodeLeft,nrElectrodeRight,current, isAllChecked_v,isAllChecked_h,transversalMontage)
    
% Choosing the channels that will be shown on the graphical interface 
ElLeft = [];
ElRight = [];
% disp(nrElectrodeLeft);
% disp(nrElectrodeRight);
for i=1:length(nrElectrodeLeft)
    if(i==1)
       ElLeft = nrElectrodeLeft{1,i};
     else
       ElLeft =[ElLeft;nrElectrodeLeft{1,i}];
     end
end 
% disp(nrElectrodeLeft);

for i=1:length(nrElectrodeRight)
    if(i==1)
       ElRight = nrElectrodeRight{1,i};
    
     else
       ElRight =[ElRight;nrElectrodeRight{1,i}];
     end
end     
% disp(nrElectrodeRight);


nom = 'Patient N°%d';
Pat(1).name = sprintf(nom,current);
Pat(1).path = DBPath;
Pat(1).debrec = timeDebrec;
Pat(1).fname = [DBPath fileName];
Pat(1).timeIn = timeIn;
Pat(1).timeOut = timeOut;
Pat(1).nrElectrodeLeft = ElLeft; 
Pat(1).nrElectrodeRight= ElRight;
Pat(1).isAllchecked_v = isAllChecked_v; %parameter that indicates if all channels are chosen
Pat(1).isAllchecked_h = isAllChecked_h;
Pat(1).transversalMontage = transversalMontage;
Pat(1).ListDeriv = [4,4,4,4,2,2,2];