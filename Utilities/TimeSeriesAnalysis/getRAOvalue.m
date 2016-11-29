function [RAO] = getRAOvalue(dataname,Tsteady,Dt) 
load (dataname);

PtfmMotions = data(Tsteady/Dt:end,15:20);
StatisMotions = zeros(6,4);
RAO = zeros(6,1);
for i = 1:6 
    [StatisMotions(i,1),StatisMotions(i,2),StatisMotions(i,3),...
        StatisMotions(i,4)] = Statistic(PtfmMotions(:,i)); 
    RAO(i) = (StatisMotions(i,1)-StatisMotions(i,2))/2;
   
end
