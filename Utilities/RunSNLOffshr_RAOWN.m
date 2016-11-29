clc;clear all;close all;

% This script is for Rigid RAO simulation, following parameters are to be set:
% ****  .fst:    
%       0: CompAero 
%       1: Elast, Servo, Hydro, Mooring
% ****  ElastoDyn.dat:
%       DOF False except 6 ptfm dofs.
% ****  HydroDyn.dat:
%       WaveMod: 3 white noise
%       WaveHs = any
%       WaveTMax: 3600
%       WaveDT:0.2
%       WvLowCOff : 0
%       WvHiCoff : 10
%       WaveNDAmp: Flase
model = '13302';
message = [' White-Noise RIGID body RAO simulation for model ', model];
msgbox(message);
fprintf(message)
disp(message)
disp(' Modified by Jinsong Liu on 6/8/2015')
%%

% computerNo = 2;
% matlabNo   = 3;

% Nsim = 10;       % Number of simulation for each steady state wind states. 
% load('WaveFre.mat')
% define input file names
% TSinp = '.\Wind\TurbSim13pt2MW.inp'; % TurbSim input filename
FASTfst = 'SNL13pt2_Floating.fst'; % FAST input file name
ADipt = 'SNL13pt2_Floating_AeroDyn.dat'; % AeroDyn input filename
EDipt = 'SNLOffshrBsline13pt2MW_1pt5_ElastoDyn.dat'; % ElastoDyn input filename
HDipt = 'SNLOffshrBsline13pt2MW_1pt5_HydroDyn.dat'; % HydroDyn input filename
SDipt = 'SNL13pt2_Floating_ServoDyn.dat'; % ServoDyn input filename
% Windipt = 'NWP.wnd';   % constant wind files


% define output file names
% ADwnd = [TSinp(1:end-4),'.wnd']; % name of wind file (TurbSim output)
FASTout = [FASTfst(1:end-4),'.out']; % FAST output filename
FASTsum = [FASTfst(1:end-4),'.sum']; % FAST summary filename
%
% get number of lines in each file for modification
% nLines_TSinp = getnlines(TSinp);
nLines_FASTfst = getnlines(FASTfst);
nLines_ADipt = getnlines(ADipt);
nLines_EDipt = getnlines(EDipt);
nLines_HDipt = getnlines(HDipt);
% nLines_Wnd = getnlines(Windipt);


%% ************** Define Input Parameters *********************
CompAero        = 0;
CompHydro       = 1;
CompMooring     = 1;

TowerHt = 129.6 ; % (142.4 for 146** model; 129.6 for 133** model )
TowerBsHt = 15.0 ; % 18  when mounted on 1.8 scale platform, 14 when mounted on 1.4 scale platform. 10*lambda.

%---------- FAST input file------------
Tmax = 6000; % total run time, seconds onshore simulation: 10 mins, offshore: one hour
Tuse = Tmax; % length of output of interest
dtFAST=0.01; 
DT_Out = dtFAST;
Ntime = floor(Tuse/DT_Out); % length of time series of interest; 

changeline(FASTfst,14,num2str(CompAero,    '% 10.0f'),nLines_FASTfst);     % Compute aerodynamic loads (switch) {0=None; 1=AeroDyn}
changeline(FASTfst,16,num2str(CompHydro,   '% 10.0f'),nLines_FASTfst);     % Compute hydrodynamic loads (switch) {0=None; 1=HydroDyn}
changeline(FASTfst,18,num2str(CompMooring, '% 10.0f'),nLines_FASTfst);     % Compute mooring system (switch) {0=None; 1=MAP; 2=FEAMooring}

changeline(FASTfst,6,num2str(Tmax, '% 10.1f'),nLines_FASTfst);     % Total run time
changeline(FASTfst,7,num2str(dtFAST, '% 10.4f'),nLines_FASTfst);   % Step Time
changeline(FASTfst,36,num2str(DT_Out, '% 10.4f'),nLines_FASTfst);   %Time step for tabular output (s)

disp([' Tower Model : ', model])
disp([' Tower Height : ', num2str(TowerHt)])

