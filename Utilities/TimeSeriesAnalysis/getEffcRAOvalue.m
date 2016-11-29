function [EffecRAO] = getEffcRAOvalue(dataname,Tsteady,Dt) 
ptfm_wave = load (dataname);
statistic_still = load('Statistic_Still.mat');
Range_still = 
motions_wave = ptfm_wave.data(Tsteady/Dt:end,15:20);

Range = zeros(6,1);
StatisMotions = zeros(6,4);
EffecRAO = zeros(6,1);
for i = 1:6 
    [StatisMotions(i,1),StatisMotions(i,2),StatisMotions(i,3),...
        StatisMotions(i,4)] = Statistic(motions_wave(:,i)); 
    Range(i) = StatisMotions(i,1)-StatisMotions(i,2);
    EffecRAO(i) = (Range(i) - Range_Still (i))/2;
end


