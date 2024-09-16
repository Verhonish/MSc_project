function dense_matrix = hb_to_dense_matrix(filename)
    % Read Harwell-Boeing file and convert to dense matrix
    [nrows, ncols, colptr, rowind, values] = read_harwell_boeing(filename);
    
    % Initialize a dense matrix with zeros
    dense_matrix = zeros(nrows, ncols);
    
    % Populate the dense matrix
    for col = 1:ncols
        start = colptr(col);
        if col == ncols
            end_idx = length(values) + 1;
        else
            end_idx = colptr(col + 1);
        end
        for idx = start:(end_idx - 1)
            row = rowind(idx);
            value = values(idx);
            dense_matrix(row, col) = value;
        end
    end
    
    % Display the dense matrix
    disp('Dense Matrix:');
    disp(dense_matrix);
end

function [nrows, ncols, colptr, rowind, values] = read_harwell_boeing(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end
    
    % Skip title and key lines
    fgetl(fid);
    fgetl(fid);
    
    % Read matrix dimensions and number of non-zero elements
    dims = fscanf(fid, '%d', 4);
    nrows = dims(1);
    ncols = dims(2);
    nnonzeros = dims(3);
    
    % Skip the format lines
    for i = 1:3
        fgetl(fid);
    end
    
    % Read column pointers
    colptr = fscanf(fid, '%d', ncols + 1);
    
    % Read row indices
    rowind = fscanf(fid, '%d', nnonzeros);
    
    % Read values
    values = fscanf(fid, '%f', nnonzeros);
    
    fclose(fid);
end