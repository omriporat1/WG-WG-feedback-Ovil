% close all
minarea = 10000;

DEM = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\DEMc_raw.tif');
resolution = DEM.cellsize;
DEM = fillsinks(DEM);
FD = FLOWobj(DEM);
ST = STREAMobj(FD,'minarea',minarea/(resolution^2));

ST_150 = load('C:\Users\Omri\Desktop\University\MSc\Matlab\cliff_reconstruction\ST_150.mat');
ST_150 = ST_150.ST_150;

% read dGPS waterfalls XYZ data
WF_XYZ = xlsread('C:\Users\Omri\Desktop\University\MSc\Fieldwork\waterfalls_and_contacts_2022_08_09-15_17_manual.xlsx');
WF_X = WF_XYZ(:,2);
WF_Y = WF_XYZ(:,3);
WF_Z = WF_XYZ(:,4);

% read fan XYZ data
fan_XYZ = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\cliff_reconstruction\Fan4.csv');
fan_X = fan_XYZ(2:end,2);
fan_Y = fan_XYZ(2:end,3);
fan_Z = fan_XYZ(2:end,4);

% zlimits = [min(DEM.Z(:)) max(DEM.Z(:))];
zlimits = [320 520];


% fig = figure;
% fig.WindowState = 'maximized';

xl = [6.81e5 6.89e5]; yl = [3.3463e6 3.351e6];

X_grid = linspace(xl(1),xl(2),1000);
Y_grid = linspace(yl(1),yl(2),1000);
[X_coords,Y_coords] = meshgrid(X_grid,Y_grid);


% subplot(3,3,1)
figure

scatter3(WF_X,WF_Y,WF_Z)
hold on
scatter3(fan_X,fan_Y,fan_Z)


[sf_WF,gof_WF] = fit([WF_X,WF_Y],WF_Z,'poly11');

options = fitoptions('Method', 'LinearLeastSquares', 'Robust', 'LAR'); % specify fit options to improve r^2
[sf_fan,gof_fan] = fit([fan_X,fan_Y],fan_Z,'poly22', options); % fit a 2nd order polynom 
% [sf_fan,gof_fan] = fit([fan_X,fan_Y],fan_Z,'poly11'); % fit a 1st order polynom (plane)





% % trial to test bounds
% coefficientValues_fan = coeffvalues(sf_fan);
% % fan_plot = plot(sf_fan,[fan_X, fan_Y],fan_Z, 'Style','predfunc');
% ci_fan = confint(sf_fan,0.95);
% ci_fan_min = ci(1,:);
% ci_fan_max = ci(2,:);
% f_fan = @(x,y) coefficientValues_fan(1) + coefficientValues_fan(2).*x + coefficientValues_fan(3).*y + coefficientValues_fan(4).*x.^2 + coefficientValues_fan(5).*x.*y + coefficientValues_fan(6).*y.^2;
% f_fan_min = @(x,y) ci_fan_min(1) + ci_fan_min(2).*x + ci_fan_min(3).*y + ci_fan_min(4).*x.^2 + ci_fan_min(5).*x.*y + ci_fan_min(6).*y.^2;
% f_fan_max = @(x,y) ci_fan_max(1) + ci_fan_max(2).*x + ci_fan_max(3).*y + ci_fan_max(4).*x.^2 + ci_fan_max(5).*x.*y + ci_fan_max(6).*y.^2;
% 
p11 = predint(sf_fan,[reshape(X_coords,[],1),reshape(Y_coords,[],1)],0.95,'observation','off');
% % fan_min_plot = plot3(reshape(X_coords,[],1),reshape(Y_coords,[],1),p11(:,2));
fan_min_Z_mat = reshape(p11(:,1),[],1000);
fan_max_Z_mat = reshape(p11(:,2),[],1000);

fan_min_surf = surface(X_coords,Y_coords,fan_min_Z_mat,'FaceAlpha',0.3);
fan_min_surf.EdgeColor = 'none';
fan_min_surf.FaceColor = 'g';


fan_max_surf = surface(X_coords,Y_coords,fan_max_Z_mat,'FaceAlpha',0.3);
fan_max_surf.EdgeColor = 'none';
fan_max_surf.FaceColor = 'g';

WF_plot = plot(sf_WF,[WF_X, WF_Y],WF_Z);
WF_plot(1).FaceColor = 'k';
WF_plot(1).FaceAlpha = 0.2;
WF_plot(1).EdgeAlpha = 0;
WF_plot(2).MarkerFaceColor = 'k';
hold on

