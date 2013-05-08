function [response_values, response_error] = get_experiment_condition_responses(experiment_group,return_struct)
%
% Averaging in the response values happens row-wise, all of the conditions
% that are specified in the return_struct in the same row will be combined,
% and all of the (potentially averaged) rows will be returned. Zeros are
% counted as non-conditions, and can be used to return many values with
% different numbers of columns i.e.
%     return_struct.inds = [1 2 3 4; 5 6 0 0; 7 0 0 0]
%
%   i.e. to return a bunch of trials with no symmetry operations etc.,:
%     return_struct.inds              = trials_for_normalization';
%     return_struct.flip_condition    = 0*return_struct.inds; % none of the inds need to be symmetry flipped since we are counting all of them 
%     return_struct.daq_channel       = 'lmr';        % lmr is turning channel
%     return_struct.normalization_val = 1;            % we haven't made this yet
%     return_struct.average_oper      = @mean;        % can be @mean or @median.
%     return_struct.timeseries_oper   = @mean;        % @mean returns the mean @(x,~)(x(:)); returns the whole timeseries
%     return_struct.average_type      = 'animal';     % average across reps and animals
%     return_struct.inds_to_use       = @(x,~)(x(:)); % returns all inds
%     return_struct.ps_offset_amt     = 0;            % ms before the trial to subtract out of the lmr response
%     
%     [a,e] = get_experiment_condition_responses(experiment_groups(group_num),return_struct);
%
%   i.e.:
%     return_struct.timeseries_oper   = @(x,dim)mean(abs(x),dim);
%       or some random filter.... etc.,
%     TODO: FIX THIS-> return_struct.inds_to_use = @(x,~)(x(1:1000));
%
% This function might get out of hand if I add more functionality.
% Plenty of comments to figure out how it works though.

for current_condition_set = 1:size(return_struct.inds,1);
    
    % Gather all of the responses as if no averaging were to be done.
    for current_condition_iter = 1:numel(return_struct.inds(current_condition_set,:))

        %all_responses{experiment/animal#}...
        all_responses = get_all_responses(current_condition_set,current_condition_iter);

        % Do averaging according to the return_struct, this gets confusing,
        % pretty confusing, but making a simpler / less swiss-army knife
        % version of this function is pretty easy.

        temp_avg_cell = [];
        temp_err_cell = [];
        
        switch return_struct.average_type

            case 'none'
                % Do no averaging, return a cell array of values per condition 
                % with individual repetitions not averaged.
                % For more conditions in the row of inds requested (i.e. the
                % 'current_condition_set'), append them below the current
                % request (and will error if they are of different lengths,
                % dummy).
                for j = 1:numel(all_responses)
                    temp_avg_cell{j} = return_struct.timeseries_oper(all_responses{j},2);
                end
                
                tmp_response_values(current_condition_iter,:) = temp_avg_cell;
                
                clear temp_avg_cell temp_err_cell

            case 'animal'
                % Average across reps, return a cell array of values per 
                % condition.
                % For each condition in the row of inds requested (i.e.
                % 'current_condition_set' variable), append them below each
                % other while iterating, and then will need to average again
                % outside this for loop.
                for j = 1:numel(all_responses)
                    temp_avg_cell{j} = return_struct.timeseries_oper(all_responses{j},2);
                end
                
                tmp_response_values(current_condition_iter,:) = temp_avg_cell;
                clear temp_avg_cell temp_err_cell

            case 'all'
                % Average across reps and animals, return a cell array of one
                % value per condition. For each condition in the row of inds
                % requested (i.e. 'current_condition_set' variable), append
                % them below each other while iterating. This will require one
                % additional averaging step outside of this loop.
                for j = 1:numel(all_responses)
                    temp_avg_cell{j} = return_struct.timeseries_oper(all_responses{j}',1)';
                end
                for j = 1:numel(temp_avg_cell)
                    temp_avg_cell{j} = return_struct.average_oper(temp_avg_cell{j},1);
                end
                
                tmp_response_values(current_condition_iter,:) = temp_avg_cell;
                
                clear temp_avg_cell temp_err_cell

            otherwise
                error('not valid entry for return_struct.average_type')
        end
        
        clear all_responses
    end
    
    % Some more averaging / combination is needed
    switch return_struct.average_type
        
        case 'none'
            response_values{current_condition_set,:} = combine_cell_cols(tmp_response_values);
            
            % No error caclulation because there was no averaging here.
            response_error = [];
            
        case 'animal'
            temp_avg_cell = combine_cell_cols(tmp_response_values);
            for j = 1:size(temp_avg_cell,2)
                temp_err_cell{j} = std(temp_avg_cell{j},1)/sqrt(size(temp_avg_cell{j},1));
                temp_avg_cell{j} = return_struct.average_oper(temp_avg_cell{j},1);
            end
            
            response_values{current_condition_set,:} = temp_avg_cell;
            
            % To calculate error with 'animal' we looked at the standard
            % error between each fly's responses within the group (row in
            % the return_struct.inds)
            response_error{current_condition_set,:} = temp_err_cell;
            clear temp_avg_cell temp_err_cell
            
        case 'all'
            % Average the sets of symmetrical conditions within each
            % animal before averaging between the animals
            temp_avg_cell = []; iter = 1;
            for c = 1:size(tmp_response_values,2)
                temp_reshaping_mat = [];
                for r = 1:size(tmp_response_values,1)
                    temp_reshaping_mat(r,:) = tmp_response_values{r,c};
                end
                temp_avg_cell(iter,:) = return_struct.average_oper(temp_reshaping_mat,1);
                iter = iter + 1;
            end
            
            response_values{current_condition_set,:} = return_struct.average_oper(temp_avg_cell,1);
            
            % To calculate error with 'all', we treat each fly as one N,
            % and only care about each fly's average response (within one
            % row of return_struct.inds) to get a standard error.
            response_error{current_condition_set,:} = std(temp_avg_cell,1)/sqrt(size(tmp_response_values,2));
            clear temp_avg_cell temp_err_cell
    end

    clear tmp_response_values temp_err_cell

