% Make figures for up down movement

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/unilat_windowed_up_down_grats_w_flicker';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/unilat_windowed_up_down_grats_w_flicker';

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

% Make large summary figure
%==========================================================================
exp_grp_num = 1;
side = 'flip';

for stim_lam = {'2_px','8_px'}
    stimulus_lambda = stim_lam{1};
    wing_output = 'lmr';
    
    save_figures = 1;

    figure_color = [1 1 1];
    figure_size = [50 50 1000 600];
    figure_title_prefix = ['Summary: ' stimulus_lambda ' Up/Down Motion'];
    figure_file_prefix = [stimulus_lambda '_up_down_stims'];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 7;
    font_size_2 = 10;
    default_colors = [1 0 0 ; 0 0 1 ; 0 .5 0];

    figure_handle(1) = figure('Name', [figure_title_prefix ] ,'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait');

    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    nHigh       = 5;    nWide       = 7;
    heightGap   = .05;  widthGap    = .02;
    heightOffset= .05;  widthOffset = .05;

    sp_positions_1 = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

    for window_size = 1:2
        if window_size == 1
            stim_inds = 1:3;
        elseif window_size == 2
            stim_inds = 4:6;
        end
        
        col_inds = [1 2 3 5 6 7];
        for stim_ind = stim_inds
            col = col_inds(stim_ind);

            stim_type_iter = 1;
            for stim_type = {['flicker_' stimulus_lambda '_right'],['up_' stimulus_lambda '_right'],['up_' stimulus_lambda '_right_w_flicker'],['down_' stimulus_lambda '_right'],['down_' stimulus_lambda '_right_w_flicker']}
                stim_type_str = stim_type{1};                
                
                row = stim_type_iter;
                
                iter = 1; clear graph
                graph.line{iter} = summ_data.(stim_type_str)(exp_grp_num).(side).(['avg_' wing_output '_ts']){stim_ind};
                graph.shade{iter} = summ_data.(stim_type_str)(exp_grp_num).(side).(['sem_' wing_output '_ts']){stim_ind};    
                graph.color{iter} = default_colors(iter,:);

                subplot('Position',sp_positions_1{row,col})
                plot(-10000:10000,zeros(20001,1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)
                hold on; box off;
                esh=makeErrorShadedTimeseries(graph);

                set(gca,'XTick',[],'XTickLabel',{''},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                
                if row == 1
                    title([{[ num2str(summ_data.(stim_type_str).info.window(stim_ind)) char(130) ' Window']},...
                           {[num2str(summ_data.(stim_type_str).info.tfs(stim_ind)) ' Hz']}],'fontsize',font_size_1)
                elseif row == 5
                    xlabel({'Time (s)'},'fontsize',font_size_1)
                    set(gca,'XTick',[0 500 1000 1500],'XTickLabel',{'0','.5','1','1.5'},'fontsize',font_size_1)
                end
                
                if col == 1 || col == 5
                    ylabel({[wing_output ' wba (V)'],stim_type_str},'interpreter','none')
                end
                
                if strcmpi(wing_output,'lmr')
                    axis([0 1500 -2.5 2.5])
                elseif strcmpi(wing_output,'lpr')
                    axis([0 1500 1 11.5])
                end
                
                stim_type_iter = stim_type_iter + 1;
            end
        end
    end

    % Add some metadata
    summ_data.(stim_type_str)(exp_grp_num);
    meta_str = [{['Up / Down Stimuli (with flicker) - ' num2str(summ_data.(stim_type_str)(exp_grp_num).info.pix(stim_inds(1))) ' Pix High']},...
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