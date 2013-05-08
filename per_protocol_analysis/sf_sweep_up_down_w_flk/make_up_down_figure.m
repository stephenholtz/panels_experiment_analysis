%% Make figures
%==========================================================================

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_sweep_up_down_w_flk';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

save_figures = 1;

exp_comp_groups(1).name = 'controls'; %
exp_comp_groups(1).inds = [1 2];
exp_comp_groups(2).name = 'c2c3_vs_controls'; %
exp_comp_groups(2).inds = [1 2 3];
exp_comp_groups(3).name = 'c2_vs_controls'; %
exp_comp_groups(3).inds = [1 2 4 5];
exp_comp_groups(4).name = 'c3_vs_controls'; %
exp_comp_groups(4).inds = [1 2 6 7];
exp_comp_groups(5).name = 'l4_vs_controls'; %
exp_comp_groups(5).inds = [1 2 8];
exp_comp_groups(6).name = 'lawf1_vs_controls'; %
exp_comp_groups(6).inds = [1 2 9 10];

clear figure_iter

wing_output = 'lmr';
if strcmp(wing_output,'lpr')
    low_y = -5;
    high_y = 5;
    y_label = 'L+R';
    save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/sf_sweep_up_down_w_flk/lpr';
elseif strcmp(wing_output,'lmr')
    low_y = -2.25;
    high_y = 2.25;
    y_label = 'L-R';
    save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/sf_sweep_up_down_w_flk/lmr_normalized';
end

exp_grp_num = 1;
figure_color = [1 1 1];
figure_size = [50 50 410 675];
axis_color = [1 1 1];
xy_color = [0 0 0];
text_color = [0 0 0];
zero_line_color = text_color;
font_size_1 = 8;
font_size_2 = 10;
default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

