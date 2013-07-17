%% Initial settings and data loading
%==========================================================================

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_tf_dir_mot_sweep/';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/sf_tf_dir_mot_sweep/';

% anon funcs for moving subplots around
nudge_subplot       = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand_subplot      = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);
take_center_third   = @(vec)(vec((length(vec)/3):(length(vec)*2/3)-1));
flip_extend_4filt   = @(vec)([fliplr(-(vec)) squeeze(vec) fliplr((vec))]);

figure_iter     = 1;
save_figures    = 1;
make_single_pdf = 1;
do_butter       = 1;

control_inds = [1 2];
exp_comp_groups(1).name = 'controls'; %
exp_comp_groups(1).inds = [1 2];
exp_comp_groups(2).name = 'c2_vs_controls'; %
exp_comp_groups(2).inds = [1 2];
exp_comp_groups(3).name = 'c3_vs_controls'; %
exp_comp_groups(3).inds = [1 2 3];
exp_comp_groups(4).name = 'c23_vs_controls'; %
exp_comp_groups(4).inds = [1 2 5];
exp_comp_groups(5).name = 'lai_vs_controls'; %
exp_comp_groups(5).inds = [1 2 6 7];

wing_output = 'lmr';
exp_grp_num = 1;

figure_type = 'paper';
fs = figure_settings(figure_type);
fs.figure_size = [50 50 450 700];

% Either go rowwise (for spatial freq) or columnwise (for temporal freq)
% through the condition pairs to get tuning conditions

%% General summary figure 1: tuning over 1 SF wrt TF (and with timeseries)
%==========================================================================

% Set up subplots for timeseries / tuning curves
%nHigh       = 15;   nWide       = 11;
nHigh       = 5;    nWide       = 6;
heightGap   = .025; widthGap    = .01;
heightOffset= .125;   widthOffset = .055;
sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
clear nHigh nWide height* width*

symm_str = 'flip'; % Use flipped and averaged conditions
%[B,A] = butter(2,.0695,'low'); % 35Hz cutoff (I think)
[B,A] = butter(2,.105,'low');

% Make a subset of the figures if just testing
testing_figures = 1;
switch testing_figures
    case 0
        % Make all of the figures
        exp_comp_inds = 1:numel(exp_comp_groups);
        stim_types = 1:6;
    case 1
        % Only make these figures
        exp_comp_inds = [1];
        stim_types = 1:6;
end

