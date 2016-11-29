clc; clear all;
fileID = 'SNL13pt2_Floating_RAOWN.out';
data = hdrload(fileID);
%%
outlist = getoutlist([fileID(1:end-10),'.sum']);
%%
index1 = find(data(:,1)==2000);
index2 = find(data(:,1)==6000);
Motions = data(index1:index2,12:17);
Ylabels = outlist(12:17);
WaveElv = data(index1:index2,20);
NFFT = 2^nextpow2(length(WaveElv));
%%
delta_t = data(2,1)-data(1,1);
fs = 1/ delta_t;
[Pxx,f] = pwelch(WaveElv,[],[],NFFT,fs);
% [Pxx,f] = pwelch(WaveElv);
figure

for i = 1 : 3
    
    CPSD(:,2*i-1) = cpsd(WaveElv, Motions(:,2*i-1),[],[],NFFT,fs);
%     CPSD(:,2*i-1) = cpsd(WaveElv, Motions(:,2*i-1));
    RAO(:,2*i-1) = abs(CPSD(:,2*i-1)./Pxx);
    subplot(3,1,i)                                                                                              
    plot(f,RAO(:,2*i-1))
    grid on
    xlabel('Frequency [Hz]')
    ylabel(['RAO(',strtrim(Ylabels{2*i-1}),')'])
    xlim([0 1.0])
end
    

%%
% Y = fft(WaveElv,NFFT)/length(WaveElv);
% fs = fs/2.*linspace(0,1,NFFT/2+1);
% figure
% plot(fs,2.*abs(Y(1:NFFT/2+1)))