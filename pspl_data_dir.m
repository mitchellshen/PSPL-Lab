function folder = pspl_data_dir(name, varargin)
%PSPL_DATA_DIR  Full path to a data folder on this computer.
%   FOLDER = PSPL_DATA_DIR('onedrive', SUB1, SUB2, ...) is your Princeton
%   OneDrive folder with the subfolders SUB1, SUB2, ... added, e.g.
%
%       pspl_data_dir('onedrive', 'Beam_CAL_database', 'ABM')
%
%   FOLDER = PSPL_DATA_DIR('wien_scans') is the folder that holds Wien
%   filter plate-potential scans.
%
%   The OneDrive folder is found in its usual place on Mac and Windows,
%   and Wien scans default to your Downloads folder. To use other folders,
%   copy pspl_config_template.m to pspl_config.m (in the same folder as
%   this file) and edit it. Git ignores pspl_config.m, so your paths stay
%   on your computer.
%
%   Errors if the folder doesn't exist, so a typo or a folder OneDrive
%   hasn't synced shows up here rather than as a failed file read.

if ispc
    home = getenv('USERPROFILE');
else
    home = getenv('HOME');
end

% Defaults
roots.onedrive   = find_onedrive(home);
roots.wien_scans = fullfile(home, 'Downloads');

% Folders set in pspl_config.m, if you have one, take precedence
if exist('pspl_config', 'file') == 2
    mine = pspl_config();
    for f = fieldnames(mine)'
        roots.(f{1}) = mine.(f{1});
    end
end

if ~isfield(roots, name)
    error('PSPL:unknownFolder', 'Unknown data folder ''%s''. Known: %s.', ...
          name, strjoin(fieldnames(roots)', ', '));
end
if isempty(roots.(name))
    error('PSPL:folderNotSet', ['Couldn''t find your ''%s'' folder automatically. ' ...
          'Copy pspl_config_template.m to pspl_config.m and set cfg.%s there.'], name, name);
end

folder = fullfile(roots.(name), varargin{:});
if ~isfolder(folder)
    error('PSPL:folderNotFound', ['Folder not found:\n  %s\nCheck the folder names, ' ...
          'that OneDrive has synced it, and pspl_config.m if you use one.'], folder);
end
end


function root = find_onedrive(home)
% Princeton OneDrive folder on this computer, or '' if none is found
candidates = {
    getenv('OneDriveCommercial')                                               % Windows
    fullfile(home, 'Library', 'CloudStorage', 'OneDrive-PrincetonUniversity')  % Mac
    fullfile(home, 'OneDrive - Princeton University')                          % Windows, older Mac
    };
root = '';
for k = 1:numel(candidates)
    if ~isempty(candidates{k}) && isfolder(candidates{k})
        root = candidates{k};
        return
    end
end
end
