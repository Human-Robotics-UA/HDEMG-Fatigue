function [final_force_data, final_trigger_data, final_force_time, final_trigger_time] = readFORCEData(user)
    
    force_data = csvread(['results/' user '/FORCE.csv'], 1, 0); % the indexes are for skipping the columns' titles.

    % Extracting columns.
    time_values = force_data(:, 1); % It doesn't matter.
    final_force_data = force_data(:, 2) * -1;
    final_trigger_data = force_data(:, 3);

    SamplingFrequency = 2000;

    % Convert the timestamps according to the sampling frequency.
    final_force_time = (0:(length(final_force_data)-1)) / SamplingFrequency;
    final_trigger_time = (0:(length(final_trigger_data)-1)) / SamplingFrequency;
end