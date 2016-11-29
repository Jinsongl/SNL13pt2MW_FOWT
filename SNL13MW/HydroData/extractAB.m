%function [pA,pB,A0]=extractAB(file)
file='snl_semi.1';
fid=fopen(file);
C=textscan(fid, '%f%d8%d8%f%f');
%%
Tp=C{1};
index=[C{2},C{3}];
A=C{4};
B=C{5};

c=1;
for i=1:length(index)
    if index(i,1)==5 && index(i,2)==5
        if Tp(i)<0
            A0=A(i)*1025;
            continue;
        end
        if Tp(i)<=0||B(i)<0
            continue;
        end
        w5(c,1)=Tp(i)/2/pi;
        B5(c,1)=B(i)*1025*w5(c,1);
        A5(c,1)=A(i)*1025;
        c=c+1;
    end
end

pA=polyfit(w5,A5,20);
pB=polyfit(w5,B5,20);
A5est=polyval(pA,w5);
B5est=polyval(pB,w5);

figure;
plot(w5,A5,'.',w5,A5est);title('Added Mass');
xlabel('Frequency (rad/s)');ylabel('Added Mass (kg m^2)');
figure;
plot(w5,B5,'.',w5,B5est);title('Damping');
xlabel('Frequency (rad/s)');ylabel('Damping (kg-m/s)');
%end