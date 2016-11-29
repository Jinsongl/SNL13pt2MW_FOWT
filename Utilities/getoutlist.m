function [outlist,units]=getoutlist(file)
% file='SNL13pt2_Floating.sum';
fid=fopen(file);
nLines=0;
while (fgets(fid) ~= -1),
    nLines = nLines+1;
end
fclose(fid);
fid=fopen(file);
l=0;i=1;s=0;flag=0;
% outlist={'Time'};
while ~feof(fid)
    line   = fgetl( fid );
    if isempty(line)
        continue
    end
    if flag==1
        if isempty(line)
            continue
        end
        outlist{i}=line(11:22);
        units{i} = line(23:33);
        i=i+1;
    end
    if strcmp(line(4:12),'Requested')
        line=fgetl(fid);
        line=fgetl(fid);
        if strcmp(line(3:8),'Number')
            flag=1;
        end
        line=fgetl(fid);
    end
end
end