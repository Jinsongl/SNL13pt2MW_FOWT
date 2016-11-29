%function pX=extractX()
file='snl_semi.3';
fid=fopen(file);
C=textscan(fid, '%f%f%d8%f%f%f%f');
%%
Tp=C{1};
Dir=C{2};
index=C{3};
X=C{4};
Ph=C{5};

c=1;
for i=1:length(index)
    if index(i)==1&&Dir(i)==0
        w5(c,1)=Tp(i)/2/pi;
        X5(c,1)=X(i)*1025*9.81;
        Ph5(c,1)=Ph(i);
        c=c+1;
    end
end

pX=polyfit(w5,X5,20);
X5est=polyval(pX,w5);
pPh=polyfit(w5,Ph5,20);
Ph5est=polyval(pPh,w5);
figure;
plot(w5,X5,'.',w5,X5est);title('Wave Excitation Force');
xlabel('Frequency (rad/s)');ylabel('Wave Excitation Force (N-m)');
figure;
plot(w5,Ph5,'.',w5,Ph5est);title('Phase');
xlabel('Frequency (rad/s)');ylabel('Phase (deg)');
%