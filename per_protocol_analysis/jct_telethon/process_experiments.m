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
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/jct_telethon/';

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

% @ 'Users/stephenholtz/panels_experiments/protocols/jct_telethon/jct_telethon.m';

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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
cond_group(i).tfs = [];
cond_group(i).dps = [];
cond_group(i).lam = [];
cond_group(i).pix = [];
cond_group(i).contrast_vals = [1];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
cond_group(i).tfs =  [1 3 9 .33 3 9];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
cond_group(i).tfs = [];
cond_group(i).dps = [30 90 270 30 90 270];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
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
cond_group(i).flip_inds = [0*ones(numel(cond_group(i).inds),1), 1*ones(numel(cond_group(i).inds),1)];
cond_group(i).tfs = [.3 .3 .3 1.3 1.3 1.3 5.3 5.3 5.3 10.6 10.6 10.6 16 16 16];
cond_group(i).dps = [6.75 6.75 6.75 29.25 29.25 29.25 119.25 119.25 119.25 238.5 238.5 238.5 360 360 360];
cond_group(i).lam = [22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5 22.5];
cond_group(i).pix = [6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6];
cond_group(i).contrast_vals = [.09 .27 .45 .09 .27 .45 .09 .27 .45 .09 .27 .45 .09 .27 .45];
cond_group(i).note = '';
cond_group(i).analysis_needed = {'lmr'};

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
                        wing_sig = 'lmr';
                        
                        normalize = @(vec)(vec-mean(vec))/(max(abs(vec))-mean(vec));

                        for g = 1:numel(temp_cond_data_1)

                            for k = 1:size(temp_cond_data_1{g},1)

                                norm_sig_1 = normalize(get_samples(temp_cond_data_1{g}(k,:)));
                                norm_sig_2 = normalize(get_samples(temp_cond_data_2{g}(k,:)));

                                [corr_coef, lags] = xcorr(norm_sig_1,norm_sig_2,150,'coeff');

                                [max_corr{g}{k}, max_corr_ind] = max(corr_coef);

                                % Currently unused. The lag b/n the stim and the
                                % response in absolute time.
                                max_corr_lag{g}{k} = lags(max_corr_ind(1));

                            end
                        end
                        
                        % fill in...
                    case 'lpr_x_tracking'
                        wing_sig = 'lpr';
                        
                        % fill in...
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
end

% Save the summarized set of experiment group responses
%==========================================================================

summ_data_loc = fullfile(experiment_group_folder_loc,'summ_data');
fprintf('\n Saving summarized data...\n %s.mat\n',summ_data_loc)
save(summ_data_loc,'summ_data');
