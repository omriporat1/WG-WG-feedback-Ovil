dat_workflow = readtable("C:\Users\Omri\Desktop\University\MSc\Manuscript\Figures\Discussion\sites_data_w_emb_len_slope_asym_2023_05_18.csv",'Format','auto');
dat_workflow = dat_workflow(:,{'site_name','WF_drainage_area','emb_length','antecedent_slope', 'antecedent_max_slope','antecedent_min_slope','divide_WF_distance','source','slope_asym_ind','slope_asym_ch_wf_remote','slope_max_asym_ch_wf_remote','slope_min_asym_ch_wf_remote','chi_diff','chi_norm_diff'});

dat_workflow.Properties.VariableNames = ["site_name","A_drain","L_embayment","slope_antecedent","slope_max_antecedent","slope_min_antecedent","L_divide_wf","source","slope_asym","remote_ch_wf_slope_asym","remote_ch_wf_max_slope_asym","remote_ch_wf_min_slope_asym","chi_asym","chi_norm_asym"];

dat_workflow_thresh_19 = dat_workflow; dat_workflow_thresh_19([1,2,4,5,8,16,17],:) = [];

%% Different correlations illustration for manuscript
figure(8)
t = tiledlayout(1,3,"TileSpacing","tight");

% Tile 1 - log drainage area vs. normalized asymmetry parameters

nexttile(t)
box on

current_data = dat_workflow_thresh_19;
y = current_data.A_drain; x1 = current_data.remote_ch_wf_slope_asym;
x_min = current_data.remote_ch_wf_min_slope_asym; x_max = current_data.remote_ch_wf_max_slope_asym;
% scatter(x1, y, 'filled','MarkerFaceColor', "#D95319");
grid on;
hold on
er = errorbar(x1, y, x1-x_min, x_max-x1,'.','horizontal');
er.Color = [0.8509, 0.3255, 0.0980];                            
er.LineWidth = 1.5;
er.MarkerSize = 20;


