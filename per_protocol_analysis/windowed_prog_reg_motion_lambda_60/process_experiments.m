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
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/windowed_prog_reg_motion_lambda_60';

experiment_groups(1).folder = 'gmr_48a08ad_gal80ts_kir21';
experiment_groups(1).name   = 'R8a08AD;+/Kir2.1(DL)';

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

% @ 'Users/stephenholtz/panels_experiments/protocols/windowed_prog_reg_motion_lambda_60/windowed_prog_reg_motion_lambda_60.m';

i=1;%      1
cond_group(i).name = 'reg_30to60';
cond_group(i).description = 'Regressive Motion 30-60';
cond_group(i).inds =  ...
                [2,9;...
                 4,11;...
                 6,13;...
                 8,15]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (53:60);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-60';

i=i+1;%    2
cond_group(i).name = 'reg_60to90';
cond_group(i).description = 'Regressive Motion 60-90';
cond_group(i).inds =  ...
                [26,33;...
                 28,35;...
                 30,37;...
                 32,39]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (61:68);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '60-90';

i=i+1;%    3
cond_group(i).name = 'reg_90to120';
cond_group(i).description = 'Regressive Motion 90-120';
cond_group(i).inds =  ...
                [50,57;...
                 52,59;...
                 54,61;...
                 56,63]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (69:76);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '90-120';

i=i+1;%    4
cond_group(i).name = 'reg_120to150';
cond_group(i).description = 'Regressive Motion 120-150';
cond_group(i).inds =  ...
                [74,81;...
                 76,83;...
                 78,85;...
                 80,87]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (77:84);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '120-150';

i=i+1;%    5
cond_group(i).name = 'reg_30to90';
cond_group(i).description = 'Regressive Motion 30-90';
cond_group(i).inds =  ...
                [98, 105;...
                 100,107;...
                 102,109;...
                 104,111]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (53:68);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    6
cond_group(i).name = 'reg_60to120';
cond_group(i).description = 'Regressive Motion 60-120';
cond_group(i).inds =  ...
                [122,129;...
                 124,131;...
                 126,133;...
                 128,135]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (61:76);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '60-120';

i=i+1;%    7
cond_group(i).name = 'reg_90to150';
cond_group(i).description = 'Regressive Motion 90-150';
cond_group(i).inds =  ...
                [146,153;...
                 148,155;...
                 150,157;...
                 152,159]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (69:84);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '90-150';

i=i+1;%    8
cond_group(i).name = 'reg_30to150';
cond_group(i).description = 'Regressive Motion 30-150';
cond_group(i).inds =  ...
                [170,177;...
                 172,179;...
                 174,181;...
                 176,183]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [120 120 120 120];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (53:84);
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-150';

i=i+1;%    9
cond_group(i).name = 'prog_30to60';
cond_group(i).description = 'Progressive Motion 30-60';
cond_group(i).inds =  ...
                [10,1;...
                 12,3;...
                 14,5;...
                 16,7]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (29:36);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-60';

i=i+1;%    10
cond_group(i).name = 'prog_60to90';
cond_group(i).description = 'Progressive Motion 60-90';
cond_group(i).inds =  ...
                [34,25;...
                 36,27;...
                 38,29;...
                 40,31]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (21:28);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '60-90';

i=i+1;%    11
cond_group(i).name = 'prog_90to120';
cond_group(i).description = 'Progressive Motion 90-120';
cond_group(i).inds =  ...
                [58,49;...
                 60,51;...
                 62,53;...
                 64,55]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (13:20);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '90-120';

i=i+1;%    12
cond_group(i).name = 'prog_120to150';
cond_group(i).description = 'Progressive Motion 120-150';
cond_group(i).inds =  ...
                [82,73;...
                 84,75;...
                 86,77;...
                 88,79]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (5:12);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '120-150';

i=i+1;%    13
cond_group(i).name = 'prog_30to90';
cond_group(i).description = 'Progressive Motion 30-90';
cond_group(i).inds =  ...
                [106,97;...
                 108,99;...
                 110,101;...
                 112,103]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (21:36);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    14
