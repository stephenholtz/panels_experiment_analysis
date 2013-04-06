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

% Import and parse the data file
data_file = fullfile(experiment_folder,'data.daq');
tmp = parse_volt_encoded_exp_data(data_file,condition_lengths,interspersal_length);
experiment.parsed_data = tmp;
clear tmp

end