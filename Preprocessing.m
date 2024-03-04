
second_run = emg_runs{2,1};
time_second_run = emg_runs{2,2};

len = length(second_run);
channels = 64;
rectified_second_run = zeros(size(second_run));

for i = 1:len
   for j = 1:channels
       rectified_second_run(i,j) = abs(second_run(i,j));
   end
end

vertical_spacing = 2;

figure;
% subplot(2,1,1);
% for channel = 1:size(second_run, 2)
%     plot(time_second_run, second_run(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
%     hold on;
% end
% title('Original signal');

% subplot(2,1,2);
for channel = 1:size(second_run, 2)
    plot(time_second_run, rectified_second_run(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
    hold on;
end
title('Rectified signal');

% Define the sampling frequency
Fs = 2000;

% Define the notch frequency
notch_freq = 50; % Hz

% Design the notch filter
[b, a] = iirnotch(notch_freq/(Fs/2), 10 / Fs);

% Apply the notch filter to each channel of the rectified signal
filtered_second_run = zeros(size(rectified_second_run));
for i = 1:channels
    filtered_second_run(:, i) = filter(b, a, rectified_second_run(:, i));
end

% Plot the rectified signal with the notch filter applied
figure;
vertical_spacing = 2;
plot(time_second_run, filtered_second_run);
for channel = 1:size(filtered_second_run, 2)
    plot(time_second_run, filtered_second_run(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
    hold on;
end
title('Rectified signal with 50 Hz Notch filter');
   

Extract the second run and its corresponding time
second_run = emg_runs{2,1};
time_second_run = emg_runs{2,2};

% Rectify the signal
rectified_second_run = abs(second_run);

% Compute linear envelope for each channel
linear_envelope = zeros(size(rectified_second_run));
for channel = 1:size(rectified_second_run, 2)
    linear_envelope(:, channel) = smooth(rectified_second_run(:, channel), 400); % Smoothing can be adjusted as needed
end

% Plot the original and averaged rectified signals
figure;
subplot(2,1,1);
for channel = 1:size(second_run, 2)
    plot(time_second_run, second_run(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
    hold on;
end
title('Original signal');
xlabel('Time');
ylabel('Amplitude');

subplot(2,1,2);
for channel = 1:size(linear_envelope, 2)
    plot(time_second_run, linear_envelope(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
    hold on;
end
title('Averaged Rectified Signal');
xlabel('Time');
ylabel('Amplitude');

user = 'H001B0101';

csvwrite(['results/' user '/' 'emg_experiment_2_preprocessed' '.csv'], linear_envelope);

% Select a specific channel for preprocessing
channel_to_process = 1; % Change this to the desired channel number

% Extract the second run and its corresponding time
second_run = emg_runs{2,1};
time_second_run = emg_runs{2,2};

% Select the desired channel
selected_channel = second_run(:, channel_to_process);

% Rectify the signal
rectified_signal = abs(selected_channel);

% Compute linear envelope for the selected channel
linear_envelope = smooth(rectified_signal, 400); % Smoothing can be adjusted as needed

% Plot the original signal and its linear envelope
figure;
subplot(2,1,1);
plot(time_second_run, selected_channel);
title(['Original signal - Channel ', num2str(channel_to_process)]);
xlabel('Time');
ylabel('Amplitude');

subplot(2,1,2);
plot(time_second_run, linear_envelope);
title(['Linear Envelope - Channel ', num2str(channel_to_process)]);
xlabel('Time');
ylabel('Amplitude');


