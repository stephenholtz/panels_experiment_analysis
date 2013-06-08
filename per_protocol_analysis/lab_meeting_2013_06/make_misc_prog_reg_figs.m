% Make figures for lab meeting (import OLD data and new)

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
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/finished_misc_prog_reg_stims';

experiment_groups(1).folder = 'gmr_48a08ad_gal80ts_kir21';
experiment_groups(1).name   = 'R48a08AD;+/Kir2.1(DL)';
experiment_groups(1).type   = 'Ctrl(a)';

experiment_groups(2).folder = 'gmr_11d03ad_gal80ts_kir21';
experiment_groups(2).name   = 'R11d03AD;+/Kir2.1(DL)';
experiment_groups(2).type   = 'Ctrl(b)';

experiment_groups(3).folder = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
experiment_groups(3).name   = 'R25b02AD;R48d11DBD/Kir2.1(DL)';
experiment_groups(3).type   = 'C2(a)';

experiment_groups(4).folder = 'gmr_20c11ad_25b02dbd_gal80ts_kir21';
experiment_groups(4).name   = 'R20c11AD;R25b02DBD/Kir2.1(DL)';
experiment_groups(4).type   = 'C2(b)';

experiment_groups(5).folder = 'gmr_26h02ad_29g11dbd_gal80ts_kir21';
experiment_groups(5).name   = 'R26h02AD;R29g11DBD/Kir2.1(DL)';
experiment_groups(5).type   = 'C3(a)';

experiment_groups(6).folder = 'gmr_35a03ad_29g11dbd_gal80ts_kir21';
experiment_groups(6).name   = 'R35a03AD;R29g11DBD/Kir2.1(DL)';
experiment_groups(6).type   = 'C3(b)';

experiment_groups(7).folder = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
experiment_groups(7).name   = 'R20c11AD;R48D11DBD/Kir2.1(DL)';
experiment_groups(7).type   = 'C2/3';

experiment_groups(8).folder = 'gmr_31c06ad_19d05dbd_gal80ts_kir21';
experiment_groups(8).name   = 'R31c06AD;R19d05DBD/Kir2.1(DL)';
experiment_groups(8).type   = 'L4(a)';

experiment_groups(9).folder = 'gmr_34g07ad_19d05dbd_gal80ts_kir21';
experiment_groups(9).name   = 'R34g07AD;R19d05DBD/Kir2.1(DL)';
experiment_groups(9).type   = 'L4(b)';

experiment_groups(10).folder = 'gmr_92a01ad_17d06dbd_gal80ts_kir21';
experiment_groups(10).name   = 'R92a01AD;R17d06DBD/Kir2.1(DL)';
experiment_groups(10).type   = 'LAI(a)';

experiment_groups(11).folder = 'gmr_92a01ad_66a02dbd_gal80ts_kir21';
experiment_groups(11).name   = 'R92a01AD;R66a02DBD/Kir2.1(DL)';
experiment_groups(11).type   = 'LAI(b)';

