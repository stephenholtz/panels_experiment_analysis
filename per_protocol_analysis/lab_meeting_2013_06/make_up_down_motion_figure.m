% Make figures for lab meeting (import OLD data)

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/tethered_flight_arena_code/'));
addpath(genpath('/Users/stephenholtz/panels_experiment_analysis/'));
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand_plot = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

% Group experiments by their folders, give more information
%==========================================================================
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_sweep_up_down_w_flk_SUMMARIES_ONLY';

experiment_groups(1).folder = 'gmr_11d03ad_gal80ts_kir21';
experiment_groups(1).name   = '11d03AD;+/Kir2.1(DL)';
experiment_groups(1).type   = 'Ctrl(a)';

experiment_groups(2).folder = 'gmr_29g11dbd_gal80ts_kir21';
experiment_groups(2).name   = '+;29g11DBD/Kir2.1(DL)';
experiment_groups(2).type   = 'Ctrl(b)';

experiment_groups(3).folder = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
experiment_groups(3).name   = '20c11AD;48d11DBD/Kir2.1(DL)';
experiment_groups(3).type   = 'C2/3';

experiment_groups(4).folder = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
experiment_groups(4).name   = '25b02AD;48d11DBD/Kir2.1(DL)';
experiment_groups(4).type   = 'C2(a)';

experiment_groups(5).folder = 'gmr_20c11ad_25b02dbd_gal80ts_kir21';
experiment_groups(5).name   = '20c11AD;25b02DBD/Kir2.1(DL)';
experiment_groups(5).type   = 'C2(b)';

experiment_groups(6).folder = 'gmr_35a03ad_29g11dbd_gal80ts_kir21';
experiment_groups(6).name   = '35a03AD;29g11DBD/Kir2.1(DL)';
experiment_groups(6).type   = 'C3(a)';

experiment_groups(7).folder = 'gmr_26h02ad_29g11dbd_gal80ts_kir21';
experiment_groups(7).name   = '26h02AD;29g11DBD/Kir2.1(DL)';
experiment_groups(7).type   = 'C3(b)';

experiment_groups(8).folder = 'gmr_31c06ad_34g07dbd_gal80ts_kir21';
experiment_groups(8).name   = '31c06AD;34g07DBD/Kir2.1(DL)';
experiment_groups(8).type   = 'L4(a)';

