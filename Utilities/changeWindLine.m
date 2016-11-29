function changeWindLine(filename,linenum,WindVel,Nlines)
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


for iline = 1:Nlines
    if (iline == linenum)
        % this reads the line# in the text file and change it
        clear char_cell char_str
        FiveCol = textscan(fidin,'%s%s',1); % read file with for '%s' = string (format); N = 1: use this type of format N times

%         Time     = num2str(Time);
        WindVel  = num2str(WindVel);
        
%         newval_X = num2str(newval_X);
%         newval_Y = num2str(newval_Y);
%         newval_Z = num2str(newval_Z);
%         FiveCol{3}{1} = Time ;
        FiveCol{2}{1} = WindVel ;
%         FiveCol{5}{1} = newval_Z ;

        newval = [char(FiveCol{1}),'  ',char(FiveCol{2}),' '];
        fprintf(fidout,'%s ',newval);
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

