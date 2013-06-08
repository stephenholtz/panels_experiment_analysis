% Make space-time diagrams

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(genpath('~/panels_experiments'));

C = window_test_prog_reg_sq_wave_motion_4px_8px;
C = C.experiment;

save_path = '/Users/stephenholtz/temp_space_time/window_test_prog_reg_sq_wave_motion_4px_8px';

if ~exist(save_path,'dir')
    mkdir(save_path)
end

make_vids = 1;

for i = [82 80]%1:numel(C)
    
    stim_name = ['cond_' num2str(i) '_' C(i).PatternName];
    
    save_file = fullfile(save_path,stim_name);
    
    stimulus = panels_arena_simulation('small',C(i));
    std_handle = stimulus.MakeSimpleSpaceTimeDiagram('green');
    %snaps_handle = stimulus.MakeSnapshotTimeSeries(10);
    params_handle = stimulus.MakeParametersPage;
    
    %panels_arena_simulation.SaveSpaceTimeDiagram(save_file,std_handle,params_handle,snaps_handle);
    panels_arena_simulation.SaveSpaceTimeDiagram(save_file,std_handle,params_handle);
    
    if make_vids
        mov_handle = stimulus.MakeMovie('green',save_file);
    end
    
    close all
    
end
