function f = reconstruction_plot(week,T_test,ind_water,T_ortho,T_qdeim,T_sdeim_opt,T_sdeim_RC,T_sdeim_lstm,center,r,p)
%RECONSTRUCTION_PLOT plots the different reconstruction errors of SST
%
% INPUTS:
% week: week to plot
% T_test: SST data
% ind_water: location of water values
% T_ortho: best-fit reconstruction
% T_qdeim: qdeim construction
% T_sdeim_opt: optimal s-deim construction
% T_sdeim_RC: rc s-deim construction
% t_sdeim_lstm: lstm s-deim construction
% center: mean of data
% r: num sensors
% p: cpqr matrix
% 
% OUTPUTS:
% f: reconstruction plot


% Unwrap data
u_hat_uw = unwrap(ind_water, T_ortho);
u_tilde_uw = unwrap(ind_water, T_qdeim);
s_deim_uw = unwrap(ind_water, T_sdeim_opt);
s_deim_rc_uw = unwrap(ind_water, T_sdeim_RC);
s_deim_lstm_uw = unwrap(ind_water, T_sdeim_lstm);
test_uw = unwrap(ind_water, T_test);

true_anomaly  = reshape(test_uw(:, week), [360,180])';
best_fit_sst  = reshape(u_hat_uw(:, week), [360,180])';
qdeim_sst     = reshape(u_tilde_uw(:, week), [360,180])';
sdeim_opt_sst = reshape(s_deim_uw(:, week), [360,180])';
rc_sst        = reshape(s_deim_rc_uw(:, week), [360,180])';
lstm_sst      = reshape(s_deim_lstm_uw(:, week), [360,180])';

% Computing Error fields (reconstruction minus true anomaly)
best_diff  = best_fit_sst  - true_anomaly;
qdeim_diff = qdeim_sst     - true_anomaly;
sdeim_diff = sdeim_opt_sst - true_anomaly;
rc_diff    = rc_sst        - true_anomaly;
lstm_diff  = lstm_sst      - true_anomaly;

% Generating lat/lon grid
lat = linspace(90,-90,180);
lon = linspace(0,360,360);

[lon_grid, lat_grid] = meshgrid(double(lon), double(lat));

% Set up data and titles for subplots
data_cells = {true_anomaly, best_diff, qdeim_diff, sdeim_diff, rc_diff, lstm_diff};
plot_titles = {'True Anomaly', 'Best Fit', ...
               'Q-DEIM', 'S-DEIM w/ Optimal Kernel', ...
               'S-DEIM w/ RC', 'S-DEIM w/ LSTM'};

% Colormaps
cmaps = {jet, ... 
         redwhiteblue(min(best_diff(:)), max(best_diff(:))), ...
         redwhiteblue(min(qdeim_diff(:)), max(qdeim_diff(:))), ...
         redwhiteblue(min(sdeim_diff(:)), max(sdeim_diff(:))), ...
         redwhiteblue(min(rc_diff(:)), max(rc_diff(:))), ...
         redwhiteblue(min(lstm_diff(:)), max(lstm_diff(:)))};

% Color axis
cax = {[], ...
       [min(best_diff(:)), max(best_diff(:))], ...
       [min(qdeim_diff(:)), max(qdeim_diff(:))], ...
       [min(sdeim_diff(:)), max(sdeim_diff(:))], ...
       [min(rc_diff(:)), max(rc_diff(:))], ...
       [min(lstm_diff(:)), max(lstm_diff(:))]};

% Create figure
f = figure('Color','white');
t = tiledlayout(3,2, 'TileSpacing', 'tight', 'Padding', 'compact');
for k = 1:6
    ax = nexttile(k);
    axesm('MapProjection','robinson','Frame','on');
    setm(ax, 'Origin', [0 180 0]);
    setm(gca, 'FFaceColor', [0.5 0.5 0.5], ...
              'FEdgeColor', 'black', ...
              'FLineWidth', 1.5);
    set(gca, 'TickLabelInterpreter', 'latex')
    gridm off;
    axis off

    pcolorm(double(lat_grid), double(lon_grid), double(data_cells{k}));
    colormap(ax, cmaps{k});
    if ~isempty(cax{k}), clim(cax{k}); end
    hcb = colorbar;
    set(hcb, 'FontSize', 12, 'TickLabelInterpreter', 'latex', 'Color', 'black')
    title(plot_titles{k}, 'Interpreter', 'latex', 'FontSize', 18, 'Color', 'black')

    % Plot sensor locations for true SST
    if k == 1
        water_inds = find(ind_water); 
        sensor_full_inds = water_inds(p(1:r));
        [full_row, full_col] = ind2sub([360,180], sensor_full_inds);
        sensor_lon = lon(full_row);
        sensor_lat = lat(full_col);
        plotm(double(sensor_lat), double(sensor_lon), 'o', ...
            'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w', ...
            'MarkerSize', 4, 'LineWidth', 0.75)
    end
end
% Convert the week index into a calendar-date range. The test set begins
% on Monday, Jan 3, 2022 (week 1), so week k spans Jan 3 + 7*(k-1) days
% through that Monday + 6 days. Format matches the paper figures
% ("May 23-29, 2022"); months that straddle a boundary use both names.
test_start = datetime(2022, 1, 3);
week_start = test_start + caldays(7*(week-1));
week_end   = week_start + caldays(6);
if month(week_start) == month(week_end)
    date_str = sprintf('%s %d-%d, %d', ...
        datestr(week_start, 'mmmm'), day(week_start), day(week_end), year(week_end));
else
    date_str = sprintf('%s %d -- %s %d, %d', ...
        datestr(week_start, 'mmmm'), day(week_start), ...
        datestr(week_end,   'mmmm'), day(week_end),   year(week_end));
end
sgtitle(['\textbf{', date_str, '}'], 'Interpreter', 'latex', 'Color', 'black', 'FontSize', 16)

end