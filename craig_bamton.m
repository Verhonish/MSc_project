clc;
clear all;
%convert HB matrix to dense matrix
K_full =1000* hb2dense(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'spring_mass_3dof_modal/K_0001_001.mtx.rb']);
M_full =1000* hb2dense(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'spring_mass_3dof_modal/M_0001_001.mtx.rb']); 
% Define the filename
filename_m_full = ['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/M_full.txt'];
filename_k_full = ['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/K_full.txt'];
% Export the matrix to a .txt file
writematrix(M_full, filename_m_full);
writematrix(K_full, filename_k_full);
dofdata=readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'spring_mass_3dof_modal/Node_Data_0001_001']);
%
xdofdata=dofdata(3:end,2);
half_rows_dofdata=0.5*length(xdofdata);
xdofdata=xdofdata(1:half_rows_dofdata,:);
xdofdata=sort(xdofdata((xdofdata ~= 0)));
a_ext_inp = readmatrix(['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/ls_d_validation/' ...
    'spring_mass_3dof_load/a_ext2.csv']); 
    
[eig_vecs_full, eig_vals_full] = eig(K_full, M_full);
natural_frequencies_full = sqrt(diag(eig_vals_full));
% Define the degrees of freedom
% internal_dofs: Internal DOFs (excluding interface)
% interface_dofs: Interface DOFs
    N = size(K_full, 1);
    interface_dofs =[3];  % e.g., (ni+1):n (last n-ni DOFs)
%interface_dofs =[448:450];  % e.g., (ni+1):n (last n-ni DOFs)
internal_dofs = setdiff(1:N, interface_dofs); % e.g., 1:ni (first ni DOFs)

acc_data = zeros(length(a_ext_inp(:,1)), N); % Initialize force matrix

for i=1:length(xdofdata)
    acc_data(:,xdofdata(i))=-1*0.001*a_ext_inp(:,2);
end

% External force vector F(t) as M * a(t) at each discrete time step
F = zeros(length(a_ext_inp(:,1)), N); % Initialize force matrix
for i = 1:length(a_ext_inp(:,1))
    F(i, :) =( M_full * (acc_data(i,:))')'; % Compute force at each time step
end

filename_f_full = ['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/F_full.txt'];
writematrix(F, filename_f_full);

% Extract subforces corresponding to internal and interface DOFs
F_i = F(:,internal_dofs);
F_f = F(:,interface_dofs);

% Extract submatrices for internal and interface DOFs
M_ii = M_full(internal_dofs, internal_dofs);
M_if = M_full(internal_dofs, interface_dofs);
M_ff = M_full(interface_dofs, interface_dofs);

K_ii = K_full(internal_dofs, internal_dofs);
K_if = K_full(internal_dofs, interface_dofs);
K_ff = K_full(interface_dofs, interface_dofs);

% Compute fixed-interface normal modes (Phi)
% These are the eigenvectors of the internal DOFs with interfaces fixed
[eig_vecs, eig_vals] = eig(K_ii, M_ii);
[sorted_eig_vals, idx] = sort(diag(eig_vals));
Phi = eig_vecs(:, idx); % Select eigenvectors corresponding to sorted eigenvalues

% Truncate the number of modes if necessary
num_modes = 1; % Number of retained fixed-interface modes
Phi = Phi(:, 1:num_modes);

% Compute the constraint modes (B)
B = -K_ii \ K_if;

% Assembly of the Craig-Bampton transformation matrix (T)
T = [Phi, B; zeros(size(M_ff, 1), size(Phi, 2)), eye(size(M_ff, 1))];

% Reduced system matrices
M_reduced = T' * M_full * T;
K_reduced = T' * K_full * T;

% Transform the forces to the reduced-order model
for i=1:length(a_ext_inp(:,1))
    F_reduced(i,:) = [Phi' * (F_i(i,:))'; B' * F_i(i,:)' + F_f(i,:)'];
end

% Now M_reduced and K_reduced can be used for further analysis
% For example, modal analysis on the reduced system
[eig_vecs_reduced, eig_vals_reduced] = eig(K_reduced, M_reduced);
natural_frequencies = sort(sqrt(abs(diag(eig_vals_reduced))));

% Define the filename
filename_m_r = ['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/M_r.txt'];
filename_k_r = ['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/K_r.txt'];
filename_f_r = ['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/F_r.txt'];
filename_T_r = ['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/spring_mass_3dof_modal/T_r.txt'];
% Export the matrix to a .txt file
writematrix(M_reduced, filename_m_r);
writematrix(K_reduced, filename_k_r);
writematrix(F_reduced, filename_f_r);
writematrix(T, filename_T_r);