%experiment_groups(12).folder = '';
%experiment_groups(12).name   = '/Kir2.1(DL)';
%experiment_groups(12).type   = 'LAI(c)-strong';

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
    %==========================================================================

    % @ 'Users/stephenholtz/panels_experiments/protocols/sf_sweep_prog_reg/misc_prog_reg_stims.m';
    i=0;
    % Standard Prog / Reg
    % Edges
    % Block Scrambled
    % Flicker
    % Reverse-Phi
    % Noise

    % OFF/ON Bars
    i=i+1;%    1
    cond_group(i).name = 'off_bar_prog';
    cond_group(i).description = 'OFF Prog Sweep Bar';
    cond_group(i).inds =  [7,1;8,2;9,3];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    2
    cond_group(i).name = 'off_bar_reg';
    cond_group(i).description = 'OFF Reg Sweep Bar';
    %cond_group(i).inds =  [10,4;11,5;12,6];
    cond_group(i).inds =  [4,10;5,11;6,12];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    3
    cond_group(i).name = 'off_bar_full';
    cond_group(i).description = 'OFF Full Sweep Bar';
    cond_group(i).inds =  [13,16;14,17;15,18];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    4
    cond_group(i).name = 'on_bar_prog';
    cond_group(i).description = 'ON Prog Sweep Bar';
    cond_group(i).inds =  [43,37;44,38;45,39];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    5
    cond_group(i).name = 'on_bar_reg';
    cond_group(i).description = 'ON Reg Sweep Bar';
    %cond_group(i).inds =  [46,40;47,41;48,42];
    cond_group(i).inds =  [40,46;41,47;42,48];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    6
    cond_group(i).name = 'on_bar_full';
    cond_group(i).description = 'ON Full Sweep Bar';
    cond_group(i).inds =  [49,52;50,53;51,54];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];

    % OFF/ON Edges
    i=i+1;%    7
    cond_group(i).name = 'off_edge_prog';
    cond_group(i).description = 'OFF Prog Sweep Edge';
    cond_group(i).inds =  [25,55;26,56;27,57];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    8
    cond_group(i).name = 'off_edge_reg';
    cond_group(i).description = 'OFF Reg Sweep Edge';
    %cond_group(i).inds =  [64,22;65,23;66,24];
    cond_group(i).inds =  [22,64;23,65;24,66];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    9
    cond_group(i).name = 'off_edge_full';
    cond_group(i).description = 'OFF Full Sweep Edge';
    cond_group(i).inds =  [31,70;32,71,;33,72];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    10
    cond_group(i).name = 'on_edge_prog';
    cond_group(i).description = 'ON Prog Sweep Edge';
    cond_group(i).inds =  [61,19;62,20;63,21];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    11
    cond_group(i).name = 'on_edge_reg';
    cond_group(i).description = 'ON Reg Sweep Edge';
    %cond_group(i).inds =  [28,58;29,59;30,60];
    cond_group(i).inds =  [58,28;59,29;60,30];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];
    i=i+1;%    12
    cond_group(i).name = 'on_edge_full';
    cond_group(i).description = 'ON Full Sweep Edge';
    cond_group(i).inds =  [67,34;68,35;69,36];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [75,150,300];

    % Block randomized stimuli
    i=i+1;%    13
    cond_group(i).name = 'block_rand_lam_30_reg';
    cond_group(i).description = 'Block Randomized: Lam 30 Reg';
    %cond_group(i).inds =  [73,80;75,82;77,84];
    cond_group(i).inds =  [80,73;82,75;84,77];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    14
    cond_group(i).name = 'block_rand_lam_30_prog';
    cond_group(i).description = 'Block Randomized: Lam 30 Prog';
    cond_group(i).inds =  [74,79;76,81;78,83];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    15
    cond_group(i).name = 'block_rand_lam_30_full';
    cond_group(i).description = 'Block Randomized: Lam 30 Full';
    cond_group(i).inds =  [86,85;88,87;90,89];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    16
    cond_group(i).name = 'block_rand_lam_60_reg';
    cond_group(i).description = 'Block Randomized: Lam 60 Reg';
    %cond_group(i).inds =  [91,98;93,100;95,102];
    cond_group(i).inds =  [98,91;100,93;102,95];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    17
    cond_group(i).name = 'block_rand_lam_60_prog';
    cond_group(i).description = 'Block Randomized: Lam 60 Prog';
    cond_group(i).inds =  [92,97;94,99;96,101];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    18
    cond_group(i).name = 'block_rand_lam_60_full';
    cond_group(i).description = 'Block Randomized: Lam 60 Full';
    cond_group(i).inds =  [104,103;106,105;108,107];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];

    % Trangle wave flicker
    i=i+1;%    19
    cond_group(i).name = 'tri_wav_flick';
    cond_group(i).description = 'Triangle Wave Flicker';
    cond_group(i).inds =  [109,113;110,114;111,115;112,116];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [.75,2,6,12];

    % Reverse Phi
    i=i+1;%    20
    cond_group(i).name = 'rev_phi_lam_60_reg';
    cond_group(i).description = 'Rev Phi: Lam 60 Reg';
    %cond_group(i).inds =  [117,124;119,126;121,128];
    cond_group(i).inds =  [124,117;126,119;128,121];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [.75,2,6];
    i=i+1;%    21
    cond_group(i).name = 'rev_phi_lam_60_prog';
    cond_group(i).description = 'Rev Phi: Lam 60 Prog';
    cond_group(i).inds =  [118,123;120,125;122,127];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [.75,2,6];
    i=i+1;%    22
    cond_group(i).name = 'rev_phi_lam_60_full';
    cond_group(i).description = 'Rev Phi: Lam 60 Full';
    cond_group(i).inds =  [130,129;132,131;134,133];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [.75,2,6];

    % Flicker (unilateral alt-bar)
    i=i+1;%    23
    cond_group(i).name = 'alt_bar_flick_lam_30';
    cond_group(i).description = 'Alt Bar Flicker Lam 30';
    cond_group(i).inds =  [153,156;154,157;155,158];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    24
    cond_group(i).name = 'alt_bar_flick_lam_60';
    cond_group(i).description = 'Alt Bar Flicker Lam 60';
    cond_group(i).inds =  [201,204;202,205;203,206];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];

    % Regular Prog and Reg
    i=i+1;%    25
    cond_group(i).name = 'lam_30_reg';
    cond_group(i).description = 'Lam 30 Reg';
    %cond_group(i).inds =  [135,142;137,144;139,146];
    cond_group(i).inds =  [142,135;144,137;146,139];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    26
    cond_group(i).name = 'lam_30_prog';
    cond_group(i).description = 'Lam 30 Prog';
    cond_group(i).inds =  [136,141;138,143;140,145];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    27
    cond_group(i).name = 'lam_30_full';
    cond_group(i).description = 'Lam 30 Full';
    cond_group(i).inds =  [148,147;150,149;152,151];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    28
    cond_group(i).name = 'lam_60_reg';
    cond_group(i).description = 'Lam 60 Reg';
    %cond_group(i).inds =  [183,190;185,192;187,194];
    cond_group(i).inds =  [190,183;192,185;194,187];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    29
    cond_group(i).name = 'lam_60_prog';
    cond_group(i).description = 'Lam 60 Prog';
    cond_group(i).inds =  [184,189;186,191;188,193];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    30
    cond_group(i).name = 'lam_60_full';
    cond_group(i).description = 'Lam 60 Full';
    cond_group(i).inds =  [196,195;198,197;200,199];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];

    % Regular Prog and Reg with 1Hz TF matched flicker
    i=i+1;%    31
    cond_group(i).name = 'lam_30_reg_w_1Hz_flk';
    cond_group(i).description = 'Lam 30 Reg 1Hz Flicker';
    %cond_group(i).inds =  [165,160;167,162;169,164];
    cond_group(i).inds =  [160,165;162,167;164,169];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    32
    cond_group(i).name = 'lam_30_prog_w_1Hz_flk';
    cond_group(i).description = 'Lam 30 Prog 1Hz Flicker';
    cond_group(i).inds =  [166,159;168,161;170,163];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    33
    cond_group(i).name = 'lam_60_reg_w_1Hz_flk';
    cond_group(i).description = 'Lam 60 Reg 1Hz Flicker';
    %cond_group(i).inds =  [213,208;215,210;217,212];
    cond_group(i).inds =  [208,213;210,215;212,217];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    34
    cond_group(i).name = 'lam_60_prog_w_1Hz_flk';
    cond_group(i).description = 'Lam 60 Prog 1Hz Flicker';
    cond_group(i).inds =  [214,207;216,209;218,211];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];

    % Regular Prog and Reg with 2Hz TF matched flicker
    i=i+1;%    35
    cond_group(i).name = 'lam_30_reg_w_2Hz_flk';
    cond_group(i).description = 'Lam 30 Reg 2Hz Flicker';
    %cond_group(i).inds = [177,172;179,174;181,176];
    cond_group(i).inds = [172,177;174,179;176,181];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    36
    cond_group(i).name = 'lam_30_prog_w_2Hz_flk';
    cond_group(i).description = 'Lam 30 Prog 2Hz Flicker';
    cond_group(i).inds = [178,171;180,173,;182,175];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    37
    cond_group(i).name = 'lam_60_reg_w_2Hz_flk';
    cond_group(i).description = 'Lam 60 Reg 2Hz Flicker';
    %cond_group(i).inds =  [225,220;227,222;229,224];
    cond_group(i).inds =  [220,225;222,227;224,229];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    38
    cond_group(i).name = 'lam_60_prog_w_2Hz_flk';
    cond_group(i).description = 'Lam 60 Prog 2Hz Flicker';
    cond_group(i).inds =  [226,219;228,221;230,223];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];

    % Prog Reg + 17% noise 
    i=i+1;%    39
    cond_group(i).name = 'lam_30_reg_w_17_noise';
    cond_group(i).description = 'Lam 30 Reg 17% Noise';
    %cond_group(i).inds = [231,238;233,240;235,242];
    cond_group(i).inds = [238,231;240,233;242,235];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    40
    cond_group(i).name = 'lam_30_prog_w_17_noise';
    cond_group(i).description = 'Lam 30 Prog 17% Noise';
    cond_group(i).inds = [232,237;234,239;236,241];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    41
    cond_group(i).name = 'lam_30_full_w_17_noise';
    cond_group(i).description = 'Lam 30 Full 17% Noise';
    cond_group(i).inds = [244,243;246,245;248,247];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    42
    cond_group(i).name = 'lam_60_reg_w_17_noise';
    cond_group(i).description = 'Lam 60 Reg 17% Noise';
    %cond_group(i).inds = [249,256;251,258;253,260];
    cond_group(i).inds = [256,249;258,251;260,253];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    43
    cond_group(i).name = 'lam_60_prog_w_17_noise';
    cond_group(i).description = 'Lam 60 Prog 17% Noise';
    cond_group(i).inds = [250,255;252,257;254,259];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    44
    cond_group(i).name = 'lam_60_full_w_17_noise';
    cond_group(i).description = 'Lam 60 Full 17% Noise';
    cond_group(i).inds = [262,261;264,263;266,265];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];

    % Prog Reg + 50% noise 
    i=i+1;%    45
    cond_group(i).name = 'lam_30_reg_w_50_noise';
    cond_group(i).description = 'Lam 30 Reg 50% Noise';
    %cond_group(i).inds = [267,274;269,276;271,278];
    cond_group(i).inds = [274,267;276,269;278,271];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    46
    cond_group(i).name = 'lam_30_prog_w_50_noise';
    cond_group(i).description = 'Lam 30 Prog 50% Noise';
    cond_group(i).inds = [268,273;270,275;272,277];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    47
    cond_group(i).name = 'lam_30_full_w_50_noise';
    cond_group(i).description = 'Lam 30 Full 50% Noise';
    cond_group(i).inds = [280,279;282,281;284,283];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    48
    cond_group(i).name = 'lam_60_reg_w_50_noise';
    cond_group(i).description = 'Lam 60 Reg 50% Noise';
    %cond_group(i).inds = [285,292;287,294;289,296];
    cond_group(i).inds = [292,285;294,287;296,289];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    49
    cond_group(i).name = 'lam_60_prog_w_50_noise';
    cond_group(i).description = 'Lam 60 Prog 50% Noise';
    cond_group(i).inds = [286,291;288,293;290,295];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];
    i=i+1;%    50
    cond_group(i).name = 'lam_60_full_w_50_noise';
    cond_group(i).description = 'Lam 60 Full 50% Noise';
    cond_group(i).inds = [298,297;300,299;302,301];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];
    cond_group(i).tfs = [3,6,12];

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
end; end