end

    % Some return_struct flags are used in this helper function
    function all_responses = get_all_responses(current_condition_set,current_condition_iter)
        condition_index = return_struct.inds(current_condition_set,current_condition_iter);
        
        if (strcmp(return_struct.daq_channel,'lmr') || strcmp(return_struct.daq_channel,'lpr')) && return_struct.ps_offset_amt > 0
            for exp_num = 1:numel(experiment_group.parsed_data)
                ps_mean = nanmean(experiment_group.parsed_data(exp_num).ps_data(condition_index).(return_struct.daq_channel)(:,(end-return_struct.ps_offset_amt):end),2);
                len=size(experiment_group.parsed_data(exp_num).data(condition_index).(return_struct.daq_channel),2);
                all_responses{exp_num} = experiment_group.parsed_data(exp_num).data(condition_index).(return_struct.daq_channel)-repmat(ps_mean,1,len); %#ok<*AGROW>
            end
        else
            for exp_num = 1:numel(experiment_group.parsed_data)
                all_responses{exp_num} = experiment_group.parsed_data(exp_num).data(condition_index).(return_struct.daq_channel); %#ok<*AGROW>
            end
        end
        %all_responses{exp_num}(repetition_num,timeseries)

        if (strcmp(return_struct.daq_channel,'lmr') || (strcmp(return_struct.daq_channel,'lpr') && return_struct.ps_offset_amt > 0)) ...
           && return_struct.flip_condition(current_condition_set,current_condition_iter)
            for exp_num = 1:numel(all_responses)
                all_responses{exp_num} = -all_responses{exp_num};
            end
        end
        
        if (strcmp(return_struct.daq_channel,'lmr') || ...
                strcmp(return_struct.daq_channel,'r_wba') || ...
                strcmp(return_struct.daq_channel,'l_wba'))...
            && return_struct.normalization_val ~=1
            
            for exp_num = 1:numel(all_responses)
                all_responses{exp_num} = return_struct.normalization_val*all_responses{exp_num};
            end
        end
        
    end

    function cell_out = combine_cell_cols(cell_in)
        % Just combines rows of cells for output ease
        for col = 1:size(cell_in,2)
            tmp = [];
            for row = 1:size(cell_in,1)
                tmp = [tmp; cell_in{row,col}];
            end
            cell_out{col} = tmp;
        end
    end
    
end