cond_group(i).name = 'prog_60to120';
cond_group(i).description = 'Progressive Motion 60-120';
cond_group(i).inds =  ...
                [130,121;...
                 132,123;...
                 134,125;...
                 136,127]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (13:28);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '60-120';

i=i+1;%    15
cond_group(i).name = 'prog_90to150';
cond_group(i).description = 'Progressive Motion 90-150';
cond_group(i).inds =  ...
                [154,145;...
                 156,147;...
                 158,149;...
                 160,151]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (5:20);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '90-150';

i=i+1;%    16
cond_group(i).name = 'prog_30to150';
cond_group(i).description = 'Progressive Motion 30-150';
cond_group(i).inds =  ...
                [178,169;...
                 180,171;...
                 182,173;...
                 184,175]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [120 120 120 120];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (5:36);
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-150';

i=i+1;%    17
cond_group(i).name = 'both_30to60';
cond_group(i).description = 'Both Halves Motion 30-60';
cond_group(i).inds =  ...
                [18,17;...
                 20,19;...
                 22,21;...
                 24,23]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (53:60);
cond_group(i).dir = 'Both';
cond_group(i).note = '30-60';

i=i+1;%    18
cond_group(i).name = 'both_60to90';
cond_group(i).description = 'Both Halves Motion 60-90';
cond_group(i).inds =  ...
                [42,41;...
                 44,43;...
                 46,45;...
                 48,47]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (61:68);
cond_group(i).dir = 'Both';
cond_group(i).note = '60-90';

i=i+1;%    19
cond_group(i).name = 'both_90to120';
cond_group(i).description = 'Both Halves Motion 90-120';
cond_group(i).inds =  ...
                [66,65;...
                 68,67;...
                 70,69;...
                 72,71]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (69:76);
cond_group(i).dir = 'Both';
cond_group(i).note = '90-120';

i=i+1;%    20
cond_group(i).name = 'both_120to150';
cond_group(i).description = 'Both Halves Motion 120-150';
cond_group(i).inds =  ...
                [90,89;...
                 92,91;...
                 94,93;...
                 96,95]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [30 30 30 30];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (77:84);
cond_group(i).dir = 'Both';
cond_group(i).note = '120-150';

i=i+1;%    21
cond_group(i).name = 'both_30to90';
cond_group(i).description = 'Both Halves Motion 30-90';
cond_group(i).inds =  ...
                [114,113;...
                 116,115;...
                 118,117;...
                 120,119]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (53:68);
cond_group(i).dir = 'Both';
cond_group(i).note = '30-90';

i=i+1;%    22
cond_group(i).name = 'both_60to120';
cond_group(i).description = 'Both Halves Motion 60-120';
cond_group(i).inds =  ...
                [138,137;...
                 140,139;...
                 142,141;...
                 144,143]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (61:76);
cond_group(i).dir = 'Both';
cond_group(i).note = '60-120';

i=i+1;%    23
cond_group(i).name = 'both_90to150';
cond_group(i).description = 'Both Halves Motion 90-150';
cond_group(i).inds =  ...
                [162,161;...
                 164,163;...
                 166,165;...
                 168,167]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [60 60 60 60];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (69:84);
cond_group(i).dir = 'Both';
cond_group(i).note = '90-150';

i=i+1;%    24
cond_group(i).name = 'both_30to150';
cond_group(i).description = 'Both Halves Motion 30-150';
cond_group(i).inds =  ...
                [186,185;...
                 188,187;...
                 190,189;...
                 192,191]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 4 8 16];
cond_group(i).window = [120 120 120 120];
cond_group(i).pix = [8 8 8 8];
cond_group(i).contrast_vals = [1 1 1 1 1 1];
cond_group(i).arena_inds = (53:84);
cond_group(i).dir = 'Both';
cond_group(i).note = '30-150';

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

