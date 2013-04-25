% Make figures for up down movement

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/windowed_prog_reg_motion_lambda_60';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/windowed_prog_reg_motion_lambda_60';

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

save_figures = 1;

% Make large mean wba summary figure
%==========================================================================
if 1

    wing_output = 'lmr';
    exp_grp_num = 1;
    stimulus_lambda = '60';
    figure_color = [1 1 1];
    figure_size = [50 50 500 600];
    figure_title_prefix = ['Summary: ' stimulus_lambda ' Prog/Reg Motion'];
    figure_file_prefix = [stimulus_lambda '_prog_reg_stims' '_mean_wba_tuning'];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 7;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

    figure_handle(1) = figure('Name', figure_title_prefix,'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait');

    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    nHigh       = 8;    nWide       = 3;
    heightGap   = .05;  widthGap    = .055;
    heightOffset= .05;  widthOffset = .05;

    sp_positions_main = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

    % Figures:
    % plot tuning curves in three cols (prog / reg / both) and 8 rows
    window_iter = 1;
    for wind = {'30to60','60to90','90to120','120to150','30to90','60to120','90to150','30to150'}
        window = wind{1};
        row = window_iter;

        direction_iter = 1;
        for dir = {'prog','reg','both'}
            direction = dir{1};
            col = direction_iter;
            stim_str = [direction '_' window];

            clear graph
            for side = 1
                if side == 1
                    side_str = 'flip';
                elseif side == 2
                    side_str = 'cw';
                elseif side == 3
                    side_str = 'ccw';
                end
                iter = 1;
                for stim_ind = 1:4
                    graph.line{side}(iter,:) = summ_data.(stim_str)(exp_grp_num).(side_str).(['avg_' wing_output]){stim_ind};
                    graph.shade{side}(iter,:) = summ_data.(stim_str)(exp_grp_num).(side_str).(['sem_' wing_output]){stim_ind};    
                    graph.color{side} = default_colors(side,:);
                    iter = iter + 1;
                end
            end

            subplot('Position',sp_positions_main{row,col})
            plot(-1000:1000,zeros(2001,1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)
            hold on; box off;
            esh=makeErrorbarTuningCurve(graph,1:4);

            set(gca,'XTick',[],'XTickLabel',{''},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))

            if row == 1
                title(summ_data.(stim_str).info.dir,'fontsize',font_size_1)
            elseif row == 8
                xlabel({'Temp Freq (s)'},'fontsize',font_size_1)
                set(gca,'XTick',[1 2 3 4],'XTickLabel',{'.5','4','8','16'},'fontsize',font_size_1)
            end

            if col == 1
                ylabel({[wing_output ' wba (V)'],window},'interpreter','none')
            elseif col == 3
                set(gca,'YAxisLocation','right')
                ylabel({[wing_output ' wba (V)'],window},'interpreter','none')
            end

            axis([0 5 -.75 2.75])

            direction_iter = direction_iter + 1;
        end
        window_iter = window_iter + 1;
    end

    % Add some metadata
    summ_data.(stim_str)(exp_grp_num);
    meta_str = [{'Prog / Reg / Bilateral Stimuli'},...
                {[summ_data.group_info(exp_grp_num).group_name 'N = ' num2str(summ_data.group_info(exp_grp_num).N)]}];

    annotation('Textbox','Position',[.1 .785 .6 .2],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none')

    % export the figure as a pdf
    if save_figures
        if ~isdir(save_figure_location)
            mkdir(save_figure_location)
        end

        saveas(figure_handle(1),fullfile(save_figure_location,[figure_file_prefix '_' summ_data.group_info(exp_grp_num).group_folder(1:end-14)]));
        export_fig(figure_handle(1),fullfile(save_figure_location,[figure_file_prefix '_' summ_data.group_info(exp_grp_num).group_folder(1:end-14)]),'-pdf','-nocrop');
    end

end


% Make timeseries summary figure (showing cw, ccw)
%==========================================================================
if 1
    wing_output = 'lmr';
    exp_grp_num = 1;
    stimulus_lambda = '60';
    figure_color = [1 1 1];
    figure_size = [50 50 500 600];
    figure_title_prefix = ['Summary: ' stimulus_lambda ' Prog/Reg Motion'];
    figure_file_prefix = [stimulus_lambda '_prog_reg_stims' '_timeseries'];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 7;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

    figure_handle(1) = figure('Name', figure_title_prefix,'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait');

    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    nHigh       = 8;    nWide       = 3;
    heightGap   = .05;  widthGap    = .055;
    heightOffset= .05;  widthOffset = .05;

    sp_positions_main = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

    % Figures:
    % plot tuning curves in three cols (prog / reg / both) and 8 rows
    window_iter = 1;
    for wind = {'30to60','60to90','90to120','120to150','30to90','60to120','90to150','30to150'}
        window = wind{1};
        row = window_iter;

        direction_iter = 1;
        for dir = {'prog','reg','both'}
            direction = dir{1};
            col = direction_iter;
            stim_str = [direction '_' window];

            clear graph
            for side = 1
                if side == 1
                    side_str = 'flip';
                elseif side == 2
                    side_str = 'cw';
                elseif side == 3
                    side_str = 'ccw';
                end
                iter = 1;
                for stim_ind = 1:4
                    graph.line{stim_ind} = summ_data.(stim_str)(exp_grp_num).(side_str).(['avg_' wing_output '_ts']){stim_ind};
                    graph.shade{stim_ind} = summ_data.(stim_str)(exp_grp_num).(side_str).(['sem_' wing_output '_ts']){stim_ind};    
                    graph.color{stim_ind} = default_colors(stim_ind,:);
                    iter = iter + 1;
                end
            end

            subplot('Position',sp_positions_main{row,col})
            plot(-1500:1500,zeros(3001,1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)
            hold on; box off;
            esh=makeErrorShadedTimeseries(graph);

            set(gca,'XTick',[],'XTickLabel',{''},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))

            if row == 1
                title(summ_data.(stim_str).info.dir,'fontsize',font_size_1)
            elseif row == 8
                xlabel({'Temp Freq (s)'},'fontsize',font_size_1)
                set(gca,'XTick',[0 500 1500],'XTickLabel',{'0','.5','1.5'},'fontsize',font_size_1)
            end
            
            if col == 1
                ylabel({[wing_output ' wba (V)'],window},'interpreter','none')
            elseif col == 3
                set(gca,'YAxisLocation','right')
                ylabel({[wing_output ' wba (V)'],window},'interpreter','none')
            end

            axis([0 1500 -1 3])

            direction_iter = direction_iter + 1;
        end
        window_iter = window_iter + 1;
    end

    % Add some metadata
    summ_data.(stim_str)(exp_grp_num);
    meta_str = [{'Prog / Reg / Bilateral Stimuli'},...
                {[summ_data.group_info(exp_grp_num).group_name 'N = ' num2str(summ_data.group_info(exp_grp_num).N)]}];

    annotation('Textbox','Position',[.1 .785 .6 .2],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none')

    % export the figure as a pdf
    if save_figures
        if ~isdir(save_figure_location)
            mkdir(save_figure_location)
        end

        saveas(figure_handle(1),fullfile(save_figure_location,[figure_file_prefix '_' summ_data.group_info(exp_grp_num).group_folder(1:end-14)]));
        export_fig(figure_handle(1),fullfile(save_figure_location,[figure_file_prefix '_' summ_data.group_info(exp_grp_num).group_folder(1:end-14)]),'-pdf','-nocrop');
    end

    
end