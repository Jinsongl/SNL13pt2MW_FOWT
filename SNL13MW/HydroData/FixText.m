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
    if index(i)==2&&Dir(i)==0
        C{5}= sprintf('%d',0);
    end
end


