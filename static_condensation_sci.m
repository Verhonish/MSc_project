function [Sci_static_cond] = static_condensation_sci(K, n,ratio)
    % This function performs static condensation using similarity transformation.
    % K: Full stiffness matrix
    % indices_to_eliminate: Indices of the DOFs to be retained
        % Sort the array in ascending order and get the sorted indices
   [sortedValues, sortedIndices] = sort(ratio, 'ascend');
    indices_retained=(sortedIndices(1:n));

        % Size of the full stiffness matrix
    N = size(K, 1);
    % Indices of the eliminated DOFs
     indices_to_eliminate= setdiff(1:N, indices_retained);
   % Partition the matrix into submatrices
    K_mm = K(indices_retained, indices_retained);
    K_ms = K(indices_retained, indices_to_eliminate);
    K_sm = K(indices_to_eliminate, indices_retained);
    K_ss = K(indices_to_eliminate, indices_to_eliminate);
    
    % Create the similarity transformation matrix Sci
    I_mm = eye(length(indices_retained));
    I_ss = eye(length(indices_to_eliminate));
    U_s_m_rel=-inv(K_ss)*K_sm;
    Sci_static_cond=zeros(N,n);
    for i = 1:length(indices_to_eliminate)
        idx = indices_to_eliminate(i);
        Sci_static_cond(idx, :) = U_s_m_rel(i,:);
    end
    for i = 1:length(indices_retained)
    idx = indices_retained(i);
    Sci_static_cond(idx, :) = I_mm(i,:);
    end
    
end


