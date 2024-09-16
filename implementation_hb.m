clc;
clear all;
filename1='/Users/vaishnavipatil/Downloads/K_0001_001.mtx.rb';
filename2='/Users/vaishnavipatil/Downloads/M_0001_001.mtx.rb';
K = hb2dense(filename1);
M = hb2dense(filename2);
[eigenvectors, eig_val] = eig(K, M);
eig_val_num=diag(eig_val);
freq=sqrt(abs(eig_val_num))/(2*pi());