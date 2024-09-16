function matrix = extract_matrix(filename)
    % Open the file
    fileID = fopen(filename, 'r');
    
    % Read the file contents
    data = fread(fileID, '*char')';
    fclose(fileID);
    
    % Find all matrix entries using regex
    pattern = '\[\s*(\d+),\s*(\d+)\]:\s*([-\d.e+]+)';
    matches = regexp(data, pattern, 'tokens');
    
    % Convert entries to a structured format
    entries = cellfun(@(x) [str2double(x{1}), str2double(x{2}), str2double(x{3})], matches, 'UniformOutput', false);
    entries = vertcat(entries{:});
    
    max_row = max(entries(:,1));
    max_col = max(entries(:,2));
    
    % Initialize an empty matrix
    matrix = zeros(max_row, max_col);
    
    for i = 1:size(entries, 1)
        row = entries(i, 1);
        col = entries(i, 2);
        value = entries(i, 3);
        matrix(row, col) = value;
    end
end



