function [SimNum,caseNumStart,caseNumEnd] = caseCalculator(PCOrder, MatOrder, INoMatPC, INoCsMat, Nsim, totalCases )
% PCOrder : Computer order ;
% MatOrder : matlab order on this PC;\

% INoPCs  : Number of PCs used to run;
% INoMatPC : number of matlabs opening on each PC;
% INoCsMat : Number of Cases Each Matlab Terminal
% Nsim : Simualtion number for each case;
if MatOrder <= INoMatPC
    


fprintf('************************************************************\n')
fprintf( [' Total simulation cases = ', num2str(totalCases) ,'\n'])
fprintf('************************************************************\n')

SimNum = (PCOrder-1) * INoMatPC * INoCsMat * Nsim+...
         (MatOrder-1) * INoCsMat    * Nsim  + 1;

caseNumStart = (PCOrder-1) * INoMatPC * INoCsMat + (MatOrder -1) * INoCsMat+1;
caseNumEnd = caseNumStart + INoCsMat -1;
if caseNumEnd > totalCases
    caseNumEnd = totalCases;
end

else 
disp(' MatOrder cannot be larger than INoMatPC')

end

end