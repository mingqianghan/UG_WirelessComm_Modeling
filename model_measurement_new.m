clc; clear; close all;

% ── Data & params ───────────────────────────────────────────────────────────
f  = [868 915 2400]*1e6;           % Carrier frequencies (Hz)
dUG = 0.1:0.01:0.5;                % Continuous burial depth (m)
ds  = [0.1 0.2 0.3 0.4 0.5];       % Measured burial depths (m)
num_location = 5;                  % # of test locations

MFM_data   = zeros(1,75);          % Arrays for evaluation (5 depths × 3 freqs × 5 locs = 75)
PLM_data   = zeros(1,75);
MLSPM_data = zeros(1,75);
Mean_data  = zeros(1,75);
L_MLSPM    = zeros(1,length(dUG));
L_MLSPMC   = zeros(1,length(ds));

soildata = load_soildata();        % user-provided function to load soil data
p_data   = importdata('Receive data.xlsx');  % measurement data (assumed: [mean; err] rows per location)

% Column titles
ttext = ["S2LP (868 MHz)" "SX1262 (915 MHz)" "SX1280 (2.4 GHz)"];

% ── Figure & layout settings ────────────────────────────────────────────────
font_size = 10;
width_cm  = 16.2;                % requested width (cm)
row_h_cm  = 3.2;               % height per row (tune as needed)
legend_h  = 1.2;               % space for legend
height_cm = num_location*row_h_cm + legend_h;

fig = figure(100);
set(fig, ...
    'Units','centimeters', ...
    'Position',[2 2 width_cm height_cm], ...
    'DefaultAxesFontSize',   font_size, ...
    'DefaultTextFontSize',   font_size, ...
    'DefaultAxesFontName',   'Times New Roman', ...
    'DefaultTextFontName',   'Times New Roman', ...
    'DefaultAxesLineWidth',  1.5, ...
    'DefaultLineLineWidth',  1.5);


tl = tiledlayout(num_location, 3, 'TileSpacing','compact', 'Padding','compact');
ylabel(tl, 'Path loss (dB)', 'fontsize', font_size, 'FontWeight','bold');

% Keep handles for legend and collect axes for shared limits
h1 = []; h2 = []; h3 = []; h4 = [];
axs = gobjects(num_location*3,1);
ax_idx = 0;

