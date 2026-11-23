# Wien filter

`Ion_source_Wien_v1.m` and `Ion_source_Wien_v2.m` work the same way and have two parts. They differ only in where they look for scan files (see the scan plot's input file below).

## 1. Plate-voltage calculator

For plate gap `d` (m), Wien filter magnetic field `B` (T) and beam energy `E`, the script prints the plate voltage that passes each species in its list (H, H₂, mass 3, He, N, Ne, N₂, Ar, Xe):

```
U = d · sqrt(2 B² E q / m)
```

with `E` in volts (energy per charge). `d` is an effective gap fitted to measured peaks; the commented lines under the calculation show how it was back-computed from measured H₂⁺ and He⁺ peak voltages.

## 2. Scan plot

Reads a Wien filter plate-potential scan and plots beam current against plate voltage and against mass.

- **Input file:** `Wien-Filter-Plate-Potential-Scan__YYYY.MM.DD_N.txt`, two numeric columns: plate voltage (V) and picoammeter current (A). Set `yyyy`, `mm`, `dd` and `num` to pick the file. v1 reads it from the folder in `path`, a fixed folder on Mitchell's Mac. v2 reads it from your own Downloads folder on Mac or Windows, or from whatever folder you set `scan_dir` to.
- **Processing:** the current is averaged at each voltage in `V_wien_seq` (0–256 V in 1 V steps, then 258–300 V in 2 V steps) and shifted so its minimum is zero. Change `V_wien_seq` if the scan used different steps.
- **Output:** a two-panel figure (current in pA vs plate voltage, and vs mass in amu using the same `d`, `B` and `E`), titled with the beam energy `E` and saved at 300 dpi as `<scan file name>_v2.png` next to the data file. Set `E` to the energy the scan was taken at: the mass axis scales with it.
