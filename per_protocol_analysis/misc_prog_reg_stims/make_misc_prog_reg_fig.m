%% Make the simplest possible figures

addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

experiment_set = 2;
switch experiment_set
    case 1
        exp_comp_groups(1).name = 'control';
        exp_comp_groups(1).inds = [1 2];
        exp_comp_groups(2).name = 'c2_controls';
        exp_comp_groups(2).inds = [1 2 3 4];
        exp_comp_groups(3).name = 'c3_controls';
        exp_comp_groups(3).inds = [1 2 5 6];
        exp_comp_groups(4).name = 'c2c3_controls';
        exp_comp_groups(4).inds = [1 2 7];
        exp_comp_groups(5).name = 'l4_control';
        exp_comp_groups(5).inds = [1 2 8 9];
        exp_comp_groups(6).name = 'lai_controls';
        exp_comp_groups(6).inds = [1 2 10 11];

        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/finished_misc_prog_reg_stims/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/finished_misc_prog_reg_stims/control_comparison';
    case 2
        exp_comp_groups(1).name = 'c2_vs_c3';
        exp_comp_groups(1).inds = [3 4 5 6];
        exp_comp_groups(2).name = 'c2_vs_lai';
        exp_comp_groups(2).inds = [3 4 10 11];
        exp_comp_groups(3).name = 'lai_vs_c3';
        exp_comp_groups(3).inds = [10 11 5 6];
        exp_comp_groups(4).name = 'c2c3_vs_c2';
        exp_comp_groups(4).inds = [7 7 3 4];
        exp_comp_groups(5).name = 'c2c3_vs_c3';
        exp_comp_groups(5).inds = [7 7 5 6];
        exp_comp_groups(6).name = 'c2c3_vs_lai';
        exp_comp_groups(6).inds = [7 7 10 11];

        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/finished_misc_prog_reg_stims/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/finished_misc_prog_reg_stims/experimental_comparison';
end

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand_plot = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

% Setup similar to the telethon figure, split timeseries/tuning
save_figures = 1;
clear figure_iter

