clc;clear all;close all;

model = '13302';
ComputerNo = 1;
MatlabNo   = 1;
% define input file names
% TSinp = '.\Wind\TurbSim13pt2MW.inp'; % TurbSim input filename
FASTfst = 'SNL13pt2_Floating.fst'; % FAST input file name
ADipt = 'SNL13pt2_Floating_AeroDyn.dat'; % AeroDyn input filename
EDipt = 'SNLOffshrBsline13pt2MW_1pt5_ElastoDyn.dat'; % ElastoDyn input filename
HDipt = 'SNLOffshrBsline13pt2MW_1pt5_HydroDyn.dat'; % HydroDyn input filename
SDipt = 'SNL13pt2_Floating_ServoDyn.dat'; % ServoDyn input filename
Windipt = 'NWP.wnd';   % constant wind file

% define output file names
% ADwnd = [TSinp(1:end-4),'.wnd']; % name of wind file (TurbSim output)
FASTout = [FASTfst(1:end-4),'.out']; % FAST output filename
FASTsum = [FASTfst(1:end-4),'.sum']; % FAST summary filename
%% get number of lines in each file for modification
% nLines_TSinp = getnlines(TSinp);
nLines_FASTfst = getnlines(FASTfst);
nLines_ADipt = getnlines(ADipt);
nLines_EDipt = getnlines(EDipt);
nLines_HDipt = getnlines(HDipt);
nLines_Wnd = getnlines(Windipt);
%
%% ************** Define Input Parameters *********************

%---------- FAST input file------------
Tmax = 3800; % total run time, seconds onshore simulation: 10 mins, offshore: one hour
Tuse = Tmax; % length of output of interest
dtFAST=0.01; 
Ntime = floor(Tuse/dtFAST); % length of time series of interest; assume dt = 0.05 sec.
TowerHt = 129.6 ; % (142.4 for 146** model; 129.6 for 133** model )
TowerBsHt = 15.0 ; % 18  when mounted on 1.8 scale platform, 14 when mounted on 1.4 scale platform. 10*lambda.
changeline(FASTfst,6,num2str(Tmax, '% 10.1f'),nLines_FASTfst);     % Total run time
changeline(FASTfst,7,num2str(dtFAST, '% 10.4f'),nLines_FASTfst);   % Step Time


%%
% ----------AeroDyn input File --------
% Wind file name!!!!!!!
HH = TowerHt + 3.19115-8.16114*sind(-5);% Wind reference (hub) height: TowerHt+Twr2Shft+OverHang*SIN(ShftTilt) (m)
% load('WindVel.mat');
WindVel = [9];
changeline(ADipt,11,num2str(HH,     '% 10.4f'),nLines_ADipt);                   % Hub Height
%%
% ------------TurbSim input file-----------
% Reference wind speed
% Uref =[5.1 8.6 12.1 15.6 19.1 22.6];
% load('WindSeed.mat');
% GridHt=280;
% GridWt=280;
% NumGrid_Z=GridHt/10+1;
% NumGrid_Y=GridWt/10+1;
% DtTurbSim=0.1;
% AnalysisTime = Tmax;
% UsableTime = Tmax;
% 
% changeline(TSinp,18,num2str(NumGrid_Z, '% 10.0f'),nLines_TSinp);    % No. of Grids in Z
% changeline(TSinp,19,num2str(NumGrid_Y, '% 10.0f'),nLines_TSinp);    % No. of Grids in Y
% changeline(TSinp,20,num2str(DtTurbSim, '% 10.4f'),nLines_TSinp);    % Time Step
% changeline(TSinp,23,num2str(HH       , '% 10.4f'),nLines_TSinp);    % Hub Height
% changeline(TSinp,36,num2str(HH       , '% 10.4f'),nLines_TSinp);    % Reference Height
% changeline(TSinp,24,num2str(GridHt   , '% 10.0f'),nLines_TSinp);    % Grid Height
% changeline(TSinp,25,num2str(GridWt   , '% 10.0f'),nLines_TSinp);    % Grid Width
% changeline(TSinp,21,num2str(AnalysisTime   , '% 10.1f'),nLines_TSinp);    % AnalysisTime
% changeline(TSinp,22,num2str(UsableTime     , '% 10.1f'),nLines_TSinp);    % UsableTime
% changeline(TSinp,32,' "B" ',nLines_TSinp);                          % IEC Turbulence category "B"

