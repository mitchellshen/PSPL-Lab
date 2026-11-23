function cfg = pspl_config()
%PSPL_CONFIG  Your own data folders for the PSPL Lab scripts.
%   Only needed when a folder isn't found automatically. Copy this file to
%   pspl_config.m in the same folder, then uncomment and edit the lines you
%   need. Git ignores pspl_config.m, so your paths stay on your computer.
%   See pspl_data_dir for how the scripts use these folders.

cfg = struct();

% Princeton OneDrive folder, the one that holds Beam_CAL_database and
% IMAP-Lo_CAL_database. Found automatically in its usual place on Mac and
% Windows.
% cfg.onedrive = '/Users/yourname/Library/CloudStorage/OneDrive-PrincetonUniversity';
% cfg.onedrive = 'C:\Users\yourname\OneDrive - Princeton University';

% Folder with Wien filter plate-potential scans. Default: your Downloads folder.
% cfg.wien_scans = '/Users/yourname/Downloads';
end