% Make a pretty nice set of figures
%==========================================================================

% Get a struct with nice figure settings
fig_type_str = 'presentation'; % 'paper' or 'presentation'
fs = figure_settings(fig_type_str);
save_figures = 1;
experiment_set = 1;

switch experiment_set
    case 1
        base_figure_name= 'misc_prog_reg_exp_';
        symm_str = 'flip';
        wing_output = 'lmr';
        %y_range = [-1.5 2];
        %y_range = [-1.25 3.5];
        y_range = [-1.25 2.25];
        y_tick = [y_range(1) 0 y_range(2)];

        figure_size =  [50 50 250 350];
        
        nHigh       = 1;    heightGap   = 0;     widthGap    = 0;
        nWide       = 1;    heightOffset= 0;     widthOffset = 0;
        tune_curve_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        tune_curve_positions{1} = expand_plot(tune_curve_positions{1},.7,.7);
        tune_curve_positions{1} = nudge(tune_curve_positions{1},.25,.15);
        
        control_inds        = [1 2];
        geno_comp_inds.ctrl = control_inds;
        geno_comp_inds.c2   = [control_inds 3 4];
        geno_comp_inds.c3   = [control_inds 5 6];
        geno_comp_inds.c2c3 = [control_inds 7];
        geno_comp_inds.l4   = [control_inds 8 9];
        geno_comp_inds.lai  = [control_inds 10 11];

        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/finished_misc_prog_reg_stims';

        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = fullfile('/Users/stephenholtz/Dropbox/lab_meeting_2013_06/reprocessed_figures/misc_prog_reg_stims/',fig_type_str);
    otherwise
        error('No experiment_set of that number')
