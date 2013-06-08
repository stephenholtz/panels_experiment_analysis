function fs = figure_settings(figure_type)
% Color scheme and figure settings script for all of the
if ~exist('figure_type','var')
    figure_type = 'paper';
end

switch lower(figure_type)
    case {'paper',1}
        fs.ctrl_colors = [.3 .3 .3 ; .3 .3 .3];
        %fs.exp_colors = [ 1 .75 0 ; 0 .2 1; 0 .5 0; .5 0 .5];
        fs.exp_colors = [40/255 154/255 1; 248/255 0 248/255; 0 238/255 0];
        %fs.exp_colors = [.5 .5 0;.5 0 0;.5 0 .5;0 .5 .5;.9 .25 .25];
        fs.bkg_color = [1 1 1];
        fs.font_color = [0 0 0];
        fs.axis_color = [.2 .2 .2];
        fs.axis_font = 'Helvetica Neue';
        fs.axis_font_size = 12;
        fs.line_width = 2;
        
    case {'presentation',2}
        fs.ctrl_colors = [.9 .9 .9; .9 .9 .9];
        %fs.exp_colors = [ 1 .75 0 ; 0 .2 1; 0 .5 0; .5 0 .5];
        fs.exp_colors = [40/255 154/255 1; 248/255 0 248/255; 0 238/255 0];
        %fs.exp_colors = [.5 .5 0;.5 0 0;.5 0 .5;0 .5 .5;.9 .25 .25];
        fs.bkg_color = [0 0 0];
        fs.font_color = [1 1 1];
        fs.axis_color = [.9 .9 .9];
        fs.axis_font = 'Helvetica Neue';
        fs.axis_font_size = 14;
        fs.line_width = 2;
        
    otherwise
        error('figure_type must be either paper or presentation')
end