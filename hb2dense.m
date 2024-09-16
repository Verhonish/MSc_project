function C = hb2dense(filename)
    % Read a matrix in Harwell-Boeing format convert it into a dense matrix
    fid = fopen(filename, 'rt');
    if fid < 0
        error(['Cannot open file "' filename '" for reading.']);
    end
    % Read the header lines
    title = fgetl(fid);
    header2 = fgetl(fid);
    header3 = fgetl(fid);
    header4 = fgetl(fid);

    % Parse header2 line to get the counts
    counts = sscanf(header2, '%d');
    totcrd = counts(1);
    ptrcrd = counts(2);
    indcrd = counts(3);
    valcrd = counts(4);
   
    % Parse header3 line to get matrix dimensions and number of nonzeros
    sizes = sscanf(header3(4:end), '%14d %14d %14d');
    nrow = sizes(1);
    ncol = sizes(2);
    nnzeros = sizes(3);
    
    % Read column pointers
    ja = zeros(ncol + 1, 1);
    current_index = 1;
    for i = 1:ptrcrd
        line = fgetl(fid);
        ja_segment = sscanf(line, '%d');
        ja(current_index:current_index + length(ja_segment) - 1) = ja_segment;
        current_index = current_index + length(ja_segment);
    end

    % Read row indices
    ia = zeros(nnzeros, 1);
        current_index = 1;
    for i = 1:indcrd
        line = fgetl(fid);
        ia_segment = sscanf(line, '%d');
   ia(current_index:current_index + length(ia_segment) - 1) = ia_segment;
        current_index = current_index + length(ia_segment);
    end

    % Read non-zero values
    a = zeros(nnzeros, 1);
        current_index = 1;
    for i = 1:valcrd
        line = fgetl(fid);
        a_segment = sscanf(line, '%f');
      a(current_index:current_index + length(a_segment) - 1) = a_segment;
        current_index = current_index + length(a_segment);
    end

    % Construct the sparse matrix
    A = spalloc(nrow, ncol, nnzeros);
    for j = 1:ncol
        for k = ja(j):(ja(j+1)-1)
            A(ia(k), j) = a(k);
        end
    end

    % Convert sparse matrix to dense matrix
    B = full(A);
    C=zeros(nrow,ncol);
    %B=0.5*(B+B');
     for i=1:nrow
         for j=1:ncol
             if i==j
                 C(i,j) =0.5* (B(i,j) + B(j,i)) ;
             else 
                 C(i,j) = (B(i,j) + B(j,i)) ;
             end
         end
     end
    fclose(fid);
end
