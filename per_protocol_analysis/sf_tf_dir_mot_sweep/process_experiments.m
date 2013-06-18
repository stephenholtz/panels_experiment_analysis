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
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/finished_misc_prog_reg_stims';

experiment_groups(1).folder = 'gmr_48a08ad_gal80ts_kir21';
experiment_groups(1).name   = 'R48a08AD;+/Kir2.1(DL)';
experiment_groups(1).type   = 'Ctrl(a)';
% 
% experiment_groups(2).folder = 'gmr_11d03ad_gal80ts_kir21';
% experiment_groups(2).name   = 'R11d03AD;+/Kir2.1(DL)';
% experiment_groups(2).type   = 'Ctrl(b)';
% 
% experiment_groups(3).folder = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
% experiment_groups(3).name   = 'R25b02AD;R48d11DBD/Kir2.1(DL)';
% experiment_groups(3).type   = 'C2(a)';
% 
% experiment_groups(4).folder = 'gmr_20c11ad_25b02dbd_gal80ts_kir21';
% experiment_groups(4).name   = 'R20c11AD;R25b02DBD/Kir2.1(DL)';
% experiment_groups(4).type   = 'C2(b)';
% 
% experiment_groups(5).folder = 'gmr_26h02ad_29g11dbd_gal80ts_kir21';
% experiment_groups(5).name   = 'R26h02AD;R29g11DBD/Kir2.1(DL)';
% experiment_groups(5).type   = 'C3(a)';
% 
% experiment_groups(6).folder = 'gmr_35a03ad_29g11dbd_gal80ts_kir21';
% experiment_groups(6).name   = 'R35a03AD;R29g11DBD/Kir2.1(DL)';
% experiment_groups(6).type   = 'C3(b)';
% 
% experiment_groups(7).folder = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
% experiment_groups(7).name   = 'R20c11AD;R48D11DBD/Kir2.1(DL)';
% experiment_groups(7).type   = 'C2/3';
% 
% experiment_groups(8).folder = 'gmr_92a10ad_17d06dbd_gal80ts_kir21';
% experiment_groups(8).name   = 'R92a01AD;R17d06DBD/Kir2.1(DL)';
% experiment_groups(8).type   = 'LAI(a)';
% 
% experiment_groups(9).folder = 'gmr_92a10ad_66a02dbd_gal80ts_kir21';
% experiment_groups(9).name   = 'R92a01AD;R66a02DBD/Kir2.1(DL)';
% experiment_groups(9).type   = 'LAI(b)';
% 
% experiment_groups(10).folder = 'gmr_92a10ad_54d12dbd_gal80ts_kir21';
% experiment_groups(10).name   = '/Kir2.1(DL)';
% experiment_groups(10).type   = 'LAI(c)-strong';

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
            try
                experiment_groups(i).parsed_data 	= [experiment_group.parsed_data];
                experiment_groups(i).metadata       = [experiment_group.metadata];
            catch
                disp('metadata or parsed_data fields are not all the same... removing extra field')
                for j = 1:numel(experiment_group)
                    if isfield(experiment_group(j).metadata,'time_taken')
                        experiment_group(j).metadata = rmfield(experiment_group(j).metadata,'time_taken');
                    end
                end
                experiment_groups(i).metadata = [experiment_group.metadata];
            end
            clear experiment_group
        end
    end
end
clear overwrite_saved_summaries i

% Set up condition indicies to stimulus type mapping
%==========================================================================

% Combined Progressive / Regressive
% Progressive
% Regressive
% Progressive + Flicker
% Regressive + Flicker

% @ 'Users/stephenholtz/panels_experiments/protocols/sf_sweep_prog_reg/misc_prog_reg_stims.m';
i=0;

% Progressive
i=i+1;
cond_group(i).name = 'prog_tf_sweep';
cond_group(i).description = 'Progressive TF Sweep. ';
cond_group(i).inds =  [];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [];

i=i+1;
cond_group(i).name = 'prog_sf_sweep';
cond_group(i).description = 'Progressive SF Sweep. ';
cond_group(i).inds =  [];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [];

% Regressive



