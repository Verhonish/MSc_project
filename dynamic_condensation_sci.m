function [Sci_dynamic_cond] = dynamic_condensation_sci(K,M,w_i,n,ratio)
    % This function performs dynamic condensation using similarity transformation.
    % K: Full stiffness matrix
   
    % Sort the array in ascending order and get the sorted indices
     [sortedValues, sortedIndices] = sort(ratio, 'ascend');
    indices_retained=(sortedIndices(1:n));

    % Size of the full stiffness matrix
     N = size(K, 1);
    % Indices of the eliminated DOFs
     indices_to_eliminate= setdiff(1:N, indices_retained);
        
    % Partition the matrix into submatrices
    K_mm = K(indices_retained, indices_retained);
        M_mm = M(indices_retained, indices_retained);
    K_ms = K(indices_retained, indices_to_eliminate);
    K_sm = K(indices_to_eliminate, indices_retained);
        M_sm = M(indices_to_eliminate, indices_retained);
    K_ss = K(indices_to_eliminate, indices_to_eliminate);
        M_ss = M(indices_to_eliminate, indices_to_eliminate);
    %[phi_ss,lambda_ss]=eig(K_ss, M_ss);

    % Create the similarity transformation matrix Sci
    I_mm = eye(length(indices_retained));
    I_ss = eye(length(indices_to_eliminate));
    %U_s_m_rel_dyn=-phi_ss*inv(lambda_ss-(w_i^2)*I_ss)*phi_ss'* (K_sm-(w_i^2)*M_sm);
    U_s_m_rel_dyn=-inv(K_ss-(w_i^2)*M_ss) * (K_sm-(w_i^2)*M_sm);
    Sci_dynamic_cond=zeros(N,n);
    for i = 1:length(indices_to_eliminate)
        idx = indices_to_eliminate(i);
        Sci_dynamic_cond(idx, :) = U_s_m_rel_dyn(i,:);
    end

    for i = 1:length(indices_retained)
    idx = indices_retained(i);
    Sci_dynamic_cond(idx, :) = I_mm(i,:); 
    end

end
