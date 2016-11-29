%% main file to calculate the stats for given data inputs.
% This script is used to calculate the statistics of interest for IFORM\
% Author: Jinsong Liu, 
%         Mechanics, Uncertainty and Simulation in Engineering,
%         The Department of Civil, Architectural and Environmental Engineering,
%         the University of Texas at Austin.
% email: Jinsongliu@utexas.edu
% Oct 2016; Last revision: Sep/06/2016

%% Get the dataFiles to analyse
% pattern = 'NRELOffshrBsline5MW\w*.mat';
% files = dir('.');
% files = regexpi({files.name}, pattern, 'match');
% % Remove empty string cells and convert dataFiles to a string cell
% files = files(~cellfun('isempty', files));
% dataFiles = cell(1, size(files, 2));
% for i = 1 : size(files,2)
%     dataFiles{i} = files{i}{1};
% end
% clear files       

clc; clear; close all;
load('matlabPlotConfiguration')
MODEL_NAME      = 'SNLOffshrBsline13pt2MW';
MOORING_MODEL   = '300';
waveDir         = 0;
NsimSelected    = [1:10];

LOGFILENAME     = ['logFile',num2str(waveDir, '%02.0f')];
Nsim            = size(NsimSelected, 2);
NseaStates      = 24;
NChannels       = 60;
destFilename    = ['SNL', MOORING_MODEL, num2str(waveDir, '%02.0f'),num2str(Nsim, '%02.0f'),'.mat'];
timeRegion      = [400,4000];
% statistics of interest
statsVars       = { 'max', 'mean', 'median', 'min', 'std', 'skewness', 'kurtosis','mur'}; 
% Pre locate data space
MODEL.max       = zeros(NseaStates * Nsim, NChannels);
MODEL.mean      = zeros(NseaStates * Nsim, NChannels);
MODEL.median    = zeros(NseaStates * Nsim, NChannels);
MODEL.min       = zeros(NseaStates * Nsim, NChannels);
MODEL.std       = zeros(NseaStates * Nsim, NChannels);
MODEL.skewness  = zeros(NseaStates * Nsim, NChannels);
MODEL.kurtosis  = zeros(NseaStates * Nsim, NChannels);
MODEL.mur       = zeros(NseaStates * Nsim, NChannels);
% MODEL.max = zeros(NseaStates * Nsim, NChannels);

%
dataFiles = cell(NseaStates * Nsim,1);
for iseaState = 1:NseaStates
     for iSim = 1: Nsim
         outfileId = [num2str(iseaState, '%02.0f'),num2str(waveDir, '%02.0f'), num2str(NsimSelected(iSim), '%02.0f')];
         dataFiles{(iseaState -1)*Nsim + iSim,1} = [MODEL_NAME, MOORING_MODEL, outfileId,'.mat'];
     end
end

%% Compute stats for dataFiles

% timeRegion = [100, 700];
% statistics of interest
% statsVars = { 'max', 'mean', 'median', 'min', 'std', 'skewness', 'kurtosis', 'peaksNum','alpha'}; 
% alpha: regularity factor, = m2 / sqrt(m0 * m4) == avg peak2peak period /
% avg up crossing period


