# Synthetic High-Frequency Oscillation Simulation

MATLAB code for generating synthetic high-frequency oscillations (HFOs)
used to evaluate and optimize HFO detection algorithms.

This repository accompanies the manuscript:

[Insert manuscript citation]

## Overview

This repository provides MATLAB code for generating synthetic
single-channel signals containing high-frequency oscillations (HFOs).

The simulation generates HFOs using Gaussian amplitude envelopes
and sinusoidal carriers, with additive bandpass-filtered pink noise.

The code was developed for the evaluation and optimization of
HFO detection algorithms across different frequency bands.

## Repository structure

```text
synthetic-hfo-simulation/
│
├── README.md
├── CITATION.cff
├── LICENSE
│
├── src/
│   └── GetSimulatedUnivariateHFOs.m
│
└── examples/
    └── example_simulation.m
```

## Simulation methodology

Each synthetic HFO is generated using a Gaussian amplitude envelope
modulating a sinusoidal carrier.

The signal is defined as:

s(t) = A(t) sin(2*pi*f_c*t) + n(t)

where:

- A(t) is the sum of the Gaussian envelopes.
- f_c is the center frequency of the selected frequency band.
- n(t) is bandpass-filtered pink noise.

The amplitude and width of each HFO are independently sampled from
Gamma distributions, parameterized by their specified means and
standard deviations.

HFO centers are randomly distributed across the signal using
normalized cumulative random spacings.

The background noise is filtered within the selected frequency band
and normalized to unit standard deviation.

### Frequency-dependent parameters

The mean Gaussian envelope width is calculated as:

mean_width = ((num_cycles / freq_center) * 2) / 5

where:

- num_cycles = 5
- freq_center = (freq_low + freq_high) / 2

The signal duration is calculated as:

duration = (num_hfos * mean_width) / p_target

where p_target = 0.005.

This calculation provides a frequency-dependent signal duration
based on a nominal target HFO occupancy of 0.5%.

The actual occupied duration may vary because HFO widths are
randomly sampled and Gaussian envelopes do not have finite support.

## Simulation parameters

The following parameters are used in the example script:

| Parameter | Description | Value |
|---|---|---|
| fs | Sampling frequency | 5000 Hz |
| num_hfos | Number of HFO components | 10 |
| freq_low | Lower frequency | 80 Hz |
| freq_high | Upper frequency | 105 Hz |
| num_cycles | Parameter used to calculate mean HFO width | 5 |
| p_target | Nominal target HFO occupancy | 0.005 |
| std_width | Standard deviation of HFO width | 0.9 ms |
| mean_ampl | Mean HFO amplitude | 5 (example value) |
| std_ampl | Standard deviation of HFO amplitude | 0.2 |

The example uses the 80–105 Hz frequency band. The parameters
can be modified to generate signals in other frequency ranges.

## Requirements

- MATLAB
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- A MATLAB release providing the pinknoise function

The code uses the following MATLAB functions:

- pinknoise
- fir1
- filtfilt
- unifrnd
- gamrnd

The MATLAB release and toolbox versions used for the manuscript
should be specified before publication.

## Usage

1. Download or clone this repository.

2. Open MATLAB.

3. Navigate to the examples directory.

4. Run:

```matlab
example_simulation
```

The example script automatically adds the src directory to
the MATLAB path.

The script generates a synthetic HFO signal, plots the full
signal with the known HFO centers, and displays a short segment
around an individual HFO.

### Using the simulation function directly

```matlab
[hfo_signal, starting_times] = ...
    GetSimulatedUnivariateHFOs( ...
    time_length, num_hfos, ...
    freq_low, freq_high, fs, ...
    mean_width, std_width, ...
    mean_ampl, std_ampl);
```

The function returns:

- hfo_signal: Simulated single-channel signal.
- starting_times: Known HFO center times in seconds.

Note that starting_times represents the centers of the
Gaussian envelopes, not the event onset times.


## Citation

If you use this code in your research, please cite the
accompanying manuscript:

[Insert manuscript citation]

## License

This repository is distributed under the terms specified in
the LICENSE file.