%%
% ----------- ElastoDyn input File------

changeline(EDipt,66,num2str(TowerHt,'% 10.4f'),nLines_EDipt);                   % Tower Height
changeline(EDipt,67,num2str(TowerBsHt,'% 10.4f'),nLines_EDipt);                   % Height of tower base above ground level [onshore] or MSL [offshore] (meters)
%%
%------------HydroDyn input File-----------
WaveMod = 1;
WaveHs = [1.0 2.5 4.0 ];
WaveTp = [7.0 8.0 9.5 ];
% WaveDT  = 0.2;
% WaveHs  = 2; 
% load('WaveFre.mat')
% WaveFre =WaveFre(:,5*(ComputerNo-1)+MatlabNo);
% % WaveFre = 0.002:0.002:0.5;
% WaveTp = 2*pi./WaveFre;
% Wave Random seed
load('WaveSeed.mat'); 
% 
changeline(HDipt,09,num2str(WaveMod, '% 10.0f'),nLines_HDipt);         % WaveMod
changeline(HDipt,11,num2str(Tmax,    '% 10.1f'),nLines_HDipt);         % WaveTMax    - Analysis time for incident wave calculations (sec)



% Allocate FAST output
%Nsim = length(Uref);
% Nsim = size(WaveFre,1);
%%

% WindVel =WindVel(:,5*(ComputerNo-1)+MatlabNo);
for r=1:length(WindVel)
%     v=Uref(r);
%     WH=Hs(r);
%     WT=Tp(r);
%     TSSeed=TSSeedHigh(:,:,r);
%     WaveSeed=WaveSeedHigh(:,:,r);
for i=1:size(WaveHs,2)
    
    disp(['Simulation for model   ',model])
    disp([ 'Wind Velocity  ', num2str(WindVel(r)), 'm/s'])
    disp([ 'WaveHs  ', num2str(WaveHs(i)), 'm'])
    disp([ 'WaveTp  ', num2str(WaveTp(i)), 's'])
    fprintf('\n')
    % TurbSim input file
%
% changeline(TSinp,4,num2str(WindSeed(i,1), '% 10.0f'),nLines_TSinp);   % 1st random windseed
% changeline(TSinp,5,num2str(WindSeed(i,2), '% 10.0f'),nLines_TSinp);   % 1st random windseed

changeWindLine (Windipt,17,num2str(WindVel(r),'% 10.2f'),nLines_Wnd);

% changeline(TSinp,37,num2str(v, '% 10.1f'),nLines_TSinp);         % Uref


% FAST input file


% HydroDyn input file

changeline(HDipt,23,num2str(WaveSeed(i,1), '% 10.0f'),nLines_HDipt);% 1st random waveseed
changeline(HDipt,24,num2str(WaveSeed(i,2), '% 10.0f'),nLines_HDipt);% 2nd random waveseed
changeline(HDipt,13,num2str(WaveHs(i), '% 10.2f'),nLines_HDipt);% WaveHs
changeline(HDipt,14,num2str(WaveTp(i), '% 10.6f'),nLines_HDipt);% WaveTp

% TurbSim
% !.\Wind\Turbsim64.exe .\Wind\Turbsim13pt2MW.inp

% FAST
!FAST_Win32.exe SNL13pt2_Floating.fst

% Save Data
[s, mess, messid] = mkdir('..', 'OffShr_Results');
Parentfoler = fileparts(pwd);
name=[Parentfoler,'\OffShr_Results\', 'SNL_13pt2MW_OffShr_',model,'Uref_',num2str(WindVel(r),'%10.1f'),'_',num2str(WaveHs(i),'%10.2f'),'.mat'];

temp = hdrload(FASTout);
[outlist,unit]=getoutlist(FASTsum);
data = temp(:,:); 
% name=['SNL_13pt2MW_1pt4_14602_600_RAO_Omega_',num2str(WaveFre(r),'%10.4f'),'.mat'];
save(name,'data','WindVel','outlist','unit');
end
end
% end