%% Put all conditions on new rows of timeseries, followed by a tuning curve (2 pages)
%==========================================================================
for exp_comp_group = exp_comp_groups
for figure_num = [1 2 3 4 5 6 7]
    switch figure_num
        case 1
            nHigh       = 12;
            nWide       = 4;
            figure_names{figure_num} = 'ON/OFF EDGES/BARS (fig1)';
            clear fig
            for sf = 1:12
                switch sf
                    case 1
                        fig(sf).stim_str = 'off_bar_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' 45deg';
                    case 2
                        fig(sf).stim_str = 'on_bar_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' 45deg';
                    case 3
                        fig(sf).stim_str = 'off_bar_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' 45deg';
                    case 4
                        fig(sf).stim_str = 'on_bar_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' 45deg';
                    case 5
                        fig(sf).stim_str = 'off_bar_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' 45deg';
                    case 6
                        fig(sf).stim_str = 'on_bar_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' 45deg';
                    case 7
                        fig(sf).stim_str = 'off_edge_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' ';
                    case 8
                        fig(sf).stim_str = 'on_edge_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' ';
                    case 9
                        fig(sf).stim_str = 'off_edge_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' ';
                    case 10
                        fig(sf).stim_str = 'on_edge_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' ';
                    case 11
                        fig(sf).stim_str = 'off_edge_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' ';
                    case 12
                        fig(sf).stim_str = 'on_edge_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'75',150','300'};
                        fig(sf).extra_str_desc = ' ';
                end
            end
        case 2
            nHigh       = 10;
            nWide       = 4;
            clear fig            
            figure_names{figure_num} = 'Block Scrambled (fig2)';
            for sf = 1:6
                switch sf
                    case 1
                        fig(sf).stim_str = 'block_rand_lam_30_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '\lambda 30';
                    case 2
                        fig(sf).stim_str = 'block_rand_lam_30_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '\lambda 30';
                    case 3
                        fig(sf).stim_str = 'block_rand_lam_30_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '\lambda 30';
                    case 4
                        fig(sf).stim_str = 'block_rand_lam_60_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '\lambda 60';
                    case 5
                        fig(sf).stim_str = 'block_rand_lam_60_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '\lambda 60';
                    case 6
                        fig(sf).stim_str = 'block_rand_lam_60_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '\lambda 60';
                end
            end
        case 3
            nHigh       = 10;
            nWide       = 4;
            clear fig
            figure_names{figure_num} = 'Flicker, Prog, Reg, Full (fig3)';
            for sf = 1:8
                switch sf
                   case 1
                        fig(sf).stim_str = 'alt_bar_flick_lam_30';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 30';
                    case 2
                        fig(sf).stim_str = 'lam_30_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 30';
                   case 3
                        fig(sf).stim_str = 'lam_30_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 30';
                   case 4
                        fig(sf).stim_str = 'lam_30_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 30';
                   case 5
                        fig(sf).stim_str = 'alt_bar_flick_lam_60';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 60';
                   case 6
                        fig(sf).stim_str = 'lam_60_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 60';
                   case 7
                        fig(sf).stim_str = 'lam_60_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 60';
                   case 8
                        fig(sf).stim_str = 'lam_60_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 60';
                end
            end
        case 4
            nHigh       = 12;
            nWide       = 4;
            clear fig
            figure_names{figure_num} = 'Prog, Reg w/ Flicker (fig4)';
            for sf = 1:12
                switch sf
                    case 1
                        fig(sf).stim_str = 'lam_30_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 2
                        fig(sf).stim_str = 'lam_30_reg_w_1Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 3
                        fig(sf).stim_str = 'lam_30_reg_w_2Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 4
                        fig(sf).stim_str = 'lam_30_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 5
                        fig(sf).stim_str = 'lam_30_prog_w_1Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 6
                        fig(sf).stim_str = 'lam_30_prog_w_2Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 7
                        fig(sf).stim_str = 'lam_60_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 8
                        fig(sf).stim_str = 'lam_60_reg_w_1Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 9
                        fig(sf).stim_str = 'lam_60_reg_w_2Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 10
                        fig(sf).stim_str = 'lam_60_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 11
                        fig(sf).stim_str = 'lam_60_prog_w_1Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 12
                        fig(sf).stim_str = 'lam_60_prog_w_2Hz_flk';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                end
            end
        case 5
            nHigh       = 12;
            nWide       = 4;
            clear fig
            figure_names{figure_num} = 'Prog, Reg w/ noise (fig5)';
            for sf = 1:12
                switch sf
                    case 1
                        fig(sf).stim_str = 'lam_30_reg_w_17_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 2
                        fig(sf).stim_str = 'lam_30_prog_w_17_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 3
                        fig(sf).stim_str = 'lam_30_full_w_17_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 4
                        fig(sf).stim_str = 'lam_60_reg_w_17_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 5
                        fig(sf).stim_str = 'lam_60_prog_w_17_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 6
                        fig(sf).stim_str = 'lam_60_full_w_17_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 7
                        fig(sf).stim_str = 'lam_30_reg_w_50_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 8
                        fig(sf).stim_str = 'lam_30_prog_w_50_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 9
                        fig(sf).stim_str = 'lam_30_full_w_50_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 10
                        fig(sf).stim_str = 'lam_60_reg_w_50_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 11
                        fig(sf).stim_str = 'lam_60_prog_w_50_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                    case 12
                        fig(sf).stim_str = 'lam_60_full_w_50_noise';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'3','6','12'};
                        fig(sf).extra_str_desc = '';
                end
            end
        case 6
            nHigh       = 10;
            nWide       = 4;
            clear fig
            figure_names{figure_num} = 'Rev Phi (fig6)';
            for sf = 1:3
               switch sf
                    case 1
                        fig(sf).stim_str = 'rev_phi_lam_60_reg';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 60';
                    case 2
                        fig(sf).stim_str = 'rev_phi_lam_60_prog';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 60';
                    case 3
                        fig(sf).stim_str = 'rev_phi_lam_60_full';
                        fig(sf).stim_inds = 1:3;
                        fig(sf).xticks = 1:3;
                        fig(sf).xticklabels = {'.75','2','6'};
                        fig(sf).extra_str_desc = '\lambda 60';
               end
            end
        case 7
            nHigh       = 10;
            nWide       = 5;
            clear fig
            figure_names{figure_num} = 'Tri Flick (fig7)';
            for sf = 1
                switch sf
                    case 1
                        fig(sf).stim_str = 'tri_wav_flick';
                        fig(sf).stim_inds = 1:4;
                        fig(sf).xticks = 1:4;
                        fig(sf).xticklabels = {'.75','2','6','12'};
                        fig(sf).extra_str_desc = '';
                end
            end
    end

    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    heightGap   = .02;      widthGap    = .055;
    heightOffset= .05;      widthOffset = .15;
    sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
    
    if ~exist('figure_iter','var')
        figure_iter = 1;
    else
        figure_iter = figure_iter + 1;
    end
    wing_output = 'lmr';
    y_range = [-3.5 3.5];
    y_tick = [y_range(1) 0 y_range(2)];
    figure_color = [1 1 1];
    figure_size = [25 25 650 880];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = [.2 .2 .2];
    zero_line_color = axis_color;
    font_size_1 = 8;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];
    symm_str = 'flip';
    figure_handle(figure_iter) = figure('Name',figure_names{figure_num},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>

    for sf = 1:numel(fig)

        for stim_ind = fig(sf).stim_inds
            % Plot the timeseries
            clear graph
            exp_grp_iter = 1;
            for exp_grp_ind = exp_comp_group.inds
                graph.line{exp_grp_iter} = summ_data.(fig(sf).stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output '_ts']){stim_ind};
                graph.shade{exp_grp_iter} = summ_data.(fig(sf).stim_str)(exp_grp_ind).(symm_str).(['sem_' wing_output '_ts']){stim_ind};
                graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
                exp_grp_iter = 1 + exp_grp_iter;
            end

            subplot('Position',sp_positions{sf,1+stim_ind-fig(sf).stim_inds(1)})
            vec = 0:numel(graph.line{1});
            plot(vec,zeros(numel(vec),1),'Linestyle','-','color',zero_line_color,'LineWidth',1);
            hold on; box off; 
            makeErrorShadedTimeseries(graph);

            %the axis will change with each of these speeds
            axis([0 numel(graph.line{1}) y_range])
            set(gca,'XTick',[0 numel(graph.line{1})],'XTickLabel',{'0',[num2str(numel(graph.line{1})) '(ms)']},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            set(gca,'YTick',y_tick,'fontsize',font_size_1,'color',figure_color,'YColor',axis_color,'XColor',axis_color)
            if str2double(summ_data.(fig(sf).stim_str)(exp_grp_ind).info.tfs(stim_ind)) > 50
                title(['Spd: ' num2str(summ_data.(fig(sf).stim_str)(exp_grp_ind).info.tfs(stim_ind)) 'dps'],'fontsize',font_size_1)
            else
                title(['Spd: ' num2str(summ_data.(fig(sf).stim_str)(exp_grp_ind).info.tfs(stim_ind)) 'Hz'],'fontsize',font_size_1)
            end
            if 1+stim_ind-fig(sf).stim_inds(1) == 1
               ylabel('\DeltaWBA','fontsize',font_size_1)
            end
        end

        % Plot the tuning curve
        clear graph
        for stim_ind = fig(sf).stim_inds
            exp_grp_iter = 1;
            for exp_grp_ind = exp_comp_group.inds
                graph.line{exp_grp_iter}(stim_ind) = summ_data.(fig(sf).stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output]){stim_ind};
                graph.shade{exp_grp_iter}(stim_ind) = summ_data.(fig(sf).stim_str)(exp_grp_ind).(symm_str).(['sem_' wing_output]){stim_ind};
                graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
                exp_grp_iter = exp_grp_iter + 1;                
            end
        end

        subplot('Position',sp_positions{sf,numel(fig(sf).stim_inds)+1})
        vec = 0:10;
        plot(vec,zeros(numel(vec),1),'Linestyle','-','color',zero_line_color,'LineWidth',1);
        hold on; box off; 
        esh=makeErrorbarTuningCurve(graph,1+fig(sf).stim_inds-fig(sf).stim_inds(1));

        axis([0 numel(fig(sf).stim_inds)+1 y_range]);
        ylabel('Mean \DeltaWBA','fontsize',font_size_1)
        set(gca,'YTick',y_tick,'fontsize',font_size_1,'color',figure_color,'YColor',axis_color,'XColor',axis_color)
        set(gca,'XTick',fig(sf).xticks,'XTickLabel',fig(sf).xticklabels,'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
        descriptions{sf} = [summ_data.(fig(sf).stim_str)(exp_grp_ind).info.description fig(sf).extra_str_desc];

        % Add some metadata and legends
        col_space = 0;
        exp_grp_iter = 1;
        for exp_grp_ind = exp_comp_group.inds
            metadata_position = 1 + exp_grp_iter - exp_comp_group.inds(1);
            metadata_string = {[summ_data.group_info(exp_grp_ind).type ' ' summ_data.group_info(exp_grp_ind).group_name ' N=' num2str(summ_data.group_info(exp_grp_ind).N)]};

            % This only works for ~6 genotypes max
            if mod(metadata_position,2)
                annotation('Textbox','Position',[.08+col_space .965 .32 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2)
                annotation('Rectangle','Position',[.06+col_space .975 .015 .01],'EdgeColor',default_colors(exp_grp_iter,:),'facecolor',default_colors(exp_grp_iter,:));
            else
                annotation('Textbox','Position',[.08+col_space .93 .32 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2)
                annotation('Rectangle','Position',[.06+col_space .94 .015 .01],'EdgeColor',default_colors(exp_grp_iter,:),'facecolor',default_colors(exp_grp_iter,:));
                col_space = col_space + .4;
            end
            exp_grp_iter = exp_grp_iter + 1;
        end

        % Add some stimulus descriptions
        for s = 1:sf
            annotation('Textbox','Position',nudge(sp_positions{sf,1},-.175,0),'String',descriptions{s},'Edgecolor','none','fontsize',font_size_2)
        end
        clear descriptions

    end
end

% export the figure as a pdf
%==========================================================================
if save_figures
    if ~isdir(save_figure_location)
        mkdir(save_figure_location)
    end
    fn = 1;
    export_fig(figure_handle(fn),fullfile(save_figure_location,[exp_comp_group.name]),'-pdf','-nocrop');
    for fn = 2:figure_iter
        %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
        export_fig(figure_handle(fn),fullfile(save_figure_location,[exp_comp_group.name]),'-pdf','-nocrop','-append');
    end
end
clear figure_handle figure_iter
close all % Kind of needed with these figures
end