fan_plot = plot(sf_fan,[fan_X, fan_Y],fan_Z);
fan_plot(1).FaceColor = 'b';
fan_plot(1).FaceAlpha = 0.4;
fan_plot(1).EdgeAlpha = 0;
fan_plot(2).MarkerFaceColor = [0.4940 0.1840 0.5560];

% surface(reshape(X_coords, [], 1),reshape(Y_coords, [],1),p11(:,1), 'FaceColor','flat');
% end of trial section


% fan_plot = plot(sf_fan,[fan_X, fan_Y],fan_Z);
% fan_plot(1).FaceColor = 'b';
% fan_plot(1).FaceAlpha = 0.4;
% fan_plot(1).EdgeAlpha = 0;
% fan_plot(2).MarkerFaceColor = 'b';

xlabel('X'); ylabel('Y'); zlabel('Z');

f_WF = @(x,y) sf_WF.p00 + sf_WF.p10.*x + sf_WF.p01.*y;

% these two lines enable first or second order polynomial:
% f_fan = @(x,y) sf_fan.p00 + sf_fan.p10*x + sf_fan.p01*y;
f_fan = @(x,y) sf_fan.p00 + sf_fan.p10.*x + sf_fan.p01.*y + sf_fan.p20.*x.^2 + sf_fan.p11.*x.*y + sf_fan.p02.*y.^2;





Z_fan_grid = f_fan(X_coords,Y_coords);
Z_WF_grid = f_WF(X_coords,Y_coords);

% Z_fan_grid_min = f_fan_min(X_coords,Y_coords);
% Z_fan_grid_max = f_fan_max(X_coords,Y_coords);



Z_diff = Z_fan_grid-Z_WF_grid;
Z_diff_min = fan_min_Z_mat-Z_WF_grid;
Z_diff_max = fan_max_Z_mat-Z_WF_grid;



% surface(X_coords,Y_coords,abs(Z_diff));
C = contours(X_coords,Y_coords,Z_diff, [0 0]);
xL = C(1, 2:end);
yL = C(2, 2:end);
zL = interp2(X_coords,Y_coords, Z_WF_grid, xL, yL);

% scatter3(xL, yL, zL, 'k', 'filled');
line(xL, yL, zL, 'Color', 'b', 'LineWidth', 3);


% min surface:
% surface(X_coords,Y_coords,abs(Z_diff));
C_min = contours(X_coords,Y_coords,Z_diff_min, [0 0]);
xL_min = C_min(1, 2:end);
yL_min = C_min(2, 2:end);
zL_min = interp2(X_coords,Y_coords, Z_WF_grid, xL_min, yL_min);

% scatter3(xL, yL, zL, 'k', 'filled');
line(xL_min, yL_min, zL_min, 'Color', 'g', 'LineWidth', 3);
% end min surface

% max surface:
% surface(X_coords,Y_coords,abs(Z_diff));
C_max = contours(X_coords,Y_coords,Z_diff_max, [0 0]);
xL_max = C_max(1, 2:end);
yL_max = C_max(2, 2:end);
zL_max = interp2(X_coords,Y_coords, Z_WF_grid, xL_max, yL_max);

% scatter3(xL, yL, zL, 'k', 'filled');
line(xL_max, yL_max, zL_max, 'Color', 'g', 'LineWidth', 3);
% end max surface

% activate for background
% imageschs(DEM); 
% view(2)
ylim(yl); xlim(xl);
% zlim(zl)
title('Present waterfalls and fan surface intersection');
% legend('','', 'Present waterfalls - 1^{st} degree polynomial', 'fan - 2^{nd} degree polynomial', 'surfaces intersection', 'Location','northeast');
legend('','','fan 95%-confidence bounds','','waterfall lip','fan','fan - waterfall surfaces intersection','fan 95%-confidence bounds - waterfall surfaces intersection','', 'Location','northeast');



% original figure - 3D

