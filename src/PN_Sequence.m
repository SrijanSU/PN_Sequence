function generate_gold_sequence()
    while true
        % Generate PN sequence for the first polynomial expression
        
        fprintf("Entries For Sequence 1 !\n");
        pn_sequence1 = combined_code();

        % Generate PN sequence for the second polynomial expression
        
        fprintf("Entries For Sequence 2 !\n");
        pn_sequence2 = combined_code();

        % Check if both sequences have the same length
        
        if length(pn_sequence1) == length(pn_sequence2)
            break; % Exit the loop if the lengths are the same
        else
            fprintf("The lengths of the PN sequences are not same.\n");
        end
    end

    %XOR the two PN sequences to generate the Gold sequence
    gold_sequence = xor(pn_sequence1, pn_sequence2);

    % Display the generated Gold sequence
    disp('Generated Gold Code:');
    disp(gold_sequence);
end


function a = combined_code()
    % Call the function to calculate the degree
    a=0;
fprintf("\nCoefficient of each term in the entered Polynomial should  be 1 \n ");
    polynomial = input('Enter the polynomial expression: ', 's');
    polynomial_expression = lower(polynomial );
    degree = find_polynomial_degree_from_input(polynomial_expression);
    
    % Assign the calculated degree to m
    m = degree;

    % Continue with the rest of the code from the second part
    fprintf( " 1) Initial content should be entered within square brackets \n 2) Give space between each entry \n 3) Number of entry should be equal to degree of the polynomial \n \n For example if polynomial is of degree 3 then the initial contents should be of the form [ 1 0 1 ] \n You can enter any matrix of zero and one but it should not be null matrix \n\n");
    while true

        b = input('Enter initial contents except null  [ ] within square brackets and give space between each entry : ');
        [bm, bn] = size(b);
       isNull1 = check_null_matrix(b);
        if isNull1 == 0
        if bn == m 
            break;
        end
            fprintf("Wrong Sequence, try again !\n");
        continue; % Go to the next iteration of the while loop
        
        end 
        fprintf("Initial condition cannot be zero !\n");
        
end
 
    bb = b;
    b(m + 1) = 0;
    a = 0;
    while true
        b = bb;
        t = convert_polynomial_to_matrix_and_position_numbers(polynomial_expression); % Pass the polynomial expression as an argument
        zz = t(1);
        for i = 1:((2^m) - 1)
            b(2:(m + 1)) = b(1:m);
            xoro = b(zz + 1);
            for k = 2:length(t)
                xoro = xor(xoro, b(t(k) + 1));
            end
            b(1) = xoro;
            a(i) = b(m + 1);
        end
        if bb(1:m) == b(1:m)
            fprintf("Generated  Sequence is :");
            disp(a);
            break;
        end
        fprintf("Something went wrong!\n");
        a =combined_code();

    end
    cc = a;
    fin_seq = a;
    d = 0;
    y = circshift(a, d);
    z =  a;
    [zm, zn] = size(z);
    ag = 0;
    disg = 0;
    n = (2^m) - 1;
    for i = 1:zn
        if z(i) == 0
            ag = ag + 1;
            cc(i) = 1;
        else
            disg = disg + 1;
            cc(i) = -1 / n;
        end
    end
    tot = (ag - disg);
    if tot == -1 
        fprintf("Follows balance property\n");
    else
        fprintf("Does not follow Balance property\n");
    end
    
    % Check run property
    if check_run_property(fin_seq)
        fprintf("Follows run property\n");
    else
        fprintf("Does not follow run property\n");
    end
    
    % Calculate autocorrelation and plot
    [autocorr_result, is_autocorrelated] = check_autocorrelation(fin_seq);

    if is_autocorrelated
        fprintf("Follows autocorrelation property\n");
    else
        fprintf("Does not follow autocorrelation property\n");
    end

    if tot==-1 && is_autocorrelated && check_run_property(fin_seq)
       fprintf("Since generated sequence satisfies all three properties , generated sequence is a PN sequence!\n"); 
       disp(a);
       return;
   
