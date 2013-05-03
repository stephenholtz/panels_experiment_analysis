%% process_experiments
% Load in groups of experiments (sorted by folders) and pull out
% information on specific conditions (or groups of conditions) for further
% analysis / plotting.
%
% Save a summary file as well: summ_data.mat

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

%% Group experiments by their folders, give more information
%==========================================================================
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/jct_telethon/';

experiment_groups(1).folder = 'gmr_48a08ad_gal80ts_kir21';
experiment_groups(1).name   = 'R48a01AD;+/Kir2.1(DL)';
experiment_groups(1).type   = 'Ctrl';

experiment_groups(2).folder = 'gmr_75h09ad_40f12dbd_gal80ts_kir21';
experiment_groups(2).name   = '75h09AD;R40f12DBD/Kir2.1(DL)';
experiment_groups(2).type   = 'L1-new';

experiment_groups(3).folder = 'gmr_48a08ad_66a01dbd_gal80ts_kir21';
experiment_groups(3).name   = 'R48a01AD;R66a01DBD/Kir2.1(DL)';
experiment_groups(3).type   = 'L1-old';

experiment_groups(4).folder = 'gmr_40f12ad_75h09dbd_gal80ts_kir21';
experiment_groups(4).name   = 'R40f12AD;R75h09DBD/Kir2.1(DL)';
experiment_groups(4).type   = 'L1-new';

% experiment_groups(5).folder = 'gmr_20f01ad_48a08dbd_gal80ts_kir21';
% experiment_groups(5).name   = 'R20f01AD;48a08DBD/Kir2.1(DL)';
% experiment_groups(5).type   = 'L1-new'; did not fly in the first set...

% experiment_groups(6).folder = 'gmr_48a08ad_40f12DBD_gal80ts_kir21';
% experiment_groups(6).name   = 'R48a01AD;R40f12DBD/Kir2.1(DL)';
% experiment_groups(6).type   = 'L1-new'; did not fly in the first set...

%% Load in all of the experiment groups via their saved summaries (creating saved summaries if they don't exist)
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

%% Set up condition indicies to stimulus type mapping
%==========================================================================

% @ 'Users/stephenholtz/panels_experiments/protocols/jct_telethon/jct_telethon.m';

% Uses a field analysis_needed to determine which processing happens for
% the summary mat file (i.e. avoid doing xcorr with the x position and lmr
% signal for every condition).

i=1;%      1
cond_group(i).name = 'ff_rot';
cond_group(i).description = 'Full Field Rotation';
cond_group(i).inds =  ...
               [47,48;...% 30
                49,50;...
                51,52;...
                53,54;...
                31,32;...% 60
                33,34;...
                35,36;...
                37,38;...
                55,56;...% 90
                57,58;...
                59,60;...
                61,62];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.5 3 9 18 .25 1.5 4.5 9 .17 1 3 6];
cond_group(i).dps = [15 90 270 540 15 90 270 540 15 90 270 540];
cond_group(i).lam = [30 30 30 30 60 60 60 60 90 90 90 90];
cond_group(i).pix = [];
cond_group(i).contrast_vals = [];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    2
cond_group(i).name = 'ff_exp';
cond_group(i).description = 'Full Field Expansion';
cond_group(i).inds =  ...
                [63,64;...% 30
                 65,66];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [1 9];
cond_group(i).dps = [15 270];
cond_group(i).lam = [30 30];
cond_group(i).pix = [];
cond_group(i).contrast_vals = [1 1];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    3
cond_group(i).name = 'lat_flick';
cond_group(i).description = 'Lateral Flicker';
cond_group(i).inds = [137,138];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = 40;
cond_group(i).dps = [];
cond_group(i).lam = [];
cond_group(i).pix = [];
cond_group(i).contrast_vals = 1;
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    4
cond_group(i).name = 'lc_rot';
cond_group(i).description = 'Low Contrast Rotation';
cond_group(i).inds = ...
                [39,40;...%
                 41,42;...
                 43,44;...
                 45,46];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [8 8 8 8];
