%% Example: Synthetic HFO simulation
% This script demonstrates how to generate synthetic HFO signals
% using GetSimulatedUnivariateHFOs.
%
% The simulation parameters follow the methodology used in the
% accompanying manuscript.

clear; clc; close all;

%% Add simulation function to MATLAB path
% Determine repository directory
script_dir = fileparts(mfilename('fullpath'));
repo_dir = fileparts(script_dir);
addpath(fullfile(repo_dir, 'src'));

%% Fixed simulation parameters

fs = 5000;              % Sampling frequency (Hz)
num_hfos = 10;          % Number of simulated HFOs
std_width = 0.9e-3;     % Width standard deviation (seconds)
mean_ampl = 5;          % Mean HFO amplitude (example value)
std_ampl = 0.2;         % Amplitude standard deviation

% Frequency-dependent parameters
num_cycles = 5;
p_target = 0.005;       % Target HFO occupancy (0.5%)

% Set random seed for reproducibility
rng(42);

%% Select frequency band
freq_low = 80;
freq_high = 105;
freq_center = (freq_low + freq_high) / 2;

%% Calculate HFO width
% Frequency-dependent mean Gaussian width
mean_width = ((num_cycles / freq_center) * 2) / 5;

%% Calculate signal duration
% Frequency-dependent signal length
duration = (num_hfos * mean_width) / p_target;
time_length = ceil(duration * fs);

% Time vector
t = (0:time_length-1) / fs;

%% Generate simulated signal
[hfo_signal, starting_times] = ...
    GetSimulatedUnivariateHFOs( ...
    time_length, num_hfos, ...
    freq_low, freq_high, fs, ...
    mean_width, std_width, ...
    mean_ampl, std_ampl);

%% Plot entire simulated signal

figure('Color', 'w');
plot(t, hfo_signal, 'k');
hold on;

% Mark known HFO centers
xline(starting_times, 'r--', 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Amplitude (a.u.)');
title(sprintf('Simulated HFO signal (%d-%d Hz)', ...
    freq_low, freq_high));
legend('Simulated signal', 'HFO centers');
xlim([0 duration]);
box off;
