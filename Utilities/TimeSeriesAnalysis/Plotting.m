clc;clear all;close all
%%
load('RAOData_flex_nonaero_model\RAO10.mat');

% figure('Units','Normalized','Position',[0.1 0.05 0.5 0.85]);
% i=0;
% titlestr=[{'WindVxi'},{'BldPitch'},{'OoPDefl1'},{'IPDefl1'},{'TTDspFA'},{'RootMxc1'},{'RootMyc1'},{'TwrBsMxt'},{'TwrBsMyt'}];
% for col=[2,11,8,9,12,24,25,39,40]
%     i=i+1;
%     
%     subplot(length(titlestr),1,i);
%     plot(data(:,1),data(:,col));title(titlestr{i});              
%     xlim([min(data(:,1)) max(data(:,1))]);
%     ylim([min(data(:,col)) max(data(:,col))]);
%     
% end

figure('Units','Normalized','Position',[0.1 0.05 0.5 0.85]);
i=0;
titlestr=[{'PtfmSurge'},{'PtfmSway'},{'PtfmHeave'},{'PtfmRoll'},{'PtfmPitch'},{'PtfmYaw'}];
for col=12:17
    i=i+1;
    subplot(length(titlestr),1,i);
    plot(data(:,1),data(:,col));title(titlestr{i});              
%     xlim([min(data(:,1)) max(data(:,1))]);
%     ylim([min(data(:,col)) max(data(:,col))]);
end
% 
% figure('Units','Normalized','Position',[0.1 0.05 0.5 0.85]);
% i=0;
% titlestr=[{'WindVxi'},{'TFair1'},{'TAnch1'},{'TFair2'},{'TAnch2'},{'TFair3'},{'TAnch3'}];
% for col=[2,45,46,47,48,49,50]
%     i=i+1;
%     subplot(length(titlestr),1,i);
%     plot(data(:,1),data(:,col));title(titlestr{i});              
%     xlim([min(data(:,1)) max(data(:,1))]);
%     ylim([min(data(:,col))-0.01 max(data(:,col))+0.01]);
% end
