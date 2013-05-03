function progress_struct = track_experiment_progress(experiment_folder)
% function [progress_struct] = track_experiment_progress(experiment_folder)
% returns a struct with the number of experiments perfomed on each
% genotype within the folder and the total number.
% 
% Pretty handy.

geno_dir = dir(experiment_folder);

geno_iter = 1;

% For each of the genotypes
for i = 1:numel(geno_dir)
    if geno_dir(i).isdir && ~sum(strcmpi(geno_dir(i).name,{'.','..','.DS_Store','.thumbsdb'}))
        exp_dir = dir(fullfile(experiment_folder,geno_dir(i).name));
        exp_count = 0;
        % For all of one genotype's experiments
        for g = 1:numel(exp_dir)
            if exp_dir(g).isdir && ~sum(strcmpi(geno_dir(i).name,{'.','..','.DS_Store','.thumbsdb'}))
                % Add up the number of .daq files for temp shift and room
                % temp experiments
                if ~isempty(dir(fullfile(experiment_folder,geno_dir(i).name,exp_dir(g).name,'*.daq')))
                    exp_count = exp_count + 1;
                end
            end
            % not good practice...
            progress_struct.([geno_dir(i).name]) = exp_count;
        end
        geno_iter = 1 + geno_iter;
    end
end