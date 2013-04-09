function parsed_exp_data = parse_volt_encoded_exp_data(data_file,condition_lengths,interspersal_length) 

% Constant variables. May need optimization in the future
ANALOGTOLERANCE         = 0.03;
DURATIONTOLERANCE       = 0.05;
SAMPLERATE              = 1000;

% Split Needed Chans from the .daq file
raw_data         = daqread(data_file);         
encoded_signal  = raw_data(:,7);

% Find all the times where adjacent voltage values differ by a
% tolerance
coarse_differences  = find(abs(diff(encoded_signal > ANALOGTOLERANCE*2)));
coarse_differences  = [coarse_differences((diff(coarse_differences) > DURATIONTOLERANCE*SAMPLERATE)); coarse_differences(end)];

% Group the similar voltage segment
start_value = coarse_differences(1:2:end);    
end_value   = coarse_differences(2:2:end);

% Determine the voltage_values
voltage_values = [];   
for value_index = 1:numel(end_value) % Use end_value to avoid errors
    curr_voltage_values = encoded_signal(start_value(value_index):end_value(value_index));
    curr_voltages = median(curr_voltage_values); % Best moct to use here
    voltage_values = [voltage_values curr_voltages];
end

% Sort and determine unique values. Assume each is a condition where
% its index == its condition number in the experiment. Much cleaner to
% break it into two for loops.
voltage_values = sort([voltage_values Inf]);
voltage_values = voltage_values(diff(voltage_values) > ANALOGTOLERANCE/2);

% Make sure there are actually a reasonable number of voltage values
% left... i.e. the tolerance is not set wrong
if (numel(voltage_values) < 1) || (numel(voltage_values) < numel(condition_lengths)*.5)
    error('Problem with voltages parsed. Probably a bad tolerance value')
end

% Some error checking on the diff between voltage_values (all should be
% just about equal...)
if range(diff(voltage_values)) > ANALOGTOLERANCE*5 % sometimes there is an offset with the first value... no idea why
    error('Problem with parsing voltage values: diff is inconsistent');
end

parsed_exp_data = [];
for d_field = {'data','ps_data'}
    for field = {'left_amp','x_pos','right_amp','y_pos','wbf','voltage','free','lmr'}
        for c_ind = 1:numel(voltage_values)
            parsed_exp_data.(d_field{1})(c_ind).(field{1}) = [];  %#ok<*AGROW>
        end
    end
end
for i = 1:numel(condition_lengths)
    condition_attempts{i} = 0;
end

