clc;
clear all;
% Define system parameters
M = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/M_r.txt']); % File should contain the mass matrix
K = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/K_r.txt']); % File should contain the stiffness matrix 
a_ext_inp = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'spring_mass_3dof_load/a_ext2.csv']); 
F1=readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/F_r.txt']);
T=readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/T_r.txt']); % File should contain the mode shape matrix
a_full= readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'spring_mass_3dof_load/a_ext2_out.csv']);

% Define the size of the system
n = size(K,1); % Example size, change as needed
% Define the time step based on the input data
time_data=a_ext_inp(:,1);
dt = time_data(2) - time_data(1); % Assumes uniform time step in the data
% Time vector
time_data = 0:dt:dt*(1*1000-1);
%time_data=time_data';
num_steps = 1.45*1000;
F2=zeros(num_steps,n);
%F1= interp1(a_ext_inp(:,1),F1,time_data);
%F1=F1(:,1:2);
time_data=0:dt:dt*(num_steps-1);
F2(1:size(F1,1),:)=F1;
t=0:0.0001:max(time_data);
% External force function 
F = @(t)[interp1(time_data,F2,t,'spline')]';
no_modes= size(T,2);
no_points=size(T,1);
acc_full=0.001*a_full(1:1000,2:end);
t_full=a_full(1:1000,1);
% Define the initial conditions
x0 = zeros(n, 1); % Initial displacement
v0 = zeros(n, 1); % Initial velocity

% Set initial conditions
x(1, :) = x0';
v(1, :) = v0';
% Combine initial conditions
y0 = [x0; v0];
% Define the ODE function
ode_func = @(t, y) [y(n+1:2*n); M\(F(t) - K*y(1:n))];
% Solve the ODE
[t, y] = ode45(ode_func, t, y0);
% Extract displacement, velocity, and acceleration
displacement = y(:, 1:n);
velocity = y(:, n+1:2*n);
acceleration = zeros(size(t, 1), n);
% Calculate acceleration
for i = 1:length(t)
    acceleration(i, :) = (M\(F(t(i)) - K*displacement(i, :)' ))';
end

for i=1: length(t)
    a_valuess(i, 1:no_points)=(T*acceleration(i, 1:no_modes)')';
end

% % subplot(4, 1, 3);
% figure;
% plot(t, a_valuess(:,1:3),t_full,acc_full(:,1:3));
% %plot(t, acceleration(:,2),t_full,acc_full(:,2));%,a_ext_inp(:,1),-1*a_ext_inp(:,2));
% title('Acceleration');
% xlabel('Time (s)');
% ylabel('Acceleration (m/s^2)');
% Define colors
% Define original colors
% Define original colors
colors = {
[0, 120, 215] / 255,    % Blue
          [112, 48, 160] / 255,   % Purple
          [0, 176, 240] / 255,    % Teal
          };

% Define lighter shades by blending with white
lighter_colors = {
    [0.6, 0.8, 1],    % Light Blue
    [0.8, 0.6, 1],    % Light Purple
    [0.6, 0.8, 1],    % Light Teal 
};

% Create a figure
figure;

% Plot a_valuess with lighter shades of colors and solid lines
hold on;
for i = 1:3
    plot(t, a_valuess(:,i), 'Color', lighter_colors{i}, 'LineWidth', 2);
end

% Plot acc_full with original colors and dashed lines
for i = 1:3
    plot(t_full, acc_full(:,i), '--', 'Color', colors{i}, 'LineWidth', 2);
end

% Release the hold
hold off;
xlim([0, 0.2]);

% Add labels and legend for clarity (optional)
xlabel('Time (s)', 'FontSize', 12);
ylabel('Acceleration (m/s^2)', 'FontSize', 12);
legend({'Reduced Model Node 1','Reduced Model Node 2','Reduced Model Node 3', 'Full Model Node 1','Full Model Node 2','Full Model Node 3'}, 'FontSize', 12); 
title('Acceleration Comparison', 'FontSize', 14);


set(gca, 'FontSize', 12); % Increase the font size of the axes
set(gcf, 'Units', 'Inches');
pos = get(gcf, 'Position');
set(gcf, 'PaperPositionMode', 'Auto');
set(gcf, 'PaperUnits', 'Inches');
set(gcf, 'PaperSize', [pos(3), pos(4)]);set(gcf, 'PaperUnits', 'inches');

 print( ['/Users/vaishnavipatil/Library/CloudStorage/' ...
     'OneDrive-UniversityCollegeLondon/Individual_project/' ...
     'ls_d_validation/full_model_load/Acceleration_comparison_3dof'],'-dpdf', '-r0');
 

