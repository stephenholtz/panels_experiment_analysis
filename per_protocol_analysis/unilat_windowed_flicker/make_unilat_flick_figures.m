% Make figures for up down movement

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/unilat_windowed_flicker';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/unilat_windowed_flicker';

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

save_figures = 1;

% Make large mean wba summary figure
%==========================================================================

wing_output = 'lmr';
exp_grp_num = 1;
stimulus_lambda = '60';
figure_color = [1 1 1];
figure_size = [50 50 500 600];
figure_title_prefix = 'Summary: Flicker';
figure_file_prefix = 'flicker_tuning_resp';
font_color = [0 0 0];
xy_color = [0 0 0];
axis_color = figure_color;
zero_line_color = font_color;
font_size_1 = 10;
font_size_2 = 12;
default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

figure_handle(1) = figure('Name', figure_title_prefix,'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait');

% Set up subplots for timeseries, space-time diagrams, and intercept plots
nHigh       = 4;    nWide       = 2;
heightGap   = .05;  widthGap    = .105;
heightOffset= .08;  widthOffset = .0;

sp_positions_main = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

% Figures:
% plot tuning curves in three cols (prog / reg / both) and 8 rows

window_iter = 1;
for wind = {'30to90','45to105','30to120','45to135'}
    window = wind{1};
    row = window_iter;
    
    direction_iter = 1;
    for vert_ext = {'full','mid'}
        vertical_extent = vert_ext{1};
        col = direction_iter;
        
        stim_str = ['flick_' window '_' vertical_extent];
        
        clear graph
        side_str = 'flip';
        for side = 1
            if side == 1
                side_str = 'flip';
            elseif side == 2
                side_str = 'cw';
            elseif side == 3
                side_str = 'ccw';
            end
            
            iter = 1;
            for stim_ind = 1:8
                graph.line{side}(iter,:) = summ_data.(stim_str)(exp_grp_num).(side_str).(['avg_' wing_output]){stim_ind};
                graph.shade{side}(iter,:) = summ_data.(stim_str)(exp_grp_num).(side_str).(['sem_' wing_output]){stim_ind};
                graph.color{side} = default_colors(side,:);
                iter = iter + 1;
            end
            
        end
        
        subplot('Position',sp_positions_main{row,col})
        plot(-10:10,zeros(21,1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)
        hold on; box off;
        esh=makeErrorbarTuningCurve(graph,1:4);
        
        set(gca,'XTick',[],'XTickLabel',{''},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
        
        if row == 1
            title([upper(vertical_extent) '  COLS'],'fontsize',font_size_1)
        elseif row == 4
            xlabel({'Temp Freq (s)'},'fontsize',font_size_1)
            set(gca,'XTick',[1:8],'XTickLabel',{'1' '4' '8' '16' '24' '48' '60' '84'},'fontsize',font_size_1)
        end
        
        if col == 1
            ylabel({[wing_output ' wba (V)'],window},'interpreter','none')
        elseif col == 2
            ylabel({[wing_output ' wba (V)'],window},'interpreter','none')
            set(gca,'YAxisLocation','right')
        end
        
        axis([0 9 -.75 .75])
        
        direction_iter = direction_iter + 1;
    end
    window_iter = window_iter + 1;
end

% Add some metadata
summ_data.(stim_str)(exp_grp_num);
meta_str = [{'Prog / Reg Stimuli'},...
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