% Make figures for velocity nulling

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/overlaid_vel_nulling_and_bilateral_vel_nulling';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/overlaid_vel_nulling_and_bilateral_vel_nulling';

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

% some stimulus specific processing...
test_contrast_values = [.09 .27 .45];
test_temp_freq_values = [.2 1.3 5.3 10.7 16];
for vn_str = {'overlaid_vel_null','bilat_vel_null'}
    
    vel_null_type_str = vn_str{1};
    
    for exp_grp_num = 1:numel(summ_data.group_info)

        contrast_inds = 1:3;
        for contrast_subset = 1:5

            avg(contrast_subset,:)=[summ_data.(vel_null_type_str)(exp_grp_num).flip.avg_lmr{contrast_inds}]; %#ok<*SAGROW>
            sem(contrast_subset,:)=[summ_data.(vel_null_type_str)(exp_grp_num).flip.sem_lmr{contrast_inds}];

            fit_vals(contrast_subset,:) = polyfit(test_contrast_values',avg(contrast_subset,:)',1);
            fit_line(contrast_subset,:) = polyval(fit_vals(contrast_subset,:),test_contrast_values);

            intercept_val(contrast_subset) = -1*(fit_vals(contrast_subset,2)/fit_vals(contrast_subset,1));
            null_contrast(contrast_subset,:) = 1/intercept_val(contrast_subset);

            contrast_inds = contrast_inds + 3;
        end

        vel_null.(vel_null_type_str)(exp_grp_num).avg = avg;
        vel_null.(vel_null_type_str)(exp_grp_num).sem = sem;
        vel_null.(vel_null_type_str)(exp_grp_num).contrast_inds = contrast_inds;
        vel_null.(vel_null_type_str)(exp_grp_num).fit_vals = fit_vals;
        vel_null.(vel_null_type_str)(exp_grp_num).fit_line = fit_line;
        vel_null.(vel_null_type_str)(exp_grp_num).intercept_val = intercept_val';
        vel_null.(vel_null_type_str)(exp_grp_num).null_contrast = null_contrast';
    end
end

% Make large summary figure: show raw timeseries, intercept calculation and
% semilog plot for the overlaid vel null
%==========================================================================
for exp_grp_num = 1:2;

    for vn_str = {'overlaid_vel_null','bilat_vel_null'}

        vel_null_type_str = vn_str{1};

        save_figures = 1;

        figure_color = [1 1 1];
        figure_size = [50 50 1000 600];
        figure_title_prefix = ['Summary: ' vel_null_type_str];
        figure_file_prefix = vel_null_type_str;
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
        nHigh       = 4;    nWide       = 5;
        heightGap   = .05;  widthGap    = .02;
        heightOffset= .04;  widthOffset = .08;

        sp_positions_1 = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

        stim_inds = 1:3;

        for vel_set = 1:5

            % plot the intercept calculations
            iter = 1; clear graph
            for stim_ind = stim_inds
                graph.line{iter} = summ_data.(vel_null_type_str)(exp_grp_num).flip.avg_lmr{stim_ind};
                graph.shade{iter} = summ_data.(vel_null_type_str)(exp_grp_num).flip.sem_lmr{stim_ind};    
                graph.color{iter} = default_colors(iter,:);
                iter = iter + 1;
            end
            

            subplot('Position',sp_positions_1{3,vel_set})
            plot(-10:10,zeros(21,1),'Color',zero_line_color,'LineWidth',1)
            hold on; box off;

            plot(1:3,[graph.line{:}],'Color',[0 0 0]);
            ebh=makeErrorbarTuningCurve(graph,1:3);

            plot(vel_null.(vel_null_type_str)(1).fit_line(vel_set,:),'linestyle','-','Color',[1 0 0],'Linewidth',1);

            title(['Test Freq = ' num2str(test_temp_freq_values(vel_set))],'fontsize',font_size_1)
            if vel_set == 1; ylabel({'Mean',' \DeltaWBA (V)'},'fontsize',font_size_1); end
            xlabel({'Test Contrast'},'fontsize',font_size_1)
            set(gca,'XTick',[1 2 3],'XTickLabel',{'.09','.27','.45'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            axis([0 4 -3 3])

            % plot the overlaid timeseries 
            iter = 1; clear graph
            for stim_ind = stim_inds
                graph.line{iter} = summ_data.(vel_null_type_str)(exp_grp_num).flip.avg_lmr_ts{stim_ind};
                graph.shade{iter} = summ_data.(vel_null_type_str)(exp_grp_num).flip.sem_lmr_ts{stim_ind};
                graph.color{iter} = default_colors(iter,:);
                iter = iter + 1;
            end

            subplot('Position',sp_positions_1{4,vel_set})
            plot(-10:10,zeros(21,1),'Color',zero_line_color,'LineWidth',1)
            hold on; box off;

            esh=makeErrorShadedTimeseries(graph);

            if vel_set == 1; ylabel({'\DeltaWBA (V)'},'fontsize',font_size_1); end
            xlabel({'Time'},'fontsize',font_size_1)
            set(gca,'XTick',[0 1000 2000],'XTickLabel',{'0','1','2(s)'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            axis([0 2000 -3 3])

            stim_inds = stim_inds + 3;

        end

        % plot the log plot
        subplot('Position',log_plot_position)
        
        lp=semilogx(test_temp_freq_values,vel_null.(vel_null_type_str)(1).null_contrast','Color',[0 0 0],'Linewidth',2);

        box off;
        title('Velocity Nulling','fontsize',font_size_2)
        ylabel({'Contrast Sensitivity','1/(null contrast)'},'fontsize',font_size_2)
        xlabel({'Test Temporal Frequency (Hz)'},'fontsize',font_size_2)
        set(gca,'fontsize',font_size_2)
        axis([0.12 30 0 5.25])

        % Add some metadata
        summ_data.(vel_null_type_str)(exp_grp_num);
        meta_str = [{summ_data.(vel_null_type_str)(exp_grp_num).info.description},...
                    {''},...
                    {summ_data.(vel_null_type_str)(exp_grp_num).info.note},...
                    {summ_data.group_info(exp_grp_num).group_name},...
                    {['N = ' num2str(summ_data.group_info(exp_grp_num).N)]}];
                
        annotation('Textbox','Position',[.6 .65 .8 .167],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none')

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