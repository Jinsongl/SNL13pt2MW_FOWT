function Plot_TimeHistory(fidin,Chanls2plot)

load(fidin)

Len_out = length(outlist);
Nplot = length(Chanls2plot);
% disp([' Only Valid for Regular RAO output !' ...
%          ['Number of output Chanels : ', num2str(Len_out)] ...
%           ['file name :', fidin]);
figure;
for i = 1: Nplot
subplot (Nplot,1,i)
% Chanls2plot(i)
TimeHis = plot(data(:,1),data(:,Chanls2plot(i)));
title ( outlist{Chanls2plot(i)});
end
xlabel('Time /s')
saveas(TimeHis, [fidin(1:end-4),'.bmp']);
% Chanels: 1 'Time        ',
% 'Azimuth     ',
% 'RotSpeed    ',
% 'GenSpeed    ',
% 'OoPDefl1    ',
% 'IPDefl1     ',
% 'TwstDefl1   ',
% 'BldPitch1   ',
% 'TTDspFA     ',
% 'TTDspSS     ',
% 'TTDspTwst   ',
% 'PtfmSurge   ',
% 'PtfmSway    ',
% 'PtfmHeave   ',
% 'PtfmRoll    ',
% 'PtfmPitch   ',
% 'PtfmYaw     ',
% 'RootFxc1    ',
% 'RootFyc1    ',
% 'RootFzc1    ',
% 'RootMxc1    ',
% 'RootMyc1    ',
% 'RootMzc1    ',
% 'RotTorq     ',
% 'LSSGagMya   ',
% 'LSSGagMza   ',
% 'YawBrFxp    ',
% 'YawBrFyp    ',
% 'YawBrFzp    ',
% 'YawBrMxp    ',
% 'YawBrMyp    ',
% 'YawBrMzp    ',
% 'TwrBsFxt    ',
% 'TwrBsFyt    ',
% 'TwrBsFzt    ',
% 'TwrBsMxt    ',
% 'TwrBsMyt    ',
% 'TwrBsMzt    ',
% 'GenPwr      ',
% 'GenTq       ',
% 'Wave1Elev   ',
% 'TFair[1]    ',
% 'TAnch[1]    ',
% 'TFair[2]    ',
% 'TAnch[2]    ',
% 'TFair[3]    ',
% 'TAnch[3]    '
% WaveFre = 0.002:0.002:0.1;
% Tp = 2*pi./WaveFre;







end