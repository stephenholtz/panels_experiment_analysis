% Make space-time diagrams

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(genpath('~/panels_experiments'));

C = jct_telethon;
C = C.experiment;

save_path = '/Users/stephenholtz/temp_space_time/jct_telethon';

if ~exist(save_path,'dir')
    mkdir(save_path)
end

make_vids = 0;

for i = 1:numel(C)
    
    stim_name = ['cond_' num2str(i)];
    
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
    
    close all force
    
end