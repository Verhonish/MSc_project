clc;
clear all;
% Define the system of first-order ODEs
%function dydt = spring_mass_damper_ode(t, y)
M = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'stiffness_trial/spring_mass_3dof/M_full.txt']); % File should contain the mass matrix

K = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'stiffness_trial/spring_mass_3dof/K_full.txt']); % File should contain the stiffness matrix

% Import the external acceleration (a_ext) as a function of time
time_a_ext = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'head_neck_load/a_ext.csv']); 
time = time_a_ext(:, 1);
a_ext_values = time_a_ext(:, 2);

n = size(M, 1); % Number of degrees of freedom

    % Extract displacement and velocity
    x = y(1:n);
    v = y(n+1:2*n);
    
    % Compute the external force at time t
    F_t = M * interp1(time, a_ext_values, t, 'linear', 'extrap');
    
    % Calculate acceleration
    a = M \ (F_t - K * x);
    
    % Return the derivative of the state vector
    dydt = [v; a];
%end