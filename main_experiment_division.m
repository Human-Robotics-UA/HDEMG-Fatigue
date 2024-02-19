%% 
% Reading HD-EMG signals --------------------------------------------------

user = 'H002B0101';

[emg_data, emg_trigger_data, emg_time, emg_trigger_time] = readEMGData(user,false,'_1.mat','_2.mat');

%% 
% Reading Force and Trigger signals ---------------------------------------

[force_data, force_trigger_data, force_time, force_trigger_time] = readFORCEData(user);

%%
% Get the four experiments ------------------------------------------------

[emg_runs, force_runs] = divideExperiments(emg_data, emg_trigger_data, emg_time, force_data, force_trigger_data, force_time);

%%
% Plot the results --------------------------------------------------------

figure;
vertical_spacing = 2;

for i = 1:size(force_runs, 1)
    % Subplot for HD-EMG data.
    subplot(size(force_runs, 1), 2, 2*i - 1);
    emg_segment = emg_runs{i, 1};
    time_segment_emg = emg_runs{i, 2};
    for channel = 1:size(emg_segment, 2)
        plot(time_segment_emg, emg_segment(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
        hold on;
    end
    title(['HD-EMG Experiment ' num2str(i)]);

    % Subplot for Force data.
    subplot(size(force_runs, 1), 2, 2*i);
    force_segment = force_runs{i, 1};
    time_segment_force = force_runs{i, 2};
    plot(time_segment_force, force_segment);
    title(['Force Experiment ' num2str(i)]);
end
