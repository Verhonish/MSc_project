function [SEREP_method_sci] = SEREP_sci(K,n,ratio,p,phi)
    % This function performs dynamic condensation using similarity transformation.
    % K: Full stiffness matrix
    % indices_to_eliminate: Indices of the DOFs to be eliminated

      % Sort the array in ascending order and get the sorted indices
    [sortedValues, sortedIndices] = sort(ratio, 'ascend');
    indices_retained=(sortedIndices(1:n));
    modes_retained=1:p;
 % Size of the full stiffness matrix
    N = size(K, 1);
    % Indices of the eliminated DOFs
    indices_to_eliminate= setdiff(1:N, indices_retained);
    modes_to_eliminate= setdiff(1:N, modes_retained);
    % Partition the matrix into submatrices
        phi_p_mm=phi(indices_retained,modes_retained);
   phi_p_ss=phi(indices_to_eliminate,indices_retained);
   
    % Create the similarity transformation matrix Sci
    SEREP_method_sci = [phi_p_mm;phi_p_ss]*inv([phi_p_mm'* phi_p_mm])*phi_p_mm'; 
end