end

figure_iter = 1;

bar_cond_strings                    = {'off_bar_prog','off_bar_reg','off_bar_full','on_bar_prog','on_bar_reg','on_bar_full'};
edge_cond_strings                   = {'off_edge_prog','off_edge_reg','off_edge_full','on_edge_prog','on_edge_reg','on_edge_full'};
block_rand_cond_strings             = {'block_rand_lam_30_reg','block_rand_lam_30_prog','block_rand_lam_30_full','block_rand_lam_60_reg','block_rand_lam_60_prog','block_rand_lam_60_full'};
flicker_cond_strings                = {'alt_bar_flick_lam_30','alt_bar_flick_lam_60'};
prog_reg_cond_strings               = {'lam_30_reg','lam_30_prog','lam_30_full','lam_60_reg','lam_60_prog','lam_60_full'};
prog_reg_1Hz_flicker_cond_strings   = {'lam_30_reg_w_1Hz_flk','lam_30_prog_w_1Hz_flk','lam_60_reg_w_1Hz_flk','lam_60_prog_w_1Hz_flk'};
prog_reg_2Hz_flicker_cond_strings   = {'lam_30_reg_w_2Hz_flk','lam_30_prog_w_2Hz_flk','lam_60_reg_w_2Hz_flk','lam_60_prog_w_2Hz_flk'};
prog_reg_17pct_noise_cond_strings   = {'lam_30_reg_w_17_noise','lam_30_prog_w_17_noise','lam_30_full_w_17_noise','lam_60_reg_w_17_noise','lam_60_prog_w_17_noise','lam_60_full_w_17_noise'};
prog_reg_50pct_noise_cond_strings   = {'lam_30_reg_w_50_noise','lam_30_prog_w_50_noise','lam_30_full_w_50_noise','lam_60_reg_w_50_noise','lam_60_prog_w_50_noise','lam_60_full_w_50_noise'};
all_conds = {bar_cond_strings{:},edge_cond_strings{:},block_rand_cond_strings{:},prog_reg_cond_strings{:},prog_reg_17pct_noise_cond_strings{:},prog_reg_50pct_noise_cond_strings{:},prog_reg_1Hz_flicker_cond_strings{:}};
for comp_field = {'c2'}%{'ctrl','c2','c3','c2c3','l4','lai'}
    comp_field = comp_field{1}; %#ok<FXSET> % Why not.
    for fig_src = {bar_cond_strings{:},edge_cond_strings{:}}
        fig_src = fig_src{1}; %#ok<FXSET> % Why not.

        % Plot a tuning curve
        %==================================================================
        
        if ~exist('figure_iter','var')
            figure_iter = 1;
        else
            figure_iter = figure_iter + 1;
        end
        
        figure_name = ['tune_curve_' base_figure_name '_' fig_src '_' comp_field '_vs_controls'];
        %figure_handle = figure('Name',figure_name,'NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_handle = figure('Name',figure_name,'ToolBar','none','MenuBar','none','NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        
        exp_grp_iter = 1; clear graph
        graph.line_width = fs.line_width;
        for exp_grp_ind = geno_comp_inds.(comp_field)
            graph.line{exp_grp_iter}    = cell2mat(summ_data.(fig_src)(exp_grp_ind).(symm_str).(['avg_' wing_output]));
            graph.shade{exp_grp_iter}   = cell2mat(summ_data.(fig_src)(exp_grp_ind).(symm_str).(['sem_' wing_output]));
            if sum(exp_grp_ind==control_inds)
                graph.color{exp_grp_iter}   = fs.ctrl_colors(exp_grp_iter,:);
            else
                graph.color{exp_grp_iter}   = fs.exp_colors(exp_grp_iter-numel(control_inds),:);
            end
            graph.x_offset(exp_grp_iter) = (exp_grp_iter-1)*.035;
            exp_grp_iter = exp_grp_iter + 1;                
        end

        subplot('Position',tune_curve_positions{1,1})
        vec = 0:10;
        plot(vec,zeros(numel(vec),1),'Linestyle','-','color',fs.axis_color,'LineWidth',1);
        hold on; box off; 
        x_axis_vec = 1:numel(summ_data.(fig_src)(1).info.tfs);
        esh=makeErrorbarTuningCurve(graph,x_axis_vec);
        axis([.75 numel(summ_data.(fig_src)(1).info.tfs)+.25 y_range]);
        %xlabel('Temporal Frequency (Hz)','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        xlabel('Degrees/Second','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        ylabel('Mean \DeltaWBA','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        set(gca,'YTick',y_tick,'FontName',fs.axis_font,'fontsize',fs.axis_font_size,'color',fs.bkg_color,'YColor',fs.axis_color,'XColor',fs.axis_color)
        set(gca,'XTick',x_axis_vec,'XTickLabel',summ_data.(fig_src)(1).info.tfs,'fontsize',fs.axis_font_size,'FontName',fs.axis_font,'ticklength',2*get(gca,'ticklength'))
        title(summ_data.(fig_src)(1).info.description,'Color',fs.font_color,'fontsize',fs.axis_font_size,'FontName',fs.axis_font)
        % Make them MR worthy:
        %fixfig;
        fix_errorbar_tee_width(1);

        % export the figure as a pdf
        %==================================================================
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

        % Plot a bunch of timeseries on top of eachother
        %==================================================================
        figure_name = ['time_ser_' base_figure_name '_' fig_src '_' comp_field '_vs_controls'];
        num_stims = numel(summ_data.(fig_src)(exp_grp_ind).(symm_str).(['avg_' wing_output '_ts']));
        
        nHigh       = 1;            heightGap   = 0;     widthGap    = 0;
        nWide       = num_stims;    heightOffset= 0;     widthOffset = 0.24;
        ts_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        figure_handle = figure('Name',figure_name,'ToolBar','none','MenuBar','none','NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        
        for stim_ind = 1:num_stims
            exp_grp_iter = 1; clear graph
            graph.line_width = fs.line_width;
            for exp_grp_ind = geno_comp_inds.(comp_field)
                graph.line{exp_grp_iter}    = summ_data.(fig_src)(exp_grp_ind).(symm_str).(['avg_' wing_output '_ts']){stim_ind};
                graph.shade{exp_grp_iter}   = summ_data.(fig_src)(exp_grp_ind).(symm_str).(['sem_' wing_output '_ts']){stim_ind};
                if sum(exp_grp_ind==control_inds)
                    graph.color{exp_grp_iter}   = fs.ctrl_colors(exp_grp_iter,:);
                else
                    graph.color{exp_grp_iter}   = fs.exp_colors(exp_grp_iter-numel(control_inds),:);
                end
                exp_grp_iter = exp_grp_iter + 1;                
            end
            
            subplot('Position',nudge(expand_plot(ts_positions{1,stim_ind},.925,.8),0,.1))
            vec = 0:numel(graph.line{1});
            plot(vec,zeros(numel(vec),1),'Linestyle','-','color',fs.axis_color,'LineWidth',1);
            hold on; box off;
            x_axis_vec = [0 numel(graph.line{1})];
            esh=makeErrorShadedTimeseries(graph);
            axis([x_axis_vec y_range]);
            if stim_ind == 1
                %xlabel('Time','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
                ylabel('Mean \DeltaWBA','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
                set(gca,'YTick',y_tick,'FontName',fs.axis_font,'fontsize',fs.axis_font_size,'color',fs.bkg_color,'YColor',fs.axis_color,'XColor',fs.axis_color)
                set(gca,'XTick',x_axis_vec,'XTickLabel',{num2str(x_axis_vec(1)),[num2str(x_axis_vec(2)) ' (ms)']},'fontsize',fs.axis_font_size,'FontName',fs.axis_font,'ticklength',2*get(gca,'ticklength'))
            elseif stim_ind == 2
                title(summ_data.(fig_src)(1).info.description,'Color',fs.font_color,'fontsize',fs.axis_font_size,'FontName',fs.axis_font)        
                axis off
            else
                axis off
            end
        end
        
        % export the figure as a pdf
        %==================================================================
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
            legend_color   = fs.exp_colors(exp_grp_iter-numel(control_inds),:);
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