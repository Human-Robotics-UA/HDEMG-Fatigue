function [final_force_data, final_trigger_data, final_force_time, final_trigger_time] = readFORCEData(user)
    % Read force data from CSV file, skipping the first row (column titles).
    force_data = csvread(['results/' user '/FORCE.csv'], 1, 0); 

    % Extracting columns from the force data.
    time_values = force_data(:, 1); % Extract time values (not used in this function).
    initial_force_data = force_data(:, 2) * -1; % Extract force data and invert it.
    initial_trigger_data = force_data(:, 3); % Extract trigger data
    
    desired_sampling_frequency = 2000; % HD-EMG sampling frequency.
    original_sampling_frequency = 1000; % Force sampling frequency.
    
    % Upsampling.
    final_force_data = resample(initial_force_data, desired_sampling_frequency, original_sampling_frequency);
    % Use 'nearest' interpolation to preserve binary nature.
    final_trigger_data = interp1((0:length(initial_trigger_data)-1)/original_sampling_frequency, initial_trigger_data, (0:length(final_force_data)-1)/desired_sampling_frequency, 'nearest');

    % Convert the timestamps to time in seconds according to the sampling frequency.
    final_force_time = (0:(length(final_force_data)-1)) / desired_sampling_frequency;
    final_trigger_time = (0:(length(final_trigger_data)-1)) / desired_sampling_frequency;
end