# PSPL Lab

Library for lab work in the Princeton Space Physics Laboratory: MATLAB tools for setting up the ion beamline and processing beam-monitor data.

## Getting started

1. Clone or download this repo.
2. In MATLAB (R2019a or newer), run `pspl_setup.m` once per session. It puts every tool folder on the MATLAB path, so the functions work from any folder, and tells you which OneDrive folder the scripts will read data from:

   ```matlab
   run('path/to/PSPL-Lab/pspl_setup.m')
   ```

   To keep the folders on the path for future sessions, run `savepath` afterwards or add that line to your `startup.m`.
3. Data stays out of the repo. The scripts find your Princeton OneDrive folder in its usual place on Mac and Windows, and read Wien filter scans from your Downloads folder. If either is somewhere else, copy `pspl_config_template.m` to `pspl_config.m` and set the folder there. Git ignores `pspl_config.m`, so your paths stay on your computer.
4. Open the tool you need. Scripts are set up by editing the variables near the top (data folders, dates, physical parameters) before running.

## What's here

| Folder | What it's for | Files |
|---|---|---|
| [`beamline/wien_filter/`](beamline/wien_filter) | Ion source Wien filter: plate voltage that passes each ion species, and plots of a plate-potential scan against voltage and mass | `Ion_source_Wien.m` |
| [`beamline/deflection/`](beamline/deflection) | Gyroradius and sideways deflection of the beam in the beamline's magnetic fields | `gyroradiusCalculator.m`, derivation note (PDF) and slides |
| [`beam_monitor/abm/`](beam_monitor/abm) | C-foil absolute beam monitor (ABM): count rates, absolute detection efficiency and absolute beam flux | `ABM_process.m` (batch script), `import_ABM_file.m`, `determine_avg_ABM_rate.m` |

Each folder's README covers inputs, outputs and data formats.

## Adding a tool

- Put it under the area it belongs to (`beamline/`, `beam_monitor/`) in its own folder. Start a new top-level folder for a new kind of equipment or analysis.
- Keep data out of the repo, and build data paths with `pspl_data_dir` instead of typing your own folders, e.g. `pspl_data_dir('onedrive', 'Beam_CAL_database', 'ABM')`. For a new kind of data folder, add a default in `pspl_data_dir.m` and an example line in `pspl_config_template.m`.
- Start each function with a help block (what it does, inputs, outputs, units) so `help <name>` works.
- Keep derivation notes and slides next to the code they explain.
- Add a row to the table above and a short README in the tool's folder.
