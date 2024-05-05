clear;
close;
clc;

users = {'H001B0101', 'H002B0101', 'H003B0101', 'H004B0101', 'H022B0101', 'H023B0101', 'H024B0101', 'H031B0101', 'H032B0101'};

window_size = 2500; % Define window size (adjust as needed)
overlap = 500; % Define overlap between windows (adjust as needed)

for i = 1:length(users)
    % Access the current user
    user = users{i};
    disp(['Feature extraction for user: ', user]);
    load(['results/' user '/' 'emg_and_force_runs_' user '.mat']);
    
    for exp_index=2:4   
        % MAV COMPUTATION -----------------------------------------------------
        run = emg_runs{exp_index, 1};
        time_run = emg_runs{exp_index, 2};

        % Rectify the signal
        rectified_run = abs(run);
        
         % Compute linear envelope for each channel
        linear_envelope = zeros(size(rectified_run));
        for channel = 1:size(rectified_run, 2)
            linear_envelope(:, channel) = smooth(rectified_run(:, channel), 2000); % Smoothing can be adjusted as needed
        end
        
        % Write preprocessed data to CSV
        csvwrite(['results/' user '/' 'emg_experiment_' num2str(exp_index) '_mav.csv'], linear_envelope);
        
        % MNF COMPUTATION -----------------------------------------------------
        % Load the preprocessed HD-EMG data from the CSV file
        filename = ['results/' user '/emg_experiment_' num2str(exp_index) '_mav.csv'];
        hd_emg_data = csvread(filename); 
    
        % Compute number of windows
        num_windows = floor((size(hd_emg_data, 1) - window_size) / (window_size - overlap)) + 1;

        % Initialize array to store mean frequencies for each channel and each window
        mnf_values = zeros(num_windows, size(hd_emg_data, 2));

        Fs = 2000;

        % Iterate over each window
        for i = 1:num_windows
            % Determine indices for current window
            start_index = (i - 1) * (window_size - overlap) + 1;
            end_index = start_index + window_size - 1;

            % Extract data for current window
            window_data = hd_emg_data(start_index:end_index, :);

            % Compute power spectral density (PSD) using periodogram for each channel
            [Pxx, f] = periodogram(window_data, [], [], Fs, 'power');

            % Compute Mean Frequency (MNF) for each channel in the current window
            mnf_values(i, :) = meanfreq(Pxx, f);
            
            % Check for NaN values and replace them with 0
            nan_indices = isnan(mnf_values(i, :));
            mnf_values(i, nan_indices) = 0;
        end
        
        % Write feature data to CSV
        csvwrite(['results/' user '/' 'emg_experiment_' num2str(exp_index) '_mnf.csv'], mnf_values);
        
        
        % RMS COMPUTATION -----------------------------------------------------
        hd_emg_data = emg_runs{exp_index, 1};

        % Rectify the signal
        rectified_data = abs(hd_emg_data);
        
        % Compute number of windows
        num_windows = floor((size(rectified_data, 1) - window_size) / (window_size - overlap)) + 1;

        % Initialize array to store mean frequencies for each channel and each window
        rms_values = zeros(num_windows, size(rectified_data, 2));

        Fs = 2000;

        % Iterate over each window
        for i = 1:num_windows
            % Determine indices for current window
            start_index = (i - 1) * (window_size - overlap) + 1;
            end_index = start_index + window_size - 1;

            % Extract data for current window
            window_data = rectified_data(start_index:end_index, :);

            % Compute Root Mean Square (RMS) for each channel in the current window
            rms_values(i, :) = rms(window_data);
        end
        
        % Write feature data to CSV
        csvwrite(['results/' user '/' 'emg_experiment_' num2str(exp_index) '_rms.csv'], rms_values);
        
    end
      
end

%% PLOT RESULTS

% Define the number of rows and columns for the grid
num_rows = 4;
num_columns = 4;

% Create vector of window indices
window_indices = (1:num_windows) * (window_size - overlap) - overlap / 2;


% MAV SHOWING -----------------------------------------------------
% Create a new figure
figure;
% Iterate over each channel and plot the RMS values in a subplot
for i = 1:size(linear_envelope, 2)/4
    % Determine the subplot position
    subplot(num_rows, num_columns, i);
    
    % Plot the RMS values for the current channel
    plot(linear_envelope(:, i), 'b', 'LineWidth', 1);
    
    % Set subplot title
    title(['Channel ', num2str(i)]);
    
    % Set subplot labels
    xlabel('Time');
    ylabel('Amplitude');
    
    % Set grid
    grid on;
end

% Adjust figure properties
sgtitle('MAV for the first 16 channels');

% MNF SHOWING -----------------------------------------------------
% Create a new figure
figure;
% Iterate over each channel and plot the RMS values in a subplot
for i = 1:size(mnf_values, 2)/4
    % Determine the subplot position
    subplot(num_rows, num_columns, i);
    
    % Plot the RMS values for the current channel
    plot(window_indices, mnf_values(:, i), 'b', 'LineWidth', 1);
    
    % Set subplot title
    title(['Channel ', num2str(i)]);
    
    % Set subplot labels
    xlabel('Window index');
    ylabel('Amplitude');
    
    % Set grid
    grid on;
end

% Adjust figure properties
sgtitle('MNF for the first 16 channels');

% RMS SHOWING -----------------------------------------------------
% Create a new figure
figure;
% Iterate over each channel and plot the RMS values in a subplot
for i = 1:size(rms_values, 2)/4
    % Determine the subplot position
    subplot(num_rows, num_columns, i);
    
    % Plot the RMS values for the current channel
    plot(window_indices, rms_values(:, i), 'b', 'LineWidth', 1);
    
    % Set subplot title
    title(['Channel ', num2str(i)]);
    
    % Set subplot labels
    xlabel('Window index');
    ylabel('Amplitude');
    
    % Set grid
    grid on;
end

% Adjust figure properties
sgtitle('RMS for the first 16 channels');