cond_group(i).dps = [180 180 180 180];
cond_group(i).lam = [22.5 22.5 22.5 22.5];
cond_group(i).pix = [6 6 6 6];
cond_group(i).contrast_vals = [.23 .07 .06 .24];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    5
cond_group(i).name = 'rp_rot';
cond_group(i).description = 'Reverse-Phi Rotation';
cond_group(i).inds = ...
               [75,76;...% 22.5
                77,78;...
                79,80;...
                81,82;...
                83,84;...
                85,86];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs =  [1 3 9 1 3 9];
cond_group(i).dps = [30 90 270 30 90 270];
cond_group(i).lam = [30 30 30 90 90 90];
cond_group(i).pix = [];
cond_group(i).contrast_vals =  [1 1 1 1 1 1];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    6
cond_group(i).name = 'stripe_osc';
cond_group(i).description = 'Stripe Oscillation';
cond_group(i).inds = ...
           [87,88;...% Dark on Bright
            89,90;...
            91,92;...
            93,94;...% Bright on Dark
            95,96;...
            97,98;...
            99,100;...% Grating
            101,102;...
            103,104];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [];
cond_group(i).dps = [30 90 270 30 90 270 30 90 270];
cond_group(i).lam = [30 30 30 30 30 30 30 30 30 30 30 30];
cond_group(i).pix = [32 32 32 32 32 32];
cond_group(i).type = {'Dark Stripe','Dark Stripe','Dark Stripe','Bright Stripe','Bright Stripe','Bright Stripe','Grating','Grating','Grating'};
cond_group(i).contrast_vals = [1 1 1 1 1 1 1 1 1 1 1 1];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr','lmr_x_tracking','x_pos'};

i=i+1;%    7
cond_group(i).name = 'reg_mot';
cond_group(i).description = 'Regressive Motion';
cond_group(i).inds = ...
           [125,126;...
            129,130;...
            133,134];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [1 3 9];
cond_group(i).dps = [30 90 360];
cond_group(i).lam = [30 30 30];
cond_group(i).pix = [];
cond_group(i).contrast_vals =  [1 1 1];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    8
cond_group(i).name = 'prog_mot';
cond_group(i).description = 'Progressive Motion';
cond_group(i).inds = ...
           [127,128;...% 22.5
            131,132;...
            135,136];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [1 3 9];
cond_group(i).dps = [30 90 360];
cond_group(i).lam = [30 30 30];
cond_group(i).pix = [];
cond_group(i).contrast_vals =  [1 1 1];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    9
cond_group(i).name = 'on_off_expansion';
cond_group(i).description = 'ON OFF Expansion';
cond_group(i).inds = ...
           [117,118;...
            119,120];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [1/3 1/3];
cond_group(i).dps = [];
cond_group(i).lam = [60 60];
cond_group(i).pix = [];
cond_group(i).type = {'on','off'};
cond_group(i).contrast_vals = [];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    10
cond_group(i).name = 'on_off_sawtooth';
cond_group(i).description = 'ON OFF Sawtooth';
cond_group(i).inds = ...
           [121,122;...
            123,124];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [1/3 1/3];
cond_group(i).dps = [];
cond_group(i).lam = [];
cond_group(i).pix = [];
cond_group(i).contrast_vals =  [1 1 1];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

i=i+1;%    11
cond_group(i).name = 'flow_oscillation';
cond_group(i).description = 'Optic Flow Oscillation';
cond_group(i).inds = ...
           [105,106;...
            107,108;...
            109,110;...
            111,112;...
            113,114;...
            115,116];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [1/3 1/3];
cond_group(i).dps = [];
cond_group(i).lam = [];
cond_group(i).pix = [];
cond_group(i).contrast_vals =  [];
cond_group(i).type =  {'Lift','Pitch','Roll','Sideslip','Thrust','Yaw'};
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr','lmr_x_tracking','lpr','lpr_x_tracking'};

i=i+1;%    12
cond_group(i).name = 'vel_null';
cond_group(i).description = 'Velocity Nulling';
cond_group(i).inds = ...
           [1,2;...
            3,4;...
            5,6;...
            7,8;...
            9,10;...
            11,12;...
            13,14;...
            15,16;...
            17,18;...
            19,20;...
            21,22;...
            23,24;...
            25,26;...
            27,28;...
            27,28;...
            29,30];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = [.3 .3 .3 1.3 1.3 1.3 5.3 5.3 5.3 10.6 10.6 10.6 16 16 16];