% figure
% % ax(2) = subplot(3,3,[2:3, 5:6, 8:9]);
% scatter3(WF_X,WF_Y,WF_Z, 'k','filled','MarkerEdgeColor','w')
% hold on
% fan_scatter = scatter3(fan_X,fan_Y,fan_Z,'b','filled','MarkerEdgeColor','w');
% fan_scatter.MarkerFaceColor = [0.4940 0.1840 0.5560];
% plot(ST_150,'color','b')
% 
% xlabel('X'); ylabel('Y'); zlabel('Z');
% 
% line(xL, yL, zL, 'Color', 'b', 'LineWidth', 3);
% line(xL_min, yL_min, zL_min, 'Color', 'g', 'LineWidth', 3);
% line(xL_max, yL_max, zL_max, 'Color', 'g', 'LineWidth', 3);
% 
% % activate for background
% imageschs(DEM,[], 'colormap','landcolor','colorbar',true,'colorbarylabel','Elevation [m]');
% grid on
% % colormap(ax(2),landcolor); 
% % colorbar
% view(2)
% ylim(yl); xlim(xl);
% % zlim(zl)
% % sf_fan_string = string(evalc('sf_fan'));
% % gof_fan_string = string(evalc('gof_fan'));
% 
% sf_fan_string = evalc("sf_fan");
% sf_fan_string(1:6) = [];
% sf_fan_string(end-1:end) = [];
% 
% gof_fan_string = evalc("gof_fan");
% gof_fan_string(1:100) = [];
% gof_fan_string(end-1:end) = [];
% 
% text(min(xlim), max(ylim), sf_fan_string, 'Horiz','left', 'Vert','top', 'Interpreter', 'none', 'BackgroundColor','w')
% text(max(xlim), min(ylim), gof_fan_string, 'Horiz','right', 'Vert','bottom','BackgroundColor','w')
% 
% % title('Present waterfalls and fan surface intersection');
% legend('Present waterfalls', 'fan', 'channels','surfaces intersection','fan 95%-confidence bounds','Location','northeast');



% figure 2D
% ax(2) = subplot(3,3,[2:3, 5:6, 8:9]);
fig1 = figure;

imageschs(DEM,[], 'colormap','landcolor','colorbar',true,'colorbarylabel','Elevation [m]');
hold on
wf_scatter = scatter(WF_X,WF_Y, 'k','filled','MarkerEdgeColor','w','DisplayName','present waterfalls');
fan_scatter = scatter(fan_X,fan_Y,'b','filled','MarkerEdgeColor','w', 'DisplayName','fan sampling points');
fan_scatter.MarkerFaceColor = [0.4940 0.1840 0.5560];
channel_plot = plot(ST_150,'color','b','DisplayName','channel');

% xlabel('X'); ylabel('Y');


% intersection lines:
intersection_line = line(xL, yL, 'Color', 'b', 'LineWidth', 3,'DisplayName','fan - waterfalls intersection');
confidence_095_line = line(xL_min, yL_min, 'Color', 'g', 'LineWidth', 3,'DisplayName','fan - waterfalls intersection 0.95% confidence');
line(xL_max, yL_max, 'Color', 'g', 'LineWidth', 3);

% activate for background

% grid on
% colormap(ax(2),landcolor); 
% colorbar
% view(2)
xl4 = [6.81 6.85].*1e5; yl4 = [3.3463 3.3488].*1e6;
ylim(yl4); xlim(xl4);
% zlim(zl)
% sf_fan_string = string(evalc('sf_fan'));
% gof_fan_string = string(evalc('gof_fan'));

sf_fan_string = evalc("sf_fan");
sf_fan_string(1:6) = [];
sf_fan_string(end-1:end) = [];

gof_fan_string = evalc("gof_fan");
gof_fan_string(1:100) = [];
gof_fan_string(end-1:end) = [];

% text(min(xlim), max(ylim), sf_fan_string, 'Horiz','left', 'Vert','top', 'Interpreter', 'none', 'BackgroundColor','w')
% text(max(xlim), min(ylim), gof_fan_string, 'Horiz','right', 'Vert','bottom','BackgroundColor','w')

% title('Present waterfalls and fan surface intersection');

sz_ant = [70 30 30]; C_ant = [0 1 1; 1 1 0; 1 1 0];
X_ant_F1 = [684407; 684153; 684542]; Y_ant_WF1 = [3348280; 3348510; 3348130];
X_ant_F2_25 = [683041; 682918; 683147]; Y_ant_WF2_25 = [3347180; 3347440; 3347030];
X_ant_F2_33 = [683591; 683593.1148; 683633]; Y_ant_WF2_33 = [3347900; 3348037.866; 3347640];
X_ant_F4 = [682818; 682803; 682806]; Y_ant_WF4 = [3347860; 3347910; 3347820];

antecedent_scatter_F1 = scatter(X_ant_F1,Y_ant_WF1,sz_ant,C_ant,'filled','o','DisplayName','reconstructed antecedent waterfall locations');
antecedent_scatter_F2_25 = scatter(X_ant_F2_25,Y_ant_WF2_25,sz_ant,C_ant,'filled','o','DisplayName','reconstructed antecedent waterfall locations');
antecedent_scatter_F2_33 = scatter(X_ant_F2_33,Y_ant_WF2_33,sz_ant,C_ant,'filled','o','DisplayName','reconstructed antecedent waterfall locations');
antecedent_scatter_F4 = scatter(X_ant_F4,Y_ant_WF4,sz_ant,C_ant,'filled','o','DisplayName','reconstructed antecedent waterfall locations');



