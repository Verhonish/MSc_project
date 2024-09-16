clc;
clear all;
clc;
clear all;
filename1='/Users/vaishnavipatil/Downloads/K_0001_001.mtx.rb';
filename2='/Users/vaishnavipatil/Downloads/M_0001_001.mtx.rb';
K = hb2dense(filename1);
M = hb2dense(filename2);

% Define boundary degrees of freedom
boundaryDOFs = [1,2,3,4,5,6];  

% Internal degrees of freedom
internalDOFs = setdiff(1:size(M, 1), boundaryDOFs);

% Number of internal modes to retain
numInternalModes = 5;

% Partition matrices
M_ii = M(internalDOFs, internalDOFs);
M_ib = M(internalDOFs, boundaryDOFs);
M_bb = M(boundaryDOFs, boundaryDOFs);

K_ii = K(internalDOFs, internalDOFs);
Check1= det(K);
K_ib = K(internalDOFs, boundaryDOFs);
K_bb = K(boundaryDOFs, boundaryDOFs);

% Constraint modes (static)
Phi_c = -K_ii \ K_ib;

% Normal modes (dynamic)
[V, D] = eig(K_ii, M_ii);
[~, idx] = sort(diag(D));
V = V(:, idx);
Phi_f = V(:, 1:numInternalModes);

% Transformation matrix
Phi_r = [Phi_c; eye(length(boundaryDOFs))];
Phi_r = [Phi_r [Phi_f; zeros(length(boundaryDOFs), numInternalModes)]];

% Reduced matrices
M_r = Phi_r' * M * Phi_r;
K_r = Phi_r' * K * Phi_r;


