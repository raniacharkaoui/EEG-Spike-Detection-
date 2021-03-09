function [Real_Sensitivity,Real_Precision,Real_PearsonCoef] = StatMesures_Two(ExpA_timeIn, ExpA_timeOut, ExpB_timeIn,ExpB_timeOut)

  precision = zeros(1,2);
  sensitivity = zeros(1,2);
  pearsonCoef = zeros(1,2);
  list_exp_timeIn = {ExpA_timeIn;  ExpB_timeIn};
  list_exp_timeOut = {ExpA_timeOut;  ExpB_timeOut};
  k =1;
  for i = 1:length(list_exp_timeIn)
      if(i == length(list_exp_timeIn))
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{1,1},list_exp_timeOut{1,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          k = k+1;
      else
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+1,1},list_exp_timeOut{i+1,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          k = k+1;
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