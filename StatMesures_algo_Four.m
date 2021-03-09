function [Real_Sensitivity,Real_Precision,Real_PearsonCoef] = StatMesures_algo_Four(ExpA_timeIn, ExpA_timeOut,ExpB_timeIn,ExpB_timeOut,ExpC_timeIn,ExpC_timeOut,ExpD_timeIn,ExpD_timeOut, algo_timeIn,algo_timeOut)

precision = zeros(1,4);
  sensitivity = zeros(1,4);
  
  [sensitivity(1,1),precision(1,1)] = Count_Results(ExpA_timeIn, ExpA_timeOut, algo_timeIn, algo_timeOut);
  [sensitivity(1,2),precision(1,2)] = Count_Results(ExpB_timeIn, ExpB_timeOut, algo_timeIn, algo_timeOut);
  [sensitivity(1,3),precision(1,3)] = Count_Results(ExpC_timeIn, ExpC_timeOut, algo_timeIn, algo_timeOut);
  [sensitivity(1,4),precision(1,4)] = Count_Results(ExpD_timeIn, ExpD_timeOut, algo_timeIn, algo_timeOut);
  
  pearsonCoef(1,1) = sqrt(sensitivity(1,1)*precision(1,1));
  pearsonCoef(1,2) = sqrt(sensitivity(1,2)*precision(1,2));
  pearsonCoef(1,3) = sqrt(sensitivity(1,3)*precision(1,3));
  pearsonCoef(1,4) = sqrt(sensitivity(1,4)*precision(1,4));
  
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