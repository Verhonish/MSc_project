clc;
clear all;
% Read the CSV file
% Assuming the CSV has two columns: time (t) and amplitude (a)
data = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'loads.csv']); 

colors = {
[0, 120, 215] / 255,    % Blue
          [112, 48, 160] / 255,   % Purple
          [0, 176, 240] / 255,    % Teal
          };

% Separate the time and amplitude columns for each load case
t1 = data(:, 1);  % Time data for load case 1
a1 = data(:, 2);  % Amplitude data for load case 1
t2 = data(:, 3);  % Time data for load case 2
a2 = data(:, 4);  % Amplitude data for load case 2
t3 = data(:, 12);  % Time data for load case 3
a3 = data(:, 13);  % Amplitude data for load case 3

% Plot all three load cases

figure;
plot(t1, 0.001*a1, 'Color', colors{1}, 'DisplayName', 'Load Case 1', 'LineWidth', 2);
hold on;
plot(t2,0.001* a2,'Color', colors{2}, 'DisplayName', 'Load Case 2', 'LineWidth', 2);
plot(t3, 0.001*a3, 'Color', colors{3}, 'DisplayName', 'Load Case 3', 'LineWidth', 2);
title('Load Cases', 'FontSize', 14);
xlabel('time (s)', 'FontSize', 12);
ylabel('Acceleration Input (m/s^2)', 'FontSize', 12);
legend show;
 grid on;
    hold off;
set(gca, 'FontSize', 12); % Increase the font size of the axes
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
set(gcf, 'PaperPositionMode', 'Auto');
set(gcf, 'PaperUnits', 'Inches');
set(gcf, 'PaperSize', [pos(3), pos(4)]);set(gcf, 'PaperUnits', 'inches');

 print( ['/Users/vaishnavipatil/Library/CloudStorage/' ...
     'OneDrive-UniversityCollegeLondon/Individual_project/' ...
     'ls_d_validation/full_final_original/loads'],'-dpdf', '-r0');
 %%

% % Remove DC component (mean) from each load case
 a1 = a1 - mean(a1);
 a2 = a2 - mean(a2);
 a3 = a3 - mean(a3);

% Determine the sampling frequency (Fs) based on the time vector of load case 1

% Original sampling frequency and time
T = t1(2) - t1(1);  % Sampling period of the original signal
Fs_old = 1/T;       % Original sampling frequency

% Desired new sampling frequency (e.g., 2x the original sampling frequency)
Fs = 2 * Fs_old;    % Adjust this to the desired new sampling rate

% Resample the signal to the new sampling frequency
[p, q] = rat(Fs / Fs_old);  % Calculate the resampling factors
a1_resampled = resample(a1, p, q);  % Resample the signal for Load Case 1
a2_resampled = resample(a2, p, q);  % Resample the signal for Load Case 2
a3_resampled = resample(a3, p, q);  % Resample the signal for Load Case 3

% Generate the new time vector based on the new sampling frequency
L_new = length(a1_resampled);  % Length of the resampled signal
t1_resampled = (0:L_new-1) / Fs;  % New time vector

% Now perform the FFT with the new sampling frequency
Y1 = fft(a1_resampled);
Y2 = fft(a2_resampled);
Y3 = fft(a3_resampled);

% Single-sided spectrum for each case
P1_1 = abs(Y1/L_new);
P1_2 = abs(Y2/L_new);
P1_3 = abs(Y3/L_new);

P1_1 = P1_1(1:L_new/2+1);
P1_2 = P1_2(1:L_new/2+1);
P1_3 = P1_3(1:L_new/2+1);

P1_1(2:end-1) = 2*P1_1(2:end-1);  % Multiply by 2 (except the DC and Nyquist terms)
P1_2(2:end-1) = 2*P1_2(2:end-1);
P1_3(2:end-1) = 2*P1_3(2:end-1);

% Redefine the frequency domain f with the new sampling frequency
f = Fs*(0:(L_new/2))/L_new;

% Plot the frequency-domain signal for all three load cases

figure;
plot(f, P1_1, 'Color', colors{1}, 'DisplayName', 'Load Case 1', 'LineWidth', 2);
hold on;
plot(f, P1_2,'Color', colors{2}, 'DisplayName', 'Load Case 2', 'LineWidth', 2);
plot(f, P1_3, 'Color', colors{3}, 'DisplayName', 'Load Case 3', 'LineWidth', 2);
title('Single-Sided Amplitude Spectrum for Load Cases', 'FontSize', 14);
xlabel('Frequency (Hz)', 'FontSize', 12);
ylabel('|P1(f)|', 'FontSize', 12);
legend show;
xlim([0 200]);
 grid on;
    hold off;
set(gca, 'FontSize', 12); % Increase the font size of the axes
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
set(gcf, 'PaperPositionMode', 'Auto');
set(gcf, 'PaperUnits', 'Inches');
set(gcf, 'PaperSize', [pos(3), pos(4)]);set(gcf, 'PaperUnits', 'inches');

 print( ['/Users/vaishnavipatil/Library/CloudStorage/' ...
     'OneDrive-UniversityCollegeLondon/Individual_project/' ...
     'ls_d_validation/full_final_original/fft_loads'],'-dpdf', '-r0');
