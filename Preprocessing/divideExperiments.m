function [emg_runs, force_runs] = divideExperiments(emg_data, emg_trigger_data, emg_time, force_data, force_trigger_data, force_time)
    % Define threshold for detecting force peaks.
    threshold = 0.5;
    
    % Calculate differences between consecutive force trigger data points.
    force_diff = diff(force_trigger_data);
    
    % Find indices of peaks where force exceeds the threshold.
    force_peaks = find(abs(force_diff) > threshold);
    
    % Extract peaks every 2 values to avoid proximal/duplicate peaks.
    force_peaks = force_peaks(1:2:end);
    
    % Initialize cell arrays to store force runs.
    force_runs = cell(4, 2); % 4 experiments
    force_runs_beforecut = cell(4, 2);
    cutted_indices = cell(4, 2);
    
    % Check if there are enough peaks to indicate multiple experiments.
    if length(force_peaks) >= 2
        iterator = 1;
        
        % Determine starting index based on the number of peaks (avoid the
        % MVC peaks if present).
        if length(force_peaks) > 8 
            initial_trigger = 3;
        else
            initial_trigger = 1;
        end
        
        % Iterate over force peaks to divide into experiments.
        for i = initial_trigger:2:length(force_peaks)-1
            start_index = force_peaks(i);
            end_index = force_peaks(i+1);

            % Extract force data segment and corresponding time segment.
            force_segment = force_data(start_index:end_index);
            time_segment = force_time(start_index:end_index);
            
            % Store force data and time before any cutting.
            force_runs_beforecut{iterator,1} = force_segment;
            force_runs_beforecut{iterator,2} = time_segment;
            
            % Apply thresholding to detect the "plateau" region.
            threshold_factor = 0.75;
            threshold = threshold_factor * max(force_segment); % Set threshold as a factor of the maximum value
            
            % Find indices where the filtered force exceeds the threshold.
            above_threshold_indices = find(force_segment > threshold);
            
            % Determine start and end points of the "plateau" region.
            if ~isempty(above_threshold_indices)
                pos_step_limit = above_threshold_indices(1);
                neg_step_limit = above_threshold_indices(end) + 1; % Sum 1 to include the last descent point
            else
                % If no points are above the threshold, skip this iteration
                continue;
            end
            
            % Store indices for cutting.
            cutted_indices{iterator, 1} = pos_step_limit;
            cutted_indices{iterator, 2} = neg_step_limit;

            % Define range to maintain (plateau).
            actual_range = pos_step_limit:neg_step_limit;

            % Cut force signal to maintain only the specified range.
            cutted_force = force_segment(actual_range);
            cutted_time = time_segment(actual_range);
            
            % Store cut force data and time.
            force_runs{iterator,1} = cutted_force;
            force_runs{iterator,2} = cutted_time;
        
            iterator = iterator + 1;
        end
    else
        disp('Insufficient number of peaks.');
    end
    
    % Define threshold for detecting EMG trigger peaks.
    threshold = 2;
    
    % Calculate differences between consecutive EMG trigger data points.
    trigger_diff = diff(emg_trigger_data);
    
    % Find peaks where the absolute difference exceeds the threshold.
    trigger_peaks = find(abs(trigger_diff) > threshold);

    % Extract the first three digits of each value.
    first_three_digits = floor(trigger_peaks / 100);

     % Find unique first three digits and their indices.
    [unique_first_three, ~, ic] = unique(first_three_digits);

     % Find the first occurrence of each unique first three digits.
    first_occurrence_idx = accumarray(ic, trigger_peaks, [], @min);

     % Extract unique trigger peaks.
    unique_trigger_peaks = first_occurrence_idx;
    
    % Initialize cell arrays to store EMG runs.
    emg_runs = cell(4, 2); % 4 experiments
    emg_runs_beforecut = cell(4, 2);
    
    % Check if there are enough peaks to indicate multiple experiments.
    if length(unique_trigger_peaks) >= 2
        iterator = 1;
        
        % Determine starting index based on the number of peaks (avoid the
        % MVC peaks if present).
        if length(unique_trigger_peaks) > 8 
            initial_trigger = 3;
        else
            initial_trigger = 1;
        end
        
        % Iterate over unique trigger peaks to divide into experiments.
        for i = initial_trigger:2:length(unique_trigger_peaks)-1
            start_index = unique_trigger_peaks(i);
            end_index = unique_trigger_peaks(i+1);

            % Extract EMG data segment and corresponding time segment.
            emg_segment = emg_data(start_index:end_index, :);
            time_segment = emg_time(start_index:end_index);
            
            % Store EMG data and time before any cutting.
            emg_runs_beforecut{iterator,1} = emg_segment;
            emg_runs_beforecut{iterator,2} = time_segment;
            
            % Calculate indices for cutting the EMG signal.
            initial_cut_emg = round(cutted_indices{iterator,1});
            final_cut_emg = round(cutted_indices{iterator,2});
            final_cut_emg = min(final_cut_emg, length(emg_segment));
            
            % Perform cutting on EMG signal.
            emg_cutted = emg_segment(initial_cut_emg:final_cut_emg, :);
            time_emg_cutted = time_segment(initial_cut_emg:final_cut_emg);
            
            % Store cut EMG data and time.
            emg_runs{iterator,1} = emg_cutted;
            emg_runs{iterator,2} = time_emg_cutted;

            iterator = iterator + 1;
        end
    else
        disp('Insufficient number of peaks.');
    end
end