% Load in all of the experiment groups via their saved summaries (creating saved summaries if they don't exist)
%==========================================================================

if 0; for do = 1 %#ok<ALIGN>
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
    %======================================================================
    % @ 'Users/stephenholtz/panels_experiments/protocols/sf_sweep_prog_reg';
    i=0;

    %-Up sf sweep-----------------------------------------------------
    i=i+1;%      1
    cond_group(i).name = 'up_motion_tf_2';
    cond_group(i).description = 'Up Motion Temp Freq 2Hz';
    cond_group(i).inds =  [9,10;17,18;25,26;33,34;41,42];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [2 2 2 2 2];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    i=i+1;%      1
    cond_group(i).name = 'up_motion_tf_6';
    cond_group(i).description = 'Up Motion Temp Freq 6Hz';
    cond_group(i).inds =  [13,14;21,22;29,30;37,38;45,46];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [6 6 6 6 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    %-Up both sf sweep-----------------------------------------------------
    i=i+1;%      1
    cond_group(i).name = 'up_both_motion_tf_2';
    cond_group(i).description = 'Up Motion Both Sides Temp Freq 2Hz';
    cond_group(i).inds =  [93;101;109;117;125];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [2 2 2 2 2];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    i=i+1;%      1
    cond_group(i).name = 'up_both_motion_tf_6';
    cond_group(i).description = 'Up Motion Both Sides Temp Freq 6Hz';
    cond_group(i).inds =  [89;97;105;113;121];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [6 6 6 6 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    %-Down sf sweep-----------------------------------------------------
    i=i+1;%      1
    cond_group(i).name = 'down_motion_tf_2';
    cond_group(i).description = 'Down Motion Temp Freq 2Hz';
    cond_group(i).inds =  [11,12;19,20;27,28;35,36;43,44];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [2 2 2 2 2];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    i=i+1;%      1
    cond_group(i).name = 'down_motion_tf_6';
    cond_group(i).description = 'Down Motion Temp Freq 6Hz';
    cond_group(i).inds =  [15,16;23,24;31,32;38,40;47,48];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [6 6 6 6 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    %-Down sf sweep Both sides----------------------------------------------
    i=i+1;%      1
    cond_group(i).name = 'down_both_motion_tf_2';
    cond_group(i).description = 'Down Motion Both Sides Temp Freq 2Hz';
    cond_group(i).inds =  [90;98;106;114;122];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [2 2 2 2 2];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    i=i+1;%      1
    cond_group(i).name = 'down_both_motion_tf_6';
    cond_group(i).description = 'Down Motion Both Sides Temp Freq 6Hz';
    cond_group(i).inds =  [94;102;110;118;126];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [6 6 6 6 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    %-opp motion sf sweep Both sides----------------------------------------------
    i=i+1;%      1
    cond_group(i).name = 'opp_motion_tf_2';
    cond_group(i).description = 'Roll Motion Temp Freq 2Hz';
    cond_group(i).inds =  [92,91;100,99;108,107;116,115;124,123];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [2 2 2 2 2];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Both';
    cond_group(i).note = '30-90';

    i=i+1;%      1
    cond_group(i).name = 'opp_motion_tf_6';
    cond_group(i).description = 'Roll Motion Temp Freq 6Hz';
    cond_group(i).inds =  [96,95;104,103;112,111;120,119;128,127];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).sf = [2 4 6 8 12]*3.75*2;
    cond_group(i).tf = [6 6 6 6 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Both';
    cond_group(i).note = '30-90';

    %-Up--------------------------------------------------------------
    i=i+1;%      1
    cond_group(i).name = 'up_motion_2px';
    cond_group(i).description = 'Up Motion 2 Pix';
    cond_group(i).inds =  [9,10; 13,14];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    i=i+1;%    2
    cond_group(i).name = 'up_motion_4px';
    cond_group(i).description = 'Up Motion 4 Pix';
    cond_group(i).inds = [17,18; 21,22];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [4 4];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    i=i+1;%    3
    cond_group(i).name = 'up_motion_6px';
    cond_group(i).description = 'Up Motion 6 Pix';
    cond_group(i).inds = [25,26; 29,30];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [6 6];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    i=i+1;%    4
    cond_group(i).name = 'up_motion_8px';
    cond_group(i).description = 'Up Motion 8 Pix';
    cond_group(i).inds = [33,34; 37,38];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [8 8];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    i=i+1;%    5
    cond_group(i).name = 'up_motion_12px';
    cond_group(i).description = 'Up Motion 12 Pix';
    cond_group(i).inds =  [41,42; 45,46];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [12 12];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up';
    cond_group(i).note = '30-90';

    %-Down--------------------------------------------------------------
    i=i+1;%    6
    cond_group(i).name = 'down_motion_2px';
    cond_group(i).description = 'Down Motion 2 Pix';
    cond_group(i).inds =  [11,12; 15,16];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    i=i+1;%    7
    cond_group(i).name = 'down_motion_4px';
    cond_group(i).description = 'Down Motion 4 Pix';
    cond_group(i).inds =  [19,20; 23,24];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [4 4 4];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    i=i+1;%    8
    cond_group(i).name = 'down_motion_6px';
    cond_group(i).description = 'Down Motion 6 Pix';
    cond_group(i).inds =  [27,28; 31,32];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [6 6];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    i=i+1;%    9
    cond_group(i).name = 'down_motion_8px';
    cond_group(i).description = 'Down Motion 8 Pix';
    cond_group(i).inds =  [35, 36; 39,40];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [8 8];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    i=i+1;%    10
    cond_group(i).name = 'down_motion_12px';
    cond_group(i).description = 'Down Motion 12 Pix';
    cond_group(i).inds =  [43,44; 47,48];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [12 12];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down';
    cond_group(i).note = '30-90';

    %-Both Side Up----------------------------------------------------}}}
    i = 1+i;%  21
    cond_group(i).name = 'up_both_sides_2px';
    cond_group(i).description = 'Up Motion Both Sides 2 Pix';
    cond_group(i).inds =  [93;89];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up Both Sides';
    cond_group(i).note = '30-90';

    i = 1+i;%  22
    cond_group(i).name = 'up_both_sides_4px';
    cond_group(i).description = 'Up Motion Both Sides 4 Pix';
    cond_group(i).inds =  [101;97];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [4 4];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up Both Sides';
    cond_group(i).note = '30-90';

    i = 1+i;%  23
    cond_group(i).name = 'up_both_sides_6px';
    cond_group(i).description = 'Up Motion Both Sides 6 Pix';
    cond_group(i).inds =  [109;105];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [6 6];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up Both Sides';
    cond_group(i).note = '30-90';

    i=i+1;%    24
    cond_group(i).name = 'up_both_sides_8px';
    cond_group(i).description = 'Up Motion Both Sides 8 Pix';
    cond_group(i).inds =  [117;113];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [8 8];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up Both Sides';
    cond_group(i).note = '30-90';

    i=i+1;%    25
    cond_group(i).name = 'up_both_sides_12px';
    cond_group(i).description = 'Up Motion Both Sides 12 Pix';
    cond_group(i).inds =  [125;121];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [12 12];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Up Both Sides';
    cond_group(i).note = '30-90';

    %-Both Side Down--------------------------------------------------
    i = 1+i;%  26
    cond_group(i).name = 'down_both_sides_2px';
    cond_group(i).description = 'Down Motion Both Sides 2 Pix';
    cond_group(i).inds =  [90;94];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down Both Sides';
    cond_group(i).note = '30-90';

    i = 1+i;%  27
    cond_group(i).name = 'down_both_sides_4px';
    cond_group(i).description = 'Down Motion Both Sides 4 Pix';
    cond_group(i).inds =  [98;102];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [4 4];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down Both Sides';
    cond_group(i).note = '30-90';

    i = 1+i;%  28
    cond_group(i).name = 'down_both_sides_6px';
    cond_group(i).description = 'Down Motion Both Sides 6 Pix';
    cond_group(i).inds =  [106;110];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [6 6];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down Both Sides';
    cond_group(i).note = '30-90';

    i=i+1;%    29
    cond_group(i).name = 'down_both_sides_8px';
    cond_group(i).description = 'Down Motion Both Sides 8 Pix';
    cond_group(i).inds =  [114;118];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [8 8];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down Both Sides';
    cond_group(i).note = '30-90';

    i=i+1;%    25
    cond_group(i).name = 'down_both_sides_12px';
    cond_group(i).description = 'Down Motion Both Sides 12 Pix';
    cond_group(i).inds =  [122;126];
    cond_group(i).flip_inds = [0; 0];
    cond_group(i).pix = [12 12];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Down Both Sides';
    cond_group(i).note = '30-90';

    %-Both Sides Opposite Motion-----------------------------------------------
    i = 1+i;%  26
    cond_group(i).name = 'both_sides_opp_2px';
    cond_group(i).description = 'Motion Both Sides Opposite 2 Pix';
    cond_group(i).inds =  [92,91;96,95];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [2 2];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Both Sides Opposite';
    cond_group(i).note = '30-90';

    i = 1+i;%  27
    cond_group(i).name = 'both_sides_opp_4px';
    cond_group(i).description = 'Motion Both Sides Opposite 4 Pix';
    cond_group(i).inds =  [100,99;104,103];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [4 4];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Both Sides Opposite';
    cond_group(i).note = '30-90';

    i = 1+i;%  28
    cond_group(i).name = 'both_sides_opp_6px';
    cond_group(i).description = 'Motion Both Sides Opposite 6 Pix';
    cond_group(i).inds =  [108,107;112,111];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [6 6];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Both Sides Opposite';
    cond_group(i).note = '30-90';

    i=i+1;%    29
    cond_group(i).name = 'both_sides_opp_8px';
    cond_group(i).description = 'Motion Both Sides Opposite 8 Pix';
    cond_group(i).inds =  [116,115;120,119];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [8 8];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Both Sides Opposite';
    cond_group(i).note = '30-90';

    i=i+1;%    30
    cond_group(i).name = 'both_sides_opp_12px';
    cond_group(i).description = 'Motion Both Sides Opposite 12 Pix';
    cond_group(i).inds =  [124,123;128,127];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).pix = [12 12];
    cond_group(i).lam = cond_group(i).pix*2*3.75;
    cond_group(i).tfs = [2 6];
    cond_group(i).window = [60 60];
    cond_group(i).contrast_vals = [1 1];
    cond_group(i).arena_inds = 53:68;
    cond_group(i).dir = 'Both Sides Opposite';
    cond_group(i).note = '30-90';

    % Pull out conditions from experiment groups
    %======================================================================
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

        trials_for_normalization = 1:120; % numel(experiment_groups(exp_grp_num).metadata(1).protocol_conditions.experiment);
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

                for ws = {'lmr','lpr'}
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
end; end

% Make a pretty nice figure for the high resolution tuning curve. Make each
% one individually for presentation purposes
%==========================================================================

% Get a struct with nice figure settings
fig_type_str = 'presentation'; % either 'paper' or 'presentation'
fs = figure_settings(fig_type_str);
save_figures = 1;
experiment_set = 1;

switch experiment_set
    case 1
        base_figure_name= 'up_down_mot_';
        symm_str = 'flip';
        fig_subset_number = 1;
        if fig_subset_number == 1
            wing_output = 'lmr';
            ylabel_str = 'Mean \DeltaWBA';
            y_range = [-1.25 2.25];
            %y_range = [-3.5 3.5];
            ax_lab='sf';
            %cond_strs = {'up_motion_2px','up_motion_4px','up_motion_6px','up_motion_8px','up_motion_12px'};
            cond_strs = {'up_motion_tf_2','up_motion_tf_6','down_motion_tf_2','down_motion_tf_6','opp_motion_tf_2','opp_motion_tf_6'};
        elseif fig_subset_number == 2
            wing_output = 'lpr';
            ylabel_str = 'Mean \SigmaWBA';
            %y_range = [-1.25 2.25];
            y_range = [-3.5 3.5];
            %y_range = [-5 1];
            ax_lab='sf';
            %cond_strs = {'up_both_sides_2px','up_both_sides_4px','up_both_sides_6px','up_both_sides_8px','up_both_sides_12px'};
            %cond_strs = {'down_both_sides_2px','down_both_sides_4px','down_both_sides_6px','down_both_sides_8px','down_both_sides_12px'};
            cond_strs = {'up_both_motion_tf_2','up_both_motion_tf_6','down_both_motion_tf_2','down_both_motion_tf_6'};
        end
        
        y_tick = [y_range(1) 0 y_range(2)];
        
        figure_size =  [50 50 500 350];

        nHigh       = 1;    heightGap   = 0;     widthGap    = 0;
        nWide       = 1;    heightOffset= 0;     widthOffset = 0;
        tune_curve_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        tune_curve_positions{1} = expand_plot(tune_curve_positions{1},.7,.7);
        tune_curve_positions{1} = nudge(tune_curve_positions{1},.175,.15);

        control_inds        = [1 2];
        geno_comp_inds.ctrl = [1 2];
        geno_comp_inds.c2   = [1 4 5];
        geno_comp_inds.c3   = [1 6 7];
        geno_comp_inds.c2c3 = [1 3];
        geno_comp_inds.l4   = [1 8];

        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_sweep_up_down_w_flk_SUMMARIES_ONLY';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = fullfile('/Users/stephenholtz/Dropbox/lab_meeting_2013_06/reprocessed_figures/up_down_motion/',fig_type_str);
    otherwise
        error('No experiment_set of that number')
end

figure_iter = 1;
for comp_field = {'ctrl','c2','c3','c2c3','l4'}
    comp_field = comp_field{1}; %#ok<FXSET> % Why not.
    for fig_src = cond_strs
        fig_src = fig_src{1}; %#ok<FXSET> % Why not.

        if ~exist('figure_iter','var')
            figure_iter = 1;
        else
            figure_iter = figure_iter + 1;
        end
        
        figure_name = [base_figure_name '_' fig_src '_' experiment_groups(geno_comp_inds.(comp_field)(1)).folder(4:end-5) '_vs_' experiment_groups(geno_comp_inds.(comp_field)(2)).folder(4:end-5)];
        %figure_handle = figure('Name',figure_name,'NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_handle= figure('Name',figure_name,'ToolBar','none','MenuBar','none','NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>

        % Plot the tuning curve
        exp_grp_iter = 1; clear graph
        graph.line_width = fs.line_width;
        for exp_grp_ind = geno_comp_inds.(comp_field)
            graph.line{exp_grp_iter}    = cell2mat(summ_data.(fig_src)(exp_grp_ind).(symm_str).(['avg_' wing_output]));
            graph.shade{exp_grp_iter}   = cell2mat(summ_data.(fig_src)(exp_grp_ind).(symm_str).(['sem_' wing_output]));
            if exp_grp_ind == 1
                graph.color{exp_grp_iter}   = fs.ctrl_colors(exp_grp_iter,:);
            else
                graph.color{exp_grp_iter}   = fs.exp_colors(exp_grp_iter-1,:);
            end
            graph.x_offset(exp_grp_iter) = (exp_grp_iter-1)*.035;
            exp_grp_iter = exp_grp_iter + 1;                
        end

        subplot('Position',tune_curve_positions{1,1})
        vec = 0:10;
        plot(vec,zeros(numel(vec),1),'Linestyle','-','color',fs.axis_color,'LineWidth',1);
        hold on; box off; 
        x_axis_vec = 1:numel(summ_data.(fig_src)(1).info.sf);
        esh=makeErrorbarTuningCurve(graph,x_axis_vec);
        axis([.75 numel(summ_data.(fig_src)(1).info.(ax_lab))+.25 y_range]);
        xlabel('Spatial Period (Lambda)','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        %xlabel('Temporal Frequency (Hz)','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        ylabel(ylabel_str,'FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        set(gca,'YTick',y_tick,'FontName',fs.axis_font,'fontsize',fs.axis_font_size,'color',fs.bkg_color,'YColor',fs.axis_color,'XColor',fs.axis_color)
        set(gca,'XTick',x_axis_vec,'XTickLabel',summ_data.(fig_src)(1).info.(ax_lab),'fontsize',fs.axis_font_size,'FontName',fs.axis_font,'ticklength',2*get(gca,'ticklength'))
        title(summ_data.(fig_src)(1).info.description,'Color',fs.font_color,'fontsize',fs.axis_font_size,'FontName',fs.axis_font)
        % Make them MR worthy:
        %fixfig;
        fix_errorbar_tee_width(1);

        % export the figure as a pdf
        %======================================================================
        if save_figures
            if ~isdir(save_figure_location)
                mkdir(save_figure_location)
            end
            fn = 1;
            export_fig(figure_handle(fn),fullfile(save_figure_location,figure_name),'-pdf','-nocrop');
            %for fn = 2:figure_iter
            %    %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
            %    export_fig(figure_handle(fn),fullfile(save_figure_location,figure_name),'-pdf','-nocrop','-append');
            %end
        end
        clear figure_handle figure_iter
        close all force
        pause(.01)
    end
    
    % Make a figure legend for the comp field
    legend_fig_size = [50 50 500 350];
    legend_figure_name = [comp_field '_vs_controls_legend_figure'];
    legend_figure_handle = figure('Name',legend_figure_name,'ToolBar','none','MenuBar','none','NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait');
    exp_grp_iter = 1;
    for exp_grp_ind = geno_comp_inds.(comp_field)
        if sum(exp_grp_ind==control_inds)
            legend_color   = fs.ctrl_colors(exp_grp_iter,:);
        else
            legend_color   = fs.exp_colors(exp_grp_iter-1,:);
        end
        metadata_string = [summ_data.group_info(exp_grp_ind).type ' [' summ_data.group_info(exp_grp_ind).group_name '] N = ' num2str(summ_data.group_info(exp_grp_ind).N)];
        
        annotation('Textbox','Position',    [.21 .965-.15*(exp_grp_iter) .4 .025],'FontWeight','bold','FontName',fs.axis_font,'color',fs.axis_color,'String',metadata_string,'Edgecolor','none','fontsize',fs.axis_font_size+1)
        annotation('Rectangle','Position',  [.04 .912-.15*(exp_grp_iter) .08 .075],'EdgeColor',legend_color,'facecolor',legend_color); 
        exp_grp_iter = exp_grp_iter + 1;
    end
    
    export_fig(legend_figure_handle,fullfile(save_figure_location,legend_figure_name),'-pdf','-nocrop');
    clear figure_handle figure_iter
    close all force
    pause(.01)
end