clear all;
clc;
% Define mass matrix M and stiffness matrix K
Mv=[10,15,20,15,30,20];
M = diag(Mv); 
K = [7,-3,0,0,0,-2;-3,7,-1,-3,0,0;0,-1,8,0,0,0;0,-3,0,5,-2,0;0,0,0,-2,3.5,-1.5;-2,0,0,0,-1.5,3.5]*1000; 
% Solve the generalized eigenvalue problem (K- lambda*M)*phi=0
[phi, lambda] = eig(K, M);
w = sqrt(diag(lambda));
w_i=w(1);
for i=1:length(K)
    ratio(i)=K(i,i)/M(i,i);
end
%no of modes to retain
p=3;
n=3;
  % Sort the array in ascending order and get the sorted indices
    [sortedValues, sortedIndices] = sort(ratio, 'descend');
    indices_retained=sort(sortedIndices(1:n));
    modes_retained=1:p;
 % Size of the full stiffness matrix
    N = size(K, 1);
    % Indices of the eliminated DOFs
    indices_to_eliminate= setdiff(1:N, indices_retained);
    modes_to_eliminate= setdiff(1:N, modes_retained);
    % Partition the matrix into submatrices
        phi_p_mm=phi(indices_retained,modes_retained);
   phi_p_ss=phi(indices_to_eliminate,modes_retained);
   %phi_p_mm(:,3)=-1*phi_p_mm(:,3);
    % Create the similarity transformation matrix Sci
    SEREP_method_sci = [phi_p_mm;phi_p_ss]*inv([phi_p_mm'* phi_p_mm])*phi_p_mm'; 

% Call the static condensation function
%Sci_static = static_condensation_sci(K, n,ratio);
% Call the dynamic function
%Sci_dynamic = dynamic_condensation_sci(K,M,w_i,n,ratio);
Sci_SERP= SEREP_method_sci;%SEREP_sci(K,n,ratio,p,phi)
Sci= Sci_SERP;
K_r=(Sci)'*K*Sci;
M_r=(Sci)'*M*Sci;

[phi_r, lambda_r] = eig(K_r, M_r);
w_r = sort(sqrt(diag(lambda_r)))