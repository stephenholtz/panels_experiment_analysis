function experiment_group = import_experiment_group(experiment_group_folder,save_flag)
% A very simple import that uses a folder to group experiments, this is the
% easiest/most flexible method. Mostly lossless reduction of data footprint
% by ~80% makes later import/summarizing and analysis very fast.

    [~,experiment_folder] = returnDirFolderList(experiment_group_folder);
    [~,experiment_group_name] = fileparts(experiment_group_folder);
        
    exp_num = 1;
    for i = 1:numel(experiment_folder)
        
        [~,file_name]=(fileparts(experiment_folder{i}));
        disp([num2str(i) '/' num2str(numel(experiment_folder)) ' - ' file_name])
        
        tmp_experiment = import_experiment(experiment_folder{exp_num});
        
        if is_quality_experiment(tmp_experiment)
            experiment_group(exp_num) = tmp_experiment; %#ok<*AGROW>
            exp_num = exp_num + 1;
            fprintf('\b - OK!\n')
        else
            fprintf('\b - Failed!\n')
        end
        
        clear tmp_experiment
        
    end
    
    if ~exist('experiment_group','var')
        experiment_group = struct([]);
        fprintf('\b No Experiments were OK. Saving Empty experiment_group\n')
    end
    
    % Save the grouped experiment in the same folder
    save_file_name = fullfile(experiment_group_folder,experiment_group_name);
    
    if save_flag
        save(save_file_name,'experiment_group');
    end
    
end