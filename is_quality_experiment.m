function quality = is_quality_experiment(experiment)
% Makes sure a minimum number of repetitions are up to snuff.

min_reps = 2;
min_wbf = 1.5;
min_pct_complete = .9;
quality = 1;

for i = 1:numel(experiment.parsed_data.data)
    for c = 1:size(experiment.parsed_data.data,2)

        suc_reps = 0;
        
        for r = 1:size(experiment.parsed_data.data(c).wbf,1)
            if sum(experiment.parsed_data.data(c).wbf(r,:) > min_wbf) > min_pct_complete*numel(experiment.parsed_data.data(c).wbf(r,:));
                suc_reps = suc_reps + 1;
            end
        end
        
        if suc_reps < min_reps
            quality = 0;
            return
        end
        
    end
end

end