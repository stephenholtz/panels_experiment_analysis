% Make space-time diagrams

% Add a few things to the path.
addpath(genpath('/Users/stephenholtz/matlab-utils')) % add matlab utilities
addpath(genpath('~/panels_experiments'));

C = overlaid_vel_nulling_and_bilateral_vel_nulling;
C = C.experiment;

save_path = '/Users/stephenholtz/temp_space_time/mr_vel_null';

if ~exist(save_path,'dir')
    mkdir(save_path)
end

make_vids = 0;

for i = 1:30
    
    stim_name = ['cond_' num2str(i) '_pat_' C(i).PatternName(12:(end-20))];
    
    save_file = fullfile(save_path,stim_name);
    
    stimulus = panels_arena_simulation('small',C(i));
    std_handle = stimulus.MakeSimpleSpaceTimeDiagram('green');
    snaps_handle = stimulus.MakeSnapshotTimeSeries(10);
    params_handle = stimulus.MakeParametersPage;
    
    tfPlot.arenaSimulation.SaveSpaceTimeDiagram(save_file,std_handle,params_handle,snaps_handle);
%    tfPlot.arenaSimulation.SaveSpaceTimeDiagram(save_file,std_handle);
    
    if make_vids
        mov_handle = stimulus.MakeMovie('green',save_file);
    end
    
    close all
    
end