% legend('Present waterfalls', 'fan', 'channels','surfaces intersection','fan 95%-confidence bounds','Location','northwest');
% legend([wf_scatter fan_scatter channel_plot intersection_line confidence_095_line antecedent_scatter_F4], 'location','northwest');
legend([wf_scatter fan_scatter antecedent_scatter_F1], 'location','northwest');

% prep_fig(fig1,6.836e5,3.3473e6,'northeast','Fan4_prep_fig_2D_c','C:\Users\Omri\Desktop\University\MSc\MSc_Thesis\Figures by chapter\4 Methods\')

%%
fan_fit_Z = sf_fan(fan_X,fan_Y);
fan_fit_res = fan_Z - fan_fit_Z;

% figure
subplot(3,3,4)

plot(sf_fan,[fan_X,fan_Y],fan_Z, 'Style','Residuals')

title('fan surface Residuals [m] - 3D')
xlabel('X'); ylabel('Y'); zlabel('Z residual');

% figure
subplot(3,3,7)

scatter3(fan_X,fan_Y,fan_fit_res,20,fan_fit_res,'filled');
axis equal
h = colorbar;
set(get(h,'label'),'string','Residual [m]');
view(2)
title('fan surface residuals [m] - 2D')
% get(gca,'DataAspectRatio')


sgtitle('\bf Fan 1 - 2^{nd} Degree Polynomial') 

%%
syms z1 x1 y1
eqn_WF = sf_WF.p00+sf_WF.p10*x1+sf_WF.p01*y1==z1;

% change for different fits:
% eqn_fan = sf_fan.p00+sf_fan.p10*x1+sf_fan.p01*y1==z1; % linear fit (poly11)
eqn_fan = sf_fan.p00 + sf_fan.p10*x1 + sf_fan.p01*y1 + sf_fan.p20*x1^2 + sf_fan.p11*x1*y1 + sf_fan.p02*y1^2 == z1;

eqns = [eqn_WF, eqn_fan];
[x_sol, z_sol] = solve(eqns,[x1 z1],'Real',true);
sol1 = [x_sol(1);z_sol(1)];
sol2 = [x_sol(2);z_sol(2)];

Y_intersect1 = linspace(yl(1), yl(2),500);
X_intersect1 = double(subs(x_sol(2),y1,Y_intersect1));
Z_intersect1 = double(subs(z_sol(2),y1,Y_intersect1));

X_intersect2 = double(subs(x_sol(1),y1,Y_intersect1));
Z_intersect2 = double(subs(z_sol(1),y1,Y_intersect1));

scatter3(X_intersect1,Y_intersect1,Z_intersect1, 'k', 'filled');
scatter3(X_intersect2,Y_intersect1,Z_intersect2, 'g', 'filled');
ylim(yl); xlim(xl);


% activate for background
imageschs(DEM); 
view(2)
ylim(yl); xlim(xl);
% zlim(zl)
title('Linear fit');

%%
fan_fit_Z = sf_fan(fan_X,fan_Y);
fan_fit_res = fan_Z - fan_fit_Z;

figure

plot(sf_fan,[fan_X,fan_Y],fan_Z, 'Style','Residuals')

title('Residuals [m]')
xlabel('X'); ylabel('Y'); zlabel('Z residual');

figure
scatter3(fan_X,fan_Y,fan_fit_res,20,fan_fit_res,'filled');
colorbar
view(2)
title('residuals [m]')

%% difference method to find the intersection of the fan and the contact
X_grid = linspace(xl(1),xl(2),1000);
Y_grid = linspace(yl(1),yl(2),1000);
[X_coords,Y_coords] = meshgrid(X_grid,Y_grid);

figure
Z_fan_grid = f_fan(X_coords,Y_coords);
Z_WF_grid = f_WF(X_coords,Y_coords);

surface(X_coords,Y_coords,Z_fan_grid, 'FaceColor', [0.5 1.0 0.5], 'EdgeColor', 'none');
surface(X_coords,Y_coords,Z_WF_grid, 'FaceColor', [1.0 0.5 0.0], 'EdgeColor', 'none');

% view(3); 
camlight; axis vis3d
hold on
Z_diff = Z_fan_grid-Z_WF_grid;
% surface(X_coords,Y_coords,abs(Z_diff));
C = contours(X_coords,Y_coords,Z_diff, [0 0]);
xL = C(1, 2:end);
yL = C(2, 2:end);
zL = interp2(X_coords,Y_coords, Z_WF_grid, xL, yL);

scatter3(xL, yL, zL, 'k');