for exp_comp_ind = exp_comp_inds
    for stim_type = stim_types
        switch stim_type
            case 1
                stim_str = 'bilateral_motion';
                graph_ts_row_nums   = 1:4;
                graph_ts_col_nums   = 1:5;
                stim_inds           = 1:20;
                title_str = summ_data.cond_groups(stim_type).description;
                x_axis_str = summ_data.cond_groups(stim_type).tfs(1:4);
            case 2
                stim_str = 'progressive';
                graph_ts_row_nums   = 1:4;
                graph_ts_col_nums   = 1:5;
                stim_inds           = 1:20;
                title_str = summ_data.cond_groups(stim_type).description;
                x_axis_str = summ_data.cond_groups(stim_type).tfs(1:4);
            case 3
                stim_str = 'regressive';
                graph_ts_row_nums   = 1:4;
                graph_ts_col_nums   = 1:5;
                stim_inds           = 1:20;
                title_str = summ_data.cond_groups(stim_type).description;
                x_axis_str = summ_data.cond_groups(stim_type).tfs(1:4);
            case 4
                stim_str = 'progressive_w_flk';
                graph_ts_row_nums   = 1:4;
                graph_ts_col_nums   = 1:5;
                stim_inds           = 1:20;
                title_str = summ_data.cond_groups(stim_type).description;
                x_axis_str = summ_data.cond_groups(stim_type).tfs(1:4);
            case 5
                stim_str = 'regressive_w_flk';
                graph_ts_row_nums   = 1:4;
                graph_ts_col_nums   = 1:5;
                stim_inds           = 1:20;
                title_str = summ_data.cond_groups(stim_type).description;
                x_axis_str = summ_data.cond_groups(stim_type).tfs(1:4);
            case 6
                stim_str = 'flicker';
                graph_ts_row_nums   = 1:4;
                graph_ts_col_nums   = 1:4;
                stim_inds           = 1:16;
                title_str = summ_data.cond_groups(stim_type).description;
                x_axis_str = summ_data.cond_groups(stim_type).tfs(1:4);
        end
        figure_handle(figure_iter) = figure('Name',['fig_' num2str(figure_iter) '_' exp_comp_groups(exp_comp_ind).name '- Temp Freq Tuning Curves'],'NumberTitle','off','Color',fs.bkg_color,'Position',fs.figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_names{figure_iter} = [exp_comp_groups(exp_comp_ind).name '_' stim_str '_timeseries_matrix'];
        figure_iter = figure_iter + 1;
        
        y_label_str = '\Delta WBA';
        x_label_str = 'Time';
        
        stim_iter = 1;
        for graph_col = graph_ts_col_nums
            for graph_row = graph_ts_row_nums
                clear graph
                graph.line_width = fs.line_width;
                
                control_color_ind = 1;
                exp_color_ind = 1;
                exp_ind = 1;
                
                for exp_grp_num = exp_comp_groups(exp_comp_ind).inds
                    graph.line{exp_ind}     = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output '_ts']){stim_inds(stim_iter)};
                    graph.shade{exp_ind}    = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output '_ts']){stim_inds(stim_iter)};
                    % Flip it, Butter it cut out its center to plot it
                    if do_butter
                        graph.line{exp_ind}     = take_center_third(filtfilt(B,A,flip_extend_4filt(graph.line{exp_ind})));
                        graph.shade{exp_ind}    = take_center_third(filtfilt(B,A,flip_extend_4filt(graph.shade{exp_ind})));
                    end
                    if ~isempty(intersect(exp_grp_num,control_inds))
                        graph.color{exp_ind} = fs.ctrl_colors(control_color_ind,:);
                        control_color_ind=control_color_ind + 1;
                    else
                        graph.color{exp_ind} = fs.exp_colors(exp_color_ind,:);
                        exp_color_ind = exp_color_ind + 1;
                    end
                    exp_ind = exp_ind + 1;
                end
                subplot('Position',sp_positions{graph_row,graph_col})
                vec=0:2250;
                plot(vec,zeros(numel(vec),1),'Linestyle','-','Color',fs.axis_color,'LineWidth',fs.line_width)
                hold on; box off;axis off;
                makeErrorShadedTimeseries(graph);
                axis([0 2250 -2 4])
                if graph_col == 1 && graph_row == 4
                    axis on;
                    set(gca,'XTick',[0 2250],'XTickLabel',{'0','2250(ms)'},'fontsize',fs.axis_font_size,'ticklength',2*get(gca,'ticklength'),'Color',fs.bkg_color)
                end
                if graph_col == 1
                    ylabel(y_label_str)
                end
                
                title({['TF ' num2str(summ_data.cond_groups(stim_type).tfs(stim_iter))],['SF ' num2str(summ_data.cond_groups(stim_type).sfs(stim_iter))]},'fontsize',fs.axis_font_size)
                
                stim_iter = stim_iter + 1;
            end
        end
        