cond_group(i).dps = [6.75 6.75 6.75 29.25 29.25 29.25 119.25 119.25 119.25 238.5 238.5 238.5 360 360 360];
cond_group(i).lam = [22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5];
cond_group(i).pix = [6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6];
cond_group(i).contrast_vals = [.09 .27 .45 .09 .27 .45 .09 .27 .45 .09 .27 .45 .09 .27 .45];
cond_group(i).note = '';
% This is a special case, the velocity nulling points needs to be calculated another way (@ end of loops below)
cond_group(i).analysis_needed = {'lmr'};

%% Pull out conditions from experiment groups
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
        for sym = 1

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

            for analysis_iter = 1:numel(cond_group(cg_num).analysis_needed)
                switch cond_group(cg_num).analysis_needed{analysis_iter}
                    case 'lmr'
                        clear a e

                        wing_sig = 'lmr';

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

                    case 'lpr'
                        clear a e

                        wing_sig = 'lpr';

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

                    case 'lmr_x_tracking'
                        clear a e

                        % Needs to be calculated on a fly by fly basis, both the average
                        % and the individual fly values should be recorded.
                        wing_sig = 'lmr';
                        position = 'x_pos';
                        % Simple anonymous func for normalizing individual vectors
                        normalize = @(vec)(vec-mean(vec))/(max(abs(vec))-mean(vec));

                        return_struct.timeseries_oper   = @(x,~)(x);
                        return_struct.daq_channel       = wing_sig;
                        return_struct.average_type      = 'none';
                        [a.(wing_sig),~] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                        return_struct.timeseries_oper   = @(x,~)(x);
                        return_struct.daq_channel       = position;
                        return_struct.average_type      = 'none';
                        [a.(position),~] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                        for condition = 1:size(a.(wing_sig),1)
                            for fly_num = 1:size(a.(wing_sig){condition},2)
                                for fly_trial = 1:size(a.(wing_sig){condition}{fly_num},1)
                                    % If there are symmetrical conditions here, they are all dealt with equally
                                    % on this level. Same as if with two for loops, just simpler.

                                    norm_sig   = normalize(a.(wing_sig){condition}{fly_num}(fly_trial,:));
                                    norm_x_pos = normalize(a.(position){condition}{fly_num}(fly_trial,:));

                                    [corr_coef, lags] = xcorr(norm_sig,norm_x_pos,150,'coeff');

                                    [max_corr(fly_trial), max_corr_ind] = max(max(corr_coef));

                                    % Currently unused. The lag b/n the stim and the response in absolute time.
                                    max_corr_lag(fly_trial) = lags(max_corr_ind(1));

                                end
                                % Save data for stats
                                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig '_corr_' position]){condition}{fly_num} = mean(max_corr);
                                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_sem_' wing_sig '_corr_' position]){condition}{fly_num} = std(max_corr)/sqrt(fly_trial);
                            end
                            % Save data for plotting
                            summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['avg_' wing_sig '_corr_' position]){condition} = ...
                                mean([summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig '_corr_' position]){condition}{:}]);
                            summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['sem_' wing_sig '_corr_' position]){condition} = ...
                                std([summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig '_corr_' position]){condition}{:}])/sqrt(fly_num);
                        end

                    case 'lpr_x_tracking'
                        clear a e

                        % Needs to be calculated on a fly by fly basis, both the average
                        % and the individual fly values should be recorded.
                        % Same as lmr_x_tracking.
                        wing_sig = 'lpr';
                        position = 'x_pos';
                        % Simple anonymous func for normalizing individual vectors
                        normalize = @(vec)(vec-mean(vec))/(max(abs(vec))-mean(vec));

                        return_struct.timeseries_oper   = @(x,~)(x);
                        return_struct.daq_channel       = wing_sig;
                        return_struct.average_type      = 'none';
                        [a.(wing_sig),~] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                        return_struct.timeseries_oper   = @(x,~)(x);
                        return_struct.daq_channel       = position;
                        return_struct.average_type      = 'none';
                        [a.(position),~] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                        for condition = 1:size(a.(wing_sig),1)
                            for fly_num = 1:size(a.(wing_sig){condition},2)
                                for fly_trial = 1:size(a.(wing_sig){condition}{fly_num},1)
                                    % If there are symmetrical conditions here, they are all dealt with equally
                                    % on this level. Same as if with two for loops, just simpler.

                                    norm_sig   = normalize(a.(wing_sig){condition}{fly_num}(fly_trial,:));
                                    norm_x_pos = normalize(a.(position){condition}{fly_num}(fly_trial,:));

                                    [corr_coef, lags] = xcorr(norm_sig,norm_x_pos,150,'coeff');

                                    [max_corr(fly_trial), max_corr_ind] = max(max(corr_coef));

                                    % Currently unused. The lag b/n the stim and the response in absolute time.
                                    max_corr_lag(fly_trial) = lags(max_corr_ind(1));

                                end
                                % Save data for stats
                                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig '_corr_' position]){condition}{fly_num} = mean(max_corr);
                                summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_sem_' wing_sig '_corr_' position]){condition}{fly_num} = std(max_corr)/sqrt(fly_trial);
                            end
                            % Save data for plotting
                            summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['avg_' wing_sig '_corr_' position]){condition} = ...
                                mean([summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig '_corr_' position]){condition}{:}]);
                            summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['sem_' wing_sig '_corr_' position]){condition} = ...
                                std([summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig '_corr_' position]){condition}{:}])/sqrt(fly_num);
                        end

                    case 'x_pos'
                        return_struct.timeseries_oper   = @(x,~)(x);
                        return_struct.daq_channel       = 'x_pos';
                        return_struct.average_type      = 'all';
                        [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                        summ_data.(cond_group_name)(exp_grp_num).(sym_type).avg_x_ts = a;
                        summ_data.(cond_group_name)(exp_grp_num).(sym_type).sem_x_ts = e;

                    otherwise
                        error('analysis_needed field has bad value')
                end
            end
        end
    end

    % Do the velocity nulling calculations, they are sufficiently different from other conditions to justify this
    clear avg sem fit_* null_contrast intercept_val

    test_contrast_values = [.09 .27 .45]; % see above
    test_temp_freq_values = [.2 1.3 5.3 10.7 16]; % see above

    vel_null_str = 'vel_null';
    contrast_inds = 1:3;
    for contrast_subset = 1:5

        avg(contrast_subset,:)=[summ_data.(vel_null_str)(exp_grp_num).flip.avg_lmr{contrast_inds}];
        sem(contrast_subset,:)=[summ_data.(vel_null_str)(exp_grp_num).flip.sem_lmr{contrast_inds}];

        fit_vals(contrast_subset,:) = polyfit(test_contrast_values',avg(contrast_subset,:)',1);
        fit_line(contrast_subset,:) = polyval(fit_vals(contrast_subset,:),test_contrast_values);

        intercept_val(contrast_subset) = -1*(fit_vals(contrast_subset,2)/fit_vals(contrast_subset,1));
        null_contrast(contrast_subset,:) = 1/intercept_val(contrast_subset);

        contrast_inds = contrast_inds + 3;
    end

    % put it all in a field called proc_data...
    summ_data.(vel_null_str)(exp_grp_num).proc_data.fit_vals = fit_vals;
    summ_data.(vel_null_str)(exp_grp_num).proc_data.fit_line = fit_line;
    summ_data.(vel_null_str)(exp_grp_num).proc_data.intercept_val = intercept_val';
    summ_data.(vel_null_str)(exp_grp_num).proc_data.null_contrast = null_contrast';

end

%% Save the summarized set of experiment group responses
%==========================================================================

summ_data_loc = fullfile(experiment_group_folder_loc,'summ_data');
fprintf('\n Saving summarized data...\n %s.mat\n',summ_data_loc)
save(summ_data_loc,'summ_data');
