% Make figures for up down movement

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/unilat_windowed_up_down_grats';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/unilat_windowed_up_down_grats';

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

% Make large summary figure
%==========================================================================
for exp_grp_num = 1

    for wo = {'lmr','lpr'}
        wing_output = wo{1};
        
        save_figures = 1;

        figure_color = [1 1 1];
        figure_size = [50 50 1000 600];
        figure_title_prefix = ['Summary: ' upper(wing_output) ' Up-Down'];
        figure_file_prefix = [wing_output 'up_down_stims'];
        font_color = [0 0 0];
        xy_color = [0 0 0];
        axis_color = figure_color;
        zero_line_color = font_color;
        font_size_1 = 7;
        font_size_2 = 10;
        default_colors = [1 0 0 ; 0 0 1 ; 0 .5 0];
        
        figure_handle(1) = figure('Name', [figure_title_prefix ] ,'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait');

        % locaction of the log plot of the null responses
        log_plot_position = [.15 .6 .3 .28];

        % Set up subplots for timeseries, space-time diagrams, and intercept plots
        nHigh       = 6;    nWide       = 8;
        heightGap   = .05;  widthGap    = .02;
        heightOffset= .05;  widthOffset = .05;
        
        sp_positions_1 = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

        cols1 = [1 3 5];
        cols2 = [2 4 6];
        
        for stim_spat_freq_iter = 1:3 % The rows
            
            stim_inds = (3*(stim_spat_freq_iter-1)) + [1:3];

            stim_type_iter = 1;
            for stim_type = {'full_field_up','full_field_down','center_120_up','center_120_down','right_120_up','right_120_down'} % The cols

                row = stim_type_iter;
                
                stim_type_str = stim_type{1};
                
                    curr_plot_type = 1;
                    col = cols2(stim_spat_freq_iter);
                
                    iter = 1; clear graph
                    for stim_ind = stim_inds
                        graph.line{iter} = summ_data.(stim_type_str)(exp_grp_num).flip.(['avg_' wing_output]){stim_ind};
                        graph.shade{iter} = summ_data.(stim_type_str)(exp_grp_num).flip.(['sem_' wing_output]){stim_ind};
                        graph.color{iter} = default_colors(iter,:);
                        iter = iter + 1;
                    end

                    subplot('Position',sp_positions_1{row,col})
                    plot(-10:10,zeros(21,1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)
                    hold on; box off;

                    plot(1:3,[graph.line{:}],'Color',[0 0 0]);
                    ebh=makeErrorbarTuningCurve(graph,1:3);
                    
                    
                    set(gca,'XTick',[],'XTickLabel',{''},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))

                    if row == 1
                        title([num2str(summ_data.(stim_type_str)(exp_grp_num).info.pix(stim_inds(1))) ' Pix High'],'fontsize',font_size_1)
                    elseif row == 6 && curr_plot_type == 1
                        xlabel({'Temp Freq (Hz)'},'fontsize',font_size_1)
                        set(gca,'XTick',[1 2 3],'XTickLabel',{'.5','4','8'},'fontsize',font_size_1)
                    end

                    if col == 1
                        ylabel({[wing_output ' wba (V)'],stim_type_str},'interpreter','none')
                    end

                    if strcmpi(wing_output,'lmr')
                        axis([0 4 -2.5 2.5])
                    elseif strcmpi(wing_output,'lpr')
                        axis([0 4 1 11.5])
                    end
                
                    curr_plot_type = 2;
                    col = cols1(stim_spat_freq_iter);
                    
                    iter = 1; clear graph
                    for stim_ind = stim_inds
                        graph.line{iter} = summ_data.(stim_type_str)(exp_grp_num).flip.(['avg_' wing_output '_ts']){stim_ind};
                        graph.shade{iter} = summ_data.(stim_type_str)(exp_grp_num).flip.(['sem_' wing_output '_ts']){stim_ind};    
                        graph.color{iter} = default_colors(iter,:);
                        iter = iter + 1;
                    end

                    subplot('Position',sp_positions_1{row,col})
                    plot(-10000:10000,zeros(20001,1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)
                    hold on; box off;

                    esh=makeErrorShadedTimeseries(graph);

                    set(gca,'XTick',[],'XTickLabel',{''},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                    
                    if row == 1
                        title([num2str(summ_data.(stim_type_str)(exp_grp_num).info.pix(stim_inds(1))) ' Pix High'],'fontsize',font_size_1)
                    elseif row == 6 && curr_plot_type == 2
                        xlabel({'Time (s)'},'fontsize',font_size_1)
                        set(gca,'XTick',[0 1000 2000],'XTickLabel',{'0','1','2'},'fontsize',font_size_1)
                    end

                    if col == 1
                        ylabel({[wing_output ' wba (V)'],stim_type_str},'interpreter','none')
                    end
                    
                    if strcmpi(wing_output,'lmr')
                        axis([0 2000 -2.5 2.5])
                    elseif strcmpi(wing_output,'lpr')
                        axis([0 2000 1 11.5])
                    end

                stim_type_iter = stim_type_iter + 1;
            end 
        end

        % Add some metadata
        summ_data.(stim_type_str)(exp_grp_num);
        meta_str = [{'UP + DOWN Stimuli'},...
                    {[wing_output ' wba (V)']},...
                    {''},...
                    {summ_data.group_info(exp_grp_num).group_name},...
                    {['N = ' num2str(summ_data.group_info(exp_grp_num).N)]}];
                
        annotation('Textbox','Position',[.8 .7 .8 .167],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none')
        
        % export the figure as a pdf
        if save_figures
            if ~isdir(save_figure_location)
                mkdir(save_figure_location)
            end

            saveas(figure_handle(1),fullfile(save_figure_location,[figure_file_prefix '_' summ_data.group_info(exp_grp_num).group_folder(1:end-14)]));
            export_fig(figure_handle(1),fullfile(save_figure_location,[figure_file_prefix '_' summ_data.group_info(exp_grp_num).group_folder(1:end-14)]),'-pdf','-nocrop');
        end

    end

end