%% This script is used to run a series of TurbSim + FAST simulations. 
% Input files refer to FAST / TurbSim User's manual
% 
% Output results file types and directory.
% Created By Jinsong Liu, July 7 2015)
% MUSE Program, UT Austin)
% FAST_v8.09)
% Last modification: Oct 11 2016, by Jinsong Liu
% parallel programming.???
clc;clear;close all;
addpath('.\SNL13MW')
addpath('.\Utilities')
%% Define environment conditions
load('SEEDS.mat')
% load('Norway5.mat')
load('EC2DGrid.mat')
disp('**********  Environment Conditions  **********')
disp(['Location: ', site])
disp('Physical random variables:')
disp(varNames)
% windVel = phyRvs(:,1);
% waveHs  = phyRvs(:,2);
% waveTp  = phyRvs(:,3);
%% Define Model Properties
disp('**********  Model Summaries  **********')
MODEL_NAME      = 'SNLOffshrBsline13pt2MW';
MODEL_FOLDER    = 'SNL13MW\';
MOORING_MODEL   = '300';
WORKDIR = pwd;
mkdir(['D:\SNL13MW\SNLOffshrBsline13pt2MW_EC2DGrid\MOORING',MOORING_MODEL]);
OUTDIR          = ['D:\SNL13MW\SNLOffshrBsline13pt2MW_EC2DGrid\MOORING',MOORING_MODEL];
disp(['Wind turbine model:      ', MODEL_NAME]);
disp(['Mooring line model:      ', MOORING_MODEL]);

%% Simulation control
% Predefined simulation parameters
Tmax        = 14;             % total run time, seconds onshr: 10 mins, offshr: one hour
seaStates   = [1:2];
seedSelect  = [1];
waveDirs    = [0];%[0, 30, 60, 90]; % Incident wave propagation heading direction (degrees) 