%%
for exp_comp_group = exp_comp_groups

    %% Make large mean wba timeseries summary figure
    %==========================================================================
    if 1
        if ~exist('figure_iter','var'); figure_iter = 1; end

        % Set up subplots for timeseries, space-time diagrams, and intercept plots
        nHigh       = 5;    nWide       = 2;
        heightGap   = .05;  widthGap    = .055;
        heightOffset= .085;  widthOffset = .05;

        sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

        % All of the conditions over a few pdfs
        symm_str = 'flip';
        for cg = 1:numel(summ_data.cond_groups)
            if ~mod(cg-1,5)
                % Make a new figure, restart the row iterator
                row = 1;
                figure_handle(figure_iter) = figure('Name',[num2str(figure_iter) exp_comp_group.name ' - ' summ_data.cond_groups(cg).dir],'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                figure_names{figure_iter} = [exp_comp_group.name ' - ' summ_data.cond_groups(cg).description(1:end-6)];
                figure_iter = figure_iter + 1;
            end

            % Plot each of the members of this cond_groups subset
            stim_str = summ_data.cond_groups(cg).name;

            for col = 1:2%numel(summ_data.(stim_str).(symm_str).avg_lmr_ts)

                % Plot the timeseries
                clear graph
                side = 1;
                for exp_grp_num = exp_comp_group.inds
                    exp_ind = find(exp_grp_num == exp_comp_group.inds);
                    graph.line{exp_ind} = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output '_ts']){col};
                    graph.shade{exp_ind} = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output '_ts']){col};
                    graph.color{exp_ind} = default_colors(exp_ind,:);
                end

                subplot('Position',sp_positions{row,col})
                vec=0:1500;
                plot(vec,zeros(numel(vec),1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)

                hold on; box off;

                esh=makeErrorShadedTimeseries(graph);

                axis([0 1500 low_y high_y])
                set(gca,'XTick',[0 500 1000 1500],'XTickLabel',{'0','.5','1','1.5'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'),'Color',axis_color)

                if col == 1
                    % Y label
                    if ~mod(row,2)
                        ylabel({summ_data.(stim_str)(exp_grp_num).info.name, [y_label ' WBA']},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    else
                        ylabel({[y_label ' WBA'],summ_data.(stim_str)(exp_grp_num).info.name},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    end
                end
                if row == 1
                   % Title 
                   title(['TF: ' num2str(summ_data.(stim_str)(exp_grp_num).info.tfs(col))],'fontsize',font_size_1,'Color',text_color)
                elseif row == 6
                    % X Label
                   xlabel('Time','interpreter','none','fontsize',font_size_1,'Color',text_color)
                end

            end
            row = row + 1;

            % Add some metadata and legends
            meta_str = figure_names{figure_iter-1};
            annotation('Textbox','Position',[0.1000 0.88 0.8000 0.05],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none','Color',text_color)

            col_space = 0;
            for exp_grp_num = exp_comp_group.inds

                exp_ind = find(exp_grp_num == exp_comp_group.inds);
                metadata_position = exp_ind-1;
                metadata_string = {[summ_data.group_info(exp_grp_num).group_name ' ' summ_data.group_info(exp_grp_num).type ' N=' num2str(summ_data.group_info(exp_grp_num).N)]};

                % This only works for ~6 genotypes max
                if ~mod(metadata_position,2)
                    annotation('Textbox','Position',[.08+col_space .971 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2,'Color',text_color)
                    annotation('Rectangle','Position',[.06+col_space .98 .015 .01],'EdgeColor',default_colors(exp_ind,:),'facecolor',default_colors(exp_ind,:));
                else
                    annotation('Textbox','Position',[.08+col_space .939 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2,'Color',text_color)
                    annotation('Rectangle','Position',[.06+col_space .948 .015 .01],'EdgeColor',default_colors(exp_ind,:),'facecolor',default_colors(exp_ind,:));
                    col_space = col_space + .4;
                end
            end
        end
    end

    %% Make tuning curves of TF over one SF
    %==========================================================================
    if 1
        if ~exist('figure_iter','var'); figure_iter = 1; end

        % Set up subplots for timeseries, space-time diagrams, and intercept plots
        nHigh       = 8;    nWide       = 5;
        heightGap   = .05;  widthGap    = .055;
        heightOffset= .085;  widthOffset = .05;

        sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        figure_handle(figure_iter) = figure('Name',[num2str(figure_iter) exp_comp_group.name '- Temp Freq Tuning Curves'],'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_names{figure_iter} = [exp_comp_group.name ' - Temporal Frequency Tuning Curves'];

        % All of the conditions over a few pdfs
        symm_str = 'flip';
        row = 0;
        for cg = 1:numel(summ_data.cond_groups)

            col = mod(cg-1,5) + 1;

            if ~mod(cg-1,5)
                row = row + 1;
            end

            % Plot each of the members of this cond_groups subset
            stim_str = summ_data.cond_groups(cg).name;

            % Plot the timeseries
            clear graph
            side = 1;
            for exp_grp_num = exp_comp_group.inds
                exp_ind = find(exp_grp_num == exp_comp_group.inds);
                for tf = 1:2
                    graph.line{exp_ind}(tf,:) = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output]){tf};
                    graph.shade{exp_ind}(tf,:) = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output]){tf};
                    graph.color{exp_ind} = default_colors(exp_ind,:);
                end
            end

            if ~(row == 8)
                subplot('Position',sp_positions{row,col})
            elseif (row == 8) && (col == 1)
                subplot('Position',sp_positions{row,2})
            elseif (row == 8) && (col == 2)
                subplot('Position',sp_positions{row,5})
            end

            vec=0:3;
            plot(vec,zeros(numel(vec),1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)

            hold on; box off;
            esh=makeErrorbarTuningCurve(graph,1:2);

            axis([0 3 low_y high_y])
            set(gca,'XTick',[1 2],'XTickLabel',{'2','6'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'),'Color',axis_color)

            if col == 1
                % Y label
                if ~mod(row,2)
                    ylabel({summ_data.(stim_str)(exp_grp_num).info.name, [y_label ' WBA']},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                else
                    ylabel({[y_label ' WBA'],summ_data.(stim_str)(exp_grp_num).info.name},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                end
            end
            if row == 1
               % Title 
               title(['SF: ' num2str(summ_data.(stim_str)(exp_grp_num).info.lam(1))],'interpreter','none','fontsize',font_size_1,'Color',text_color)
            elseif row == 8
                % X Label
               xlabel('TF','interpreter','none','fontsize',font_size_1,'Color',text_color)
            end
        end

        % Add some metadata and legends
        meta_str = figure_names{figure_iter};
        annotation('Textbox','Position',[0.1000 0.88 0.8000 0.05],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none','Color',text_color)

        col_space = 0;
        for exp_grp_num = exp_comp_group.inds

            exp_ind = find(exp_grp_num == exp_comp_group.inds);
            metadata_position = exp_ind-1;
            metadata_string = {[summ_data.group_info(exp_grp_num).group_name ' ' summ_data.group_info(exp_grp_num).type ' N=' num2str(summ_data.group_info(exp_grp_num).N)]};

            % This only works for ~6 genotypes max
            if ~mod(metadata_position,2)
                annotation('Textbox','Position',[.08+col_space .971 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2,'Color',text_color)
                annotation('Rectangle','Position',[.06+col_space .98 .015 .01],'EdgeColor',default_colors(exp_ind,:),'facecolor',default_colors(exp_ind,:));
            else
                annotation('Textbox','Position',[.08+col_space .939 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2,'Color',text_color)
                annotation('Rectangle','Position',[.06+col_space .948 .015 .01],'EdgeColor',default_colors(exp_ind,:),'facecolor',default_colors(exp_ind,:));
                col_space = col_space + .4;
            end
        end
        figure_iter = figure_iter + 1;
    end
    %% Make tuning curves to show many SFs over one TF
    %==========================================================================
    if 1
        if ~exist('figure_iter','var'); figure_iter = 1; end

        % Set up subplots for timeseries, space-time diagrams, and intercept plots
        nHigh       = 8;    nWide       = 2;
        heightGap   = .05;  widthGap    = .055;
        heightOffset= .085;  widthOffset = .08;

        sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        figure_handle(figure_iter) = figure('Name',[num2str(figure_iter) exp_comp_group.name '- Spatial Tuning Curves'],'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_names{figure_iter} = [exp_comp_group.name '- Spatial Tuning Curves'];

        % All of the conditions over a few pdfs
        symm_str = 'flip';
        clear tf
        
        tf_struct.u_1  = {summ_data.cond_groups(1:5).name};
        tf_struct.u_2  = {summ_data.cond_groups(1:5).name};

        tf_struct.d_1  = {summ_data.cond_groups(6:10).name};
        tf_struct.d_2  = {summ_data.cond_groups(6:10).name};

        tf_struct.uf_1  = {summ_data.cond_groups(11:15).name};
        tf_struct.uf_2  = {summ_data.cond_groups(11:15).name};

        tf_struct.df_1  = {summ_data.cond_groups(16:20).name};
        tf_struct.df_2  = {summ_data.cond_groups(16:20).name};

        tf_struct.bu_1  = {summ_data.cond_groups(21:25).name};
        tf_struct.bu_2  = {summ_data.cond_groups(21:25).name};

        tf_struct.bd_1  = {summ_data.cond_groups(26:30).name};
        tf_struct.bd_2  = {summ_data.cond_groups(26:30).name};

        tf_struct.bo_1 = {summ_data.cond_groups(31:35).name};
        tf_struct.bo_2 = {summ_data.cond_groups(31:35).name};

        tf_struct.flk_1 = {summ_data.cond_groups(36:37).name};
        tf_struct.flk_2 = {summ_data.cond_groups(36:37).name};

        stim_types = {'u','uf','d','df','bu','bd','bo','flk'};
        tf_nums = 1:2;

        for col = tf_nums
            stim_iter = 1;

            for sm = stim_types
                stim = sm{1};

                stimulus_group = (tf_struct.([stim '_' num2str(col)]));

                clear graph
                for exp_grp_num = exp_comp_group.inds
                    exp_ind = find(exp_grp_num == exp_comp_group.inds);
                    for sf_iter = 1:numel(stimulus_group)
                        % Build the tuning curve    
                        graph.line{exp_ind}(sf_iter) = summ_data.(stimulus_group{sf_iter})(exp_grp_num).(symm_str).(['avg_' wing_output]){col};
                        graph.shade{exp_ind}(sf_iter) = summ_data.(stimulus_group{sf_iter})(exp_grp_num).(symm_str).(['sem_' wing_output]){col};
                        graph.color{exp_ind} = default_colors(exp_ind,:);
                    end
                end
                % plot the tuning curve
                subplot('Position',sp_positions{stim_iter,col})
                vec=0:7;
                plot(vec,zeros(numel(vec),1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)

                hold on; box off;

                if ~strcmp(stim,'flk')
                    esh=makeErrorbarTuningCurve(graph,1:numel(graph.line{1}));
                    axis([0 6 low_y high_y])
                    %[2,4,6,8,12,16]*2*3.75
                    set(gca,'XTick',1:5,'XTickLabel',{'15','30','45','60','90'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                else
                    esh=makeErrorbarTuningCurve(graph,[2 5]);
                    axis([0 6 low_y high_y])
                    set(gca,'XTick',[2 5],'XTickLabel',{'30','90'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                end

                if col == 1
                    % Y label
                    if ~mod(stim_iter,2)
                        ylabel({summ_data.(stimulus_group{1})(exp_grp_num).info.name, [y_label ' WBA']},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    else
                        ylabel({[y_label ' WBA'], summ_data.(stimulus_group{1})(exp_grp_num).info.name},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    end
                end
                if stim_iter == 1
                   % Title 
                   title(['TF: ' num2str(summ_data.(stimulus_group{1})(exp_grp_num).info.tfs(col))],'fontsize',font_size_1,'Color',text_color)
                elseif stim_iter == 8
                    % X Label
                   xlabel('Spatial Frequency','interpreter','none','fontsize',font_size_1,'Color',text_color)
                end

                stim_iter = stim_iter + 1;
            end
        end

        % Add some metadata and legends
        meta_str = figure_names{figure_iter};
        annotation('Textbox','Position',[0.1000 0.88 0.8000 0.05],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none','Color',text_color)

        col_space = 0;
        for exp_grp_num = exp_comp_group.inds

            exp_ind = find(exp_grp_num == exp_comp_group.inds);
            metadata_position = exp_ind-1;
            metadata_string = {[summ_data.group_info(exp_grp_num).group_name ' ' summ_data.group_info(exp_grp_num).type ' N=' num2str(summ_data.group_info(exp_grp_num).N)]};

            % This only works for ~6 genotypes max
            if ~mod(metadata_position,2)
                annotation('Textbox','Position',[.08+col_space .971 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2,'Color',text_color)
                annotation('Rectangle','Position',[.06+col_space .98 .015 .01],'EdgeColor',default_colors(exp_ind,:),'facecolor',default_colors(exp_ind,:));
            else
                annotation('Textbox','Position',[.08+col_space .939 .3 .025],'String',metadata_string,'Edgecolor','none','fontsize',font_size_2,'Color',text_color)
                annotation('Rectangle','Position',[.06+col_space .948 .015 .01],'EdgeColor',default_colors(exp_ind,:),'facecolor',default_colors(exp_ind,:));
                col_space = col_space + .4;
            end
        end

        figure_iter = figure_iter + 1;
    end
    if strcmp(exp_comp_group.name, exp_comp_groups(1).name);
        figures_per_line = figure_iter - 1;
    end
end

%% export the figure as a pdf
%==========================================================================
if save_figures
    if ~isdir(save_figure_location)
        mkdir(save_figure_location)
    end

    for figure_iter = 1:numel(figure_handle-1)
        %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
        export_fig(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]),'-pdf','-nocrop');
    end

    % also do a single pdf version
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