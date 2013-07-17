%% Make the simplest possible figures
%==========================================================================

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

experiment_set = 5;
switch experiment_set
    case 1 % New L1 stuff
        exp_comp_groups(1).name = 'control'; %
        exp_comp_groups(1).inds = 1;
        exp_comp_groups(2).name = 'old_L1_vs_controls'; %
        exp_comp_groups(2).inds = [1 3];
        exp_comp_groups(3).name = 'new_good_L1_vs_controls'; %
        exp_comp_groups(3).inds = [1 2];
        exp_comp_groups(4).name = 'new_ok_L1_vs_controls'; %
        exp_comp_groups(4).inds = [1 4];
        exp_comp_groups(5).name = 'new_poor_L1_vs_controls'; %
        exp_comp_groups(5).inds = [1 6];
        exp_comp_groups(6).name = 'new_old_L1_vs_controls'; %
        exp_comp_groups(6).inds = [1 2 3];
        exp_comp_groups(6).name = 'good_L1_vs_controls'; %
        exp_comp_groups(6).inds = [1 2 3 4];

        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/L1_telethon_flies/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/L1_telethon_flies';
    
    case 2 % New medulla stuff
        exp_comp_groups(1).name = 'Tm3_vs_controls'; %
        exp_comp_groups(1).inds = [1 2 3];
        exp_comp_groups(2).name = 'Tm4_vs_controls'; %
        exp_comp_groups(2).inds = [1 4];
        exp_comp_groups(3).name = 'T4_T5_vs_controls'; %
        exp_comp_groups(3).inds = [1 5];
 
        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/medulla_jct_telethon/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/medulla_jct_telethon_1';
        
    case 3 % New medulla stuff pt2
        exp_comp_groups(1).name = 't5_vs_controls'; %
        exp_comp_groups(1).inds = [1 2];
        exp_comp_groups(2).name = 't2_vs_controls'; %
        exp_comp_groups(2).inds = [1 3 4];
        exp_comp_groups(3).name = 't3_vs_controls'; %
        exp_comp_groups(3).inds = [1 5];

        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/medulla_jct_telethon/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/medulla_jct_telethon_2';
        
    case 4 % New medulla stuff pt3
        exp_comp_groups(1).name = '314_vs_controls'; %
        exp_comp_groups(1).inds = [1 2];
        exp_comp_groups(2).name = '317_vs_controls'; %
        exp_comp_groups(2).inds = [1 3];
        exp_comp_groups(3).name = '328_vs_controls'; %
        exp_comp_groups(3).inds = [1 4];
        
        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/medulla_jct_telethon/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/medulla_jct_telethon_3';
        
    case 5 % New medulla stuff pt4
        exp_comp_groups(1).name = '325_vs_controls'; %
        exp_comp_groups(1).inds = [1 2];
        exp_comp_groups(2).name = '340_vs_controls'; %
        exp_comp_groups(2).inds = [1 3];
        exp_comp_groups(3).name = '366_vs_controls'; %
        exp_comp_groups(3).inds = [1 4];
        exp_comp_groups(4).name = '385_vs_controls'; %
        exp_comp_groups(4).inds = [1 5];
        
        % Load in the data if needed
        experiment_group_folder_loc = '/Volumes/janelia_backup/slh_fs_reiserlab_share/tethered_flight_part_4/medulla_jct_telethon/';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/medulla_jct_telethon_4';
        
    case 6 % L4 stuff
        exp_comp_groups(1).name = 'l4_vs_controls'; %
        exp_comp_groups(1).inds = [1 2 3]; %

        % Load in the data if needed
        experiment_group_folder_loc = '/Volumes/janelia_backup/slh_fs_reiserlab_share/tethered_flight_part_4/l4_jct_telethon';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/l4_jct_telethon';
        
end

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand_plot = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

save_figures = 1;
make_fig_1 = 1;
make_fig_2 = 1;
clear figure_iter

%%
for exp_comp_group = exp_comp_groups
%% Put all conditions on new rows of timeseries, followed by a tuning curve (2 pages)
%==========================================================================

