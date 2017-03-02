function plot_rawdata(parameters, filenames)
%% imports and erases any cells that are empty

% preallocating array space
TOF = cell(1, length(parameters));
Ext = cell(1, length(parameters));
Green = cell(1, length(parameters));
Red = cell(1, length(parameters));
Yellow = cell(1, length(parameters));

% imports arrays
for i=1:length(parameters)
   TOF{i} = import_TOF(filenames{i});
   Ext{i} = import_Extinction(filenames{i});
   Green{i} = import_Green(filenames{i});
   Red{i} = import_Red(filenames{i});
   Yellow{i} = import_Yellow(filenames{i});
end

%% erases empty cells (deletes any values not containing a number)
fh = @(x) all(isnan(x(:)));

TOF(cellfun(fh, TOF)) = [];
Ext(cellfun(fh, Ext)) = [];
Green(cellfun(fh, Green)) = [];
Red(cellfun(fh, Red)) = [];
Yellow(cellfun(fh, Yellow)) = [];

%% gets rid of blank cells by converting to cell arrays
% first line of each block is for preallocating

TOF1 = cell(1, length(TOF));
for k = 1:length(TOF);
TOF1{1,k} = num2cell(TOF{1,k});
TOF1{1,k}(cellfun(fh, TOF1{1,k})) = [];
end

Ext1 = cell(1, length(Ext));
for k = 1:length(Ext);
Ext1{1,k} = num2cell(Ext{1,k});
Ext1{1,k}(cellfun(fh, Ext1{1,k})) = [];
end

Green1 = cell(1, length(Green));
for k = 1:length(Green);
Green1{1,k} = num2cell(Green{1,k});
Green1{1,k}(cellfun(fh, Green1{1,k})) = [];
end

Red1 = cell(1, length(Red));
for k = 1:length(Red);
Red1{1,k} = num2cell(Red{1,k});
Red1{1,k}(cellfun(fh, Red1{1,k})) = [];
end
 
Yellow1 = cell(1, length(Yellow));
for k = 1:length(Yellow);
Yellow1{1,k} = num2cell(Yellow{1,k});
Yellow1{1,k}(cellfun(fh, Yellow1{1,k})) = [];
end
%% returns cell arrays to matrices for compatability with plotting
% need to extend for the rest of the parameters

for k = 1:length(TOF1);
TOF2{1,k} = cell2mat(TOF1{1,k});
%[TOF2{1,k}] = deleteoutliers(TOF2{1,k});
end


for k = 1:length(Ext1);
Ext2{1,k} = cell2mat(Ext1{1,k});
%[Ext2{1,k}] = deleteoutliers(Ext2{1,k});
end

%% plots TOF v EXT raw data for each file - asks what dimensions for subplot
%ask which parameters to plot against?

prompt1 = 'How many rows in raw data subplots?';
prompt2 = 'How many columns in raw data subplots?';

subplotrows = input(prompt1,'s');
subplotcol = input(prompt2,'s');

subplotrows = str2double(subplotrows);
subplotcol = str2double(subplotcol);

figure()
    
for hh = 1:length(parameters);
    subplot (subplotrows,subplotcol,hh);
    plot(TOF2{1,hh},Ext2{1,hh},'bo','Color','blue')
    xlim([0 1600]); %set axes lengths here
    ylim([0 900]);
end
end