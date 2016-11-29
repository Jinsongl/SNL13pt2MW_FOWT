clc;clear all;close all;

model = '13302';
computerNo = 2;
matlabNo   = 3;

Nsim = 10;       % Number of simulation for each steady state wind states. 
load('WaveFre.mat')
% define input file names
% TSinp = '.\Wind\TurbSim13pt2MW.inp'; % TurbSim input filename
FASTfst = 'SNL13pt2_Floating.fst'; % FAST input file name
ADipt = 'SNL13pt2_Floating_AeroDyn.dat'; % AeroDyn input filename
EDipt = 'SNLOffshrBsline13pt2MW_1pt5_ElastoDyn.dat'; % ElastoDyn input filename
HDipt = 'SNLOffshrBsline13pt2MW_1pt5_HydroDyn.dat'; % HydroDyn input filename
% SDipt = 'SNL13pt2_Floating_ServoDyn.dat'; % ServoDyn input filename
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

%---------- FAST input file------------
Tmax = 1; % total run time, seconds onshore simulation: 10 mins, offshore: one hour
Tuse = Tmax; % length of output of interest
dtFAST=0.01; 
DT_Out = dtFAST;
Ntime = floor(Tuse/dtFAST); % length of time series of interest; assume dt = 0.05 sec.
TowerHt = 129.6 ; % (142.4 for 146** model; 129.6 for 133** model )
TowerBsHt = 15.0 ; % 18  when mounted on 1.8 scale platform, 14 when mounted on 1.4 scale platform. 10*lambda.
changeline(FASTfst,6,num2str(Tmax, '% 10.1f'),nLines_FASTfst);     % Total run time
changeline(FASTfst,7,num2str(dtFAST, '% 10.4f'),nLines_FASTfst);   % Step Time
changeline(FASTfst,36,num2str(DT_Out, '% 10.4f'),nLines_FASTfst);   %Time step for tabular output (s)
%%
% ----------AeroDyn input File --------
% Wind file name!!!!!!!
HH = TowerHt + 3.19115-8.16114*sind(-5);% Wind reference (hub) height: TowerHt+Twr2Shft+OverHang*SIN(ShftTilt) (m)
% load('WindVel.mat');
% WindVel = [9];
changeline(ADipt,11,num2str(HH,     '% 10.4f'),nLines_ADipt);                   % Hub Height
%%
% ----------- ElastoDyn input File------

changeline(EDipt,66,num2str(TowerHt,'% 10.4f'),nLines_EDipt);                   % Tower Height
changeline(EDipt,67,num2str(TowerBsHt,'% 10.4f'),nLines_EDipt);                   % Height of tower base above ground level [onshore] or MSL [offshore] (meters)

%%
%------------HydroDyn input File-----------
WaveMod = 1;
% WaveHs = [1.0 2.5 4.0 ];
% WaveTp = [7.0 8.0 9.5 ];
% WaveDT  = 0.2;
WaveHs  = 2; 
% load('WaveFre.mat')
% WaveFre =WaveFre(2*matlabNo-1:2*matlabNo,computerNo);
% disp(num2str(WaveFre(1)));
% disp(num2str(WaveFre(2)));
% % WaveFre = 0.002:0.002:0.5;
% WaveTp = 2*pi./WaveFre;
% Wave Random seed
% load('WaveSeed.mat'); 
% 
changeline(HDipt,09,num2str(WaveMod, '% 10.0f'),nLines_HDipt);         % WaveMod
changeline(HDipt,11,num2str(Tmax,    '% 10.1f'),nLines_HDipt);         % WaveTMax    - Analysis time for incident wave calculations (sec)
changeline(HDipt,13,num2str(WaveHs,  '% 10.0f'),nLines_HDipt);         %Significant wave height of incident waves (meters)


%% Define Wave Frequency
WaveFre = [0.25];
WaveTp = 2*pi./WaveFre;
%%
data = zeros(Tmax/dtFAST + 1, 47, Nsim);
for r=1:size(WaveTp,2)
    changeline(HDipt,14,num2str(WaveTp(r), '% 10.2f'),nLines_HDipt);        % WaveTp
    for i = 1 : Nsim
        disp(['RAO Simulation for model   ',model, '  **** Simulation Number: ', num2str(i)])
    %     disp([ 'Wind Velocity  ', num2str(WindVel(r)), 'm/s'])
        disp([ 'WaveHs  ', num2str(WaveHs), 'm'])
        disp([ 'WaveTp  ', num2str(WaveTp(r)), 's'])
        fprintf('\n')
    
        % TurbSim
        % !.\Wind\Turbsim64.exe .\Wind\Turbsim13pt2MW.inp

        % FAST
        !FAST_Win32.exe SNL13pt2_Floating.fst


        % Save Data
        [s, mess, messid] = mkdir('..', 'OffShr_Results');
        Parentfoler = fileparts(pwd);
        name=[Parentfoler,'\OffShr_Results\', 'SNL_13pt2MW_OffShr_',model,'_RAO_',num2str(WaveFre(r),'%10.3f'),'.mat'];

        temp = hdrload(FASTout);
        [outlist,unit]=getoutlist(FASTsum);
        data(:,:,i) = temp(:,:); 
        % name=['SNL_13pt2MW_1pt4_14602_600_RAO_Omega_',num2str(WaveFre(r),'%10.4f'),'.mat'];
        save(name,'data','outlist','unit');
    end
end
% end
