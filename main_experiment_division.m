%% 
% Reading HD-EMG signals --------------------------------------------------

user = 'H003B0101';

% Default users
[emg_data, emg_trigger_data, emg_time, emg_trigger_time] = readEMGData(user,false,'_1.mat','_2.mat');

% User H022B0101
%[emg_data, emg_trigger_data, emg_time, emg_trigger_time] = readEMGData(user,false);

% User H032B0101
%[emg_data, emg_trigger_data, emg_time, emg_trigger_time] = readEMGData(user,false,'_1.mat','_2.mat','_3.mat');

%% 
% Reading Force and Trigger signals ---------------------------------------

[force_data, force_trigger_data, force_time, force_trigger_time] = readFORCEData(user);

%%
% Get the four experiments ------------------------------------------------

[emg_runs, force_runs] = divideExperiments(emg_data, emg_trigger_data, emg_time, force_data, force_trigger_data, force_time);

%%
% Plot the results --------------------------------------------------------

vertical_spacing = 2;

figure;
subplot(5, 1, [2 1]); % This plot has to be bigger in order to visualize all channels correctly.
for channel = 1:size(emg_data, 2)
    plot(emg_time, emg_data(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
    hold on;
end
ylabel('HD-EMG Signal');
title('HD-EMG Signal over Time');

subplot(5, 1, 3);
plot(emg_trigger_time, emg_trigger_data);
title('HD-EMG Trigger Values');

% Subplot for force values.
subplot(5, 1, 4);
plot(force_time, force_data);
title('Force Values');
ylabel('Force');

% Subplot for trigger values.
subplot(5, 1, 5);
plot(force_trigger_time, force_trigger_data);
title('Force Trigger Values');
xlabel('Time (seconds)');
ylabel('Trigger');

figure;
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

%%
% Save the experiments ----------------------------------------------------

% Saving in .mat format
save(['results/' user '/' 'emg_and_force_runs_' user '.mat'], 'emg_runs', 'force_runs');

% Saving in .csv format
for i = 1:size(emg_runs, 1)
    emg_segment = emg_runs{i, 1}; csvwrite(['results/' user '/' 'emg_experiment_' num2str(i) '.csv'], emg_segment);
end

for i = 1:size(force_runs, 1)
    force_segment = force_runs{i, 1}; csvwrite(['results/' user '/' 'force_experiment_' num2str(i) '.csv'], force_segment);
end

