% Make figures for lab meeting (import OLD data)

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/tethered_flight_arena_code/'));
addpath(genpath('/Users/stephenholtz/panels_experiment_analysis/'));
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(fullfile([fileparts(mfilename('fullpath')) filesep '..' filesep '..'])); % add the panels_experiment_analysis directory in the silliest way possible

% funcs for moving subplots around
nudge = @(pos,x_dir,y_dir)([pos(1)+x_dir pos(2)+y_dir pos(3) pos(4)]);
expand_plot = @(in,exp_lr,exp_ud)([in(1) in(2) in(3)*exp_lr in(4)*exp_ud]);

data_location = '/Users/stephenholtz/local_experiment_copies/high_res_tuning_curves_v01';

% Group experiments by their folders, give more information
%==========================================================================
% Old grouping method:
%geno_names{1} = 'gmr_29g11dbd_gal80ts_kir21';
%geno_names{2} = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
%geno_names{3} = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
%geno_names{4} = 'gmr_31c06ad_34g07dbd_gal80ts_kir21';
%geno_names{5} = 'gmr_35a03ad_29g11dbd_gal80ts_kir21';

experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/high_res_tuning_curves_v01'; %#ok<*NASGU>

experiment_groups(1).folder = 'gmr_29g11dbd_gal80ts_kir21';
experiment_groups(1).name   = '+;R29g11DBD/Kir2.1(DL)';
experiment_groups(1).type   = 'Ctrl(c)';

experiment_groups(2).folder = 'gmr_25b02ad_48d11dbd_gal80ts_kir21';
experiment_groups(2).name   = 'R25b02AD;48d11DBD/Kir2.1(DL)';
experiment_groups(2).type   = 'C2(a)';

experiment_groups(3).folder = 'gmr_35a03ad_29g11dbd_gal80ts_kir21';
experiment_groups(3).name   = 'R35a03AD;R29g11DBD/Kir2.1(DL)';
experiment_groups(3).type   = 'C3(a)';

experiment_groups(4).folder = 'gmr_20c11ad_48d11dbd_gal80ts_kir21';
experiment_groups(4).name   = 'R20c11AD;R48d11DBD/Kir2.1(DL)';
experiment_groups(4).type   = 'C2/C3';

experiment_groups(5).folder = 'gmr_31c06ad_34g07dbd_gal80ts_kir21';
experiment_groups(5).name   = 'R31c06AD;34g07DBD/Kir2.1(DL)';
experiment_groups(5).type   = 'L4';

