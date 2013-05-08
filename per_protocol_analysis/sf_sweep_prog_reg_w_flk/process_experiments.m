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
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_sweep_prog_reg_w_flk';

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

% % Wide field cells
% experiment_groups(9).folder = 'gmr_11g01ad_17c11dbd_gal80ts_kir21';
% experiment_groups(9).name   = '11g01AD;17c11DBD/Kir2.1(DL)';
% experiment_groups(9).type   = 'lawf1(a)';
% 
% experiment_groups(10).folder = 'gmr_52h01ad_17c11dbd_gal80ts_kir21';
% experiment_groups(10).name   = '52h01AD;17c11DBD/Kir2.1(DL)';
% experiment_groups(10).type   = 'lawf1(b)';

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

% @ 'Users/stephenholtz/panels_experiments/protocols/sf_sweep_prog_reg/sf_sweep_prog_reg.m';

% Progressive motion 
% Regressive motion
% Progressive motion + flicker
% Regressive motion + flicker
% Both sides motion 
% Flicker

% This flag will make it so that the stimuli are flipped,averaged,saved as
% if they were all presented on the right (versus progressive motion on the
% right and regressive motion on the left).
% Better to flip later in plotting!
stim_on_right = 1;

%-Progressive--------------------------------------------------------------
i=1;%      1
cond_group(i).name = 'prog_motion_2px';
cond_group(i).description = 'Progressive Motion 2 Pix';
cond_group(i).inds =  [13,14; 17,18; 21,22];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [2 2 2];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    2
cond_group(i).name = 'prog_motion_4px';
cond_group(i).description = 'Progressive Motion 4 Pix';
cond_group(i).inds = [25,26; 29,30; 33,34];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    3
cond_group(i).name = 'prog_motion_6px';
cond_group(i).description = 'Progressive Motion 6 Pix';
cond_group(i).inds = [37,38; 41,42; 45,46];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [6 6 6];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    4
cond_group(i).name = 'prog_motion_8px';
cond_group(i).description = 'Progressive Motion 8 Pix';
cond_group(i).inds = [49,50; 53,54; 57,58];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [8 8 8];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    5
cond_group(i).name = 'prog_motion_12px';
cond_group(i).description = 'Progressive Motion 12 Pix';
cond_group(i).inds =  [61,62; 65,66; 69 70];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [12 12 12];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';


i=i+1;%    6
cond_group(i).name = 'prog_motion_16px';
cond_group(i).description = 'Progressive Motion 16 Pix';
cond_group(i).inds =  [73,74; 77,78; 81,82];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [16 16 16];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

%-Regressive--------------------------------------------------------------
i=i+1;%    7
cond_group(i).name = 'reg_motion_2px';
cond_group(i).description = 'Regressive Motion 2 Pix';
if stim_on_right; cond_group(i).inds =  [16,15; 20,19; 24,23];
else cond_group(i).inds =  [15,16; 19,20; 23,24]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [2 2 2];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    8
cond_group(i).name = 'reg_motion_4px';
cond_group(i).description = 'Regressive Motion 4 Pix';
if stim_on_right; cond_group(i).inds =  [28,27; 32,31; 36,35];
else cond_group(i).inds =  [27,28; 31,32; 35,36]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    9
cond_group(i).name = 'reg_motion_6px';
cond_group(i).description = 'Regressive Motion 6 Pix';
if stim_on_right; cond_group(i).inds =  [40,39; 44,43; 48,47];
else cond_group(i).inds =  [39,40; 43,44; 47,48]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [6 6 6];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    10
cond_group(i).name = 'reg_motion_8px';
cond_group(i).description = 'Regressive Motion 8 Pix';
if stim_on_right; cond_group(i).inds =  [52, 51; 56,55; 60,59];
else cond_group(i).inds =  [51, 52; 55,56; 59,60]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [8 8 8];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    11
cond_group(i).name = 'reg_motion_12px';
cond_group(i).description = 'Regressive Motion 12 Pix';
if stim_on_right; cond_group(i).inds =  [64,63; 68,67; 72,71];
else cond_group(i).inds =  [63,64; 67,68; 71,72]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [12 12 12];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    12
cond_group(i).name = 'reg_motion_16px';
cond_group(i).description = 'Regressive Motion 16 Pix';
if stim_on_right; cond_group(i).inds =  [76,75; 80,79; 84,83];
else cond_group(i).inds =  [75,76; 79,80; 83,84]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [16 16 16];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

%-Progressive Flicker------------------------------------------------------
i = 1+i;%   13
cond_group(i).name = 'prog_motion_2px_w_flk';
cond_group(i).description = 'Progressive Motion with Flicker 2 Pix';
cond_group(i).inds =  [85,86; 89,90; 93,94];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [2 2 2];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i = 1+i;%  14
cond_group(i).name = 'prog_motion_4px_w_flk';
cond_group(i).description = 'Progressive Motion with Flicker 4 Pix';
cond_group(i).inds =  [97,98; 101,102; 105,106];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i = 1+i;%  15
cond_group(i).name = 'prog_motion_6px_w_flk';
cond_group(i).description = 'Progressive Motion with Flicker 6 Pix';
cond_group(i).inds =  [109,110; 113,114; 117,118];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [6 6 6];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    16
cond_group(i).name = 'prog_motion_8px_w_flk';
cond_group(i).description = 'Progressive Motion with Flicker 8 Pix';
cond_group(i).inds =  [121,122; 125,126; 129,130];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [8 8 8];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    17
cond_group(i).name = 'prog_motion_12px_w_flk';
cond_group(i).description = 'Progressive Motion with Flicker 12 Pix';
cond_group(i).inds =  [133,134; 137,138; 141,142];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [12 12 12];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