if make_fig_1
%=FIRST SET OF PLOTS===================================================
    
    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    nHigh       = 10;       nWide       = 5;
    heightGap   = .05;      widthGap    = .055;
    heightOffset= .05;      widthOffset = .15;
    sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

    if ~exist('figure_iter','var'); figure_iter = 1; end
    wing_output = 'lmr';
    figure_names{figure_iter} = 'Telethon Summary Part 1';
    figure_color = [1 1 1];
    figure_size = [25 25 650 880];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 8;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];
    
    figure_handle(figure_iter) = figure('Name',figure_names{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
    
    symm_str = 'flip';
    % Plot the first set of stimuli 
    for stim_type = 1:10
        switch stim_type
            case 1
                stim_str = 'ff_rot';
                stim_inds = 1:4;
                xticks = 1:4;
                xticklabels = {'.5','3','9','18'};
                extra_str_description = ' \lambda 30';
            case 2
                stim_str = 'ff_rot';
                stim_inds = 5:8;
                xticks = 1:4;
                xticklabels = {'.5','3','9','18'};
                extra_str_description = ' \lambda 60';
            case 3
                 stim_str = 'ff_rot';
                stim_inds = 9:12;
                xticks = 1:4;
                xticklabels = {'.5','3','9','18'};
                extra_str_description = ' \lambda 90';
            case 4
                stim_str = 'ff_exp';
                stim_inds = 1:2;
                xticks = 1:2;
                xticklabels = {'1','9'};
                extra_str_description = ' \lambda 30';
            case 5
                stim_str = 'lat_flick';
                stim_inds = 1;
                xticks = 1;
                xticklabels = {'40'};
                extra_str_description = '';
            case 6
                stim_str = 'prog_mot';
                stim_inds = 1:3;
                xticks = 1:3;
                xticklabels = {'1','3','9'};
                extra_str_description = ' \lambda 30';
            case 7
                stim_str = 'reg_mot';
                stim_inds = 1:3;
                xticks = 1:3;
                xticklabels = {'1','3','9'};
                extra_str_description = ' \lambda 30';
            case 8
                stim_str = 'lc_rot';
                stim_inds = 1:4;
                xticks = 1:4;
                xticklabels = {'.23', '.07', '.06', '.24'};
                extra_str_description = ' \lambda 22.5';
            case 9
                stim_str = 'rp_rot';
                stim_inds = 1:3;
                xticks = 1:3;
                xticklabels = {'1','3','9'};
                extra_str_description = ' \lambda 30';
            case 10
                stim_str = 'rp_rot';
                stim_inds = 4:6;
                xticks = 1:3;
                xticklabels = {'1','3','9'};
                extra_str_description = ' \lambda 90';
        end

        for stim_ind = stim_inds
            % Plot the timeseries
            clear graph
            exp_grp_iter = 1;
            for exp_grp_ind = exp_comp_group.inds
                graph.line{exp_grp_iter} = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output '_ts']){stim_ind};
                graph.shade{exp_grp_iter} = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['sem_' wing_output '_ts']){stim_ind};
                graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
                exp_grp_iter = 1 + exp_grp_iter;
            end

            subplot('Position',sp_positions{stim_type,1+stim_ind-stim_inds(1)})
            vec = 0:2500;
            plot(vec,zeros(numel(vec),1),'Linestyle','--','color',zero_line_color,'LineWidth',1);
            hold on; box off; 

            esh=makeErrorShadedTimeseries(graph);

            axis([0 2500 -4 4]);
            set(gca,'XTick',[0 2500],'XTickLabel',{'0','2.5 (s)'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            set(gca,'YTick',[-4 0 4],'fontsize',font_size_1)
            if stim_type == 8
                title(['MC: ' num2str(summ_data.(stim_str)(exp_grp_ind).info.contrast_vals(stim_ind))],'fontsize',font_size_1)
            else
                title(['TF: ' num2str(summ_data.(stim_str)(exp_grp_ind).info.tfs(stim_ind)) 'Hz'],'fontsize',font_size_1)
            end
            
            if 1+stim_ind-stim_inds(1) == 1
               ylabel('\DeltaWBA','fontsize',font_size_1)
            end
            
        end

        % Plot the tuning curve
        clear graph
        for stim_ind = stim_inds
            exp_grp_iter = 1;
            for exp_grp_ind = exp_comp_group.inds
                graph.line{exp_grp_iter}(1+stim_ind-stim_inds(1)) = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output]){stim_ind};
                graph.shade{exp_grp_iter}(1+stim_ind-stim_inds(1)) = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['sem_' wing_output]){stim_ind};
                graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
                exp_grp_iter = exp_grp_iter + 1;                
            end
        end

        subplot('Position',sp_positions{stim_type,numel(stim_inds)+1})
        vec = 0:10;
        plot(vec,zeros(numel(vec),1),'Linestyle','--','color',zero_line_color,'LineWidth',1);
        hold on; box off; 

        esh=makeErrorbarTuningCurve(graph,1+stim_inds-stim_inds(1));
        
        axis([0 numel(stim_inds)+1 -4 4]);
        ylabel('Mean \DeltaWBA','fontsize',font_size_1)
        set(gca,'YTick',[-4 0 4],'fontsize',font_size_1)
        set(gca,'XTick',xticks,'XTickLabel',xticklabels,'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
        
        descriptions{stim_type} = [summ_data.(stim_str)(exp_grp_ind).info.description extra_str_description];
    end
    
    % Add some stimulus descriptions
    for stim_type = 1:10
        annotation('Textbox','Position',nudge(sp_positions{stim_type,1},-.175,0),'String',descriptions{stim_type},'Edgecolor','none','fontsize',font_size_2)
    end
    clear descriptions
    
    % Add some metadata and legends
    col_space = 0;
    exp_grp_iter = 1;
    for exp_grp_ind = exp_comp_group.inds
        metadata_position = 1 + exp_grp_iter - exp_comp_group.inds(1);

        metadata_string = {[summ_data.group_info(exp_grp_ind).group_name ' N=' num2str(summ_data.group_info(exp_grp_ind).N)]};

        % This only works for ~6 genotypes max
        if mod(metadata_position,2)
            annotation('Textbox','Position',[.08+col_space .965 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2)
            annotation('Rectangle','Position',[.06+col_space .975 .015 .01],'EdgeColor',default_colors(exp_grp_iter,:),'facecolor',default_colors(exp_grp_iter,:));
        else
            annotation('Textbox','Position',[.08+col_space .93 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2)
            annotation('Rectangle','Position',[.06+col_space .94 .015 .01],'EdgeColor',default_colors(exp_grp_iter,:),'facecolor',default_colors(exp_grp_iter,:));
            col_space = col_space + .4;
        end
        exp_grp_iter = exp_grp_iter + 1;
    end
    
    figure_iter = figure_iter +1;
end

if make_fig_2
    %=SECOND SET OF PLOTS==================================================
    % not quite as orderly, these are a bit different from each other
    
    % Set up subplots
    nHigh       = 10;       nWide       = 4;
    heightGap   = .05;      widthGap    = .055;
    heightOffset= .05;      widthOffset = .15;
    sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
    
    if ~exist('figure_iter','var'); figure_iter = 1; end
    wing_output = 'lmr';
    figure_names{figure_iter} = 'Telethon Summary Part 2';
    figure_color = [1 1 1];
    figure_size = [25 25 650 880];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 8;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

    figure_handle(figure_iter) = figure('Name',figure_names{figure_iter},'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
    row = 0;
    
    %-ON/OFF + Stripe Oscillation------------------------------------------
    symm_str = 'flip';
    for stim_type = 1:5
        switch stim_type
            case 1
                row = row + 1;
                stim_str = 'on_off_sawtooth';
                stim_inds = 1:2;
                xticks = 1:2;
                xticklabels = {'on','off'};
                extra_str_description = '';
            case 2
                row = row + 1;
                stim_str = 'on_off_expansion';
                stim_inds = 1:2;
                xticks = 1:2;
                xticklabels = {'on','off'};
                extra_str_description = '';
            case 3
                row = row + 1;
                stim_str = 'stripe_osc';
                stim_inds = 1:3;
                xticks = 1:3;
                xticklabels = {'30','90','270'};
                extra_str_description = ' Dark on Bright';
            case 4
                row = row + 1;
                stim_str = 'stripe_osc';
                stim_inds = 4:6;
                xticks = 1:3;
                xticklabels = {'30','90','270'};
                extra_str_description = ' Bright on Dark';
            case 5
                row = row + 1;
                stim_str = 'stripe_osc';
                stim_inds = 7:9;
                xticks = 1:3;
                xticklabels = {'30','90','270'};
                extra_str_description = ' Grating';
        end
        
        for stim_ind = stim_inds
            % Plot the timeseries
            clear graph
            exp_grp_iter = 1;
            for exp_grp_ind = exp_comp_group.inds
                graph.line{exp_grp_iter} = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output '_ts']){stim_ind};
                graph.shade{exp_grp_iter} = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['sem_' wing_output '_ts']){stim_ind};
                graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
                exp_grp_iter = exp_grp_iter + 1;
            end

            subplot('Position',sp_positions{stim_type,1+stim_ind-stim_inds(1)})
            vec = 0:2500;
            plot(vec,zeros(numel(vec),1),'Linestyle','--','color',zero_line_color,'LineWidth',1);
            hold on; box off; 

            esh=makeErrorShadedTimeseries(graph);
            
            axis([0 2500 -2 2]);
            set(gca,'XTick',[0 2500],'XTickLabel',{'0','2.5 (s)'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            set(gca,'YTick',[-2 0 2],'fontsize',font_size_1)
            if stim_type >=3
                title([num2str(summ_data.(stim_str)(exp_grp_ind).info.dps(stim_ind)) ' dps'],'fontsize',font_size_1)
            else
                title(xticklabels(stim_ind))
            end
            if 1+stim_ind-stim_inds(1) == 1
               ylabel('\DeltaWBA','fontsize',font_size_1)
            end
        end

        % Plot the tuning curve
        clear graph
        for stim_ind = stim_inds
            exp_grp_iter = 1;
            for exp_grp_ind = exp_comp_group.inds
                if stim_type >=3 
                    graph.line{exp_grp_iter}(1+stim_ind-stim_inds(1)) = summ_data.(stim_str)(exp_grp_ind).(symm_str).avg_lmr_corr_x_pos{stim_ind};
                    graph.shade{exp_grp_iter}(1+stim_ind-stim_inds(1)) = summ_data.(stim_str)(exp_grp_ind).(symm_str).avg_lmr_corr_x_pos{stim_ind};
                else
                    graph.line{exp_grp_iter}(1+stim_ind-stim_inds(1)) = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output]){stim_ind};
                    graph.shade{exp_grp_iter}(1+stim_ind-stim_inds(1)) = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['sem_' wing_output]){stim_ind};
                end
                graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
                exp_grp_iter = exp_grp_iter + 1;
            end
        end

        subplot('Position',sp_positions{stim_type,numel(stim_inds)+1})
        vec = 0:10;
        plot(vec,zeros(numel(vec),1),'Linestyle','--','color',zero_line_color,'LineWidth',1);
        hold on; box off; 

        esh=makeErrorbarTuningCurve(graph,1+stim_inds-stim_inds(1));
        
        if stim_type >= 3
            axis([0 numel(stim_inds)+1 0 .5]);
            set(gca,'YTick',[0 .5],'fontsize',font_size_1)
            ylabel('Correlation','fontsize',font_size_1)
        else
            axis([0 numel(stim_inds)+1 -2 2]);
            set(gca,'YTick',[-3 0 3],'fontsize',font_size_1)
            ylabel('Mean \DeltaWBA','fontsize',font_size_1)
        end
        set(gca,'XTick',xticks,'XTickLabel',xticklabels,'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
        
        descriptions{row} = [summ_data.(stim_str)(exp_grp_ind).info.description extra_str_description];
    end
    
    %-Optic flow-----------------------------------------------------------
    stim_str = 'flow_oscillation';
    
    col = 0;
    row = row + 1;
    
    for stim_ind = 1:6
        stim_name = summ_data.(stim_str)(exp_grp_ind).info.type{stim_ind};
        switch lower(stim_name)
            case {'lift','pitch'}
                wing_output = 'lpr';
                y_label = '\SigmaWBA';
            otherwise
                wing_output = 'lmr';
                y_label = '\DeltaWBA';
        end
        
        col = col + 1;
        if col > 4
            col = 1;
            row = row + 1;
        end
        
        clear graph
        exp_grp_iter = 1;
        for exp_grp_ind = exp_comp_group.inds
            graph.line{exp_grp_iter} = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output '_ts']){stim_ind};
            graph.shade{exp_grp_iter} = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['sem_' wing_output '_ts']){stim_ind};
            graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
            exp_grp_iter = exp_grp_iter + 1;
        end

        subplot('Position',sp_positions{row,col})
        vec = 0:2500;
        plot(vec,zeros(numel(vec),1),'Linestyle','--','color',zero_line_color,'LineWidth',1);
        hold on; box off; 

        esh=makeErrorShadedTimeseries(graph);

        axis([0 2500 -2 2]);
        set(gca,'XTick',[0 2500],'XTickLabel',{'0','2.5 (s)'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
        set(gca,'YTick',[-2 0 2],'fontsize',font_size_1)
        ylabel(y_label,'fontsize',font_size_1)
        title(stim_name,'fontsize',font_size_1)

        col = col + 1;
        clear graph
        exp_grp_iter = 1;
        for exp_grp_ind = exp_comp_group.inds
            graph.line{exp_grp_iter}(1) = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output '_corr_x_pos']){stim_ind};
            graph.shade{exp_grp_iter}(1) = summ_data.(stim_str)(exp_grp_ind).(symm_str).(['avg_' wing_output '_corr_x_pos']){stim_ind};
            graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
            exp_grp_iter = exp_grp_iter + 1;
        end

        subplot('Position',sp_positions{row,col})
        vec = 0:10;
        plot(vec,zeros(numel(vec),1),'Linestyle','--','color',zero_line_color,'LineWidth',1);
        hold on; box off; 

        esh=makeErrorbarTuningCurve(graph,1);

        axis([0 2 0 .5]);
        set(gca,'YTick',[0 .5],'fontsize',font_size_1)
        ylabel('Correlation','fontsize',font_size_1)
        title(summ_data.(stim_str)(exp_grp_ind).info.type{stim_ind},'fontsize',font_size_1)
    
        descriptions{row} = summ_data.(stim_str)(exp_grp_ind).info.description;
    end
    
    %-Velocity Nulling-----------------------------------------------------
        
        row = row + 1;
        stim_str = 'vel_null';
        descriptions{row} = summ_data.(stim_str)(exp_grp_ind).info.description;
        
        % Set up subplots
        nHigh       = 6;       nWide       = 7;
        heightGap   = .05;      widthGap    = .055;
        heightOffset= .05;      widthOffset = .05;
        vel_null_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

        stim_inds = 1:3;
        vel_null_row = 6;
        test_temp_freq_values = [.2 1.3 5.3 10.7 16];

        for vel_set = 1:5

            % plot the intercept calculations
            clear graph
            exp_grp_iter = 1;
            for exp_grp_ind = exp_comp_group.inds
                iter = 1; 
                for stim_ind = stim_inds
                    graph.line{exp_grp_iter}(iter) = summ_data.vel_null(exp_grp_ind).flip.avg_lmr{stim_ind};
                    graph.shade{exp_grp_iter}(iter) = summ_data.vel_null(exp_grp_ind).flip.sem_lmr{stim_ind};    
                    graph.color{exp_grp_iter} = default_colors(exp_grp_iter,:);
                    iter = iter + 1;
                end
                exp_grp_iter = exp_grp_iter + 1;
            end

            subplot('Position',nudge(vel_null_positions{vel_null_row,vel_set},0,.02))
            plot(-10:10,zeros(21,1),'Color',zero_line_color,'LineWidth',1)
            hold on; box off;
            
            ebh=makeErrorbarTuningCurve(graph,1:3);
            
            plot(summ_data.vel_null(exp_grp_ind).proc_data.fit_line(vel_set,:),'linestyle','-','Color',[1 0 0],'Linewidth',1);
            title(['Test Freq = ' num2str(summ_data.vel_null(exp_grp_ind).info.tfs(stim_inds(1)))],'fontsize',font_size_1)
            if vel_set == 1; ylabel({'Mean',' \DeltaWBA (V)'},'fontsize',font_size_1); end
            xlabel({'Test Contrast'},'fontsize',font_size_1)
            set(gca,'XTick',[1 2 3],'XTickLabel',{'.09','.27','.45'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            axis([0 4 -3 3])
            
            stim_inds = stim_inds + 3;
            
        end

        % plot the log plot
        subplot('Position',nudge(expand_plot(vel_null_positions{vel_null_row,6},2,1),.03,.02))
        
        exp_grp_iter = 1;
        for exp_grp_ind = exp_comp_group.inds
            hold all
            lp(exp_grp_iter)=semilogx(test_temp_freq_values,summ_data.vel_null(exp_grp_ind).proc_data.null_contrast','Color',default_colors(exp_grp_iter,:));
            exp_grp_iter = exp_grp_iter + 1;
        end
        
        box off;
        title('Velocity Nulling','fontsize',font_size_1)
        ylabel({'Contrast Sensitivity','1/(null contrast)'},'fontsize',font_size_1)
        xlabel({'Test Temporal Frequency (Hz)'},'fontsize',font_size_1)
        set(gca,'fontsize',font_size_1)
        axis([0.12 20 0 5.25])

    % Add some stimulus descriptions
    for stim_type = 1:numel(descriptions)
        if stim_type == 9
            nudge_amt_y = .03;
        else
            nudge_amt_y = 0;
        end
        
        annotation('Textbox','Position',nudge(sp_positions{stim_type,1},-.175,nudge_amt_y),'String',descriptions{stim_type},'Edgecolor','none','fontsize',font_size_2)
    end
    clear descriptions
    
    % Add some metadata and legends
    col_space = 0;
    exp_grp_iter = 1;
    for exp_grp_ind = exp_comp_group.inds
        metadata_position = 1 + exp_grp_iter - exp_comp_group.inds(1);

        metadata_string = {[summ_data.group_info(exp_grp_ind).group_name ' N=' num2str(summ_data.group_info(exp_grp_ind).N)]};

        % This only works for ~6 genotypes max
        if mod(metadata_position,2)
            annotation('Textbox','Position',[.08+col_space .965 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2)
            annotation('Rectangle','Position',[.06+col_space .975 .015 .01],'EdgeColor',default_colors(exp_grp_iter,:),'facecolor',default_colors(exp_grp_iter,:));
        else
            annotation('Textbox','Position',[.08+col_space .93 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2)
            annotation('Rectangle','Position',[.06+col_space .94 .015 .01],'EdgeColor',default_colors(exp_grp_iter,:),'facecolor',default_colors(exp_grp_iter,:));
            col_space = col_space + .4;
        end
        exp_grp_iter = exp_grp_iter + 1;
    end

    figure_iter = figure_iter +1;
end

    %% export the figure as a pdf
    %==========================================================================
    if save_figures
        if ~exist(save_figure_location,'dir')
            mkdir(save_figure_location)
        end

        for f = 1:numel(figure_handle)
            %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
            export_fig(figure_handle(f),fullfile(save_figure_location,['telethon_sum_' exp_comp_group.name]),'-pdf','-nocrop','-append');
        end
    end
clear figure_*
end

