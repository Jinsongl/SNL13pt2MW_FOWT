clear all;clc;
load ('WaveFreq.mat')
Chanls2plot = [20,12:17];
for r = 11 : 20%length(WaveFre)
    name=['SNL_13pt2MW_1pt4_Reg_RAO_Omega_',num2str(WaveFreq(r),'%5.3f'),'.mat'];
    load ( name );
    Plot_TimeHistory(name,Chanls2plot);
%     saveas(TimeHis, [name(1:end-4),'.bmp']);
end
