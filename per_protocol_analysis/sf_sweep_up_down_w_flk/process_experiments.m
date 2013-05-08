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
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_sweep_up_down_w_flk';

experiment_groups(1).folder = 'gmr_11d03ad_gal80ts_kir21';
experiment_groups(1).name   = '11d03AD;+/Kir2.1(DL)';
experiment_groups(1).type   = 'Ctrl(a)';

experiment_groups(2).folder = 'gmr_29g11dbd_gal80ts_kir21';
experiment_groups(2).name   = '+;29g11DBD/Kir2.1(DL)';
experiment_groups(2).type   = 'Ctrl(b)';

experiment_groups(3).folder = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
experiment_groups(3).name   = '20c11AD;48d11DBD/Kir2.1(DL)';
experiment_groups(3).type   = 'C2/3';

experiment_groups(4).folder = 'gmr_20c11ad_25b02dbd_gal80ts_kir21';
experiment_groups(4).name   = '20c11AD;25b02DBD/Kir2.1(DL)';
experiment_groups(4).type   = 'C2(a)';

experiment_groups(5).folder = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
experiment_groups(5).name   = '25b02AD;48d11DBD/Kir2.1(DL)';
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

% Wide field cells
experiment_groups(9).folder = 'gmr_11g01ad_17c11dbd_gal80ts_kir21';
experiment_groups(9).name   = '11g01AD;17c11DBD/Kir2.1(DL)';
experiment_groups(9).type   = 'lawf1(a)';

experiment_groups(10).folder = 'gmr_52h01ad_17c11dbd_gal80ts_kir21';
experiment_groups(10).name   = '52h01AD;17c11DBD/Kir2.1(DL)';
experiment_groups(10).type   = 'lawf1(b)';

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

% @ 'Users/stephenholtz/panels_experiments/protocols/sf_sweep_up_down_w_flk/sf_sweep_up_down_w_flk.m';

% Up motion 
% Down motion
% Up motion + flicker
% Down motion + flicker
% Both sides motion 
% Flicker

%-Up--------------------------------------------------------------
i=1;%      1
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

%-Up Flicker------------------------------------------------------}}}
i = 1+i;%  11
cond_group(i).name = 'up_motion_2px_w_flk';
cond_group(i).description = 'Up Motion with Flicker 2 Pix';
cond_group(i).inds =  [49,50; 53,54];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [2 2];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Up';
cond_group(i).note = '30-90';

i = 1+i;%  12
cond_group(i).name = 'up_motion_4px_w_flk';
cond_group(i).description = 'Up Motion with Flicker 4 Pix';
cond_group(i).inds =  [57,58; 61,62];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Up';
cond_group(i).note = '30-90';

i = 1+i;%  13
cond_group(i).name = 'up_motion_6px_w_flk';
cond_group(i).description = 'Up Motion with Flicker 6 Pix';
cond_group(i).inds =  [65,66; 69,70];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [6 6];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Up';
cond_group(i).note = '30-90';

i=i+1;%    14
cond_group(i).name = 'up_motion_8px_w_flk';
cond_group(i).description = 'Up Motion with Flicker 8 Pix';
cond_group(i).inds =  [73,74; 77,78];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [8 8];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Up';
cond_group(i).note = '30-90';

i=i+1;%    15
cond_group(i).name = 'up_motion_12px_w_flk';
cond_group(i).description = 'Up Motion with Flicker 12 Pix';
cond_group(i).inds =  [81,82; 85,86];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [12 12];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Up';
cond_group(i).note = '30-90';

%-Down Flicker------------------------------------------------------
i = 1+i;%  16
cond_group(i).name = 'down_motion_2px_w_flk';
cond_group(i).description = 'Down Motion with Flicker 2 Pix';
cond_group(i).inds =  [51,52; 55,56];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [2 2];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Down';
cond_group(i).note = '30-90';

i = 1+i;%  17
cond_group(i).name = 'down_motion_4px_w_flk';
cond_group(i).description = 'Down Motion with Flicker 4 Pix';
cond_group(i).inds =  [59,60; 63,64];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Down';
cond_group(i).note = '30-90';

i = 1+i;%  18
cond_group(i).name = 'down_motion_6px_w_flk';
cond_group(i).description = 'MDown Motion with Flicker 6 Pix';
cond_group(i).inds =  [67,68; 71,72];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [6 6];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Down';
cond_group(i).note = '30-90';

i=i+1;%    19
cond_group(i).name = 'down_motion_8px_w_flk';
cond_group(i).description = 'Down Motion with Flicker 8 Pix';
cond_group(i).inds =  [75,76; 79,80];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [8 8 8];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Down';
cond_group(i).note = '30-90';

i=i+1;%    20
cond_group(i).name = 'down_motion_12px_w_flk';
cond_group(i).description = 'Down Motion with Flicker 12 Pix';
cond_group(i).inds =  [83,84; 87,88];
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

%-Flicker--------------------------------------------------------------
% these are all set up as relative to image on the right
i=i+1;%    31
cond_group(i).name = 'flicker_4px';
cond_group(i).description = 'Flicker 4 Pix';
cond_group(i).inds = [1,2; 3,4]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Flicker';
cond_group(i).note = '30-90';

i=i+1;%    32
cond_group(i).name = 'flicker_12px';
cond_group(i).description = 'Flicker 12 Pix';
cond_group(i).inds = [5,6; 7,8];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [12 12];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6];
cond_group(i).window = [60 60];
cond_group(i).contrast_vals = [1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Flicker';
cond_group(i).note = '30-90';

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
            
            for ws = {'lmr','lpr','wbf'}
                
                if strcmp(ws,'lmr')
                    return_struct.normalization_val = summ_data.group_info(exp_grp_num).normalization_val;
                else
                    return_struct.normalization_val = 1;
                end

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

