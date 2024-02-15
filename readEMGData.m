
function [final_emg_data, final_trigger_data, final_emg_time, final_trigger_time] = readEMGData(user, exp1, exp2, exp3)
    num_experiments = nargin-1;
    
    if nargin < 2
        load(['results/' user '/' user '.mat']);
        
        % Check each description for the presence of 'Flexor'
        indices_without_flexor = [];
        for i = 1:length(Description)
            if ~contains(Description{i}, 'Flexor')
                indices_without_flexor = [indices_without_flexor, i];
            end
            if contains(Description{i}, 'AUX')
                trigger_index = i;
            end
        end

        final_trigger_data = Data(:, trigger_index);
        final_trigger_time = Time;

        final_emg_data = Data;
        final_emg_data(:, indices_without_flexor) = [];
        final_emg_time = Time;
        
        % Plot the EMG signals
        figure;
        vertical_spacing = 2;
        subplot(2,1,1);
        for channel = 1:size(final_emg_data, 2)
            plot(final_emg_time, final_emg_data(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
            hold on;
        end
        title('HD-EMG Signal Combined');
        subplot(2,1,2);
        plot(final_trigger_time, final_trigger_data);
        title('Trigger Signal Combined');
    
    else
        load(['results/' user '/' user exp1]);
        % Rename the variables loaded because otherwise, the second part of the experiment would replace them.
        Data_1 = Data;
        emg_data_1 = Data_1{1,1};
        Description_1 = Description;
        % The sampling frequency is not mandatory to rename as it's the same.
        Time_1 = Time;
        load(['results/' user '/' user '_1_Trigger.mat'], 'Data', 'Time');
        Trigger_Data_1 = Data;
        Trigger_Time_1 = Time;


        load(['results/' user '/' user exp2]);
        % Rename the variables loaded because otherwise, the third part of the experiment would replace them.
        Data_2 = Data;
        emg_data_2 = Data_2{1,1};
        Description_2 = Description;
        % The sampling frequency is not mandatory to rename as it's the same.
        Time_2 = Time;
        load(['results/' user '/' user '_2_Trigger.mat'], 'Data', 'Time');
        Trigger_Data_2 = Data;
        Trigger_Time_2 = Time;

        trigger_1 = Trigger_Data_1{1,1};
        trigger_2 = Trigger_Data_2{1,1};


        if nargin > 3
            load(['results/' user '/' user exp3]);
            % Rename the variables loaded if needed
            Data_3 = Data;
            emg_data_3 = Data_3{1,1};
            Description_3 = Description;
            OTBFile_3 = OTBFile;
            % The sampling frequency is not mandatory to rename as it's the same.
            Time_3 = Time;

            load(['results/' user '/' user '_3_Trigger.mat'], 'Data', 'Time');
            Trigger_Data_3 = Data;
            Trigger_Time_3 = Time;
            trigger_3 = Trigger_Data_3{1,1};

            % Get the EMG and Time combinations from the files.
            combined_emg_data_12 = cat(1, emg_data_1, emg_data_2);
            final_emg_data = cat(1, combined_emg_data_12, emg_data_3);
            final_emg_time = (0:size(final_emg_data, 1)-1) / SamplingFrequency;

            combined_trigger_data_12 = cat(1, trigger_1, trigger_2);
            final_trigger_data = cat(1, combined_trigger_data_12, trigger_3);
            final_trigger_time = (0:size(final_trigger_data, 1)-1) / SamplingFrequency;
        else
            % Find the maximum time value in the first file
            max_time_1 = max(Time_1{1,1});
            max_trigger_time_1 = max(Trigger_Time_1{1,1});

            % Adjust the time values in the second file to align with the first 
            % file.
            Time_adjusted = Time_2{1,1} + max_time_1;
            Trigger_time_adjusted = Trigger_Time_2{1,1} + max_trigger_time_1;

            % Get the EMG and Time combinations from both files.
            final_emg_data = cat(1, emg_data_1, emg_data_2);
            final_emg_time = cat(1, Time_1{1,1}, Time_adjusted);

            % Get the Trigger and Time combinations from both files.
            final_trigger_data = cat(1, trigger_1, trigger_2);
            final_trigger_time = cat(1, Trigger_Time_1{1,1}, Trigger_time_adjusted);
        end

        % Plot the EMG signals
        figure;
        vertical_spacing = 2;

        subplot(2*num_experiments+2,1,1);
        for channel = 1:size(emg_data_1, 2)
            plot(Time_1{1,1}, emg_data_1(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
            hold on;
        end
        title('HD-EMG Signal Part 1');
        subplot(2*num_experiments+2,1,2);
        plot(Trigger_Time_1{1,1}, trigger_1);
        title('Trigger Signal Part 1');

        subplot(2*num_experiments+2,1,3);
        for channel = 1:size(emg_data_2, 2)
            plot(Time_2{1,1}, emg_data_2(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
            hold on;
        end
        title('HD-EMG Signal Part 2');
        subplot(2*num_experiments+2,1,4);
        plot(Trigger_Time_2{1,1}, trigger_2);
        title('Trigger Signal Part 2');

        if nargin > 3
            subplot(2*num_experiments+2,1,5);
            for channel = 1:size(emg_data_3, 2)
                plot(Time_3{1,1}, emg_data_3(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
                hold on;
            end
            title('HD-EMG Signal Part 3');
            subplot(2*num_experiments+2,1,6);
            plot(Trigger_Time_3{1,1}, trigger_3);
            title('Trigger Signal Part 3');
        end

        subplot(2*num_experiments+2,1,2*num_experiments+1);
        for channel = 1:size(final_emg_data, 2)
            plot(final_emg_time, final_emg_data(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
            hold on;
        end
        title('HD-EMG Signal Combined');
        subplot(2*num_experiments+2,1,2*num_experiments+2);
        plot(final_trigger_time, final_trigger_data);
        title('Trigger Signal Combined');
    end
end
