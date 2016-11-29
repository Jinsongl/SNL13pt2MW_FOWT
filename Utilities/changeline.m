function changeline(filename,linenum,newval,Nlines)
% read TurbSim/FAST/AeroDyn input file and modify the value at line linenum
%arg#1: filename: name of text file to modify, string type, 
%    for example: filename = '750kW55m.inp';
%arg#2: linenum: line number, integer
%    for example: linenum = 37;
%arg#3: newval: new value to write, string type
%    for example: num2str(12.0, '% 10.1f');
%arg#4: Nlines: number of lines of the text file, integer
%    for example: Nlines = 66;

% input file
infile = filename;
fidin = fopen(infile, 'r');    %open file for 'r' = reading

% output file
outfile = 'tempfile.tmp';
fidout = fopen(outfile, 'w');  %open file for 'w' = writing

% number of lines in the input file
%Nlines = 195; % for FAST input file (varies with # of output variables)
%Nlines = 44; % for AeroDyn input file (varies with # of BldNodes)
%Nlines = 66; % for TurbSim input file
%Uref_new = '25.0';
for iline = 1:Nlines
    if (iline == linenum)
        % this reads the line# in the text file and change it
        clear char_cell char_str
        textscan(fidin,'%s',1); % read file with for '%s' = string (format); N = 1: use this type of format N times
        fprintf(fidout,'%s                ',newval);
        clear char_cell char_str
        char_cell = textscan(fidin,'%s',1,'delimiter','\n');
        char_str = char(char_cell{1});
        fprintf(fidout,'%s\n',char_str);        
    else % simple copy all other lines
        clear char_cell char_str
        char_cell = textscan(fidin,'%s',1,'delimiter','\n'); % Read formatted data from text file into cell array
        char_str = char(char_cell{1});     % Convert to character array (string)
        fprintf(fidout,'%s\n',char_str);   % \n change next to line
    end;
end

fclose all;

%delete(infile);
copyfile(outfile,infile,'f');
delete(outfile);

fclose all;

