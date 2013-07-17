% process_experiments 
% Load in groups of experiments (sorted by folders) and pull out
% information on specific conditions (or groups of conditions) for further
% analysis / plotting.
%
% Save a summary file as well: summ_data.mat 
% press 'CTRL' + '='

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Group experiments by their folders, give more information
%==========================================================================
exp_grp_folder = 1;
switch exp_grp_folder 
    case 1
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_tf_dir_mot_sweep/';
        
        experiment_groups(1).folder     = 'gmr_48a08ad_gal80ts_kir21';
        experiment_groups(1).name       = 'R48a08AD;+/Kir2.1(DL)';
        experiment_groups(1).type       = 'Ctrl(a)';
        
        experiment_groups(2).folder     = 'gmr_29g11dbd_gal80ts_kir21';
        experiment_groups(2).name       = '+;R29g11DBD/Kir2.1(DL)';
        experiment_groups(2).type       = 'Ctrl(b)';

        experiment_groups(3).folder     = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
        experiment_groups(3).name       = 'R25b02AD;R48d11DBD/Kir2.1(DL)';
        experiment_groups(3).type       = 'C2(a)';

        experiment_groups(4).folder     = 'gmr_20c11ad_25b02dbd_gal80ts_kir21';
        experiment_groups(4).name       = 'R20c11AD;R25b02DBD/Kir2.1(DL)';
        experiment_groups(4).type       = 'C2(b)';

        experiment_groups(5).folder     = 'gmr_26h02ad_29g11dbd_gal80ts_kir21';
        experiment_groups(5).name       = 'R26h02AD;R29g11DBD/Kir2.1(DL)';
        experiment_groups(5).type       = 'C3(a)';

        experiment_groups(6).folder     = 'gmr_35a03ad_29g11dbd_gal80ts_kir21';
        experiment_groups(6).name       = 'R35a03AD;R29g11DBD/Kir2.1(DL)';
        experiment_groups(6).type       = 'C3(b)';

        experiment_groups(7).folder     = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
        experiment_groups(7).name       = 'R20c11AD;R48D11DBD/Kir2.1(DL)';
        experiment_groups(7).type       = 'C2/3';

        experiment_groups(8).folder     = 'gmr_92a10ad_17d06dbd_gal80ts_kir21';
        experiment_groups(8).name       = 'R92a01AD;R17d06DBD/Kir2.1(DL)';
        experiment_groups(8).type       = 'LAI(a)';

        experiment_groups(9).folder     = 'gmr_92a10ad_66a02dbd_gal80ts_kir21';
        experiment_groups(9).name       = 'R92a01AD;R66a02DBD/Kir2.1(DL)';
        experiment_groups(9).type       = 'LAI(b)';

        experiment_groups(10).folder    = 'gmr_54d12ad_92a10dbd_gal80ts_kir21';
        experiment_groups(10).name      = 'R54d12AD;R92a10DBD/Kir2.1(DL)';
        experiment_groups(10).type      = 'LAI(c)';

        experiment_groups(11).folder     = 'uka_gal80ts_kir21';
        experiment_groups(11).name       = 'uka';
        experiment_groups(11).type       = 'uka';
        
    case 2
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_tf_dir_mot_sweep/';
        
        experiment_groups(1).folder     = 'gmr_48a08ad_gal80ts_kir21';
        experiment_groups(1).name       = 'R48a08AD;+/Kir2.1(DL)';
        experiment_groups(1).type       = 'Ctrl(a)';
        
        experiment_groups(2).folder     = 'gmr_29g11dbd_gal80ts_kir21';
        experiment_groups(2).name       = '+;R29g11DBD/Kir2.1(DL)';
        experiment_groups(2).type       = 'Ctrl(b)';

        experiment_groups(3).folder     = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
        experiment_groups(3).name       = 'R25b02AD;R48d11DBD/Kir2.1(DL)';
        experiment_groups(3).type       = 'C2(a)';
        
        experiment_groups(4).folder     = 'gmr_35a03ad_29g11dbd_gal80ts_kir21';
        experiment_groups(4).name       = 'R35a03AD;R29g11DBD/Kir2.1(DL)';
        experiment_groups(4).type       = 'C3(b)';
        
        experiment_groups(5).folder     = 'gmr_92a10ad_17d06dbd_gal80ts_kir21';
        experiment_groups(5).name       = 'R92a01AD;R17d06DBD/Kir2.1(DL)';
        experiment_groups(5).type       = 'LAI(a)';
        
    case 3
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_tf_dir_mot_sweep/';
        
        experiment_groups(1).folder     = 'gmr_48a08ad_gal80ts_kir21';
        experiment_groups(1).name       = 'R48a08AD;+/Kir2.1(DL)';
        experiment_groups(1).type       = 'Ctrl(a)';
        
        experiment_groups(2).folder     = 'gmr_29g11dbd_gal80ts_kir21';
        experiment_groups(2).name       = '+;R29g11DBD/Kir2.1(DL)';
        experiment_groups(2).type       = 'Ctrl(b)';

    case 4
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_tf_dir_mot_sweep_test/';
        
        experiment_groups(1).folder     = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
        experiment_groups(1).name       = 'R20c11AD;R48D11DBD/Kir2.1(DL)';
        experiment_groups(1).type       = 'C2/3';
