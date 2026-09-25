function [hfo_signal, starting_times] = GetSimulatedUnivariateHFOs( ...
    time_length, num_hfos, freq_low, freq_high, fs, ...
    mean_width, std_width, mean_ampl, std_ampl)

% GETSIMULATEDUNIVARIATEHFOS Generate synthetic high-frequency oscillations.
%
% Generates a single-channel synthetic signal containing a specified
% number of high-frequency oscillation (HFO) components.
%
% Each HFO consists of a sinusoidal carrier modulated by a Gaussian
% envelope. The widths and amplitudes of the individual HFOs are
% independently sampled from Gamma distributions.
%
% Bandpass-filtered pink noise is added to the simulated HFO signal.
%
% INPUTS:
%   time_length - Number of samples in the simulated signal.
%   num_hfos    - Number of HFO components to generate.
%   freq_low    - Lower frequency of the HFO band (Hz).
%   freq_high   - Upper frequency of the HFO band (Hz).
%   fs          - Sampling frequency (Hz).
%   mean_width  - Mean Gaussian envelope width (seconds).
%   std_width   - Standard deviation of HFO width (seconds).
%   mean_ampl   - Mean HFO amplitude (arbitrary units).
%   std_ampl    - Standard deviation of HFO amplitude.
%
% OUTPUTS:
%   hfo_signal     - Simulated signal (1 x time_length).
%   starting_times - HFO center times in seconds (1 x num_hfos).
%
% NOTE:
%   starting_times contains the centers of the Gaussian envelopes,
%   rather than the onset times of the HFO events.
%
%   The function generates exactly num_hfos components, although
%   overlapping or low-amplitude components may not be individually
%   detectable.
%
%   All width and amplitude distribution parameters must be positive.
%
% See also: example_simulation.m

%% Generate HFO parameters
% Randomly distribute HFO centers across the signal
starting_times = GetCentralPositions(num_hfos, time_length) / fs;

% Generate Gamma-distributed widths and amplitudes
hfo_widths = GetGammaDistributedValues( ...
    num_hfos, mean_width, std_width);

hfo_amplitudes = GetGammaDistributedValues( ...
    num_hfos, mean_ampl, std_ampl);

% Time vector
t = (0:time_length-1) / fs;

%% Generate HFO envelopes
% Initialize envelope
hfo_envelope = 0;

% Sum the Gaussian envelopes of individual HFOs
for i = 1:length(hfo_widths)

    t0 = starting_times(i);
    hfo_width = hfo_widths(i);
    hfo_amplitude = hfo_amplitudes(i);

    hfo_envelope_curr = hfo_amplitude * ...
        exp(-0.5 * (t - t0).^2 / hfo_width^2);

    hfo_envelope = hfo_envelope + hfo_envelope_curr;

end

%% Generate bandpass-filtered pink noise
noise = pinknoise(1, time_length);

% FIR bandpass filter
filter_order = min(100, ceil(time_length / 4));

b = fir1(filter_order, ...
    [freq_low freq_high] / (fs / 2), "bandpass");

noise = filtfilt(b, 1, noise);

% Normalize noise to unit standard deviation
noise = noise / std(noise);

%% Generate HFO carrier
freq_central = (freq_low + freq_high) / 2;
hfo_carrier = sin(2 * pi * t * freq_central);

%% Combine HFOs and noise
hfo_signal = hfo_carrier .* hfo_envelope + noise;

%% Internal functions

function positions = GetCentralPositions(num_pulses, time_length)
    % Generate positive random spacings.
    % Two additional values provide spacing around the HFO centers.
    proportions = unifrnd(0, 1, 1, num_pulses + 2);
    proportions = cumsum(proportions) / sum(proportions);
    positions = proportions(1:end-2) * time_length;
end

function values = GetGammaDistributedValues( ...
    num_pulses, mean_value, std_value)
    [a, b] = GammaParameters(mean_value, std_value);
    values = gamrnd(a, b, 1, num_pulses);
end

function [a, b] = GammaParameters(mean_value, std_value)
    var_value = std_value^2;
    b = var_value / mean_value;
    a = mean_value / b;
end
end
