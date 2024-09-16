clc;
clear;

% Parameters
m = 1; % Mass value (assumed same for all)
k = 1; % Spring constant (assumed same for all)

% Mass Matrix (same for both cases)
M = m * eye(3);

% Stiffness Matrix for Free Ends
K_free = k * [1, -1, 0; 
             -1, 2, -1; 
              0, -1, 1];

% Stiffness Matrix for One End Fixed with Another Spring
K_fixed = k * [2, -1, 0; 
              -1, 2, -1; 
               0, -1, 1];

% Display matrices
disp('Mass Matrix (M):');
disp(M);

disp('Stiffness Matrix for Free Ends (K_free):');
disp(K_free);

disp('Stiffness Matrix for One End Fixed (K_fixed):');
disp(K_fixed);

% Eigenvalue analysis
[mode_shapes_free, lambda_free] = eig(K_free, M);
frequencies_free = sqrt(diag(lambda_free)) / (2 * pi);

[mode_shapes_fixed, lambda_fixed] = eig(K_fixed, M);
frequencies_fixed = sqrt(diag(lambda_fixed)) / (2 * pi);

disp('Natural Frequencies for Free Ends (Hz):');
disp(frequencies_free);

disp('Natural Frequencies for One End Fixed (Hz):');
disp(frequencies_fixed);

% Plot mode shapes
figure;
subplot(2,1,1);
plot(mode_shapes_free);
title('Mode Shapes for Free Ends');
xlabel('Mass Index');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(mode_shapes_fixed);
title('Mode Shapes for One End Fixed');
xlabel('Mass Index');
ylabel('Amplitude');
grid on;
