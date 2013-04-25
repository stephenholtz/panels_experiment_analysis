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

save_figure_location = '/Users/stephenholtz/local_experiment_copies/figures/sf_sweep_prog_reg_w_flk';

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

save_figures = 1;

%% Make large mean wba timeseries summary figure
%==========================================================================
if 0
    if ~exist('figure_iter','var'); figure_iter = 1; end
    wing_output = 'lmr';
    exp_grp_num = 1;
    figure_color = [1 1 1];
    figure_size = [50 50 400 650];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 10;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    nHigh       = 6;    nWide       = 3;
    heightGap   = .05;  widthGap    = .055;
    heightOffset= .05;  widthOffset = .05;

    sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);

    % All of the conditions over a few pdfs
    symm_str = 'flip';
    for cg = 1:numel(summ_data.cond_groups)
        if ~mod(cg-1,6)
            % Make a new figure, restart the row iterator
            row = 1;
            figure_handle(figure_iter) = figure('Name',summ_data.cond_groups(cg).dir,'NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
            figure_names{figure_iter} = summ_data.cond_groups(cg).description(1:end-6);
            figure_iter = figure_iter + 1;
        end

        % Plot each of the members of this cond_groups subset
        stim_str = summ_data.cond_groups(cg).name;

        for col = 1:numel(summ_data.(stim_str).(symm_str).avg_lmr_ts)

            % Plot the timeseries
            clear graph
            side = 1;
            graph.line{side} = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output '_ts']){col};
            graph.shade{side} = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output '_ts']){col};
            graph.color{side} = default_colors(side,:);

            subplot('Position',sp_positions{row,col})
            vec=0:1500;
            plot(vec,zeros(numel(vec),1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)

            hold on; box off;

            esh=makeErrorShadedTimeseries(graph);

            axis([0 1500 -1 4])
            set(gca,'XTick',[0 500 1000 1500],'XTickLabel',{'0','.5','1','1.5'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))

            if col == 1
                % Y label
                ylabel({summ_data.(stim_str).info.name, 'L-R WBA'},'interpreter','none','fontsize',font_size_1)
            end
            if row == 1
               % Title 
               title(['TF: ' num2str(summ_data.(stim_str).info.tfs(col))],'fontsize',font_size_1)
            elseif row == 6
                % X Label
               xlabel('Time','interpreter','none','fontsize',font_size_1)
            end

        end
        row = row + 1;

        % Add some metadata
        meta_str = {summ_data.group_info(exp_grp_num).group_name, [ 'N = ' num2str(summ_data.group_info(exp_grp_num).N)]};
        annotation('Textbox','Position',[.1 .785 .6 .2],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none')

    end
end

%% Make tuning curves of TF over one SF
%==========================================================================
if 1
    if ~exist('figure_iter','var'); figure_iter = 1; end
    wing_output = 'lmr';
    exp_grp_num = 1;
    figure_color = [1 1 1];
    figure_size = [50 50 500 650];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 10;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    nHigh       = 6;    nWide       = 6;
    heightGap   = .05;  widthGap    = .055;
    heightOffset= .05;  widthOffset = .05;

    sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
    figure_handle(figure_iter) = figure('Name','Temp Freq Tuning Curves','NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
    figure_names{figure_iter} = 'Temporal Frequency Tuning Curves';
    
    % All of the conditions over a few pdfs
    symm_str = 'flip';
    
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
        for tf = 1:3
            graph.line{side}(tf,:) = summ_data.(stim_str)(exp_grp_num).(symm_str).(['avg_' wing_output]){tf};
            graph.shade{side}(tf,:) = summ_data.(stim_str)(exp_grp_num).(symm_str).(['sem_' wing_output]){tf};
            graph.color{side} = default_colors(side,:);
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

        axis([0 4 -1 4])
        set(gca,'XTick',[1 2 3],'XTickLabel',{'2','6','18'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))

        if col == 1
            % Y label
            ylabel({summ_data.(stim_str).info.name, 'L-R WBA'},'interpreter','none','fontsize',font_size_1)
        end
        if row == 1
           % Title 
           title(['SF: ' num2str(summ_data.(stim_str).info.lam(1))],'interpreter','none','fontsize',font_size_1)
        elseif row == 6
            % X Label
           xlabel('TF','interpreter','none','fontsize',font_size_1)
        end

        % Add some metadata
        meta_str = {summ_data.group_info(exp_grp_num).group_name, [ 'N = ' num2str(summ_data.group_info(exp_grp_num).N)]};
        annotation('Textbox','Position',[.1 .785 .6 .2],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none')

    end
    figure_iter = figure_iter + 1;
end
%% Make tuning curves to show many SFs over one TF
%==========================================================================
if 1
    if ~exist('figure_iter','var'); figure_iter = 1; end
    wing_output = 'lmr';
    exp_grp_num = 1;
    figure_color = [1 1 1];
    figure_size = [50 50 400 650];
    font_color = [0 0 0];
    xy_color = [0 0 0];
    axis_color = figure_color;
    zero_line_color = font_color;
    font_size_1 = 10;
    font_size_2 = 10;
    default_colors = [0 0 1 ; 1 0 0 ; 0 .5 0; .5 0 .5];

    % Set up subplots for timeseries, space-time diagrams, and intercept plots
    nHigh       = 6;    nWide       = 3;
    heightGap   = .05;  widthGap    = .055;
    heightOffset= .05;  widthOffset = .05;

    sp_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
    figure_handle(figure_iter) = figure('Name','Spatial Tuning Curves','NumberTitle','off','Color',figure_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
    figure_names{figure_iter} = 'Spatial Tuning Curves';
    
    % All of the conditions over a few pdfs
    symm_str = 'flip';

    tf.p_1  = {summ_data.cond_groups(1:6).name};
    tf.p_2  = {summ_data.cond_groups(1:6).name};
    tf.p_3 =  {summ_data.cond_groups(1:6).name};

    tf.r_1  = {summ_data.cond_groups(7:12).name};
    tf.r_2  = {summ_data.cond_groups(7:12).name};
    tf.r_3  = {summ_data.cond_groups(7:12).name};

    tf.pf_1  = {summ_data.cond_groups(13:18).name};
    tf.pf_2  = {summ_data.cond_groups(13:18).name};
    tf.pf_3  = {summ_data.cond_groups(13:18).name};

    tf.rf_1  = {summ_data.cond_groups(19:24).name};
    tf.rf_2  = {summ_data.cond_groups(19:24).name};
    tf.rf_3  = {summ_data.cond_groups(19:24).name};

    tf.bs_1  = {summ_data.cond_groups(25:30).name};
    tf.bs_2  = {summ_data.cond_groups(25:30).name};
    tf.bs_3  = {summ_data.cond_groups(25:30).name};

    tf.flk_1 = {summ_data.cond_groups(31:32).name};
    tf.flk_2 = {summ_data.cond_groups(31:32).name};
    tf.flk_3 = {summ_data.cond_groups(31:32).name};

    stim_types = {'p','pf','rf','r','bs','flk'};
    tf_nums = 1:3;

    for col = tf_nums
        stim_iter = 1;
        
        for sm = stim_types
            stim = sm{1};
            
            stimulus_group = (tf.([stim '_' num2str(col)]));
            
            clear graph
            for sf_iter = 1:numel(stimulus_group)
                % Build the tuning curve    
                graph.line{1}(sf_iter) = summ_data.(stimulus_group{sf_iter})(exp_grp_num).(symm_str).(['avg_' wing_output]){col};
                graph.shade{1}(sf_iter) = summ_data.(stimulus_group{sf_iter})(exp_grp_num).(symm_str).(['sem_' wing_output]){col};
                graph.color{1} = default_colors(1,:);
            end

            % plot the tuning curve
            subplot('Position',sp_positions{stim_iter,col})
            vec=0:7;
            plot(vec,zeros(numel(vec),1),'Linestyle','--','Color',zero_line_color,'LineWidth',1)

            hold on; box off;

            if ~strcmp(stim,'flk')
                esh=makeErrorbarTuningCurve(graph,1:numel(graph.line{1}));
                axis([0 7 -1 4])
                %[2,4,6,8,12,16]*2*3.75
                set(gca,'XTick',1:6,'XTickLabel',{'15','30','45','60','90','120'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            else
                esh=makeErrorbarTuningCurve(graph,[2 6]);
                axis([0 7 -1 4])
                set(gca,'XTick',[2 6],'XTickLabel',{'30','120'},'fontsize',font_size_1,'ticklength',2*get(gca,'ticklength'))
            end
            
            if col == 1
                % Y label
                ylabel({summ_data.(stimulus_group{1}).info.name, 'L-R WBA'},'interpreter','none','fontsize',font_size_1)
            end
            if stim_iter == 1
               % Title 
               title(['TF: ' num2str(summ_data.(stimulus_group{1}).info.tfs(col))],'fontsize',font_size_1)
            elseif stim_iter == 6
                % X Label
               xlabel('Spatial Frequency','interpreter','none','fontsize',font_size_1)
            end

            stim_iter = stim_iter + 1;
        end
    end
    
    % Add some metadata
    meta_str = {summ_data.group_info(exp_grp_num).group_name, [ 'N = ' num2str(summ_data.group_info(exp_grp_num).N)]};
    annotation('Textbox','Position',[.1 .785 .6 .2],'String',meta_str,'Edgecolor','none','fontsize',font_size_2+2,'interpreter','none')
    
    figure_iter = figure_iter + 1;
end


%% export the figure as a pdf
%==========================================================================
if save_figures
    if ~isdir(save_figure_location)
        mkdir(save_figure_location)
    end
    
    for figure_iter = 1:numel(figure_handle)
        %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
        export_fig(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]),'-pdf','-nocrop');
    end
end