%%


% Define frequency bands (example: 0-50 Hz, 50-100 Hz, 100-200 Hz, etc.)
bands = [0, 50; 50, 100; 100, 200; 200, 500; 500, Fs/2];  % Modify as needed

% Initialize storage for peak frequency and percentage calculations
peak_frequencies = zeros(3, 1);  % Store peak frequencies for each load case
peak_bands = strings(3, 1);      % Store the frequency band where the peak occurs

% Power spectrum for each case
power_spectrum1 = P1_1.^2;
power_spectrum2 = P1_2.^2;
power_spectrum3 = P1_3.^2;

% Total power for each load case
total_power1 = sum(power_spectrum1);
total_power2 = sum(power_spectrum2);
total_power3 = sum(power_spectrum3);

% Power percentage in different bands for each case
power_percentage1 = zeros(size(bands, 1), 1);
power_percentage2 = zeros(size(bands, 1), 1);
power_percentage3 = zeros(size(bands, 1), 1);

for i = 1:size(bands, 1)
    % Find indices of the frequencies within the current band
    band_indices = (f >= bands(i, 1)) & (f < bands(i, 2));
    
    % Calculate power percentage for each load case in the current band
    power_percentage1(i) = sum(power_spectrum1(band_indices)) / total_power1 * 100;
    power_percentage2(i) = sum(power_spectrum2(band_indices)) / total_power2 * 100;
    power_percentage3(i) = sum(power_spectrum3(band_indices)) / total_power3 * 100;
end

% Find the peak frequencies for each load case
[~, max_index1] = max(power_spectrum1);
[~, max_index2] = max(power_spectrum2);
[~, max_index3] = max(power_spectrum3);

peak_frequencies(1) = f(max_index1);
peak_frequencies(2) = f(max_index2);
peak_frequencies(3) = f(max_index3);

% Determine which frequency band contains the peak for each load case
for i = 1:size(bands, 1)
    if peak_frequencies(1) >= bands(i, 1) && peak_frequencies(1) < bands(i, 2)
        peak_bands(1) = sprintf('%d - %d Hz', bands(i, 1), bands(i, 2));
    end
    if peak_frequencies(2) >= bands(i, 1) && peak_frequencies(2) < bands(i, 2)
        peak_bands(2) = sprintf('%d - %d Hz', bands(i, 1), bands(i, 2));
    end
    if peak_frequencies(3) >= bands(i, 1) && peak_frequencies(3) < bands(i, 2)
        peak_bands(3) = sprintf('%d - %d Hz', bands(i, 1), bands(i, 2));
    end
end

% Display peak frequencies and the frequency range for each load case
fprintf('Load Case 1: Peak frequency = %.2f Hz in range %s\n', peak_frequencies(1), peak_bands(1));
fprintf('Load Case 2: Peak frequency = %.2f Hz in range %s\n', peak_frequencies(2), peak_bands(2));
fprintf('Load Case 3: Peak frequency = %.2f Hz in range %s\n', peak_frequencies(3), peak_bands(3));

% Create stacked horizontal bar chart for power distribution in different bands for each load case
figure;
power_matrix = [power_percentage1, power_percentage2, power_percentage3]';

% Plot the stacked horizontal bar chart
barh(1:3, power_matrix, 'stacked','BarWidth',0.4);

% Customize the chart
title('Power Distribution in Frequency Bands for Each Load Case','FontSize',14);
xlabel('Percentage of Total Power (%)',FontSize=12);
ylabel('Load Cases');
legend('0-50 Hz', '50-100 Hz', '100-200 Hz', '200-500 Hz', ...
    ['500-' num2str(Fs/2) ' Hz']);%,'Location','bestoutside');

% Set y-axis labels (1 for Load Case 1, 2 for Load Case 2, 3 for Load Case 3)
yticks(1:3);
yticklabels({'Load Case 1', 'Load Case 2', 'Load Case 3'});

% Add text on the bars to show the maximum frequency for each load case
hold on;
for i = 1:3
    % Get the position to place the maximum frequency text
   x_position = sum(power_matrix(i, :)) * 0.5;  % Adjust text position to be inside the bar
    text(x_position, i, sprintf('Max Freq: %.2f Hz', peak_frequencies(i)), ...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right', 'Color', 'w');  
end
hold off;

set(gca, 'FontSize', 12); % Increase the font size of the axes
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
reducedHeight = pos(4);% - 3;
set(gcf, 'Position', [pos(1), pos(2), pos(3), reducedHeight]);
set(gcf, 'PaperPositionMode', 'Auto');
set(gcf, 'PaperUnits', 'Inches');
set(gcf, 'PaperSize', [pos(3), pos(4)]);set(gcf, 'PaperUnits', 'inches');

 print( ['/Users/vaishnavipatil/Library/CloudStorage/' ...
     'OneDrive-UniversityCollegeLondon/Individual_project/' ...
     'ls_d_validation/full_final_original/fft_power'],'-dpdf', '-r0');