% ── Main plotting loop ─────────────────────────────────────────────────────
for k = 1:num_location
    % Soil data for this location
    VWC   = soildata(k).VWC;
    C     = soildata(k).Clay;
    Layer = soildata(k).Layer;

    % Measurement rows for this location (assumed: row1=mean, row2=err)
    plot_data = p_data.data(5*k-4:5*k-3,:);      % 2×15 array (3 freqs × 5 depths)
    Mean_data(1,15*k-14:15*k) = plot_data(1,:);  % collect means for evaluation

    for i = 1:length(f)
        ax = nexttile(tl, (k-1)*3 + i); ax_idx = ax_idx + 1; axs(ax_idx) = ax;

        % Soil EM params at this frequency
        [falpha, fbeta, er, ei] = MBSDM(mean(C), mean(VWC), f(i));

        % Models at continuous depths
        L_MFM = MFM(er, falpha, fbeta, dUG, f(i));
        L_PLM = WUSN_PLM(er, falpha, fbeta, dUG, f(i));

        % MLSPM along dUG and at measurement ds
        for j = 1:length(dUG)
            L_MLSPM(j) = MLSPMV3(VWC, C, Layer, dUG(j), f(i));
        end
        for j = 1:length(ds)
            L_MLSPMC(j) = MLSPMV3(VWC, C, Layer, ds(j),  f(i));
        end

        % Pack model samples at measurement depths for metrics
        idx = 15*k + 5*i - 19 : 15*k + 5*i - 15;   % 5 indices per freq-location
        MFM_data(1,  idx)   = MFM(er, falpha, fbeta, ds, f(i));
        PLM_data(1,  idx)   = WUSN_PLM(er, falpha, fbeta, ds, f(i));
        MLSPM_data(1, idx)  = L_MLSPMC;

        % ── Plot ───────────────────────────────────────────────────────────
        hold(ax,'on');
        p1 = plot(ax, dUG, L_MFM,   '-.', 'Color',[0 44 83]/255,     'DisplayName','MFM');
        p2 = plot(ax, dUG, L_PLM,   '--',  'Color',[12 132 198]/255, 'DisplayName','WUSN-PLM');
        p3 = plot(ax, dUG, L_MLSPM, '-',   'Color',[255 165 16]/255, 'DisplayName','MLSPM');

        mu    = plot_data(1,5*i-4:5*i);
        erbar = plot_data(2,5*i-4:5*i);
        p4 = errorbar(ax, ds, mu, erbar, 'x', 'MarkerSize',8, ...
            'Color',[247 77 77]/255, 'CapSize',8, 'LineStyle','none', ...
            'LineWidth',1.5, 'DisplayName','Measurement');

        % Titles on first row
        if k == 1
            title(ax, ttext(i), 'FontWeight','normal');
        end

        % Only show x tick labels on last row
        if k < num_location
            ax.XTickLabel = [];
        end

        % Row labels on first column; keep ticks on all, but hide y tick labels on columns 2–3
        if i == 1
            ylabel(ax, sprintf('L%d', k));      % row label
        else
            ax.YTickLabel = [];                 % keep ticks for grid, hide labels only
        end

        if ax_idx == 14
            xlabel(ax, 'Burial depth (m)', 'FontSize', font_size, 'FontWeight','bold');
        end


        % Grid on (both directions), draw grid behind data
        ax.XGrid = 'on';
        ax.YGrid = 'on';
        ax.Layer = 'top';

        % Turn full box off; draw selected borders manually
        box(ax,'off');
        hold(ax,'off');

        % Save handles for legend from the last tile
        if k == num_location && i == length(f)
            h1 = p1; h2 = p2; h3 = p3; h4 = p4;
        end
    end
end

% ── Shared axes (same limits) ──────────────────────────────────────────────
linkaxes(axs, 'xy');
xlim(axs(1), [min(dUG) max(dUG)]);
% Unify y-limits to global min/max among all subplots
ylims = arrayfun(@(a) a.YLim, axs, 'UniformOutput', false);
ylims = cat(1, ylims{:});
set(axs, 'YLim', [min(ylims(:,1)) max(ylims(:,2))]);

% ── Draw ONLY top & right borders for each axes (LineWidth = 1.5) ──────────
for ii = 1:numel(axs)
    ax = axs(ii);
    xl = xlim(ax); yl = ylim(ax);
    hold(ax,'on');
    % top boundary
    plot(ax, [xl(1) xl(2)], [yl(2) yl(2)], '-', ...
        'LineWidth',1.5, 'Color', ax.XColor, 'Clipping','off');
    % right boundary
    plot(ax, [xl(2) xl(2)], [yl(1) yl(2)], '-', ...
        'LineWidth',1.5, 'Color', ax.XColor, 'Clipping','off');
    hold(ax,'off');
end

% ── Create a single legend in the 'south' tile ────────────────────────────
lg = legend(...
    [h1,h2,h3,h4], ...
    {'MFM','WUSN-PLM','MLSPM','Measurement'}, ...
    'Orientation','horizontal', ...
    'Box','on', ...
    'FontSize', font_size);
lg.Layout.Tile = 'south';

%print(fig, 'All measurements.svg', '-dsvg');


% ── Model evaluation ───────────────────────────────────────────────────────
fprintf("Model Evaluation ...... \n");
[MFM_rmse,MFM_mae]     = Model_evaluation(MFM_data,Mean_data);
[PLM_rmse,PLM_mae]     = Model_evaluation(PLM_data,Mean_data);
[MLSPM_rmse,MLSPM_mae] = Model_evaluation(MLSPM_data,Mean_data);

fprintf("MFM   --- RMSE:%.2f MAE:%.2f \n", MFM_rmse, MFM_mae);
fprintf("PLM   --- RMSE:%.2f MAE:%.2f \n", PLM_rmse, PLM_mae);
fprintf("MLSPM --- RMSE:%.2f MAE:%.2f \n", MLSPM_rmse, MLSPM_mae);