end

% Load in all of the experiment groups via their saved summaries (creating saved summaries if they don't exist)
%==========================================================================
save_summaries = 1;

% this creates (in CMU style):
% experiment_group(folder#).parsed_data(experiment#).data(condition#).lmr(rep#,:)
group_numbers_to_process = 1:numel(experiment_groups);
for i = group_numbers_to_process
    if ~isfield(experiment_groups(i),'metadata') || isempty(experiment_groups(i).metadata)
        % import/save a group summary if it does not already exist
        experiment_group_summary = fullfile(experiment_group_folder_loc,experiment_groups(i).folder,[experiment_groups(i).folder '.mat']);
        disp([num2str(i) '/' num2str(numel(experiment_groups)) '===' experiment_groups(i).folder])

        if ~exist(experiment_group_summary,'file')
            experiment_group = import_experiment_group(fullfile(experiment_group_folder_loc,experiment_groups(i).folder),save_summaries);
            for j = 1:numel(experiment_group)
                experiment_groups(i).parsed_data(j) 	= experiment_group(j).parsed_data; %#ok<*SAGROW>
                try experiment_groups(i).metadata(j)    = experiment_group(j).metadata;
                catch % Sometimes there are new metadata fields added in
                    for fn=fieldnames(experiment_group(j-1).metadata)';
                        if ~isfield(experiment_group(j).metadata,fn)
                            experiment_groups(i).metadata(j).(fn{1}) = '';
                        else
                            experiment_groups(i).metadata(j).(fn{1}) = experiment_group(j).metadata.(fn{1});
                        end
                    end
                end
            end
            clear experiment_group
        else
            load(experiment_group_summary); % loads experiment_group variable
            for j = 1:numel(experiment_group)
                experiment_groups(i).parsed_data(j) 	= experiment_group(j).parsed_data;
                try experiment_groups(i).metadata(j)    = experiment_group(j).metadata;
                catch % Sometimes there are new metadata fields added in
                    for fn=fieldnames(experiment_group(j-1).metadata)';
                        if ~isfield(experiment_group(j).metadata,fn)
                            experiment_groups(i).metadata(j).(fn{1}) = '';
                        else
                            experiment_groups(i).metadata(j).(fn{1}) = experiment_group(j).metadata.(fn{1});
                        end
                    end
                end
            end
            clear experiment_group
        end
    end
end

% Set up condition indicies to stimulus type mapping
%==========================================================================

% Combined Progressive / Regressive
% Progressive
% Regressive
% Progressive + Flicker
% Regressive + Flicker
% Flicker Only

% @ 'Users/stephenholtz/panels_experiments/protocols/sf_sweep_prog_reg/misc_prog_reg_stims.m';
i=0;

% motion both sides 
i=i+1;
cond_group(i).name = 'bilateral_motion';
cond_group(i).description = 'Bilateral (CW) Motion';
cond_group(i).inds =  [02,01;04,03;06,05;08,07;...
                       10,09;12,11;14,13;16,15;... 
                       18,17;20,19;22,21;24,23;...
                       26,25;28,27;30,29;32,31;...
                       34,33;36,35;38,37;40,39];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = repmat([.5 2 6 14],1,5);
cond_group(i).sfs = [repmat(2,1,4) repmat(4,1,4) repmat(6,1,4) repmat(8,1,4) repmat(10,1,4)]*3.75*2;
cond_group(i).dir = 'cw';

% combined progressive
i=i+1;
cond_group(i).name = 'progressive';
cond_group(i).description = 'Progressive (CW)';
cond_group(i).inds =  [42,49;44,51;46,53;48,55;...
                       58,65;60,67;62,69;64,71;...
                       74,81;76,83;78,85;80,87;...
                       90,97;92,99;94,101;96,103;...
                       106,113;108,115;110,117;112,119];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = repmat([.5 2 6 14],1,5);
cond_group(i).sfs = [repmat(2,1,4) repmat(4,1,4) repmat(6,1,4) repmat(8,1,4) repmat(10,1,4)]*3.75*2;
cond_group(i).dir = 'cw';

% Combined Regressive
i=i+1;
cond_group(i).name = 'regressive';
cond_group(i).description = 'Regressive (CW)';
cond_group(i).inds =  [50,41;52,43;54,45;56,47;...
                       66,57;68,59;70,61;72,63;...
                       82,73;84,75;86,77;88,79;...
                       98,89;100,91;102,93;104,95;...
                       114,105;116,107;118,109;120,111];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = repmat([.5 2 6 14],1,5);
cond_group(i).sfs = [repmat(2,1,4) repmat(4,1,4) repmat(6,1,4) repmat(8,1,4) repmat(10,1,4)]*3.75*2;
cond_group(i).dir = 'cw';

% Combined Progressive + Flicker
i=i+1;
cond_group(i).name = 'progressive_w_flk';
cond_group(i).description = 'Progressive (CW) with Flicker';
cond_group(i).inds =  [130,121;132,123;134,125;136,127;...
                       146,137;148,139;150,141;152,143;...
                       162,153;164,155;166,157;168,159;...
                       178,169;180,171;182,173;184,175;...
                       194,185;196,187;198,189;200,191];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = repmat([.5 2 6 14],1,5);
cond_group(i).sfs = [repmat(2,1,4) repmat(4,1,4) repmat(6,1,4) repmat(8,1,4) repmat(10,1,4)]*3.75*2;
cond_group(i).dir = 'cw';

% Combined Regressive + Flicker
i=i+1;
cond_group(i).name = 'regressive_w_flk';
cond_group(i).description = 'Regressive (CW) with Flicker';
cond_group(i).inds =  [122,129;124,131;126,133;128,135;...
                       138,145;140,147;142,149;144,151;...
                       154,161;156,163;158,165;160,167;...
                       170,177;172,179;174,181;176,183;...
                       186,193;188,195;190,197;192,199];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = repmat([.5 2 6 14],1,5);
cond_group(i).sfs = [repmat(2,1,4) repmat(4,1,4) repmat(6,1,4) repmat(8,1,4) repmat(10,1,4)]*3.75*2;
cond_group(i).dir = 'cw';

% Flicker
i=i+1;
cond_group(i).name = 'flicker';
cond_group(i).description = 'Flicker';
cond_group(i).inds =  [201,205;202,206;203,207;204,208;...
                       209,213;210,214;211,215;212,216;...
                       217,221;218,222;219,223;220,224;...
                       225,229;226,230;227,231;228,232];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).tfs = repmat([.5 2 6 14],1,5);
cond_group(i).sfs = [repmat(2,1,4) repmat(4,1,4) repmat(8,1,4) repmat(24,1,4)]*3.75*2;
cond_group(i).dir = 'cw';

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
        end
    end
end

% Save the summarized set of experiment group responses
%==========================================================================
summ_data_loc = fullfile(experiment_group_folder_loc,'summ_data');
fprintf('\n Saving summarized data...\n %s.mat\n',summ_data_loc)
save(summ_data_loc,'summ_data');