% Pull out conditions from experiment groups
%==========================================================================
% 
% summarized data is grouped for plotting / easy sharing i.e.
% summ_data.group_info(experiment_group_num).group_name = 'gmr...';
% summ_data.group_info(experiment_group_num).group_metadata = [experiment_groups(experiment_group_num).metadata]
% summ_data.(cond_group_name)(experiment_group_num).info = cond_group
% summ_data.(cond_group_name)(experiment_group_num).(flip,cw,ccw).(avg_lmr,avg_lmr_ts} = [some data];

% Useful anon func for making a vector;
mk_sym_vec = @(vec)([zeros(size(vec,1),1),ones(size(vec,1),1)]);

% Determine normalization values (average lmr, wbf per experiment group)
for exp_grp_num = 1:numel(experiment_groups)
    
    trials_for_normalization = 1:numel(experiment_groups(exp_grp_num).metadata(1).protocol_conditions.experiment);
    
    return_struct.inds              = trials_for_normalization; % Put all conditions in one big set
    return_struct.flip_condition    = zeros(1,numel(trials_for_normalization));
    return_struct.daq_channel       = 'lmr';        % lmr is turning channel
    return_struct.normalization_val = 1;            % we haven't made this yet
    return_struct.average_oper      = @nanmean;     % can be @nanmean or @median.
    return_struct.timeseries_oper   = @(x,~)(nanmean(abs(x)));%@nanmean;        % @nanmean returns the timeseries mean @(x,~)(x) returns the whole timeseries
    return_struct.average_type      = 'all';        % average across reps and animals
    return_struct.inds_to_use       = @(x,~)(x);    % returns all inds.. NOT WORKING YET!
    return_struct.ps_offset_amt     = 50;           % ms before the trial to subtract out of the lmr response
    
    [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);
    summ_data.mean_turn_resp(exp_grp_num) = a{1};
end

% Useful for dynamic field references
summ_data.cond_groups = cond_group;
summ_data.overall_mean_turn_resp = mean(summ_data.mean_turn_resp);

for exp_grp_num = 1:numel(experiment_groups)

    % Copy useful metadata over.
    summ_data.group_info(exp_grp_num).group_name = experiment_groups(exp_grp_num).name;
    summ_data.group_info(exp_grp_num).type = experiment_groups(exp_grp_num).type;
    summ_data.group_info(exp_grp_num).group_metadata = [experiment_groups(exp_grp_num).metadata];
    summ_data.group_info(exp_grp_num).group_folder = experiment_groups(exp_grp_num).folder;
    summ_data.group_info(exp_grp_num).N = size(experiment_groups(exp_grp_num).parsed_data,2);
    summ_data.group_info(exp_grp_num).normalization_val = summ_data.overall_mean_turn_resp/summ_data.mean_turn_resp(exp_grp_num);    

    for cg_num = 1:numel(cond_group)

        cond_group_name = cond_group(cg_num).name;

        % Copy info from cond_group struct
        summ_data.(cond_group_name)(exp_grp_num).info = cond_group(cg_num);

        return_struct.daq_channel       = 'lmr';        % lmr is turning channel
        return_struct.normalization_val = summ_data.group_info(exp_grp_num).normalization_val;
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
            
            % X position has all of the movement regardless of side
            return_struct.timeseries_oper   = @(x,~)(x);
            return_struct.daq_channel       = 'x_pos';
            return_struct.average_type      = 'all';
            [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);
            
            summ_data.(cond_group_name)(exp_grp_num).(sym_type).avg_x_ts = a;
            summ_data.(cond_group_name)(exp_grp_num).(sym_type).sem_x_ts = e;
            
            % No need for y position here.
            %return_struct.timeseries_oper   = @(x,~)(x);
            %return_struct.daq_channel       = 'y_pos';
            %return_struct.average_type      = 'all';
            %[a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);
            % 
            %summ_data.(cond_group_name)(exp_grp_num).(sym_type).avg_y_ts = a;
            %summ_data.(cond_group_name)(exp_grp_num).(sym_type).sem_y_ts = e;
        end
    end
end

% Save the summarized set of experiment group responses
%==========================================================================
summ_data_loc = fullfile(experiment_group_folder_loc,'summ_data');
fprintf('\n Saving summarized data...\n %s.mat\n',summ_data_loc)
save(summ_data_loc,'summ_data');