else
     fprintf("Since generated sequence does not satisfies all three properties , generated sequence is not a PN sequence!\n"); 
     a= combined_code();
    end
    

  
    
    function degree = find_polynomial_degree_from_input(polynomial_expression)
        % Extract terms from the polynomial expression
        terms = split(polynomial_expression, '+');

        % Initialize degree
        degree = -Inf;

        % Iterate over each term to find the highest degree
        for i = 1:length(terms)
            % Extract the term
            term = strtrim(terms{i});

            % Check if the term contains 'x^'
            index = strfind(term, 'x^');
            if ~isempty(index)
                % Extract the degree part of the term
                degree_part = term(index + 2:end);
                % Convert the degree part to a number
                term_degree = str2double(degree_part);
                % Update the degree if the current term's degree is higher
                degree = max(degree, term_degree);
            elseif contains(term, 'x') && isempty(strfind(term, 'x^'))
                % If the term contains 'x' but not 'x^', it is of degree 1
                degree = max(degree, 1);
            elseif isempty(strfind(term, 'x'))
                % If the term does not contain 'x', it is a constant term (degree 0)
                degree = max(degree, 0);
            end
        end
    end

    function t = convert_polynomial_to_matrix_and_position_numbers(polynomial_expression)
        % Convert the polynomial to binary representation
        binary_representation = convert_polynomial_to_binary(polynomial_expression);
        %disp('Binary representation:');
        %disp(binary_representation);

        % Convert the binary representation to matrix form
        matrix = binary_representation_to_matrix(binary_representation);
        %disp('Matrix representation:');
        %disp(matrix);

        % Discard the first column of the matrix
        modifiedMatrix = discardFirstColumn(matrix);
        %disp('Modified matrix:');
        %disp(modifiedMatrix);

        % Calculate position numbers of ones in the modified matrix
        columnNumbers = findOnesColumnsFunction(modifiedMatrix);

        % Display the position numbers where the value is one within square brackets
        %disp(['Position numbers of ones: [' num2str(columnNumbers) ']']);

        % Return the position numbers
        t = columnNumbers;
    end

    function binary_representation = convert_polynomial_to_binary(polynomial)
        % Convert polynomial to binary representation
        % Example input: 'x^3 + x^2 + 1'

        % Initialize binary representation
        binary_representation = [];

        % Split polynomial into terms
        terms = strsplit(polynomial, {'+', '-'});

        % Determine the degree of the polynomial
        max_degree = 0;
        for i = 1:length(terms)
            term = strtrim(terms{i});
            if contains(term, 'x')
                exponent = sscanf(term, 'x^%d');
                if isempty(exponent)
                    exponent = 1;
                end
                max_degree = max(max_degree, exponent);
            end
        end

        % Construct binary representation
        for degree = max_degree:-1:0
            term_found = false;
            for i = 1:length(terms)
                term = strtrim(terms{i});
                if contains(term, 'x')
                    exponent = sscanf(term, 'x^%d');
                    if isempty(exponent)
                        exponent = 1;
                    end
                    if exponent == degree
                        binary_representation(degree+1) = 1; % Indexing starts from 1 in MATLAB
                        term_found = true;
                        break;
                    end
                elseif degree == 0
                    binary_representation(degree+1) = 1;
                    term_found = true;
                    break;
                end
            end
            if ~term_found
                binary_representation(degree+1) = 0;
            end
        end
        % Reverse the binary_representation vector to have MSB first
        binary_representation = fliplr(binary_representation);
    end

    function matrix = binary_representation_to_matrix(binary_representation)
        % Convert binary representation to matrix form
        matrix = double(binary_representation);
    end

    function modifiedMatrix = discardFirstColumn(matrix)
        % Discard the first column of the matrix
        if isempty(matrix)
            % If the matrix is empty, return an empty matrix
            modifiedMatrix = [];
        else
            % Remove the first column
            modifiedMatrix = matrix(:, 2:end);
        end
    end

    function columnNumbers = findOnesColumnsFunction(vector)
        % Initialize an empty array to store column numbers
        columnNumbers = [];

        % Iterate over each element of the vector
        for i = 1:length(vector)
            % Check if the element is one
            if vector(i) == 1
                % If yes, add the column number to the array
                columnNumbers = [columnNumbers, i]; % Adjust index to start from zero
            end
        end
    end

    function [autocorr_result, is_autocorrelated] = check_autocorrelation(binary_sequence)
        % Calculate autocorrelation
        autocorr_result = xcorr(binary_sequence, 'coeff');
        tau = -length(binary_sequence) + 1:length(binary_sequence) - 1;

        % Plot the binary sequence
        subplot(2, 1, 1);
        stem(binary_sequence);
        xlabel('Sample');
        ylabel('Amplitude');
        title('Binary Sequence');

        % Plot the autocorrelation
        subplot(2, 1, 2);
        stem(tau, autocorr_result);
        xlabel('Delay');
        ylabel('Autocorrelation');
        title('Autocorrelation of Binary Sequence');

        % Determine if autocorrelation meets threshold
        threshold = 0.8; % Set your threshold here
        max_corr = max(abs(autocorr_result));
        is_autocorrelated = max_corr >= threshold;
    end
    
    function is_run_property = check_run_property(sequence)
        % Check if the sequence follows the run property
        max_run_length = m; % Define the maximum allowed run length
        count = 1;
        for i = 2:length(sequence)
            if sequence(i) == sequence(i - 1)
                count = count + 1;
                if count > max_run_length
                    is_run_property = false;
                    return;
                end
            else
                count = 1;
            end
        end
        is_run_property = true;
    end
end
function isNull = check_null_matrix(matrix)
    % Check if all elements of the matrix are zero
    isNull = all(matrix(:) == 0);
end

