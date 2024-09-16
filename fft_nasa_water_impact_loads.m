clc;
clear all;

% Read the CSV file
data1 = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'loads.csv']); 
data=data1(:,[5,6,5,7,5,8,5,9,5,10,5,11]);

% Colors for plotting each load case
colors = {
    [0, 120, 215] / 255,   % Blue
    [112, 48, 160] / 255,  % Purple
    [0, 176, 240] / 255,   % Teal
    [255, 165, 0] / 255,   % Orange
    [60, 179, 113] / 255,  % Medium Sea Green
    [220, 20, 60] / 255    % Crimson
};

% Number of load cases
num_cases = 6;

% Initialize cell arrays to store time and amplitude data for each load case
t = cell(num_cases, 1);
a = cell(num_cases, 1);

% Loop to separate the time and amplitude columns for each load case
for i = 1:num_cases
    t{i} = data(:, 2 * i - 1);   % Time data for load case i
    a{i} = data(:, 2 * i);       % Amplitude data for load case i
end

% Plot all load cases
figure;
hold on;
for i = 1:num_cases
    plot(t{i}, 0.001 * a{i}, 'Color', colors{i}, 'DisplayName', sprintf('Load Case %d', i), 'LineWidth', 2);
end
title('Load Cases for Water Landing', 'FontSize', 14);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Acceleration Input(m/s^2)', 'FontSize', 12);
legend show;
grid on;
hold off;
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
set(gcf, 'PaperPositionMode', 'Auto');
set(gcf, 'PaperUnits', 'Inches');
set(gcf, 'PaperSize', [pos(3), pos(4)]);

print(['/Users/vaishnavipatil/Library/CloudStorage/' ...
     'OneDrive-UniversityCollegeLondon/Individual_project/' ...
     'ls_d_validation/full_final_original/loads_water_landing'], '-dpdf', '-r0');
%%

% % Remove DC component (mean) from each load case
for i=1:num_cases
    a{i}=a{i}-mean(a{i});
end
% Determine the sampling frequency (Fs) based on the time vector of load case 1
T = t{1}(2) - t{1}(1);  % Sampling period (assuming uniform sampling for all cases)
Fs = 1 / T;             % Sampling frequency
L = length(t{1});       % Length of signal

% Initialize cell arrays to store FFT results and single-sided spectra
Y = cell(num_cases, 1);
P1 = cell(num_cases, 1);

% Compute FFT for each load case
for i = 1:num_cases
    Y{i} = fft(a{i});
    P1{i} = abs(Y{i} / L);
    P1{i} = P1{i}(1:L/2+1);
    P1{i}(2:end-1) = 2 * P1{i}(2:end-1);  % Multiply by 2 (except the DC and Nyquist terms)
end

% Define the frequency domain f
f = Fs * (0:(L/2)) / L;

% Plot the frequency-domain signal for all load cases
figure;
hold on;
for i = 1:num_cases
    plot(f, P1{i}, 'Color', colors{i}, 'DisplayName', sprintf('Load Case %d', i), 'LineWidth', 2);
end
title('Single-Sided Amplitude Spectrum for Load Cases', 'FontSize', 14);
xlabel('Frequency (Hz)', 'FontSize', 12);
ylabel('|P1(f)|', 'FontSize', 12);
legend show;
xlim([0 200]);
grid on;
hold off;
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
set(gcf, 'PaperPositionMode', 'Auto');
set(gcf, 'PaperUnits', 'Inches');
set(gcf, 'PaperSize', [pos(3), pos(4)]);

print(['/Users/vaishnavipatil/Library/CloudStorage/' ...
     'OneDrive-UniversityCollegeLondon/Individual_project/' ...
     'ls_d_validation/full_final_original/fft_loads_water_landing'], '-dpdf', '-r0');

% Define frequency bands (example: 0-50 Hz, 50-100 Hz, 100-200 Hz, etc.)
bands = [0, 50; 50, 100; 100, 200; 200, 500; 500, Fs/2];  % Modify as needed

% Initialize storage for peak frequency, percentage calculations, and power spectrum
peak_frequencies = zeros(num_cases, 1);
peak_bands = strings(num_cases, 1);
power_spectrum = cell(num_cases, 1);
total_power = zeros(num_cases, 1);
power_percentage = zeros(size(bands, 1), num_cases);

% Calculate power spectrum and total power for each load case
for i = 1:num_cases
    power_spectrum{i} = P1{i}.^2;
    total_power(i) = sum(power_spectrum{i});
end

% Calculate power percentage in different bands for each load case
for i = 1:num_cases
    for j = 1:size(bands, 1)
        band_indices = (f >= bands(j, 1)) & (f < bands(j, 2));
        power_percentage(j, i) = sum(power_spectrum{i}(band_indices)) / total_power(i) * 100;
    end
end

% Find the peak frequencies for each load case and their corresponding bands
for i = 1:num_cases
    [~, max_index] = max(power_spectrum{i});
    peak_frequencies(i) = f(max_index);
    for j = 1:size(bands, 1)
        if peak_frequencies(i) >= bands(j, 1) && peak_frequencies(i) < bands(j, 2)
            peak_bands(i) = sprintf('%d - %d Hz', bands(j, 1), bands(j, 2));
            break;
        end
    end
end
%%
% Display peak frequencies and the frequency range for each load case
for i = 1:num_cases
    fprintf('Load Case %d: Peak frequency = %.2f Hz in range %s\n', i, peak_frequencies(i), peak_bands(i));
end

% Create stacked horizontal bar chart for power distribution in different bands for each load case
figure;
barh(1:num_cases, power_percentage', 'stacked', 'BarWidth', 0.4);

% Customize the chart
title('Power Distribution in Frequency Bands for Each Load Case', 'FontSize', 14);
xlabel('Percentage of Total Power (%)', 'FontSize', 12);
ylabel('Load Cases');
legend('0-50 Hz', '50-100 Hz', '100-200 Hz', '200-500 Hz', ...
    ['500-' num2str(Fs/2) ' Hz']);%,'Location','bestoutside');

% Set y-axis labels
yticks(1:num_cases);
yticklabels(arrayfun(@(x) sprintf('Load Case %d', x), 1:num_cases, 'UniformOutput', false));

% Add text on the bars to show the maximum frequency for each load case
hold on;
for i = 1:num_cases
    x_position = sum(power_percentage(:, i)) * 0.5;
    text(x_position, i, sprintf('Max Freq: %.2f Hz', peak_frequencies(i)), ...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right', 'Color', 'w');
end
hold off;

set(gca, 'FontSize', 12);
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
reducedHeight = pos(4);% - 3;
set(gcf, 'Position', [pos(1), pos(2), pos(3), reducedHeight]);
set(gcf, 'PaperPositionMode', 'Auto');
set(gcf, 'PaperUnits', 'Inches');
set(gcf, 'PaperSize', [pos(3), pos(4)]);

print(['/Users/vaishnavipatil/Library/CloudStorage/' ...
     'OneDrive-UniversityCollegeLondon/Individual_project/' ...
     'ls_d_validation/full_final_original/fft_power_water_landing'], '-dpdf', '-r0');