%         % Make all of the TF tuning curve plots (single SF)
%         bottom_tune_row = graph_ts_row_nums(end) + 1;
%         stim_ind = [];
%         for graph_col = graph_ts_col_nums
%             %stim_ind = (graph_row-1)*graph_ts_col_nums(end) + 1;
%             %TODO
%             clear graph
%             graph.line{exp_ind}     = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output]){stim_inds(stim_iter)};
%             graph.shade{exp_ind}    = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output]){stim_inds(stim_iter)};
%             if ~isempty(intersect(exp_grp_num,control_inds))
%                 graph.color{exp_ind} = fs.ctrl_colors(control_color_ind,:);
%                 control_color_ind=control_color_ind + 1;
%             else
%                 graph.color{exp_ind} = fs.exp_colors(exp_color_ind,:);
%                 exp_color_ind = exp_color_ind + 1;
%             end
%             subplot('Position',sp_positions{bottom_tune_row,graph_col})
%             vec=0:bottom_tune_row;
%             plot(vec,zeros(numel(vec),1),'Linestyle','-','Color',fs.axis_color,'LineWidth',fs.line_width)
%             hold on; box off;axis off;
%             makeErrorbarTuningCurve(graph);
%         end
% 
%         % Make all of the SF tuning curve plots (single TF)
%         right_tune_col = graph_ts_col_nums(end) + 1;
%         stim_ind = [];
%         for graph_row = graph_ts_row_nums
%             %stim_ind = (graph_row-1)*graph_ts_col_nums(end) + 1;
%             %TODO
%             clear graph
%             graph.line{exp_ind}     = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output]){stim_inds(stim_iter)};
%             graph.shade{exp_ind}    = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output]){stim_inds(stim_iter)};
%             if ~isempty(intersect(exp_grp_num,control_inds))
%                 graph.color{exp_ind} = fs.ctrl_colors(control_color_ind,:);
%                 control_color_ind=control_color_ind + 1;
%             else
%                 graph.color{exp_ind} = fs.exp_colors(exp_color_ind,:);
%                 exp_color_ind = exp_color_ind + 1;
%             end
%             subplot('Position',sp_positions{graph_row,right_tune_col})
%             vec=0:right_tune_col;
%             plot(vec,zeros(numel(vec),1),'Linestyle','-','Color',fs.axis_color,'LineWidth',fs.line_width)
%             hold on; box off;axis off;
%             makeErrorbarTuningCurve(graph);
%         end

        % Add a title based on stim_type (title_str from switch)
        annotation('Textbox','Position',[.08 .9725 .8 .025],'String',title_str,'Edgecolor','none','fontsize',fs.title_font_size,'Color',fs.font_color)
        
        % Add a legend
        col_space = 0;
        exp_color_ind = 1;
        control_color_ind = 1;
        exp_grp_iter = 1;
        for exp_grp_ind = exp_comp_groups(exp_comp_ind).inds
            metadata_position = 1 + exp_grp_iter - exp_comp_groups(exp_comp_ind).inds(1);

            metadata_string = {[summ_data.group_info(exp_grp_ind).type '  N = ' num2str(summ_data.group_info(exp_grp_ind).N) ' ' summ_data.group_info(exp_grp_ind).group_name]};
            
            % Get the colors right
            if ~isempty(intersect(exp_grp_num,control_inds))
                tmp_color = fs.ctrl_colors(control_color_ind,:);
                control_color_ind=control_color_ind + 1;
            else
                tmp_color = fs.exp_colors(exp_color_ind,:);
                exp_color_ind = exp_color_ind + 1;
            end

            % This only works for ~6 genotypes max
            if mod(metadata_position,2)
                annotation('Textbox','Position',[.08+col_space .95 .3 .025],'String',metadata_string,'Edgecolor','none','Color',fs.font_color,'fontsize',fs.axis_font_size+1)
                annotation('Rectangle','Position',[.06+col_space .96 .015 .01],'EdgeColor',tmp_color,'facecolor',tmp_color);
            else
                annotation('Textbox','Position',[.08+col_space .915 .3 .025],'String',metadata_string,'Edgecolor','none','Color',fs.font_color,'fontsize',fs.axis_font_size+1)
                annotation('Rectangle','Position',[.06+col_space .925 .015 .01],'EdgeColor',tmp_color,'facecolor',tmp_color);
                col_space = col_space + .32;
            end
            exp_grp_iter = exp_grp_iter + 1;
        end
    end
    % Clean up.
    clear ts_hand stim_str stim_iter first_* title_str
end

%% General summary figure 2: tuning over 1 TF wrt SF (and with timeseries)
%==========================================================================

%% Export the figure as a pdf
%==========================================================================
if save_figures
    if ~isdir(save_figure_location)
        mkdir(save_figure_location)
    end

    for figure_iter = 1:numel(figure_handle-1)
        %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
        export_fig(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]),'-pdf','-nocrop');
    end
    figures_per_line = 6;
    % also do a single pdf version
    if make_single_pdf
        combo_figs_iter = 0;
        for figure_iter = 1:numel(figure_handle-1)
            if ~mod(figure_iter-1,figures_per_line)
                combo_figs_iter = combo_figs_iter + 1;
                combo_figure_name = [exp_comp_groups(combo_figs_iter).name ' combined_figures'];
                export_fig(figure_handle(figure_iter),fullfile(save_figure_location,combo_figure_name),'-pdf','-nocrop');
            else
                export_fig(figure_handle(figure_iter),fullfile(save_figure_location,combo_figure_name),'-pdf','-nocrop','-append');
            end
        end
    end
end