nstatsVars = size(statsVars,2);
isNstatsVarsChecked = false;
nFiles = size(dataFiles, 1);
disp('========================================')
disp('Calculating statistics of data....')
disp('Summary: ')
disp('  => Statistics of interest:')
disp(statsVars)
disp(['  => Time domain of interest: [',num2str(timeRegion(1)),', ', num2str(timeRegion(2)),']'])
disp(['  => Number of files to be processed: ', num2str(nFiles)])
disp('========================================')
%%
for iFile = 1 : nFiles
    fileName = dataFiles{iFile};
    disp('==>Stats calculating for input data from:')
    disp(['   ',fileName])
    try 
        load(fileName)
    catch ME
        log = fopen(LOGFILENAME,'a');
        fprintf(log, '%s\n', fileName);
        fclose(log);
        continue
    end
    % Simluation input mismatch, # of output not equal
    if size(data, 2) ~= NChannels
        ChannelsSel = [1:54,69,70,85,86,101,102];
        data    = data(:,ChannelsSel);
        outlist = outlist(:,ChannelsSel);
        units   = units(:,ChannelsSel); 
    end
    % Save channels from the first file
    if ~exist('headers','var')      
        nChannels   = size(units, 2);     
        headers     = cell(2, nChannels);
        for iChannel = 1 : nChannels
            headers{1,iChannel} = strtrim(outlist{iChannel});
            headers{2,iChannel} = strtrim(units{iChannel});
        end
    end
    if exist('timeRegion', 'var')
        timeSta = find(data(:,1) == timeRegion(1));
        timeEnd = find(data(:,1) == timeRegion(2));
        data = data(timeSta:timeEnd, :); 
    end
    % Calcualte statistics for each channel
    try 
        MODEL.max(iFile, :)     = max(data);
        MODEL.mean(iFile, :)    = mean(data);
        MODEL.median(iFile, :)  = median(data);
        MODEL.min(iFile, :)     = min(data);
        MODEL.std(iFile, :)     = std(data);
        MODEL.skewness(iFile, :)= skewness(data);
        MODEL.kurtosis(iFile, :)= kurtosis(data);
    %     MODEL.peaksNum(iFile, :)= peaksNum(data);
        mu = MODEL.mean(iFile, :);
        MODEL.mur(iFile, :)   = up_crossing_rate(data, mu);
    catch ME
    % Create log file
        logFile = fopen(LOGFILENAME,'a');

        fprintf(logFile,'%s\n' ,datetime('now'));
        fprintf(logFile,'%s\n' ,fileName);
%         fprintf(logFile,'%s\n' ,['Error in running function ', method]);
        fprintf(logFile,'%s\n' ,ME.message);
        % Close files
        fclose(logFile);
    end        
end
clearvars  -except MODEL headers statsVars destFilename Nsim NseaStates;
save(destFilename,'MODEL','statsVars','headers')
    %% Counting the number of peaks
%     try
%         npks(iFile, :) = peaksNum(data);
%         
%     catch ME
%         %% Create log file
%         logFile = fopen('logFile','a+');
% 
%         fprintf(logFile,'%s\n' ,datetime('now'));
%         fprintf(logFile,'%s\n' ,fileName);
%         fprintf(logFile,'%s\n' ,'Error in running function peaksNum');
%         fprintf(logFile,'%s\n' ,ME.message);
%         %% Close files
%         fclose(logFile);
%     end
    
    %% Calculate up crossing rate
    
        
% end
% 

%% Save files



