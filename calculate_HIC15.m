function [HIC15,t1_opt,t2_opt] = calculate_HIC15(accel, time)
    % time: a vector of time points corresponding to the acceleration data in seconds
    % Number of data points
    n = length(time);

   % Initialize the HIC15 value and the corresponding time interval
    HIC15 = 0;
    t1_opt = 0;
    t2_opt = 0;

    % Number of data points
    n = length(time);

    % Loop over each possible starting point
    for i = 1:n
        % Loop for every possible time window up to 15 ms (0.015 seconds)
        for j = i:n
            % Calculate the time interval dt
            dt = time(j) - time(i);
            
            % Only proceed if the time interval is <= 15 ms
            if dt > 0 && dt <= 0.015
                % Calculate the average acceleration over this interval
                a_avg = trapz(time(i:j), accel(i:j)) / dt;

                % Calculate HIC for this interval
                HIC = (dt) * (a_avg ^ 2.5);

                % Update maximum HIC15 and corresponding time interval
                if HIC > HIC15
                    HIC15 = HIC;
                    t1_opt = time(i);
                    t2_opt = time(j);
                end
            end
        end
    end

    % Finalize HIC15 calculation
    HIC15 = HIC15 ^ (1/2.5);

end
