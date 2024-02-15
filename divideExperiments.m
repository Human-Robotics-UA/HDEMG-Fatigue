function [emg_runs, force_runs] = divideExperiments(emg_data, emg_trigger_data, emg_time, emg_trigger_time, force_data, force_trigger_data, force_time, force_trigger_time)
    threshold = 0.5;
    force_diff = diff(force_trigger_data);
    force_peaks = find(abs(force_diff) > threshold);

    force_peaks = force_peaks(1:2:end);

    force_runs = cell(4, 2); % 4 experiments
    force_runs_beforecut = cell(4, 2);
    cutted_indices = cell(4, 2);
    if length(force_peaks) >= 2
        % Plot HD-EMG segments between each pair of indices
    %     figure;

        iterator = 1;

        if length(force_peaks) > 8 
            initial_trigger = 3;
        else
            initial_trigger = 1;
        end

        for i = initial_trigger:2:length(force_peaks)-1
            start_index = force_peaks(i);
            end_index = force_peaks(i+1);

            % Extract HD-EMG data segment between each pair of indices
            force_segment = force_data(start_index:end_index);
            time_segment = force_time(start_index:end_index);
            trigger_segment = force_trigger_data(start_index:end_index);

            total_experiments = (length(force_peaks)-2)/2;
            num_experiment = floor((i)/2);

            force_runs_beforecut{iterator,1} = force_segment;
            force_runs_beforecut{iterator,2} = time_segment;

            array_ordenado = sort(force_segment, 'descend');
            second_value = array_ordenado(1000);
            disp(max(force_segment));
            disp(second_value);
            threshold = 0.75 * max(force_segment);
            filtered_indices = find(force_segment > threshold);
            pos_slope_limit = filtered_indices(1);
            neg_slope_limit = filtered_indices(end) + 1; % Suma 1 para incluir el último punto de la bajada

            cutted_indices{iterator, 1} = pos_slope_limit;
            cutted_indices{iterator, 2} = neg_slope_limit;

            % Define el rango de muestras a mantener (el plateau)
            actual_range = pos_slope_limit:neg_slope_limit;

            % Corta la señal de fuerza para mantener solo el rango de muestras de mantenimiento
            cutted_force = force_segment(actual_range);
            cutted_time = time_segment(actual_range);

            force_runs{iterator,1} = cutted_force;
            force_runs{iterator,2} = cutted_time;

            % Plot the HD-EMG experiments
    %         subplot(total_experiments, 2, iterator);
    %         plot(time_segment, force_segment);
    %         title(['Force Signal for Experiment ' num2str(num_experiment)]);
    %         
    %         iterator = iterator + 1;
    %         
    %         subplot(total_experiments, 2, iterator);
    %         plot(time_segment, trigger_segment);
    %         title(['Trigger Signal for Experiment ' num2str(num_experiment)]);
    %         
            iterator = iterator + 1;
        end
    else
        disp('Insufficient number of peaks.');
    end
    
    % Find peaks in the trigger signal where the signal is greater than the
    % threshold.
    threshold = 2;
    trigger_diff = diff(emg_trigger_data);
    trigger_peaks = find(abs(trigger_diff) > threshold);

    % Extract the first three digits of each value
    first_three_digits = floor(trigger_peaks / 100);

    % Find unique first three digits and their indices
    [unique_first_three, ~, ic] = unique(first_three_digits);

    % Use accumarray to find the first occurrence of each unique first three digits
    first_occurrence_idx = accumarray(ic, trigger_peaks, [], @min);

    % unique_trigger_peaks contains the indices of unique trigger peaks
    unique_trigger_peaks = first_occurrence_idx;

    emg_runs = cell(4, 2); % 4 experiments
    emg_runs_beforecut = cell(4, 2);
    if length(unique_trigger_peaks) >= 2
        % Plot HD-EMG segments between each pair of indices
    %     figure;

        iterator = 1;
        if length(unique_trigger_peaks) > 8 
            initial_trigger = 3;
        else
            initial_trigger = 1;
        end

        for i = initial_trigger:2:length(unique_trigger_peaks)-1
            start_index = unique_trigger_peaks(i);
            end_index = unique_trigger_peaks(i+1);

            % Extract HD-EMG data segment between each pair of indices
            emg_segment = emg_data(start_index:end_index, :);
            time_segment = emg_time(start_index:end_index);
            trigger_segment = emg_trigger_data(start_index:end_index);

            total_experiments = (length(trigger_peaks)-2)/2;
            num_experiment = floor((i)/2);

            emg_runs_beforecut{iterator,1} = emg_segment;
            emg_runs_beforecut{iterator,2} = time_segment;
    %         
    %         longitud_recorte_fuerza = length(force_runs_beforecut{iterator,1}) - length(force_runs{iterator,1});

            % Calcula el porcentaje de recorte en la señal de EMG
    %         porcentaje_recorte_emg = longitud_recorte_fuerza / length(emg_segment);

            % Calcula el tamaño del recorte en la señal de EMG
    %         longitud_recorte_emg = round(length(emg_segment) * porcentaje_recorte_emg);

            % Calcula los índices de corte para la señal de EMG
    %         initial_cut_emg = round(cutted_indices{iterator,1} * (1 + porcentaje_recorte_emg)); % Ajusta el inicio del corte
    %         final_cut_emg = round(cutted_indices{iterator,2} * (1 + porcentaje_recorte_emg)); % Ajusta el final del corte

            % Realiza el corte correspondiente en la señal de EMG
    %         emg_cutted = emg_segment(initial_cut_emg:final_cut_emg);
    %         time_emg_cutted = time_segment(initial_cut_emg:final_cut_emg);

            initial_cut_emg = round(cutted_indices{iterator,1} * 2);
            final_cut_emg = round(cutted_indices{iterator,2} * 2);
            final_cut_emg = min(final_cut_emg, length(emg_segment));
            emg_cutted = emg_segment(initial_cut_emg:final_cut_emg, :);
            time_emg_cutted = time_segment(initial_cut_emg:final_cut_emg);

    %         disp(initial_cut_emg);
    %         disp(final_cut_emg);

            emg_runs{iterator,1} = emg_cutted;
            emg_runs{iterator,2} = time_emg_cutted;

            % Plot the HD-EMG experiments
    %         subplot(total_experiments, 2, iterator);
    %         for channel = 1:size(emg_segment, 2)
    %             plot(time_segment, emg_segment(:, channel) + vertical_spacing * channel, 'DisplayName', sprintf('Channel %d', channel));
    %             hold on;
    %         end
    %         title(['HD-EMG Signal for Experiment ' num2str(num_experiment)]);
    %         
    %         iterator = iterator + 1;
    %         
    %         subplot(total_experiments, 2, iterator);
    %         plot(time_segment, trigger_segment);
    %         title(['Trigger HD-EMG Signal for Experiment ' num2str(num_experiment)]);

            iterator = iterator + 1;
        end
    else
        disp('Insufficient number of peaks.');
    end
end