%%
% close all
% QoiOuputs = [31,46,15:20,51];
% QoiData = MODEL.max(:, QoiOuputs);
% QoiStats = cell(size(QoiOuputs,2), 1);
% for i = 1 : size(QoiOuputs, 2)
%     data = QoiData(:, i);
%     dataStats = zeros(NseaStates, 3);
%     for iseaState = 1 : NseaStates
%         dataNsim = data( (iseaState -1 )*Nsim + 1: iseaState * Nsim, 1);
% %         if iseaState == 18
% %             dataNsim(6,1) = mean(dataNsim);
% %         end
% %         if iseaState == 21
% %             dataNsim(8,1) = mean(dataNsim);
% %         end
%         if iseaState > 18
%             dataNsim(6,1) = mean(dataNsim);
%         end
%         dataStats(iseaState, 1) = max(dataNsim);
%         dataStats(iseaState, 2) = mean(dataNsim);
%         dataStats(iseaState, 3) = std(dataNsim);
% %         figure
% %         plot(dataNsim);
% %         ylim([0 10e4])
%     end
%     QoiStats{i, 1} = dataStats;
% end
% 
% 
% %% Variability 
% windVel = [3:25];
% windRat = 11.3;
% 
% RootMy = QoiStats{1,1};
% errorbar(windVel,RootMy(:,2),RootMy(:,3),'-s','MarkerSize',8,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% hold on
% rectangle('Position',[11 0 8 7e4],'EdgeColor','g','LineWidth',1)
% xlim([2.5 25.5])
% % hold on
% % plot(ones(1e5,1)*windRat,(0:1e5)');
% title({'E[Y] ± \sigma[Y] at each wind speed', 'Y: Median of 50-yr extreme value distribution'})
% ylabel('RootMy [kN.m]')
% xlabel('Wind speed [m/s]')
% %%
% 
% TwrBsMyt = QoiStats{2,1};
% figure
% errorbar(windVel,TwrBsMyt(:,2),TwrBsMyt(:,3),'-s','MarkerSize',8,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% hold on
% rectangle('Position',[10 0 7 6e5],'EdgeColor','g','LineWidth',1)
% xlim([2.5 25.5])
% % hold on
% % plot(ones(1e5,1)*windRat,(0:1e5)');
% title({'E[Y] ± \sigma[Y] at each wind speed', 'Y: Median of 50-yr extreme value distribution'})
% ylabel('TwrBsMyt [kN.m]')
% xlabel('Wind speed [m/s]')
% 
% 
% %%
% 
% PtfmSurge = QoiStats{3,1};
% figure
% errorbar(windVel,PtfmSurge(:,2),PtfmSurge(:,3),'-s','MarkerSize',8,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% hold on
% rectangle('Position',[9 0 6 25],'EdgeColor','g','LineWidth',1)
% xlim([2.5 25.5])
% % hold on
% % plot(ones(1e5,1)*windRat,(0:1e5)');
% title({'E[Y] ± \sigma[Y] at each wind speed', 'Y: Median of 50-yr extreme value distribution'})
% ylabel('PtfmSurge [m]')
% xlabel('Wind speed [m/s]')
% 
% %%
% 
% PtfmPitch = QoiStats{4,1};
% figure
% errorbar(windVel,PtfmPitch(:,2),PtfmPitch(:,3),'-s','MarkerSize',8,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% hold on
% rectangle('Position',[10 0 7 5],'EdgeColor','g','LineWidth',1)
% xlim([2.5 25.5])
% % hold on
% % plot(ones(1e5,1)*windRat,(0:1e5)');
% title({'E[Y] ± \sigma[Y] at each wind speed', 'Y: Median of 50-yr extreme value distribution'})
% ylabel('PtfmPitch [deg]')
% xlabel('Wind speed [m/s]')
% 
% 
% 
% %%
% 
% TFair = QoiStats{5,1};
% figure
% errorbar(windVel,TFair(:,2),TFair(:,3),'-s','MarkerSize',8,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% hold on
% rectangle('Position',[9 0 6 5e3],'EdgeColor','g','LineWidth',1)
% xlim([2.5 25.5])
% % hold on
% % plot(ones(1e5,1)*windRat,(0:1e5)');
% title({'E[Y] ± \sigma[Y] at each wind speed', 'Y: Median of 50-yr extreme value distribution'})
% ylabel('TFair [kN]')
% xlabel('Wind speed [m/s]')
% 
% 
% %% *********** 50yr Estimates ************
% %%
% QoiOutputsMax = zeros(5,1);
% figure
% for i = 1 : size(QoiOuputs, 2)
% %     QoiStats
%     QoiOutputsMax(i, 1) =  max(QoiStats{i,1}(:,1));
%     plot(windVel, QoiStats{i,1}(:,1) / QoiOutputsMax(i, 1), 'Color', plotColor{i}, 'Marker', plotMarkers{i}); hold on
% end
% legend(['RootMy,      Max: ', num2str(QoiOutputsMax(1, 1)),' ', headers{2, QoiOuputs(1)}],...
%        ['TwrBsMyt,  Max: ', num2str(QoiOutputsMax(2, 1)),' ', headers{2, QoiOuputs(2)}],...
%        ['PtfmSurge, Max: ', num2str(QoiOutputsMax(3, 1)), ' ',headers{2, QoiOuputs(3)}],...
%        ['PtfmPitch,  Max: ', num2str(QoiOutputsMax(4, 1)),' ', headers{2, QoiOuputs(4)}],...
%        ['TFair,         Max: ', num2str(QoiOutputsMax(5, 1)),' ', headers{2, QoiOuputs(5)}],...
%         'Location','southeast')
% xlim([2.5 25.5])
% title({'Max[Y_i] at each wind speed', 'Max[Y_i]: Maxima of N=10 50-year return extreme median values'})
% ylabel('Normalized quantity ')
% xlabel('Wind speed [m/s]')
% 
% %%
% RootMy = QoiStats{1,1};
% errorbar((1:23),RootMy(:,2),RootMy(:,3),'-s','MarkerSize',8,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% hold on
% rectangle('Position',[11 0 7 7e4],'EdgeColor','g','LineWidth',1)
% % hold on
% % plot(ones(1e5,1)*windRat,(0:1e5)');
% title({'E[Y] ± \sigma[Y] at each wind speed', 'Y: Median of 50-yr extreme value distribution'})
% ylabel('RootMy [kN.m]')
% xlabel('Wind speed [m/s]')

















































































