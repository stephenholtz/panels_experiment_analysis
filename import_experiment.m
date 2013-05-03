function experiment = import_experiment(experiment_folder)
% Import all of the experiments in a given folder. 
% 
% Pulls in (for each experiment in the folder)
%  * The experimental metadata (which includes the protocol_conditions)
%  * The parsed data from the experiment

% Import the metadata/conditions
load(fullfile(experiment_folder,'metadata.mat'));
experiment.metadata = metadata;
conditions = metadata.protocol_conditions;
condition_lengths = [conditions.experiment(:).Duration];
interspersal_length = conditions.closed_loop.Duration;

% % Import and parse the data file
% data_file = fullfile(experiment_folder,'data.daq');
% tmp = parse_volt_encoded_exp_data(data_file,condition_lengths,interspersal_length);
% experiment.parsed_data = tmp;
% clear tmp

% Import and parse the data files. appending if there are more than 1
daq_files = dir(fullfile(experiment_folder,'*.daq'));
for i = 1:numel(daq_files);
    curr_data_file = fullfile(experiment_folder,daq_files(i).name);
    tmp = parse_volt_encoded_exp_data(curr_data_file,condition_lengths,interspersal_length);
    for j = 1:numel(tmp.data)
        fns = fieldnames(tmp.data(j))';
        for fn = fns
            experiment.parsed_data.data(j).(fn{1}) = [];
            experiment.parsed_data.ps_data(j).(fn{1}) = [];
        end
        for fn = fns
            experiment.parsed_data.data(j).(fn{1}) = [experiment.parsed_data.data(j).(fn{1}); tmp.data(j).(fn{1})];
            experiment.parsed_data.ps_data(j).(fn{1}) = [experiment.parsed_data.ps_data(j).(fn{1}); tmp.ps_data(j).(fn{1})];
        end
    end
    clear tmp
end
end