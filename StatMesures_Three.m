function [Real_Sensitivity,Real_Precision,Real_PearsonCoef] = StatMesures_Three(ExpA_timeIn, ExpA_timeOut, ExpB_timeIn,ExpB_timeOut, ExpC_timeIn, ExpC_timeOut)

  precision = zeros(1,6);
  sensitivity = zeros(1,6);
  pearsonCoef = zeros(1,6);
  list_exp_timeIn = {ExpA_timeIn;  ExpB_timeIn; ExpC_timeIn};
  list_exp_timeOut = { ExpA_timeOut;  ExpB_timeOut; ExpC_timeOut};
  k =1;
  for i = 1:length(list_exp_timeIn)
      if(i == length(list_exp_timeIn)-1)
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+1,1},list_exp_timeOut{i+1,1});
          [sensitivity(k+1),precision(k+1)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{1,1},list_exp_timeOut{1,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          pearsonCoef(k+1) = sqrt(sensitivity(k+1)*precision(k+1));
          k = k+2;
      elseif(i == length(list_exp_timeIn))
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{1,1},list_exp_timeOut{1,1});
          [sensitivity(k+1),precision(k+1)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{2,1},list_exp_timeOut{2,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          pearsonCoef(k+1) = sqrt(sensitivity(k+1)*precision(k+1));
          k = k+2;
      else
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+1,1},list_exp_timeOut{i+1,1});
          [sensitivity(k+1),precision(k+1)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+2,1},list_exp_timeOut{i+2,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          pearsonCoef(k+1) = sqrt(sensitivity(k+1)*precision(k+1));
          k = k+2;
      end      
  end
  
  sumP = 0;
  for i=1:length(precision)
      sumP = sumP + precision(i);
  end
  
  Real_Precision = sumP/length(precision);
  
  sumS = 0;
  for i=1:length(sensitivity)
      sumS = sumS + sensitivity(i);
  end
  
  Real_Sensitivity = sumS/length(sensitivity);
  
  sumPearsonCoef = 0 ;
  for i=1:length(pearsonCoef)
      sumPearsonCoef = sumPearsonCoef + pearsonCoef(i);
  end
  
  Real_PearsonCoef = sumPearsonCoef/length(pearsonCoef);
end