i=i+1;%    18
cond_group(i).name = 'prog_motion_16px_w_flk';
cond_group(i).description = 'Progressive Motion with Flicker 16 Pix';
cond_group(i).inds =  [145,146; 149,150; 153,154];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [16 16 16];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Progressive';
cond_group(i).note = '30-90';

%-Regressive Flicker------------------------------------------------------
i = 1+i;%  19
cond_group(i).name = 'reg_motion_2px_w_flk';
cond_group(i).description = 'Regressive Motion with Flicker 2 Pix';
if stim_on_right; cond_group(i).inds =  [88,87; 92,91; 96,95];
else cond_group(i).inds =  [87,88; 91,92; 95,96]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [2 2 2];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i = 1+i;%  20
cond_group(i).name = 'reg_motion_4px_w_flk';
cond_group(i).description = 'Regressive Motion with Flicker 4 Pix';
if stim_on_right; cond_group(i).inds =  [100,99; 104,103; 108,107];
else cond_group(i).inds =  [99,100; 103,104; 107,108]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i = 1+i;%  21
cond_group(i).name = 'reg_motion_6px_w_flk';
cond_group(i).description = 'MRegressive Motion with Flicker 6 Pix';
if stim_on_right; cond_group(i).inds =  [112,111; 116,115; 120,119];
else cond_group(i).inds =  [111,112; 115,116; 119,120]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [6 6 6];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    22
cond_group(i).name = 'reg_motion_8px_w_flk';
cond_group(i).description = 'Regressive Motion with Flicker 8 Pix';
if stim_on_right; cond_group(i).inds =  [124,123; 128,127; 132,131];
else cond_group(i).inds =  [123,124; 127,128; 131,132]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [8 8 8];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    23
cond_group(i).name = 'reg_motion_12px_w_flk';
cond_group(i).description = 'Regressive Motion with Flicker 12 Pix';
if stim_on_right; cond_group(i).inds =  [136,135; 140,139; 144,143];
else cond_group(i).inds =  [135,136; 139,140; 143,144]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [12 12 12];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

i=i+1;%    24
cond_group(i).name = 'reg_motion_16px_w_flk';
cond_group(i).description = 'Regressive Motion with Flicker 16 Pix';
if stim_on_right; cond_group(i).inds =  [148,147; 152,151; 156,155];
else cond_group(i).inds =  [147,148; 151,152; 155,156]; end
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [16 16 16];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Regressive';
cond_group(i).note = '30-90';

%-Both Sides------------------------------------------------------
i = 1+i;%  25
cond_group(i).name = 'both_sides_2px';
cond_group(i).description = 'Both Sides Motion 2 Pix';
cond_group(i).inds =  [157,158; 159,160; 163,164];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [2 2 2];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Both Sides';
cond_group(i).note = '30-90';

i = 1+i;%  26
cond_group(i).name = 'both_sides_4px';
cond_group(i).description = 'Motion Both Sides4 Pix';
cond_group(i).inds =  [163,164; 165,166; 167,168];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Both Sides';
cond_group(i).note = '30-90';

i = 1+i;%  27
cond_group(i).name = 'both_sides_6px';
cond_group(i).description = 'Motion Both Sides6 Pix';
cond_group(i).inds =  [169,170; 171,172; 173,174];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [6 6 6];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Both Sides';
cond_group(i).note = '30-90';

i=i+1;%    28
cond_group(i).name = 'both_sides_8px';
cond_group(i).description = 'Motion Both Sides8 Pix';
cond_group(i).inds =  [175,176; 177,178; 179,180];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [8 8 8];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Both Sides';
cond_group(i).note = '30-90';

i=i+1;%    29
cond_group(i).name = 'both_sides_12px';
cond_group(i).description = 'Motion Both Sides12 Pix';
cond_group(i).inds =  [181,182; 183,184; 185,186];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [12 12 12];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Both Sides';
cond_group(i).note = '30-90';

i=i+1;%    30
cond_group(i).name = 'both_sides_16px';
cond_group(i).description = 'Motion Both Sides16 Pix';
cond_group(i).inds =  [187,188; 189,190; 191,192];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [16 16 16];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Both Sides';
cond_group(i).note = '30-90';

%-Flicker------------------------------------------------------------------
% all of the flickers are averaged with respect to the right side stimulus
i=i+1;%    31
cond_group(i).name = 'flicker_4px';
cond_group(i).description = 'Flicker 4 Pix';
cond_group(i).inds = [1,2; 3,4; 5,6]; %
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [4 4 4];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
cond_group(i).arena_inds = 53:68;
cond_group(i).dir = 'Flicker';
cond_group(i).note = '30-90';

i=i+1;%    32
cond_group(i).name = 'flicker_16px';
cond_group(i).description = 'Flicker 16 Pix';
cond_group(i).inds = [7,8; 9,10; 11,12];
cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
cond_group(i).pix = [16 16 16];
cond_group(i).lam = cond_group(i).pix*2*3.75;
cond_group(i).tfs = [2 6 18];
cond_group(i).window = [60 60 60];
cond_group(i).contrast_vals = [1 1 1];
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