% Load in all of the experiment groups via their saved summaries (creating saved summaries if they don't exist)
%==========================================================================

if 0; for do = 1 %#ok<ALIGN>
    save_summaries = 1;

    % this creates: experiment_group(folder#).parsed_data(experiment#).data(condition#).lmr(rep#,:)
    for i = 1:numel(experiment_groups)
        if ~isfield(experiment_groups(i),'metadata') || isempty(experiment_groups(i).metadata)
            % import/save a group summary if it does not already exist
            experiment_group_summary = fullfile(experiment_group_folder_loc,experiment_groups(i).folder,[experiment_groups(i).folder '.mat']);
            disp([num2str(i) '/' num2str(numel(experiment_groups)) '===' experiment_groups(i).folder])

            if ~exist(experiment_group_summary,'file')
                experiment_group = import_experiment_group(fullfile(experiment_group_folder_loc,experiment_groups(i).folder),save_summaries);
                experiment_groups(i).parsed_data    = [experiment_group.parsed_data]; %#ok<*SAGROW>
                experiment_groups(i).metadata       = experiment_group.metadata;
                clear experiment_group
            else
                load(experiment_group_summary); % loads experiment_group variable
                try
                    experiment_groups(i).parsed_data 	= [experiment_group.parsed_data];
                    experiment_groups(i).metadata       = [experiment_group.metadata];
                catch
                    disp('metadata or parsed_data fields are not all the same... removing extra field')
                    for j = 1:numel(experiment_group)
                        if isfield(experiment_group(j).metadata,'time_taken')
                            experiment_group(j).metadata = rmfield(experiment_group(j).metadata,'time_taken');
                        end
                    end
                    experiment_groups(i).metadata = [experiment_group.metadata];
                end
                clear experiment_group
            end
        end
    end
    clear overwrite_saved_summaries i

    % Set up condition indicies to stimulus type mapping
    %==========================================================================

    % @ 'Users/stephenholtz/panels_experiments/protocols/sf_sweep_prog_reg/misc_prog_reg_stims.m';
    i=0;

    % For unilateral stimuli (all in terms of cw!):
    % ccw_left(-) and cw_right(+)  go together -- progressive
    % cw_left(+)  and ccw_right(-) go together -- regressive
    i = i + 1;
    cond_group(i).name = 'lam_30_full';
    cond_group(i).description = '30 Degree Standard Phi Full Field'; % OKAY
    cond_group(i).tf = [.25, .5, 2, 4, 8, 12, 25, 50, 75, 100];
    cond_group(i).speed = [.25, .5, 2, 4, 8, 12, 25, 50, 75, 100]*8;
    cond_group(i).inds = [1,2;...
                          3,4;...
                          5,6;...
                          7,8;...
                          9,10;...
                          11,12;...
                          13,14;...
                          15,16;...
                          17,18;...
                          19,20];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'lam_30_prog';
    cond_group(i).description = '30 Degree Standard Phi Progressive Motion'; % OKAY
    cond_group(i).tf = [.25, .5, 2, 4, 8, 12, 25, 50, 75, 100];
    cond_group(i).speed = [.25, .5, 2, 4, 8, 12, 25, 50, 75, 100]*8;
    cond_group(i).direction = 'Progressive';
    cond_group(i).inds = [41,22;...
                         43,24;...
                         45,26;...
                         47,28;...
                         49,30;...
                         51,32;...
                         53,34;...
                         55,36;...
                         57,38;...
                         59,40];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'lam_30_reg';
    cond_group(i).description = '30 Degree Standard Phi Regressive Motion'; % OKAY
    cond_group(i).tf = [.25, .5, 2, 4, 8, 12, 25, 50, 75, 100];
    cond_group(i).speed = [.25, .5, 2, 4, 8, 12, 25, 50, 75, 100]*8;
    cond_group(i).direction = 'Regressive';
    cond_group(i).inds = [21,42;...
                          23,44;...
                          25,46;...
                          27,48;...
                          29,50;...
                          31,52;...
                          33,54;...
                          35,56;...
                          37,58;...
                          39,60];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'lam_60_full';
    cond_group(i).description = '60 Degree Standard Phi Full Field'; % OKAY
    cond_group(i).tf = [.5 4 8 25 75]; 
    cond_group(i).speed = [.5 4 8 25 75]*16;
    cond_group(i).inds = [61,62;...
                         63,64;...
                         65,66;...
                         67,68;...
                         69,70];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'lam_60_prog';
    cond_group(i).description = '60 Degree Standard Phi Progressive Motion'; %OKAY
    cond_group(i).tf = [.5 4 8 25 75]; 
    cond_group(i).speed = [.5 4 8 25 75]*16;
    cond_group(i).direction = 'Progressive';
    cond_group(i).inds =[81,72;...
                         83,74;...
                         85,76;...
                         87,78;...
                         89,80];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'lam_60_reg';
    cond_group(i).description = '60 Degree Standard Phi Regressive Motion'; % OKAY
    cond_group(i).tf = [.5 4 8 25 75]; 
    cond_group(i).speed = [.5 4 8 25 75]*16;
    cond_group(i).direction = 'Regressive';
    cond_group(i).inds = [71,82;...
                         73,84;...
                         75,86;...
                         77,88;...
                         79,90];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'rev_phi_lam_60_full';
    cond_group(i).description = '60 Degree Reverse Phi Full Field'; % OKAY
    cond_group(i).tf = [.5 4 8 25 75]; 
    cond_group(i).speed = [.5 4 8 25 75]*16;
    cond_group(i).inds = [91,92;...
                          93,94;...
                          95,96;...
                          97,98;...
                          99,100];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'rev_phi_lam_60_prog';
    cond_group(i).description = '60 Degree Standard Phi Progressive Motion'; % OKAY
    cond_group(i).tf = [.5 4 8 25 75]; 
    cond_group(i).speed = [.5 4 8 25 75]*16;
    cond_group(i).direction = 'Progressive';
    cond_group(i).inds = [111,102;...
                          113,104;...
                          115,106;...
                          117,108;...
                          119,110];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];

    i = i + 1;
    cond_group(i).name = 'rev_phi_lam_60_reg';
    cond_group(i).description = '60 Degree Standard Phi Regressive Motion'; % OKAY
    cond_group(i).tf = [.5 4 8 25 75]; 
    cond_group(i).speed = [.5 4 8 25 75]*16;
    cond_group(i).direction = 'Regressive';
    cond_group(i).inds =  [101,112;...
                           103,114;...
                           105,116;...
                           107,118;...
                           109,120];
    cond_group(i).flip_inds = [0*ones(size(cond_group(i).inds,1),1), 1*ones(size(cond_group(i).inds,1),1)];


    % Pull out conditions from experiment groups
    %==========================================================================
    % 
    % summarized data is grouped for plotting / easy sharing i.e.
    % summ_data.group_info(experiment_group_num).group_name = 'gmr...';
    % summ_data.group_info(experiment_group_num).group_metadata = [experiment_groups(experiment_group_num).metadata]
    % summ_data.(cond_group_name)(experiment_group_num).info = cond_group
    % summ_data.(cond_group_name)(experiment_group_num).(flip,cw,ccw).(avg_lmr,avg_lmr_ts} = [some data];

    % Useful anon func for making a vector;
    mk_sym_vec = @(vec)([zeros(size(vec,1),1),ones(size(vec,1),1)]);

    % Determine normalization values (average lmr, wbf per experiment group)
    for exp_grp_num = 1:numel(experiment_groups)

        trials_for_normalization = 1:120; % numel(experiment_groups(exp_grp_num).metadata(1).protocol_conditions.experiment);
        return_struct.inds              = trials_for_normalization; % Put all conditions in one big set
        return_struct.flip_condition    = zeros(1,numel(trials_for_normalization));
        return_struct.daq_channel       = 'lmr';        % lmr is turning channel
        return_struct.normalization_val = 1;            % we haven't made this yet
        return_struct.average_oper      = @nanmean;     % can be @nanmean or @median.
        return_struct.timeseries_oper   = @(x,~)(nanmean(abs(x)));%@nanmean;        % @nanmean returns the timeseries mean @(x,~)(x) returns the whole timeseries
        return_struct.average_type      = 'all';        % average across reps and animals
        return_struct.inds_to_use       = @(x,~)(x);    % returns all inds.. NOT WORKING YET!
        return_struct.ps_offset_amt     = 50;           % ms before the trial to subtract out of the lmr response

        [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);
        summ_data.mean_turn_resp(exp_grp_num) = a{1};
    end

    % Useful for dynamic field references
    summ_data.cond_groups = cond_group;
    summ_data.overall_mean_turn_resp = mean(summ_data.mean_turn_resp);

    for exp_grp_num = 1:numel(experiment_groups)

        % Copy useful metadata over.
        summ_data.group_info(exp_grp_num).group_name = experiment_groups(exp_grp_num).name;
        summ_data.group_info(exp_grp_num).type = experiment_groups(exp_grp_num).type;
        summ_data.group_info(exp_grp_num).group_metadata = [experiment_groups(exp_grp_num).metadata];
        summ_data.group_info(exp_grp_num).group_folder = experiment_groups(exp_grp_num).folder;
        summ_data.group_info(exp_grp_num).N = size(experiment_groups(exp_grp_num).parsed_data,2);
        summ_data.group_info(exp_grp_num).normalization_val = summ_data.overall_mean_turn_resp/summ_data.mean_turn_resp(exp_grp_num);    

        for cg_num = 1:numel(cond_group)

            cond_group_name = cond_group(cg_num).name;

            % Copy info from cond_group struct
            summ_data.(cond_group_name)(exp_grp_num).info = cond_group(cg_num);

            return_struct.daq_channel       = 'lmr';        % lmr is turning channel
            return_struct.normalization_val = summ_data.group_info(exp_grp_num).normalization_val;
            return_struct.average_oper      = @nanmean;     % can be @nanmean @median etc...
            return_struct.inds_to_use       = @(x,~)(x);    % returns all inds.. NOT WORKING YET!
            return_struct.ps_offset_amt     = 50;           % ms before the trial to subtract out of the lmr response

            % Pull in the condition_group responses (per symmetry type)
            for sym = 1

                if sym == 1
                    sym_type = 'flip';
                    return_struct.inds = cond_group(cg_num).inds;
                    return_struct.flip_condition = cond_group(cg_num).flip_inds;
                elseif sym == 2
                    sym_type = 'cw';
                    return_struct.inds = cond_group(cg_num).inds(:,1);
                    return_struct.flip_condition = 0*return_struct.inds;
                elseif sym == 3
                    sym_type = 'ccw';
                    return_struct.inds = cond_group(cg_num).inds(:,2);
                    return_struct.flip_condition = 0*return_struct.inds;
                end

                for ws = {'lmr'}
                    wing_sig = ws{1};

                    return_struct.timeseries_oper   = @(x,~)(x);
                    return_struct.daq_channel       = wing_sig;
                    return_struct.average_type      = 'all';
                    [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                    summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['avg_' wing_sig '_ts']) = a;
                    summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['sem_' wing_sig '_ts']) = e;

                    return_struct.timeseries_oper   = @nanmean;
                    return_struct.daq_channel       = wing_sig;
                    return_struct.average_type      = 'all';
                    [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                    summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['avg_' wing_sig]) = a;
                    summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['sem_' wing_sig]) = e;

                    return_struct.timeseries_oper   = @nanmean;
                    return_struct.daq_channel       = wing_sig;
                    return_struct.average_type      = 'animal'; % This is for stats
                    [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                    summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_avg_' wing_sig]) = a;
                    summ_data.(cond_group_name)(exp_grp_num).(sym_type).(['all_sem_' wing_sig]) = e;
                end

                % X position has all of the movement regardless of side
                return_struct.timeseries_oper   = @(x,~)(x);
                return_struct.daq_channel       = 'x_pos';
                return_struct.average_type      = 'all';
                [a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);

                summ_data.(cond_group_name)(exp_grp_num).(sym_type).avg_x_ts = a;
                summ_data.(cond_group_name)(exp_grp_num).(sym_type).sem_x_ts = e;

                % No need for y position here.
                %return_struct.timeseries_oper   = @(x,~)(x);
                %return_struct.daq_channel       = 'y_pos';
                %return_struct.average_type      = 'all';
                %[a,e] = get_experiment_condition_responses(experiment_groups(exp_grp_num),return_struct);
                % 
                %summ_data.(cond_group_name)(exp_grp_num).(sym_type).avg_y_ts = a;
                %summ_data.(cond_group_name)(exp_grp_num).(sym_type).sem_y_ts = e;
            end
        end
    end

    % Save the summarized set of experiment group responses
    %==========================================================================
    summ_data_loc = fullfile(experiment_group_folder_loc,'summ_data');
    fprintf('\n Saving summarized data...\n %s.mat\n',summ_data_loc)
    save(summ_data_loc,'summ_data');
end; end

% Make a pretty nice figure for the high resolution tuning curve. Make each
% one
%==========================================================================

% Get a struct with nice figure settings
fig_type_str = 'presentation';
fs = figure_settings(fig_type_str);
save_figures = 1;
experiment_set = 1;

switch experiment_set
    case 1
        base_figure_name= 'high_res_tune_exp_';
        symm_str = 'flip';
        wing_output = 'lmr';
        y_range = [-1.5 4];
        y_tick = [y_range(1) 0 y_range(2)];

        figure_size =  [50 50 500 350];
        
        nHigh       = 1;    heightGap   = 0;     widthGap    = 0;
        nWide       = 1;    heightOffset= 0;     widthOffset = 0;
        tune_curve_positions = getFullPageSubplotPositions(nWide,nHigh,widthGap,heightGap,widthOffset,heightOffset);
        tune_curve_positions{1} = expand_plot(tune_curve_positions{1},.7,.7);
        tune_curve_positions{1} = nudge(tune_curve_positions{1},.175,.15);
        
        control_inds        = 1;
        geno_comp_inds.c2   = [1 2];
        geno_comp_inds.c3   = [1 3];
        geno_comp_inds.c2c3 = [1 4];
        geno_comp_inds.l4   = [1 5];

        % Load in the data if needed
        experiment_group_folder_loc = '/Users/stephenholtz/local_experiment_copies/high_res_tuning_curves_v01';
        if ~exist('summ_data','var')
            load(fullfile(experiment_group_folder_loc,'summ_data'));
        end
        save_figure_location = fullfile('/Users/stephenholtz/Dropbox/lab_meeting_2013_06/reprocessed_figures/hi_res_tune_curves/',fig_type_str);
    otherwise
        error('No experiment_set of that number')
end

figure_iter = 1;
for comp_field = {'c2','c3','c2c3','l4'}
    comp_field = comp_field{1}; %#ok<FXSET> % Why not.
    for fig_src = {'lam_30_full','lam_30_prog','lam_30_reg','lam_60_full','lam_60_prog','lam_60_reg','rev_phi_lam_60_full','rev_phi_lam_60_prog','rev_phi_lam_60_reg'}
        fig_src = fig_src{1}; %#ok<FXSET> % Why not.
        
        if ~exist('figure_iter','var')
            figure_iter = 1;
        else
            figure_iter = figure_iter + 1;
        end
        
        figure_name = [base_figure_name '_' fig_src '_' experiment_groups(geno_comp_inds.(comp_field)(1)).folder(4:end-5) '_vs_' experiment_groups(geno_comp_inds.(comp_field)(2)).folder(4:end-5)];
        %figure_handle = figure('Name',figure_name,'NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        figure_handle = figure('Name',figure_name,'ToolBar','none','MenuBar','none','NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait'); %#ok<*SAGROW>
        
        % Plot the tuning curve
        exp_grp_iter = 1; clear graph
        graph.line_width = fs.line_width;
        for exp_grp_ind = geno_comp_inds.(comp_field)
            graph.line{exp_grp_iter}    = cell2mat(summ_data.(fig_src)(exp_grp_ind).(symm_str).(['avg_' wing_output]));
            graph.shade{exp_grp_iter}   = cell2mat(summ_data.(fig_src)(exp_grp_ind).(symm_str).(['sem_' wing_output]));
            if exp_grp_ind == 1
                graph.color{exp_grp_iter}   = fs.ctrl_colors(exp_grp_iter,:);
            else
                graph.color{exp_grp_iter}   = fs.exp_colors(exp_grp_iter-1,:);
            end
            graph.x_offset(exp_grp_iter) = (exp_grp_iter-1)*.035;
            exp_grp_iter = exp_grp_iter + 1;                
        end

        subplot('Position',tune_curve_positions{1,1})
        vec = 0:10;
        plot(vec,zeros(numel(vec),1),'Linestyle','-','color',fs.axis_color,'LineWidth',1);
        hold on; box off; 
        x_axis_vec = 1:numel(summ_data.(fig_src)(1).info.tf);
        esh=makeErrorbarTuningCurve(graph,x_axis_vec);
        axis([.75 numel(summ_data.(fig_src)(1).info.tf)+.25 y_range]);
        xlabel('Temporal Frequency (Hz)','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        ylabel('Mean \DeltaWBA','FontName',fs.axis_font,'fontsize',fs.axis_font_size)
        set(gca,'YTick',y_tick,'FontName',fs.axis_font,'fontsize',fs.axis_font_size,'color',fs.bkg_color,'YColor',fs.axis_color,'XColor',fs.axis_color)
        set(gca,'XTick',x_axis_vec,'XTickLabel',summ_data.(fig_src)(1).info.tf,'fontsize',fs.axis_font_size,'FontName',fs.axis_font,'ticklength',2*get(gca,'ticklength'))
        title(summ_data.(fig_src)(1).info.description,'Color',fs.font_color,'fontsize',fs.axis_font_size,'FontName',fs.axis_font)
        % Make them MR worthy:
        %fixfig;
        fix_errorbar_tee_width(1);

        % export the figure as a pdf
        %======================================================================
        if save_figures
            if ~isdir(save_figure_location)
                mkdir(save_figure_location)
            end
            fn = 1;
            export_fig(figure_handle(fn),fullfile(save_figure_location,figure_name),'-pdf','-nocrop');
            %for fn = 2:figure_iter
            %    %saveas(figure_handle(figure_iter),fullfile(save_figure_location,[figure_names{figure_iter}]));
            %    export_fig(figure_handle(fn),fullfile(save_figure_location,figure_name),'-pdf','-nocrop','-append');
            %end
        end
        clear figure_handle figure_iter
        close all force
        pause(.01)
    end
    
    % Make a figure legend for the comp field
    legend_fig_size = [50 50 500 350];
    legend_figure_name = [comp_field '_vs_controls_legend_figure'];
    legend_figure_handle = figure('Name',legend_figure_name,'ToolBar','none','MenuBar','none','NumberTitle','off','Color',fs.bkg_color,'Position',figure_size,'PaperOrientation','portrait');
    exp_grp_iter = 1;
    for exp_grp_ind = geno_comp_inds.(comp_field)
        if sum(exp_grp_ind==control_inds)
            legend_color   = fs.ctrl_colors(exp_grp_iter,:);
        else
            legend_color   = fs.exp_colors(exp_grp_iter-numel(control_inds),:);
        end
        metadata_string = [summ_data.group_info(exp_grp_ind).type ' [' summ_data.group_info(exp_grp_ind).group_name '] N = ' num2str(summ_data.group_info(exp_grp_ind).N)];
        
        annotation('Textbox','Position',    [.21 .965-.15*(exp_grp_iter) .4 .025],'FontWeight','bold','FontName',fs.axis_font,'color',fs.axis_color,'String',metadata_string,'Edgecolor','none','fontsize',fs.axis_font_size+1)
        annotation('Rectangle','Position',  [.04 .912-.15*(exp_grp_iter) .08 .075],'EdgeColor',legend_color,'facecolor',legend_color); 
        exp_grp_iter = exp_grp_iter + 1;
    end
    
    export_fig(legend_figure_handle,fullfile(save_figure_location,legend_figure_name),'-pdf','-nocrop');
    clear figure_handle figure_iter
    close all force
    pause(.01)
end
