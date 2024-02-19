function [final_force_data, final_trigger_data, final_force_time, final_trigger_time] = readFORCEData(user)
    % Read force data from CSV file, skipping the first row (column titles).
    force_data = csvread(['results/' user '/FORCE.csv'], 1, 0); 

    % Extracting columns from the force data.
    time_values = force_data(:, 1); % Extract time values (not used in this function).
    final_force_data = force_data(:, 2) * -1; % Extract force data and invert it.
    final_trigger_data = force_data(:, 3); % Extract trigger data

    SamplingFrequency = 2000; % Define the sampling frequency.

    % Convert the timestamps to time in seconds according to the sampling frequency.
    final_force_time = (0:(length(final_force_data)-1)) / SamplingFrequency;
    final_trigger_time = (0:(length(final_trigger_data)-1)) / SamplingFrequency;
end