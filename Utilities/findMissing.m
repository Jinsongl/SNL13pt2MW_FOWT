clc; clear; close all;
%% Get the dataFiles to analyse
pattern = 'SNLOffshrBsline13pt2MW300\w*.mat';
files = dir('.');
files = regexpi({files.name}, pattern, 'match');
% Remove empty string cells and convert dataFiles to a string cell
files = files(~cellfun('isempty', files));
waveDirs = [0,30, 60, 90]';
NseaStates = 23;
Nsim = 30;
dataStatus = zeros(NseaStates * size(waveDirs, 1), Nsim);

for i = 1 : size(files,2)
    fileName    = files{i}{1};
    iseaState   = str2double(fileName(end-9: end-8));
    iwaveDir     = str2double(fileName(end-7: end-6))/30 +1;
    iSim        = str2double(fileName(end-5: end-4));
    dataStatus((iseaState-1) * 4 + iwaveDir, iSim) = 1;
end
