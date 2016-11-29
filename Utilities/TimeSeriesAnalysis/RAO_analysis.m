clear all;clc;
delta_t = 0.02;
transient = 1000;
start = transient/ delta_t +1;
omega = 0.01:0.01:0.3;
for i = 1 :size(omega,2)
    
    fid = ['SNLOfshr_1pt8_RAO',num2str(omega(i),'%3.2f'),'.mat']
    load(fid)
    data = data(start:end,:);
    steadystate(i,:) = abs(max(data)-mean(data));
    
end
%%
for i = 16
    figure
    plot(omega,steadystate(:,i))
    title(outlist(i))
end