%%
% ----------AeroDyn input File --------
% Wind file name!!!!!!!
HH = TowerHt + 3.19115-8.16114*sind(-5);% Wind reference (hub) height: TowerHt+Twr2Shft+OverHang*SIN(ShftTilt) (m)
% load('WindVel.mat');
% WindVel = [9];
changeline(ADipt,11,num2str(HH,     '% 10.4f'),nLines_ADipt);                   % Hub Height
%%
% ----------- ElastoDyn input File------

h = msgbox('Make sure Only Ptfm 6 DOFs are TURE in ElastoDyn file');
changeline(EDipt,66,num2str(TowerHt,'% 10.4f'),nLines_EDipt);                     % Tower Height
changeline(EDipt,67,num2str(TowerBsHt,'% 10.4f'),nLines_EDipt);                   % Height of tower base above ground level [onshore] or MSL [offshore] (meters)

%%
%------------HydroDyn input File-----------
WaveMod = 3;    % Incident wave kinematics model {0: none=still water, 
                % 1: regular (periodic), 1P#: regular (periodic) with user-specified phase, 
                % 2: JONSWAP/Pierson-Moskowitz spectrum (irregular), 3: White noise spectrum (irregular),
                % 4: user-defined spectrum from routine UserWaveSpctrm (irregular),
                % 5: GH Bladed wave data [option 5 is invalid for HasWAMIT = TRUE]} (switch)

% WaveDT  = 0.2;

% load('WaveFre.mat')
% WaveFre =WaveFre(2*matlabNo-1:2*matlabNo,computerNo);
% disp(num2str(WaveFre(1)));
% disp(num2str(WaveFre(2)));
% % WaveFre = 0.002:0.002:0.5;
% WaveTp = 2*pi./WaveFre;
% Wave Random seed
% load('WaveSeed.mat'); 
WaveHs  = 6;  % Significant wave height of incident waves (meters) 
WaveTmax   = 3600; % Analysis time for incident wave calculations
WaveDT     = 0.2 ; % Time step for incident wave calculations
WvLowCOff = 0; % Low  frequency cutoff used in the difference-frequencies 
WvHiCoff   = 10;  % High frequency cutoff used in the difference-frequencies (rad/s)
WaveNDAmp  = 'False';

changeline(HDipt,09,num2str(WaveMod, '% 10.0f')   ,nLines_HDipt);         % WaveMod
changeline(HDipt,11,num2str(Tmax,    '% 10.3f')   ,nLines_HDipt);         % WaveTMax    - Analysis time for incident wave calculations (sec)
changeline(HDipt,13,num2str(WaveHs,  '% 10.3f')   ,nLines_HDipt);         %Significant wave height of incident waves (meters)
changeline(HDipt,16,num2str(WvLowCOff,  '% 10.3f'),nLines_HDipt);         %Significant wave height of incident waves (meters)
changeline(HDipt,17,num2str(WvHiCoff,  '% 10.3f') ,nLines_HDipt);         %Significant wave height of incident waves (meters)
changeline(HDipt,25,WaveNDAmp                     ,nLines_HDipt);         %Significant wave height of incident waves (meters)

disp( ' Summary for HydroDyn inputs: ')
disp([' Wave Mode: ', num2str(WaveMod)]);
disp([' Wave Height: ', num2str(WaveHs)]);
disp([' Analysis time for incident wave calculations--WaveTMax: ', num2str(WaveTmax)]);

% FAST
!FAST_Win32.exe SNL13pt2_Floating.fst


% Save Data
[s, mess, messid] = mkdir('..', 'OffShr_Results');
Parentfoler = fileparts(pwd);
name=[Parentfoler,'\OffShr_Results\', 'SNL_13pt2MW_OffShr_',model,'_RAO_WN.mat'];

temp = hdrload(FASTout);
[outlist,unit]=getoutlist(FASTsum);
data(:,:) = temp(:,:); 
% name=['SNL_13pt2MW_1pt4_14602_600_RAO_Omega_',num2str(WaveFre(r),'%10.4f'),'.mat'];
save(name,'data','outlist','unit');

