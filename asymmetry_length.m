dat_workflow = readtable("C:\Users\Omri\Desktop\University\MSc\Manuscript\Figures\Discussion\sites_data_w_emb_len_slope_asym_2023_05_18.csv",'Format','auto');
dat_workflow = dat_workflow(:,{'site_name','WF_drainage_area','emb_length','antecedent_slope', 'antecedent_max_slope','antecedent_min_slope','divide_WF_distance','source','slope_asym_ind','slope_asym_ch_wf_remote','slope_max_asym_ch_wf_remote','slope_min_asym_ch_wf_remote','chi_diff','chi_norm_diff'});

dat_workflow.Properties.VariableNames = ["site_name","A_drain","L_embayment","slope_antecedent","slope_max_antecedent","slope_min_antecedent","L_divide_wf","source","slope_asym","remote_ch_wf_slope_asym","remote_ch_wf_max_slope_asym","remote_ch_wf_min_slope_asym","chi_asym","chi_norm_asym"];

dat_workflow_thresh_19 = dat_workflow; dat_workflow_thresh_19([1,2,4,5,8,16,17],:) = [];

%% Different correlations illustration for manuscript

figure(4)
box on
xlabel('normalized difference','FontSize',12,'FontWeight','bold');
ylabel('divide-waterfall distance [m]','FontSize',12,'FontWeight','bold');
xlim([0 1]); ylim([10 1500]);
set(gca, 'YScale', 'log');
grid on;
hold on
% Tile 1 - divide-waterfall distancevs. normalized asymmetry parameters
% current_data = dat_field_small;


current_data = dat_workflow_thresh_19;
y = current_data.L_divide_wf; x1 = current_data.remote_ch_wf_slope_asym;
scatter(x1, y, 'filled','MarkerFaceColor', "#D95319");
er = errorbar(x1, y, x1-x_min, x_max-x1,'.','horizontal');
er.Color = [0.8509, 0.3255, 0.0980];                            
er.LineWidth = 1.5;
er.MarkerSize = 20;


linearCoefficients = polyfit(x1, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x1);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
px1 = [gca().XLim(1) gca().XLim(2)];
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, '--', 'LineWidth', 2, 'Color',"#D95319");
text(0.05,0.15,sprintf(' N = %.0f', numel(x1)), "Color","#D95319", 'Units','normalized');
text(0.05,0.05,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#D95319", 'Units','normalized');


% legend('Chi difference', '','Remote slope difference', '','div-ch slope difference', '','ch-wf slope difference', '','Location','northeast');



current_data = dat_workflow_thresh_19;
y = current_data.L_divide_wf; x1 = current_data.chi_norm_asym;


scatter(x1, y, '^', 'filled','MarkerFaceColor',"#0072BD");

linearCoefficients = polyfit(x1, log10(y), 1);          % Coefficients
yfit = polyval(linearCoefficients, x1);          % Estimated  Regression Line
SStot = sum((log10(y)-mean(log10(y))).^2);                    % Total Sum-Of-Squares
SSres = sum((log10(y)-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2
px1 = [gca().XLim(1) gca().XLim(2)];
py1 = 10.^polyval(linearCoefficients, px1);
plot(px1, py1, ':', 'LineWidth', 2,'Color',"#0072BD");
text(0.05,0.1,sprintf(' y = %.2fx + %.2f, R^2 = %.2f', linearCoefficients(1), linearCoefficients(2), Rsq), "Color","#0072BD", 'Units','normalized');
text(0.05,0.2,sprintf(' N = %.0f', numel(x1)), "Color","#0072BD", 'Units','normalized');
legend('fluvial slope difference', '','Chi difference', '','Location','northeast');
legend('', 'fluvial slope difference','', 'Chi difference','','Location','northeast');
