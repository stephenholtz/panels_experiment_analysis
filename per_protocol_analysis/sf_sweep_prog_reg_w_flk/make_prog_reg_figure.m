%% Make figures
%==========================================================================

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% Load in the data if needed
experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/sf_sweep_prog_reg_w_flk';
if ~exist('summ_data','var')
    load(fullfile(experiment_group_folder_loc,'summ_data'));
end

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/sf_sweep_prog_reg_w_flk/all_normalized';

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
% exp_comp_groups(6).name = 'lawf1_vs_controls'; %
% exp_comp_groups(6).inds = [1 2 9 10];

clear figure_iter

wing_output = 'lmr';
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
        nHigh       = 6;    nWide       = 3;
        heightGap   = .05;  widthGap    = .055;
        heightOffset= .085;  widthOffset = .05;

        sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

        % All of the conditions over a few pdfs
        symm_str = 'flip';
        for cg = 1:numel(summ_data.cond_groups)
            if ~mod(cg-1,6)
                % Make a new figure, restart the row iterator
                row = 1;
                figure_handle(figure_iter) = figure('Name',[num2str(figure_iter) exp_comp_group.name ' - ' summ_data.cond_groups(cg).dir],'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
                figure_names{figure_iter} = [exp_comp_group.name ' - ' summ_data.cond_groups(cg).description(1:end-6)];
                figure_iter = figure_iter + 1;
            end

            % Plot each of the members of this cond_groups subset
            stim_str = summ_data.cond_groups(cg).name;

            for col = 1:3%numel(summ_data.(stim_str))

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

                axis([0 1500 -3.25 3.25])
                set(gca,'XTick',[0 500 1000 1500],'XTickLabel',{'0','.5','1','1.5'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'),'Color',axis_color)

                if col == 1
                    % Y label
                    if ~mod(row,2)
                        ylabel({summ_data.(stim_str)(exp_grp_num).info.name, 'L-R WBA'},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    else
                        ylabel({'L-R WBA',summ_data.(stim_str)(exp_grp_num).info.name},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    end
                end
                if row == 1
                   % Title 
                   title(['TF: ' num2str(summ_data.(stim_str)(exp_grp_num).info.tfs(col))],'fontsize',font_size_1,'Color',text_color)
                elseif row == 6
                    % X Label
                   xlabel('Time','interpreter','none','fontsize',font_size_1)
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
        nHigh       = 6;    nWide       = 6;
        heightGap   = .05;  widthGap    = .055;
        heightOffset= .085;  widthOffset = .05;

        sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        figure_handle(figure_iter) = figure('Name',[num2str(figure_iter) exp_comp_group.name '- Temp Freq Tuning Curves'],'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_names{figure_iter} = [exp_comp_group.name ' - Temporal Frequency Tuning Curves'];

        % All of the conditions over a few pdfs
        symm_str = 'flip';
        row = 0;
        for cg = 1:numel(summ_data.cond_groups)

            col = mod(cg-1,6) + 1;

            if ~mod(cg-1,6)
                row = row + 1;
            end

            % Plot each of the members of this cond_groups subset
            stim_str = summ_data.cond_groups(cg).name;

            % Plot the timeseries
            clear graph
            side = 1;
            for exp_grp_num = exp_comp_group.inds
                exp_ind = find(exp_grp_num == exp_comp_group.inds);
                for tf = 1:3
                    graph.line{exp_ind}(tf,:) = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output]){tf};
                    graph.shade{exp_ind}(tf,:) = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output]){tf};
                    graph.color{exp_ind} = default_colors(exp_ind,:);
                end
                graph.x_offset(exp_ind) = .1*(iter-2);
            end
            
            if ~(row == 6)
                subplot('Position',sp_positions{row,col})
            elseif (row == 6) && (col == 1)
                subplot('Position',sp_positions{row,2})
            elseif (row == 6) && (col == 2)
                subplot('Position',sp_positions{row,6})
            end
            vec=0:4;
            plot(vec,zeros(numel(vec),1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)

            hold on; box off;
            esh=makeErrorbarTuningCurve(graph,1:3);

            axis([0 4 -3.25 3.25])
            set(gca,'XTick',[1 2 3],'XTickLabel',{'2','6','18'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'),'Color',axis_color)

            if col == 1
                % Y label
                if ~mod(row,2)
                    ylabel({summ_data.(stim_str)(exp_grp_num).info.name, 'L-R WBA'},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                else
                    ylabel({'L-R WBA',summ_data.(stim_str)(exp_grp_num).info.name},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                end
            end
            if row == 1
               % Title 
               title(['SF: ' num2str(summ_data.(stim_str)(exp_grp_num).info.lam(1))],'interpreter','none','fontsize',font_size_1,'Color',text_color)
            elseif row == 6
                % X Label
               xlabel('TF','interpreter','none','fontsize',font_size_1)
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
        nHigh       = 6;    nWide       = 3;
        heightGap   = .05;  widthGap    = .055;
        heightOffset= .085;  widthOffset = .05;

        sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        figure_handle(figure_iter) = figure('Name',[num2str(figure_iter) exp_comp_group.name '- Spatial Tuning Curves'],'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_names{figure_iter} = [exp_comp_group.name '- Spatial Tuning Curves'];

        % All of the conditions over a few pdfs
        symm_str = 'flip';
        clear tf
        
        tf_struct.p_1  = {summ_data.cond_groups(1:6).name};
        tf_struct.p_2  = {summ_data.cond_groups(1:6).name};
        tf_struct.p_3 =  {summ_data.cond_groups(1:6).name};

        tf_struct.r_1  = {summ_data.cond_groups(7:12).name};
        tf_struct.r_2  = {summ_data.cond_groups(7:12).name};
        tf_struct.r_3  = {summ_data.cond_groups(7:12).name};

        tf_struct.pf_1  = {summ_data.cond_groups(13:18).name};
        tf_struct.pf_2  = {summ_data.cond_groups(13:18).name};
        tf_struct.pf_3  = {summ_data.cond_groups(13:18).name};

        tf_struct.rf_1  = {summ_data.cond_groups(19:24).name};
        tf_struct.rf_2  = {summ_data.cond_groups(19:24).name};
        tf_struct.rf_3  = {summ_data.cond_groups(19:24).name};

        tf_struct.bs_1  = {summ_data.cond_groups(25:30).name};
        tf_struct.bs_2  = {summ_data.cond_groups(25:30).name};
        tf_struct.bs_3  = {summ_data.cond_groups(25:30).name};

        tf_struct.flk_1 = {summ_data.cond_groups(31:32).name};
        tf_struct.flk_2 = {summ_data.cond_groups(31:32).name};
        tf_struct.flk_3 = {summ_data.cond_groups(31:32).name};

        stim_types = {'p','pf','rf','r','bs','flk'};
        tf_nums = 1:3;

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
                    graph.x_offset(exp_ind) = .1*(iter-2);
                end
                % plot the tuning curve
                subplot('Position',sp_positions{stim_iter,col})
                vec=0:7;
                plot(vec,zeros(numel(vec),1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)

                hold on; box off;

                if ~strcmp(stim,'flk')
                    esh=makeErrorbarTuningCurve(graph,1:numel(graph.line{1}));
                    axis([0 7 -3.25 3.25])
                    %[2,4,6,8,12,16]*2*3.75
                    set(gca,'XTick',1:6,'XTickLabel',{'15','30','45','60','90','120'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                else
                    esh=makeErrorbarTuningCurve(graph,[2 6]);
                    axis([0 7 -3.25 3.25])
                    set(gca,'XTick',[2 6],'XTickLabel',{'30','120'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
                end

                if col == 1
                    % Y label
                    if ~mod(stim_iter,2)
                        ylabel({summ_data.(stimulus_group{1})(exp_grp_num).info.name, 'L-R WBA'},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    else
                        ylabel({'L-R WBA', summ_data.(stimulus_group{1})(exp_grp_num).info.name},'interpreter','none','fontsize',font_size_1,'Color',text_color)
                    end
                end
                if stim_iter == 1
                   % Title 
                   title(['TF: ' num2str(summ_data.(stimulus_group{1})(exp_grp_num).info.tfs(col))],'fontsize',font_size_1)
                elseif stim_iter == 6
                    % X Label
                   xlabel('Spatial Frequency','interpreter','none','fontsize',font_size_1)
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