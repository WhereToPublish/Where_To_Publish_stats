function[txt_hdl, txtSize] = place_r_and_pval(r_corr, pval)
%[txt_hdl, txtSize] = place_r_and_pval(r_corr, pval)
% place_r_and_pval serves to display correlation info on graph for the
% mediation script (but can also be used elsewhere)
%
% INPUTS
% r_corr: correlation coefficient
%
% pval: p.value
%
% See also mediation
%
% OUTPUTS
% txt_hdl: text handle
%
% txtSize: structure with information regarding font size used, along with
% the width and height of the text

%% round the values in case they are too long
% round correlation coefficient (if below 0.001, will be equal to 0.001 or
% 0)
if r_corr > 0.01
    r_corr = round(r_corr, 2);
else
    r_corr = round(r_corr,3);
end
% include a number of stars depending on if pval significant or not
if pval > 0.05
    pval_stars = '';
elseif (pval > 0.01) && (pval <= 0.05)
    pval_stars = '*';
elseif (pval > 0.005) && (pval <= 0.01)
    pval_stars = '**';
elseif (pval > 0.001) && (pval <= 0.005)
    pval_stars = '***';
elseif pval <= 0.001
    pval_stars = '****';
elseif isnan(pval)
    pval_stars = '';
end
r_corr_str = [num2str(r_corr),pval_stars];

% for p.value need to track how small p.value is if below 0.001
if (pval >= 0.001) || isnan(pval)
    pval_str = ['p = ',num2str(round(pval, 3))];
else
    % pval_str = num2str(round(pval,1,'significant')); % to show actual
    % value
    pval_str = 'p < 0.001'; % just mention this if pvalue is smaller than 0.001
end

%% text size
txtSize.FontSize = 20;

%% add the text
txt_hdl = text(0, 0,...
    {['r = ',r_corr_str], pval_str},...
    'FontSize',txtSize.FontSize);

%% extract size of the text
txt_size = get(txt_hdl,'Extent'); % provides a 4 columns vector with [x_start, y_start, width, height]
txt_width = txt_size(3);
txt_height = txt_size(4);
txtSize.width = txt_width;
txtSize.height = txt_height;

%% adjust text position to be in top-right or bottom-right part of the figure
% measure current x and y limits
xlim_vals = xlim;
ylim_vals = ylim;

% replace x and y accordingly
% replace X at the border of the X dimension
txt_hdl.Position(1) = xlim_vals(2) - txt_width;
txt_hdl.HorizontalAlignment = 'left'; % text ending to the left of txt_hdl.Position(1)
    
% replace y up or down
if r_corr < 0 % negative correlation (top right of the screen)
    txt_hdl.Position(2) = ylim_vals(2) - txt_height;
    txt_hdl.VerticalAlignment = 'cap'; % text ending just below of txt_hdl.Position(2)
elseif (r_corr >= 0) || isnan(r_corr) % positive correlation (bottom right of the screen)
    txt_hdl.Position(2) = ylim_vals(1) + txt_height;
    txt_hdl.VerticalAlignment = 'bottom'; % text ending just above txt_hdl.Position(2)
end

end % function