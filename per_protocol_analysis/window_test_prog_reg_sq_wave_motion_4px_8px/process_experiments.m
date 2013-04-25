% process_experiments
% Load in groups of experiments (sorted by folders) and pull out
% information on specific conditions (or groups of conditions) for further
% analysis / plotting.
%
% Save a summary file as well: summ_data.mat 

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Group experiments by their folders, give more information
%==========================================================================
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/window_test_prog_reg_sq_wave_motion_4px_8px';

experiment_groups(1).folder = 'gmr_29g11dbd_gal80ts_kir21';
experiment_groups(1).name   = '+;R29g11DBD/Kir2.1(DL)';

% Load in all of the experiment groups via their saved summaries (creating saved summaries if they don't exist)
%==========================================================================
save_summaries = 1;

% this creates: experiment_group(folder#).parsed_data(experiment#).data(condition#).lmr(rep#,:)

for i = 1:numel(experiment_groups)
    if ~isfield(experiment_groups(i),'metadata') || isempty(experiment_groups(i).metadata)
        % import/save a group summary if it does not already exist
        experiment_group_summary = fullfile(experiment_group_folder_loc,experiment_groups(i).folder,[experiment_groups(i).folder '.mat']);
        disp([num2str(i) '/' num2str(numel(experiment_groups)) '===' experiment_groups(i).folder])

        if ~exist(experiment_group_summary,'file')
            experiment_group = import_experiment_group(fullfile(experiment_group_folder_loc,experiment_groups(i).folder),save_summaries);
            experiment_groups(i).parsed_data    = [experiment_group.parsed_data]; %#ok<*SAGROW>
            experiment_groups(i).metadata       = experiment_group.metadata;
            clear experiment_group
        else
            load(experiment_group_summary); % loads experiment_group variable
            experiment_groups(i).parsed_data 	= [experiment_group.parsed_data];
            experiment_groups(i).metadata       = [experiment_group.metadata];
            clear experiment_group
        end
    end
end
clear overwrite_saved_summaries i

% Set up condition indicies to stimulus type mapping
%==========================================================================

% @ 'Users/stephenholtz/panels_experiments/protocols/window_test_prog_reg_sq_wave_motion_4px_8px/window_test_prog_reg_sq_wave_motion_4px_8px.m';
i=1;%      1
cond_group(i).name = 'prog_30to90_4px';
cond_group(i).description = 'Progressive Motion 30-90 4Pix';
cond_group(i).inds =  ...
                [ 8,1;...
                 10,3;...
                 12,5]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    2
cond_group(i).name = 'prog_45to105_4px';
cond_group(i).description = 'Progressive Motion 45-105 4Pix';
cond_group(i).inds =  ...
                [20,13;...
                 22,15;...
                 24,17]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '45-105';

i=i+1;%    3
cond_group(i).name = 'prog_30to120_4px';
cond_group(i).description = 'Progressive Motion 30-120 4Pix';
cond_group(i).inds =  ...
                [32,25;...
                 34,27;...
                 36,29]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-120';

i=i+1;%    4
cond_group(i).name = 'prog_45to135_4px';
cond_group(i).description = 'Progressive Motion 45-135 4Pix';
cond_group(i).inds =  ...
                [44,37;...
                 46,39;...
                 48,41]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '45-135';

i=i+1;%    5
cond_group(i).name = 'prog_30to90_8px';
cond_group(i).description = 'Progressive Motion 30-90 8Pix';
cond_group(i).inds =  ...
                [56,49;...
                 58,51;...
                 60,53]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    6
cond_group(i).name = 'prog_45to105_8px';
cond_group(i).description = 'Progressive Motion 45-105 8Pix';
cond_group(i).inds =  ...
                [68,61;...
                 70,63;...
                 72,65]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '45-105';

i=i+1;%    7
cond_group(i).name = 'prog_30to120_8px';
cond_group(i).description = 'Progressive Motion 30-120 8Pix';
cond_group(i).inds =  ...
                [80,73;...
                 82,75;...
                 84,77]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-120';

i=i+1;%    8
cond_group(i).name = 'prog_45to135_8px';
cond_group(i).description = 'Progressive Motion 45-135 8Pix';
cond_group(i).inds =  ...
                [92,85;...
                 94,87;...
                 96,89]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '45-135';

i=i+1;%    9
cond_group(i).name = 'reg_30to90_4px';
cond_group(i).description = 'Regressive Motion 30-90 4Pix';
cond_group(i).inds =  ...
                [2,7;...
                 4,9;...
                 6,11]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    10
cond_group(i).name = 'reg_45to105_4px';
cond_group(i).description = 'Regressive Motion 45-105 4Pix';
cond_group(i).inds =  ...
                [14,19;...
                 16,21;...
                 18,23]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '45-105';

i=i+1;%    11
cond_group(i).name = 'reg_30to120_4px';
cond_group(i).description = 'Regressive Motion 30-120 4Pix';
cond_group(i).inds =  ...
                [26,31;...
                 28,33;...
                 30,35]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-120';

i=i+1;%    12
cond_group(i).name = 'reg_45to135_4px';
cond_group(i).description = 'Regressive Motion 45-135 4Pix';
cond_group(i).inds =  ...
                [38,43;...
                 40,45;...
                 42,47]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [4 4 4];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '45-135';

i=i+1;%    13
cond_group(i).name = 'reg_30to90_8px';
cond_group(i).description = 'Regressive Motion 30-90 8Pix';
cond_group(i).inds =  ...
                [50,55;...
                 52,57;...
                 54,59]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    14
cond_group(i).name = 'reg_45to105_8px';
cond_group(i).description = 'Regressive Motion 45-105 8Pix';
cond_group(i).inds =  ...
                [62,67;...
                 64,69;...
                 66,71]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [60 60 60];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '45-105';

i=i+1;%    15
cond_group(i).name = 'reg_30to120_8px';
cond_group(i).description = 'Regressive Motion 30-120 8Pix';
cond_group(i).inds =  ...
                [74,79;...
                 76,81;...
                 78,83]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-120';

i=i+1;%    16
cond_group(i).name = 'reg_45to135_8px';
cond_group(i).description = 'Regressive Motion 45-135 8Pix';
cond_group(i).inds =  ...
                [86,91;...
                 88,93;...
                 90,95]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8];
cond_group(i).window = [90 90 90];
cond_group(i).pix = [8 8 8];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 57:72;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '45-135';

% Pull out conditions from experiment groups
%==========================================================================

% summarized data is grouped for plotting / easy sharing i.e.
% summ_data.group_info(experiment_group_num).group_name = 'gmr...';
% summ_data.group_info(experiment_group_num).group_metadata = [experiment_groups(experiment_group_num).metadata]
% summ_data.(cond_group_name)(experiment_group_num).info = cond_group
% summ_data.(cond_group_name)(experiment_group_num).(flip,cw,ccw).(avg_lmr,avg_lmr_ts} = [some data];

%useful anon func for making a vector;
mk_sym_vec = @(vec)([zeros(size(vec,1),1),ones(size(vec,1),1)]);

% Determine normalization values (average lmr, wbf per experiment group)
for group_num = 1:numel(experiment_groups)
    
    trials_for_normalization = 1:numel(experiment_groups(group_num).metadata(1).protocol_conditions.experiment);
    
    return_struct.inds              = trials_for_normalization; % Put all conditions in one big set
    return_struct.flip_condition    = zeros(1,numel(trials_for_normalization));
    return_struct.daq_channel       = 'lmr';        % lmr is turning channel
    return_struct.normalization_val = 1;            % we haven't made this yet
    return_struct.average_oper      = @nanmean;        % can be @nanmean or @median.
    return_struct.timeseries_oper   = @nanmean;        % @nanmean returns the timeseries mean @(x,~)(x) returns the whole timeseries
    return_struct.average_type      = 'all';        % average across reps and animals
    return_struct.inds_to_use       = @(x,~)(x);    % returns all inds.. NOT WORKING YET!
    return_struct.ps_offset_amt     = 25;           % ms before the trial to subtract out of the lmr response
    
    [a,e] = get_experiment_condition_responses(experiment_groups(group_num),return_struct);
    summ_data.mean_turn_resp(group_num) = a{1};
end

summ_data.overall_mean_turn_resp = mean(summ_data.mean_turn_resp);

for exp_grp_num = 1:numel(experiment_groups)

    % Copy metadata over.
    summ_data.group_info(exp_grp_num).group_name = experiment_groups(exp_grp_num).name;
    summ_data.group_info(exp_grp_num).group_metadata = [experiment_groups(exp_grp_num).metadata];
    summ_data.group_info(exp_grp_num).group_folder = experiment_groups(exp_grp_num).folder;
    summ_data.group_info(exp_grp_num).N = size(experiment_groups(exp_grp_num).parsed_data,2);
    
    for cg_num = 1:numel(cond_group)
        
        cond_group_name = cond_group(cg_num).name;
        
        % Copy info from cond_group struct
        summ_data.(cond_group_name)(exp_grp_num).info = cond_group(cg_num);

        return_struct.daq_channel       = 'lmr';        % lmr is turning channel
        return_struct.normalization_val = 1;
        return_struct.average_oper      = @nanmean;     % can be @nanmean @median etc...
        return_struct.inds_to_use       = @(x,~)(x);    % returns all inds.. NOT WORKING YET!
        return_struct.ps_offset_amt     = 50;           % ms before the trial to subtract out of the lmr response

        % Pull in the condition_group responses (per symmetry type)
        for sym = 1:3
            
            if sym == 1
                sym_type = 'flip';
                return_struct.inds = cond_group(cg_num).inds;
                return_struct.flip_condition = cond_group(cg_num).flip_inds;
            elseif sym == 2
                sym_type = 'cw';
                return_struct.inds = cond_group(cg_num).inds(:,1);
                return_struct.flip_condition = 0*return_struct.inds;
            elseif sym == 3
                sym_type = 'ccw';
                return_struct.inds = cond_group(cg_num).inds(:,2);
                return_struct.flip_condition = 0*return_struct.inds;
            end
            
            for ws = {'lmr'}
                wing_sig = ws{1};
                
                return_struct.timeseries_oper   = @(x,~)(x);
                return_struct.daq_channel       = wing_sig;
                return_struct.average_type      = 'all';
                [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['avg_' wing_sig '_ts']) = a;
                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['sem_' wing_sig '_ts']) = e;

                return_struct.timeseries_oper   = @nanmean;
                return_struct.daq_channel       = wing_sig;
                return_struct.average_type      = 'all';
                [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['avg_' wing_sig]) = a;
                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['sem_' wing_sig]) = e;

                return_struct.timeseries_oper   = @nanmean;
                return_struct.daq_channel       = wing_sig;
                return_struct.average_type      = 'animal'; % This is for stats
                [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig]) = a;
                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_sem_' wing_sig]) = e;
                
            end
            
            return_struct.timeseries_oper   = @(x,~)(x);
            return_struct.daq_channel       = 'x_pos';
            return_struct.average_type      = 'all';
            [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);
            
            summ_data.(cond_group_name)(exp_grp_num).(sym_type).avg_x_ts = a;
            summ_data.(cond_group_name)(exp_grp_num).(sym_type).sem_x_ts = e;
            
            return_struct.timeseries_oper   = @(x,~)(x);
            return_struct.daq_channel       = 'y_pos';
            return_struct.average_type      = 'all';
            [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);
            
            summ_data.(cond_group_name)(exp_grp_num).(sym_type).avg_y_ts = a;
            summ_data.(cond_group_name)(exp_grp_num).(sym_type).sem_y_ts = e;

        end
    end
end

% Save the summarized set of experiment group responses
%==========================================================================

summ_data_loc = fullfile(experiment_group_folder_loc,'summ_data');
fprintf('\n Saving summarized data...\n %s.mat\n',summ_data_loc)
save(summ_data_loc,'summ_data');

