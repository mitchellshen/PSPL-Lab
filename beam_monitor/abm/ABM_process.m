clc; clear all; close all; format long;

% INPUT dates
yr  = 24; % year  of ABM data recorded
mon = 10; % month of ABM data recorded
day = 24; % day   of ABM data recorded
filenum_max = 2; % files of ABM data recorded

% INPUT data folder, the one that holds the HVPS-ABM-Data-... folders.
% pspl_data_dir finds your OneDrive folder; run pspl_setup once per MATLAB session first.
% data_dir = fullfile(getenv('HOME'), 'Dropbox (Personal)', 'ABM_JG-MMS', 'Hi-ABM log');  % older Hi-ABM logs, personal Dropbox
% data_dir = pspl_data_dir('onedrive', 'Beam_CAL_database', 'ABM');
% data_dir = pspl_data_dir('onedrive', 'IMAP-Lo_CAL_database', 'FM Cal', 'ABM_reference', 'T101_TOF_Cal');
% data_dir = pspl_data_dir('onedrive', 'IMAP-Lo_CAL_database', 'FM Cal', 'ABM_reference', 'T102_Pre-Cal1');
% data_dir = pspl_data_dir('onedrive', 'IMAP-Lo_CAL_database', 'FM Cal', 'ABM_reference', 'T104_Pre-Cal2');
data_dir = pspl_data_dir('onedrive', 'IMAP-Lo_CAL_database', 'FM Cal', 'ABM_reference', 'T105_Final_Cal');

% INPUT settings
date_str = sprintf('20%02d.%02d.%02d', yr, mon, day);   % e.g. 2024.10.24
folder   = ['HVPS-ABM-Data-' date_str];
tbl = zeros(filenum_max,15);

% PROCESSING
for i = 1:filenum_max
data = readtable(fullfile(data_dir, folder, ['ABM-Counts_' date_str '_' num2str(i) '.csv']));
t0   = datetime(table2array(  data(1,1)),'InputFormat','MM/dd/yyyy/HH:mm:ss.S');
t1   = datetime(table2array(data(end,1)),'InputFormat','MM/dd/yyyy/HH:mm:ss.S');
ttol = seconds(t1-t0);       % time span
corr = size(data,1)./ttol;   % time correction of cadence 

tbl(i, 1) = i;
tbl(i, 2) = ttol;
tbl(i, 3) = mean( table2array(data(:,5)) ) * corr; % FCEM average 
tbl(i, 4) = mean( table2array(data(:,4)) ) * corr; % ACEM average 
tbl(i, 5) = mean( table2array(data(:,6)) ) * corr; % COIN average
tbl(i, 6) = std(  table2array(data(:,5)) ) * corr ./ sqrt( size(data,1) ); % FCEM uncertainty
tbl(i, 7) = std(  table2array(data(:,4)) ) * corr ./ sqrt( size(data,1) ); % ACEM uncertainty
tbl(i, 8) = std(  table2array(data(:,6)) ) * corr ./ sqrt( size(data,1) ); % COIN uncertainty

% Absolute Detection Efficiency
ADE_N_bin = table2array(data(:,6)).^2 ./ ( table2array(data(:,5)).*table2array(data(:,4)) ); 
ADE_Y_bin = sum( table2array(data(:,6)) )^2 ./ ... 
          ( sum( table2array(data(:,5)) )*sum( table2array(data(:,4)) ) ); 

% Absolute Beam flux
cts_N_bin = table2array(data(:,5))    .*   table2array(data(:,4))./table2array(data(:,6)  ) * corr;
cts_Y_bin =(sum( table2array(data(:,5)) )*sum( table2array(data(:,4)) ) ) ./ ...
            sum( table2array(data(:,6)) ) ./ ttol;

% Special binning processing      
tbl(i, 9) = mean(ADE_N_bin(isfinite(ADE_N_bin)));   % ADE seperately calculated with mean 
tbl(i,10) =  std(ADE_N_bin(isfinite(ADE_N_bin)))./...
            sum(isfinite(ADE_N_bin));               % ADE uncertainty, biased when more zero counts

tbl(i,11) = ADE_Y_bin;                              % ADE binned, single value
tbl(i,12) =  std(ADE_N_bin(isfinite(ADE_N_bin)))./...
            sum(isfinite(ADE_N_bin));               % ADE uncertainty

tbl(i,13) = mean(cts_N_bin(isfinite(cts_N_bin)));   % cts seperately calculated with mean of non-zeros
tbl(i,14) =  std(cts_N_bin(isfinite(cts_N_bin)))./...
            sum(isfinite(cts_N_bin));               % cts uncertainty, biased when more zero counts

tbl(i,15) = cts_Y_bin;                              % cts binned, single value
tbl(i,16) =  std(cts_N_bin(isfinite(cts_N_bin)))./...
            sum(isfinite(cts_N_bin));               % cts uncertainty
end

% SAVE file
writematrix(tbl, fullfile(data_dir, ['tbl_' date_str '.txt']), 'Delimiter', 'tab');
disp('Process done');
