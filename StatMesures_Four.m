function [Real_Sensitivity,Real_Precision,Real_PearsonCoef] = StatMesures_Four(ExpA_timeIn, ExpA_timeOut, ExpB_timeIn,ExpB_timeOut, ExpC_timeIn, ExpC_timeOut,ExpD_timeIn, ExpD_timeOut)

  precision = zeros(1,12);
  sensitivity = zeros(1,12);
  pearsonCoef = zeros(1,12);
  list_exp_timeIn = {ExpA_timeIn;  ExpB_timeIn; ExpC_timeIn; ExpD_timeIn};
  list_exp_timeOut = { ExpA_timeOut;  ExpB_timeOut; ExpC_timeOut, ; ExpD_timeOut};
   k =1;
  for i = 1:length(list_exp_timeIn)
      if(i == length(list_exp_timeIn)-1)
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+1,1},list_exp_timeOut{i+1,1});
          [sensitivity(k+1),precision(k+1)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{1,1},list_exp_timeOut{1,1});
          [sensitivity(k+2),precision(k+2)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{2,1},list_exp_timeOut{2,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          pearsonCoef(k+1) = sqrt(sensitivity(k+1)*precision(k+1));
          pearsonCoef(k+2) = sqrt(sensitivity(k+2)*precision(k+2));
          k = k+3;
      elseif(i == length(list_exp_timeIn))
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{1,1},list_exp_timeOut{1,1});
          [sensitivity(k+1),precision(k+1)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{2,1},list_exp_timeOut{2,1});
          [sensitivity(k+2),precision(k+2)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{3,1},list_exp_timeOut{3,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          pearsonCoef(k+1) = sqrt(sensitivity(k+1)*precision(k+1));
          pearsonCoef(k+2) = sqrt(sensitivity(k+2)*precision(k+2));
          k = k+3;
      elseif((i == length(list_exp_timeIn)-2))
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+1,1},list_exp_timeOut{i+1,1});
          [sensitivity(k+1),precision(k+1)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{1,1},list_exp_timeOut{1,1});
          [sensitivity(k+2),precision(k+2)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+2,1},list_exp_timeOut{i+2,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          pearsonCoef(k+1) = sqrt(sensitivity(k+1)*precision(k+1));
          pearsonCoef(k+2) = sqrt(sensitivity(k+2)*precision(k+2));
          k = k+3;
      else
          [sensitivity(k),precision(k)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+1,1},list_exp_timeOut{i+1,1});
          [sensitivity(k+1),precision(k+1)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+2,1},list_exp_timeOut{i+2,1});
          [sensitivity(k+2),precision(k+2)] = Count_Results(list_exp_timeIn{i,1},list_exp_timeOut{i,1},list_exp_timeIn{i+3,1},list_exp_timeOut{i+3,1});
          pearsonCoef(k) = sqrt(sensitivity(k)*precision(k));
          pearsonCoef(k+1) = sqrt(sensitivity(k+1)*precision(k+1));
          pearsonCoef(k+2) = sqrt(sensitivity(k+2)*precision(k+2));
          k = k+3;
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