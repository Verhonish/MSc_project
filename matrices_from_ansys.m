clc;
clear all;
% Extract matrices from the provided files
M = extract_matrix('/Users/vaishnavipatil/Downloads/3_ele_beam_stiffness/Mdense.txt');
K = extract_matrix('/Users/vaishnavipatil/Downloads/3_ele_beam_stiffness/Kdense.txt');

[eigenvectors, eig_val] = eig(K, M);
eig_val_num=diag(eig_val);
freq=(sqrt(eig_val_num))/(2*pi());