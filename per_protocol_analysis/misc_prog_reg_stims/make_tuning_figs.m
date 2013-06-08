%% Make the simplest possible figures

addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

experiment_set = 1;
switch experiment_set
    case 1
        base_figure_name     = 'all_types';
        exp_inds.ctrl   = [1 2];
        exp_inds.c2     = [1 2 3 4];
        exp_inds.c3     = [1 2 5 6];
        exp_inds.c2c3   = [1 2 7];
        exp_inds.l4     = [1 2 8 9];
        exp_inds.lai    = [1 2 10 11];
        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/finished_misc_prog_reg_stims/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/finished_misc_prog_reg_stims/tuning_comparison/';
end

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand_plot = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);
save_figures = 1;
for ls = {'30','60'}
    lam = ls{1};

    %% Make a series of compact timeseries: Ctrl | Cell 1 vs Ctrl Range | Cell 2 vs ...
    %==========================================================================

    if 1
        for figure_type = 1:9

            % Set up subplots 
            heightGap   = .05;      widthGap    = .005;
            heightOffset= .05;      widthOffset = .025;
            nHigh       = 3;        nWide       = 15;
            sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

            if ~exist('figure_iter','var')
                figure_iter = 1;
            else
                figure_iter = figure_iter + 1;
            end

            % figure variables
            wing_output = 'lmr';
            figure_color = [1 1 1];
            figure_size = [25 25 750 350];
            font_color = [0 0 0];
            xy_color = [0 0 0];
            axis_color = [.2 .2 .2];
            zero_line_color = axis_color;
            font_size_1 = 8;
            font_size_2 = 10;
            control_colors = [.3 .3 .3 ; .3 .3 .3];
            default_colors = [ 1 .75 0 ; 0 .2 1; 0 .5 0; .5 0 .5];
            symm_str = 'flip';

            % The rows are different stimuli to compare w/the cols (driver sets)
            cols = {'c2','c3','c2c3','lai'};

            switch figure_type
                case 1
                    pol  = 'off';
                    type = 'bar';
                    rows = {[pol '_' type '_prog'],[pol '_' type '_reg'],[pol '_' type '_full']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_' pol '_' type];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 2
                    rows = {['lam_' lam '_prog'],['alt_bar_flick_lam_' lam],['lam_' lam '_reg']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_prog_flicker_reg_lam_' lam];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 3
                    rows = {['lam_' lam '_prog'],['lam_' lam '_prog_w_1Hz_flk'],['lam_' lam '_prog_w_2Hz_flk']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_prog_with_flicker_lam_' lam];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 4
                    rows = {['lam_' lam '_reg'],['lam_' lam '_reg_w_1Hz_flk'],['lam_' lam '_reg_w_2Hz_flk']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_reg_with_flicker_lam_' lam];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 5
                    rows = {['rev_phi_lam_60_prog'],['rev_phi_lam_60_reg'],['rev_phi_lam_60_full']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_rev_phi_lam_60'];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 6
                    rows = {['lam_' lam '_prog'],['lam_' lam '_prog_w_17_noise'],['lam_' lam '_prog_w_50_noise']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_lam_' lam '_prog_w_noise'];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 7
                    rows = {['lam_' lam '_reg'],['lam_' lam '_reg_w_17_noise'],['lam_' lam '_reg_w_50_noise']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_lam_' lam '_reg_w_noise'];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 8
                    rows = {['lam_' lam '_full'],['lam_' lam '_full_w_17_noise'],['lam_' lam '_full_w_50_noise']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_lam_' lam '_full_w_noise'];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                case 9
                    rows = {['block_rand_lam_' lam '_prog'],['block_rand_lam_' lam '_reg'],['block_rand_lam_' lam '_full']};

                    % Name/make figure
                    figure_name{figure_iter} = [base_figure_name '_lam_' lam '_block_randomized'];
                    figure_handle(figure_iter) = figure('Name',figure_name{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
            end

            if figure_type == 4 || figure_type == 5 || figure_type == 7
                y_range = [-3 3];
            else
                y_range = [-1.5 3.5];
            end
            y_tick = [y_range(1) 0 y_range(2)];

            % Col = genotype set
            col_iter = 1;
            for c = cols
                col = c{1};
                row_iter = 1;
                % Row = stimulus set
                for r = rows
                    row = r{1};
                    % Stimulus_ind = stimulus speed (3 of each)
                    for stim_ind = 1:3
                        plot_col = (col_iter-1)*3 + stim_ind + 1;
                        % exp_grp_iter = genotype set driver
                        clear graph
                        graph.line_width = 1;
                        for exp_grp_iter = 1:numel(exp_inds.(col))
                            exp_grp_ind = (exp_inds.(col)(exp_grp_iter));
                            graph.line{exp_grp_iter} = summ_data.(row)(exp_grp_ind).(symm_str).(['avg_' wing_output '_ts']){stim_ind};
                            if exp_grp_ind == 1 || exp_grp_iter == 2
                                graph.color{exp_grp_iter} = control_colors(exp_grp_iter,:);
                                graph.shade{exp_grp_iter} = zeros(1,numel(summ_data.(row)(exp_grp_ind).(symm_str).(['sem_' wing_output]){stim_ind}));
                            else
                                graph.color{exp_grp_iter} = default_colors(exp_grp_iter-2,:);
                                graph.shade{exp_grp_iter} = zeros(1,numel(summ_data.(row)(exp_grp_ind).(symm_str).(['sem_' wing_output]){stim_ind}));
                            end
                        end

                        subplot('Position',nudge(sp_positions{row_iter,plot_col},.04*(col_iter-1),0));
                        vec = 0:numel(graph.line{1});
                        plot(vec,zeros(numel(vec),1),'Linestyle','-','color',zero_line_color,'LineWidth',1);
                        hold on; box off;
                        makeErrorShadedTimeseries(graph);
                        %the axis will change with each of these speeds
                        axis([0 numel(graph.line{1}) y_range])
                        set(gca,'XTick',[0 numel(graph.line{1})],'XTickLabel',{'0','end'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                        %set(gca,'XTick',[0 numel(graph.line{1})],'XTickLabel',{'0',[num2str(numel(graph.line{1})) '(ms)']},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                        set(gca,'YTick',y_tick,'fontsize',font_size_1,'color',figure_color,'YColor',axis_color,'XColor',axis_color)
                        if stim_ind ~= 1
                            axis off
                        else
                            if row_iter == 1
                                title(summ_data.group_info(exp_grp_ind).type(),'fontsize',font_size_2);
                            end
                            if plot_col < 3
                                switch figure_type
                                    case 1
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Progressive'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Regressive'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Full-Sweep'},'fontsize',font_size_2)
                                        end
                                        %ylabel({'\DeltaWBA',summ_data.(row)(exp_grp_ind).info.description},'fontsize',font_size_1)
                                    case 2
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Progressive'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Flicker'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Regressive'},'fontsize',font_size_2)
                                        end
                                    case 3
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Progressive'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Prog + 1Hz Flick'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Prog + 2Hz Flick'},'fontsize',font_size_2)
                                        end
                                    case 4
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Regressive'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Reg + 1Hz Flick'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Reg + 2Hz Flick'},'fontsize',font_size_2)
                                        end
                                    case 5
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','RevPhi Prog'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','RevPhi Reg'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','RevPhi Full-Field'},'fontsize',font_size_2)
                                        end
                                    case 6
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Prog 0% Noise'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Prog 17% Noise'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Prog 50% Noise'},'fontsize',font_size_2)
                                        end
                                    case 7
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Reg 0% Noise'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Reg 17% Noise'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Reg 50% Noise'},'fontsize',font_size_2)
                                        end
                                    case 8
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Full 0% Noise'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Full 17% Noise'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Full 50% Noise'},'fontsize',font_size_2)
                                        end
                                    case 9
                                        if row_iter == 1
                                            ylabel({'\DeltaWBA','Prog Rand Block'},'fontsize',font_size_2)
                                        elseif row_iter == 2
                                            ylabel({'\DeltaWBA','Reg Rand Block'},'fontsize',font_size_2)
                                        elseif row_iter == 3
                                            ylabel({'\DeltaWBA','Full Rand Block'},'fontsize',font_size_2)
                                        end
                                end
                            end
                        end
                    end
                    row_iter = row_iter + 1;
                end
                col_iter = col_iter + 1;
            end
            % Add a title on top:
            annotation('Textbox','Position',[.1 .9 .7 .1],'String',figure_name{figure_iter},'Edgecolor','none','fontsize',font_size_2,'interpreter','none')
        end
    end

    %% export the figure as a pdf
    %==========================================================================
    if save_figures
        if ~isdir(save_figure_location)
            mkdir(save_figure_location)
        end
        fn = 1;
        export_fig(figure_handle(fn),fullfile(save_figure_location,['tuning_comparison_' figure_name{fn} '_' lam]),'-pdf','-nocrop');
        for fn = 2:figure_iter
            %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
            export_fig(figure_handle(fn),fullfile(save_figure_location,['tuning_comparison_' figure_name{fn} '_' lam]),'-pdf','-nocrop','-append');
        end
    end
    clear figure_handle figure_iter
end