linearCoefficients = polyfit(x1, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x1);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
% px1 = [gca().XLim(1) gca().XLim(2)];
px1 = [0 1];
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, '--', 'LineWidth', 2, 'Color',"#D95319");
text(0.05,0.05,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#D95319", 'Units','normalized');
text(0.05,0.15,sprintf(' N = %.0f', numel(x1)), "Color","#D95319", 'Units','normalized');


current_data = dat_workflow_thresh_19;
y = current_data.A_drain; x2 = current_data.chi_norm_asym;
xlabel('normalized difference','FontSize',12,'FontWeight','bold');
ylabel('drainage area [m^2]','FontSize',12,'FontWeight','bold');
xlim([0 1]); set(gca, 'YScale', 'log');


scatter(x2, y, '^',"filled", 'MarkerFaceColor',"#0072BD");
xlim([0 1]); ylim([10 1e6]); set(gca, 'YScale', 'log');

linearCoefficients = polyfit(x2, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x2);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
px1 = [gca().XLim(1) gca().XLim(2)];
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, ':', 'LineWidth', 2,'Color',"#0072BD");
text(0.05,0.1,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#0072BD", 'Units','normalized');
text(0.05,0.2,sprintf(' N = %.0f', numel(x2)), "Color","#0072BD", 'Units','normalized');


legend('fluvial slope difference', '','Chi difference', '','Location','northeast');




% Tile 2 - drainage area vs. embayment length

nexttile(t)
box on;
current_data = dat_workflow;
y = current_data.A_drain; x1 = current_data.L_embayment;

% ylabel('drainage area [m^2]');
xlim([0 4000]); ylim([10 1e6]); set(gca, 'YScale', 'log');
hold on
grid on;
% xlabel('embayment length [m]'); 
xlabel('embayment length [m]','FontSize',12,'FontWeight','bold');


scatter(x1,y,'filled','MarkerFaceColor', "#D95319");
text(0.25,0.05,sprintf(' N = %.0f', numel(x1)), "Color","#D95319", 'Units','normalized');

% Tile 3 -  log drainage area vs. antecedent slope 

nexttile(t);
box on;
current_data = dat_workflow;
y = current_data.A_drain; x1 = current_data.slope_antecedent;

xlim([0 0.04]); ylim([10 1e6]); set(gca, 'YScale', 'log');
grid on;
hold on

% scatter(x1,y,'filled','MarkerFaceColor', "#D95319");
axis_state = gca;

x_min = current_data.slope_min_antecedent; x_max = current_data.slope_max_antecedent;
scatter(x1, y, 'filled','MarkerFaceColor', "#D95319");

% er = errorbar(x1, y, x1-x_min, x_max-x1,'.','horizontal');
% er.Color = [0.8509, 0.3255, 0.0980];                            
% er.LineWidth = 1.5;
% er.MarkerSize = 20;



linearCoefficients = polyfit(x1, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x1);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, '--', 'LineWidth', 2, 'Color',"#D95319");
text(0.05,0.05,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#D95319", 'Units','normalized');
text(0.05,0.1,sprintf(' N = %.0f', numel(x1)), "Color","#D95319", 'Units','normalized');
axis(axis_state);
xlabel('antecedent slope [m/m]','FontSize',12,'FontWeight','bold');

%% Different correlations with wf-div distance for SM
figure(6)
t = tiledlayout(1,3,"TileSpacing","tight");

% Tile 1 - log div-wf vs. normalized asymmetry parameters

nexttile(t)
box on

current_data = dat_workflow_thresh_19;
y = current_data.L_divide_wf; x1 = current_data.remote_ch_wf_slope_asym;
x_min = current_data.remote_ch_wf_min_slope_asym; x_max = current_data.remote_ch_wf_max_slope_asym;
% scatter(x1, y, 'filled','MarkerFaceColor', "#D95319");
grid on;
hold on
er = errorbar(x1, y, x1-x_min, x_max-x1,'.','horizontal');
er.Color = [0.8509, 0.3255, 0.0980];                            
er.LineWidth = 1.5;
er.MarkerSize = 20;


linearCoefficients = polyfit(x1, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x1);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
% px1 = [gca().XLim(1) gca().XLim(2)];
px1 = [0 1];
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, '--', 'LineWidth', 2, 'Color',"#D95319");
text(0.05,0.05,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#D95319", 'Units','normalized');
text(0.05,0.15,sprintf(' N = %.0f', numel(x1)), "Color","#D95319", 'Units','normalized');


current_data = dat_workflow_thresh_19;
y = current_data.L_divide_wf; x2 = current_data.chi_norm_asym;
xlabel('normalized difference','FontSize',12,'FontWeight','bold');
ylabel('divide-waterfall distance [m]','FontSize',12,'FontWeight','bold');
xlim([0 1]); set(gca, 'YScale', 'log');


scatter(x2, y, '^',"filled", 'MarkerFaceColor',"#0072BD");
xlim([0 1]); ylim([4 2e3]); set(gca, 'YScale', 'log');

linearCoefficients = polyfit(x2, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x2);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
px1 = [gca().XLim(1) gca().XLim(2)];
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, ':', 'LineWidth', 2,'Color',"#0072BD");
text(0.05,0.1,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#0072BD", 'Units','normalized');
text(0.05,0.2,sprintf(' N = %.0f', numel(x2)), "Color","#0072BD", 'Units','normalized');


legend('fluvial slope difference', '','Chi difference', '','Location','northeast');




% Tile 2 - log div-wf distance vs. embayment length

nexttile(t)
box on;
current_data = dat_workflow;
y = current_data.L_divide_wf; x1 = current_data.L_embayment;

% ylabel('drainage area [m^2]');
xlim([0 4000]); ylim([4 2e3]); set(gca, 'YScale', 'log');
hold on
grid on;
% xlabel('embayment length [m]'); 
xlabel('embayment length [m]','FontSize',12,'FontWeight','bold');


scatter(x1,y,'filled','MarkerFaceColor', "#D95319");
text(0.25,0.05,sprintf(' N = %.0f', numel(x1)), "Color","#D95319", 'Units','normalized');

% Tile 3 -  log div-wf disance vs. antecedent slope 

nexttile(t);
box on;
current_data = dat_workflow;
y = current_data.L_divide_wf; x1 = current_data.slope_antecedent;

xlim([0 0.04]); ylim([4 2e3]); set(gca, 'YScale', 'log');
grid on;
hold on

% scatter(x1,y,'filled','MarkerFaceColor', "#D95319");
axis_state = gca;

x_min = current_data.slope_min_antecedent; x_max = current_data.slope_max_antecedent;
scatter(x1, y, 'filled','MarkerFaceColor', "#D95319");

% er = errorbar(x1, y, x1-x_min, x_max-x1,'.','horizontal');
% er.Color = [0.8509, 0.3255, 0.0980];                            
% er.LineWidth = 1.5;
% er.MarkerSize = 20;



linearCoefficients = polyfit(x1, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x1);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, '--', 'LineWidth', 2, 'Color',"#D95319");
text(0.05,0.05,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#D95319", 'Units','normalized');
text(0.05,0.1,sprintf(' N = %.0f', numel(x1)), "Color","#D95319", 'Units','normalized');
axis(axis_state);
xlabel('antecedent slope [m/m]','FontSize',12,'FontWeight','bold');