for value_index = 1:numel(end_value)
    current_block = start_value(value_index):end_value(value_index);
    curr_voltage_values = encoded_signal(current_block);
    [~, condition_number] = min(abs(mean(curr_voltage_values) - voltage_values));
    condition_length = condition_lengths(condition_number)*SAMPLERATE;

    % this might cause problems!!
    condition_length = floor(condition_length);
    
    if isempty(parsed_exp_data.data(condition_number).left_amp)
        rep = 1;
    else
        rep = size(parsed_exp_data.data(condition_number).left_amp,1) + 1;
    end
    
    % For debugging
    condition_attempts{condition_number} = 1 + condition_attempts{condition_number};
    
    if numel(current_block) >= condition_length;
        parsed_exp_data.data(condition_number).left_amp(rep,:)         = raw_data(current_block(1:condition_length),1)';
        parsed_exp_data.data(condition_number).x_pos(rep,:)            = raw_data(current_block(1:condition_length),4)';
        parsed_exp_data.data(condition_number).right_amp(rep,:)        = raw_data(current_block(1:condition_length),2)';
        parsed_exp_data.data(condition_number).y_pos(rep,:)            = raw_data(current_block(1:condition_length),5)';
        parsed_exp_data.data(condition_number).wbf(rep,:)              = raw_data(current_block(1:condition_length),3)';
        parsed_exp_data.data(condition_number).voltage(rep,:)          = encoded_signal(current_block(1:condition_length))';
        parsed_exp_data.data(condition_number).free(rep,:)             = raw_data(current_block(1:condition_length),6)';
        
        parsed_exp_data.data(condition_number).lmr(rep,:) = parsed_exp_data.data(condition_number).left_amp(rep,:) - parsed_exp_data.data(condition_number).right_amp(rep,:);
        parsed_exp_data.data(condition_number).lpr(rep,:) = parsed_exp_data.data(condition_number).left_amp(rep,:) + parsed_exp_data.data(condition_number).right_amp(rep,:);
        
        % Get the pre stimulus (ps) data...
        % This depends on there being an opening closed loop segment!!!!
        if value_index == 1
            ps_block = 1:interspersal_length*SAMPLERATE;
        else
            ps_block = (current_block(1)-(interspersal_length*SAMPLERATE)):(current_block(1)-1);
        end
        
        parsed_exp_data.ps_data(condition_number).left_amp(rep,:)         = raw_data(ps_block,1)';
        parsed_exp_data.ps_data(condition_number).x_pos(rep,:)            = raw_data(ps_block,4)';
        parsed_exp_data.ps_data(condition_number).right_amp(rep,:)        = raw_data(ps_block,2)';
        parsed_exp_data.ps_data(condition_number).y_pos(rep,:)            = raw_data(ps_block,5)';
        parsed_exp_data.ps_data(condition_number).wbf(rep,:)              = raw_data(ps_block,3)';
        parsed_exp_data.ps_data(condition_number).voltage(rep,:)          = encoded_signal(ps_block)';
        parsed_exp_data.ps_data(condition_number).free(rep,:)             = raw_data(ps_block,6)';
        
        parsed_exp_data.ps_data(condition_number).lmr(rep,:) = parsed_exp_data.ps_data(condition_number).left_amp(rep,:) - parsed_exp_data.ps_data(condition_number).right_amp(rep,:);
        parsed_exp_data.ps_data(condition_number).lpr(rep,:) = parsed_exp_data.ps_data(condition_number).left_amp(rep,:) + parsed_exp_data.ps_data(condition_number).right_amp(rep,:);
    else
        
    end

end

% Fill in NaNs where there were not sucessful trials.
for condition_number = 1:numel(condition_lengths)

    if isempty(parsed_exp_data.data(condition_number).lpr)

        condition_length = condition_lengths(condition_number)*SAMPLERATE;

        % Fill in the data fields
        nan_data = nan(1,condition_length);

        parsed_exp_data.data(condition_number).left_amp(rep,:)         = nan_data;
        parsed_exp_data.data(condition_number).x_pos(rep,:)            = nan_data;
        parsed_exp_data.data(condition_number).right_amp(rep,:)        = nan_data;
        parsed_exp_data.data(condition_number).y_pos(rep,:)            = nan_data;
        parsed_exp_data.data(condition_number).wbf(rep,:)              = nan_data;
        parsed_exp_data.data(condition_number).voltage(rep,:)          = nan_data;
        parsed_exp_data.data(condition_number).free(rep,:)             = nan_data;

        parsed_exp_data.data(condition_number).lmr(rep,:) = nan_data;
        parsed_exp_data.data(condition_number).lpr(rep,:) = nan_data;
        
        % Fill in the ps_data fields
        nan_ps_data = nan(1,interspersal_length*SAMPLERATE);

        parsed_exp_data.ps_data(condition_number).left_amp(rep,:)         = nan_ps_data;
        parsed_exp_data.ps_data(condition_number).x_pos(rep,:)            = nan_ps_data;
        parsed_exp_data.ps_data(condition_number).right_amp(rep,:)        = nan_ps_data;
        parsed_exp_data.ps_data(condition_number).y_pos(rep,:)            = nan_ps_data;
        parsed_exp_data.ps_data(condition_number).wbf(rep,:)              = nan_ps_data;
        parsed_exp_data.ps_data(condition_number).voltage(rep,:)          = nan_ps_data;
        parsed_exp_data.ps_data(condition_number).free(rep,:)             = nan_ps_data;

        parsed_exp_data.ps_data(condition_number).lmr(rep,:) = nan_ps_data;
        parsed_exp_data.ps_data(condition_number).lpr(rep,:) = nan_ps_data;

    end
end

end