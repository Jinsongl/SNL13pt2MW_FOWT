function nLines = getnlines(filename)
fid = fopen(filename);
nLines = 0;
while (fgets(fid) ~= -1),
  nLines = nLines+1;
end
fclose(fid);