disp(['Number of simulatoin:    Nsim = ', num2str(size(seedSelect, 2))]);
disp(['Total simulation time:   Tmax = ', num2str(Tmax)]);
disp(['Wave directions(deg):    ', num2str(waveDirs')]);

% input files
FASTfst = [MODEL_NAME,'.fst'];                          % FAST input --main
TSinp   = ['SNL13MW\Wind\', MODEL_NAME, '_Wind.inp'];               % TurbSim wind
ADipt   = [MODEL_FOLDER, MODEL_NAME, '_AeroDyn.dat'];               % AeroFile
EDipt   = [MODEL_FOLDER, MODEL_NAME, '_ElastoDyn.dat'];             % Elastro dynamic
HDipt   = [MODEL_FOLDER, MODEL_NAME, '_HydroDyn.dat'];              % Hydrodynamic
MAPipt  = [MODEL_FOLDER, MODEL_NAME, '_MAP', MOORING_MODEL, '.dat'];% Mooring

% number of lines for each input control files
nLines_FASTfst  = getnlines(FASTfst);
nLines_TSinp    = getnlines(TSinp);
nLines_ADipt    = getnlines(ADipt);
nLines_EDipt    = getnlines(EDipt);
nLines_HDipt    = getnlines(HDipt);
% nLines_Wnd      = getnlines(Windipt);

% output files
ADwnd   = [TSinp(9:end-4),  '.wnd'];    % name of wind file (TurbSim output)
FASTout = [FASTfst(1:end-4),'.out'];    % FAST output filename
FASTsum = [FASTfst(1:end-4),'.sum'];    % FAST summary filename


%% Change Input Parameters
%---------- FAST primary input file------------
changeline(FASTfst,6,   num2str(Tmax, '% 10.1f'),nLines_FASTfst);   % Total run time
changeline(FASTfst,31,  ['"',MAPipt,'"']        ,nLines_FASTfst);   % Mooring file
%---------- AeroDyn input File --------
changeline(ADipt,10,    ['"',ADwnd,'"']         ,nLines_ADipt);     % Wind file from TurbSim
%---------- TurbSim input File --------
changeline(TSinp,21,    num2str(Tmax, '% 10.1f'),nLines_TSinp);     % Length of analysis time series
changeline(TSinp,22,    num2str(Tmax, '% 10.1f'),nLines_TSinp);     % Usable length of output time series
%%
for iseaState = 1:size(seaStates,2) %  1 : 10 : size(windVel, 1) %
    windVel = phyRvs(seaStates(1, iseaState),1);
    waveHs  = phyRvs(seaStates(1, iseaState),2);
    waveTp  = phyRvs(seaStates(1, iseaState),3);

%     disp(['Wind Velocity    ', num2str(windVel(iseaState)), 'm/s'])
    for iwaveDir = 1 : size(waveDirs, 2)
        waveDir = waveDirs(1, iwaveDir);
        changeline(HDipt,18,num2str(waveDir       , '% 10.2f'),nLines_HDipt);% 
        for iseed = 1: size(seedSelect, 2);
            seed = seedSelect(iseed);
%             if (iseaState == 17) && (waveDir == 90)
%                 continue;
%             end
%             if (iseaState == 21) && (waveDir == 30)
%                 continue;
%             end
            disp(['>>>>>>>>>>> Number of Simulation : ', num2str(seed),'<<<<<<<<<<<<<'])
            disp(['Working Directory:       ', WORKDIR(end-7:end)])
            disp(['Mooring line model:      ', MOORING_MODEL]);
            disp(['Wind Velocity    ', num2str(windVel), 'm/s'])
            disp(['wave direction:  ', num2str(waveDir), 'deg'])
            disp(['waveHs:          ', num2str(waveHs),  'm'])
            disp(['waveTp:          ', num2str(waveTp),  's'])
%             outfileName = [MODEL_NAME,MOORING_MODEL, num2str(iseaState, '%02.0f'),num2str(waveDir, '%02.0f'), num2str(iSim, '%02.0f'),'.mat'];
            outfileName = [MODEL_NAME,MOORING_MODEL, num2str(waveDir, '%02.0f'), num2str(seaStates(1, iseaState), '%02.0f'), num2str(seed, '%02.0f'),'.mat'];
    %**************constnat wind profile*******************
    %     changeline(ADipt,10, ['"',Windipt,'"'] ,nLines_ADipt);  % Change to const wind file
    %     changeWindLine (Windipt,4,num2str(windVel(DLC),'% 10.2f'),nLines_Wnd);
    %     changeWindLine (Windipt,5,num2str(windVel(DLC),'% 10.2f'),nLines_Wnd);
    %     changeWindLine (Windipt,6,num2str(windVel(DLC),'% 10.2f'),nLines_Wnd);
    %************** TurbSim input file*******************
            changeline(TSinp,4, num2str(SEEDS(seed,1), '% 10.0f'),nLines_TSinp);        % 1st random windseed
            changeline(TSinp,5, num2str(SEEDS(seed,2), '% 10.0f'),nLines_TSinp);        % 1st random windseed
            changeline(HDipt,23,num2str(SEEDS(seed,3), '% 10.0f'),nLines_HDipt);        % 1st random waveseed
            changeline(HDipt,24,num2str(SEEDS(seed,4), '% 10.0f'),nLines_HDipt);        % 2nd random waveseed
            changeline(TSinp,37,num2str(windVel, '% 10.2f'),nLines_TSinp);  % Uref
            changeline(HDipt,13,num2str(waveHs,  '% 10.2f'),nLines_HDipt);  % waveHs
            changeline(HDipt,14,num2str(waveTp,  '% 10.2f'),nLines_HDipt);  % waveTp
            % Run TurbSim
            command = ['SNL13MW\Wind\TurbSim.exe SNL13MW\Wind\',MODEL_NAME,'_Wind.inp'];
            system(command);
            % Run FAST
            command = ['FAST_Win32.exe ', MODEL_NAME, '.fst'];
            system(command);
            % Save Datamkdir(['D:\SNL13MW\', MODEL_NAME],['MOORING',MOORING_MODEL]);
            OutputDir = [OUTDIR,'\', outfileName];
            
            data = hdrload([MODEL_NAME,'.out']);
            [outlist,units]=getoutlist([MODEL_NAME, '.sum']); 
            save(OutputDir,'data','outlist','units');
            command = ['C:\software\gdrive.exe upload -p 0BymogEaRlu2lSGtTOU1kZzZKRzQ',' ', OutputDir];
            system(command)
       
        end
    end
end
delete([MODEL_NAME,'.out']);
% setpref('Internet','E_mail','jinsongliu@utexas.edu');
% setpref('Internet','SMTP_Server','smtp.gmail.com');
% sendmail('jinsongliu@utexas.edu', [num2str(seaStates(1,1)), ' - ', num2str(seaStates(1,end)), ' Done!'], 'uploaded')