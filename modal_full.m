clc;
clear all;
% Define Mass and Stiffness matrices for a component

% filename1=['/Users/vaishnavipatil/Downloads/' ...
%     'K_0001_001.mtx.rb'];
% filename2=['/Users/vaishnavipatil/Downloads/' ...
%     'M_0001_001.mtx.rb'];
filename1=['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/head_neck_modal/K_0001_001.mtx.rb'];
filename2=['/Users/vaishnavipatil/Library/CloudStorage/' ...
    'OneDrive-UniversityCollegeLondon/Individual_project/' ...
    'ls_d_validation/head_neck_modal/M_0001_001.mtx.rb'];
K_full = hb2dense(filename1);
M_full = hb2dense(filename2); 
[Phi, Lambda] = eig(K_full, M_full);
natural_frequencies_full = sqrt(diag(Lambda));

% The effective masses are the diagonal elements of M_modal
effective_masses = (diag(M_full));


