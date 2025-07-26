sites_table_w_field_channelheads = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\sites_data_for_profile_struct_19m_thresh_2023_09_21.csv');

[ST_table,sites_ST_coord_struct] = extract_site_trunk_table(sites_table_w_field_channelheads);
%%
DEM = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\Clifflines\MAPI_cut_wider_150cm.tif');

sites_table_w_field_channelheads = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\sites_data_for_profile_struct_19m_thresh_2023_05_12.csv');
ST_table = load('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\STREAMobj_remote_19m_2023_05_12.mat').ST_table;
sites_ST_coord_struct = load('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\Stream_coords_19m_2023_05_12.mat').sites_ST_coord_struct;
sites_table_w_field_channelheads.site_name = erase(sites_table_w_field_channelheads.site_name,'"');

% sites_table_w_field_channelheads = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\sites_data_for_profile_struct_19m_thresh_2023_09_21.csv');
% ST_table = load('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\STREAMobj_remote_19m_2023_09_21.mat').ST_table;
% sites_ST_coord_struct = load('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\Stream_coords_19m_2023_09_21.mat').sites_ST_coord_struct;
% sites_table_w_field_channelheads.site_name = erase(sites_table_w_field_channelheads.site_name,'"');
%%

% ST_table_orig = ST_table;
% sites_ST_coord_struct_orig = sites_ST_coord_struct;
% store1 = ST_table(3:4,:).cl;
% ST_table(3:4,:).cl = ST_table(3:4,:).hl;
% ST_table(3:4,:).hl = store1;
% store1 = sites_ST_coord_struct(3).cl;
% sites_ST_coord_struct(3).cl = sites_ST_coord_struct(3).hl;
% sites_ST_coord_struct(3).hl = store1;
% store1 = sites_ST_coord_struct(4).cl;
% sites_ST_coord_struct(4).cl = sites_ST_coord_struct(4).hl;
% sites_ST_coord_struct(4).hl = store1;

% ST_table_orig = ST_table;
% sites_ST_coord_struct_orig = sites_ST_coord_struct;
% store1 = ST_table(3,:).cl;
% ST_table(3,:).cl = ST_table(3,:).hl;
% ST_table(3,:).hl = store1;
% store1 = sites_ST_coord_struct(3).cl;
% sites_ST_coord_struct(3).cl = sites_ST_coord_struct(3).hl;
% sites_ST_coord_struct(3).hl = store1
%%
figure
imageschs(DEM,[],'colormap',[1 1 1],'colorbar',false);
% [num_sites,~] = size(sites_ST_coord_struct);
[~,num_sites] = size(sites_ST_coord_struct);

hold on
for i = 1:num_sites
    scatter(sites_ST_coord_struct(i).cl.x,sites_ST_coord_struct(i).cl.y,'.r');
    scatter(sites_ST_coord_struct(i).hl.x,sites_ST_coord_struct(i).hl.y,'.b');
end
axis equal

%%
figure
imageschs(DEM,[],'colormap',[1 1 1],'colorbar',false);
% [num_sites,~] = size(sites_ST_coord_struct);
[~,num_sites] = size(sites_ST_coord_struct);

hold on
for i = 1:num_sites
    plot(ST_table.cl{i},'.b')
    plot(ST_table.hl{i},'.r')
%     scatter(sites_ST_coord_struct(i).cl.x,sites_ST_coord_struct(i).cl.y,'.r');
%     scatter(sites_ST_coord_struct(i).hl.x,sites_ST_coord_struct(i).hl.y,'.b');
end
axis equal

%%
ch_ratio = 0.7;
sites_ST_coord_struct_vert = sites_ST_coord_struct';

[ch_cl_table,ch_hl_table] = create_channelhead_table(sites_table_w_field_channelheads,sites_ST_coord_struct_vert,ch_ratio); %later remove specification


scatter(ch_cl_table,'x','y','filled');

scatter(ch_hl_table,'x','y','filled');
scatter(sites_table_w_field_channelheads.ch_cliff_X(sites_table_w_field_channelheads.ch_cliff_X>0),sites_table_w_field_channelheads.ch_cliff_Y(sites_table_w_field_channelheads.ch_cliff_X>0),'*')
scatter(sites_table_w_field_channelheads.ch_highland_X(sites_table_w_field_channelheads.ch_highland_X>0),sites_table_w_field_channelheads.ch_highland_Y(sites_table_w_field_channelheads.ch_highland_X>0),'*')

%%
Z_RMSE = 0.2396484;
asym_table = calculate_norm_slope(sites_ST_coord_struct_vert,ch_cl_table,ch_hl_table,Z_RMSE);

%%
mn_ratio = 0.25;
A0 = 1e6;
ST_table_equal_height = upslope_to_min(sites_table_w_field_channelheads,ST_table);




chi_table = calculate_norm_chi(sites_table_w_field_channelheads,ST_table_equal_height,ch_cl_table,ch_hl_table, mn_ratio, A0);
asym_table.lower_ch_chi_asym = chi_table(:,1);
asym_table.lower_ch_norm_chi_asym = chi_table(:,2);

%%
create_profiles_figure(sites_ST_coord_struct_vert,ch_cl_table,ch_hl_table,asym_table,sites_table_w_field_channelheads);


%%
window = 40;
[test_data_struct_cl,test_data_struct_hl] = calculate_plot_dz_dchi(sites_table_w_field_channelheads,ST_table_equal_height, mn_ratio,A0,window);

%%
figure
tiledlayout(3,2)

    for site_ind = 1:num_sites % calculate the derivative for each site
        
                % Extract data for the current site
        distance_cl = test_data_struct_cl(site_ind).distance;
        chi_cl = test_data_struct_cl(site_ind).chi;
        z_cl = test_data_struct_cl(site_ind).z;
        derivative_cl = test_data_struct_cl(site_ind).deriv;

        distance_hl = test_data_struct_hl(site_ind).distance;
        chi_hl = test_data_struct_hl(site_ind).chi;
        z_hl = test_data_struct_hl(site_ind).z;
        derivative_hl = test_data_struct_hl(site_ind).deriv;
        
        if max(distance_cl) > 100
            nexttile;
            hold on;
%         scatter(distance_cl, z_cl, 20, chi_cl, 'filled');
%         scatter(distance_hl, z_hl, 20, chi_hl, 'filled');

            ylabel('Altitude [m]');
%         c = colorbar;
%         clim([ min([chi_cl;chi_hl]) , max([chi_cl;chi_hl]) ]);
%         ylabel(c, 'Chi Values');
%         colormap("jet");
            plot(distance_cl, z_cl, '-.','Color', [0 0 1 0.5],'LineWidth',3);
            plot(distance_hl, z_hl,'-.','Color', [1 0 0 0.5],'LineWidth',3);
            xlim([0 1500])
            % Plot the derivative as a function of distance
            yyaxis right;
            ax = gca;
            plot(distance_cl(4:end-3), derivative_cl(4:end-3), '-','Color', [0 0 1], 'LineWidth',1.5);
            plot(distance_hl(4:end-3), derivative_hl(4:end-3), '-','Color', [1 0 0], 'LineWidth',1.5);
            
%             h = findobj(ax, 'Type', 'Line');  % Get all lines in the current axes
%             set(h(1:2), 'Color', [0 0 1 0.5]); % Adjust the first two lines' transparency

            set(ax,'YScale','log');
            ylim(ax,[0.0001,1]);
            ylabel('dZ/dχ');
%             ylabel('\chi Label', 'Interpreter', 'latex');

            ax.YColor = 'k';
            title([string(sites_table_w_field_channelheads.site_name(site_ind))]);
            xlabel('Distance from waterfall [m]');
            legend('cliff channel', 'highland channel', 'dZ/dχ cliff channel', 'dZ/dχ highland channel', 'Location','southeast');
        end
    end
%%

figure
tiledlayout(5,2)

    for site_ind = 1:num_sites % calculate the derivative for each site
        nexttile;
                % Extract data for the current site
        distance_cl = test_data_struct(site_ind).distance;
        chi_cl = test_data_struct(site_ind).chi;
        z_cl = test_data_struct(site_ind).z;
        derivative_cl = test_data_struct(site_ind).deriv;

        % Plot the derivative as a function of distance
        plot(chi_cl, z_cl, 'r', 'LineWidth',1);
        ylabel('z [mASL]');
        xlabel('Chi');
        title([string(sites_table_w_field_channelheads.site_name(site_ind))]);
       
    end


%%



p = polyfit(asym_table.ch_wf_norm_slope, asym_table.lower_ch_norm_chi_asym, 1);   % Returns coefficients for a first-degree polynomial

% Calculate R-squared value
r = corrcoef(asym_table.ch_wf_norm_slope, asym_table.lower_ch_norm_chi_asym);
r2 = r(1,2)^2;

% Plot data and regression line
figure;
scatter(asym_table.ch_wf_norm_slope, asym_table.lower_ch_norm_chi_asym,'filled');
hold on;
xlabel('slope'); ylabel('Chi');
axis([0 1 0 1]);
plot(xlim(), polyval(p, xlim()), 'r');

% Add equation and R-squared value to plot
eqn = sprintf('y = %.2fx + %.2f', p(1), p(2));
r2txt = sprintf('R^2 = %.2f', r2);
text(0.1, 0.8, eqn, 'Color', 'r');
text(0.1, 0.7, r2txt, 'Color', 'r');


%%
figure
scatter(asym_table,{'div_ch_norm_slope','ch_wf_norm_slope'},'lower_ch_norm_chi_asym','filled')
grid on
hold on
axis equal
xlim([-1 1])
ylim([-1 1])
% plot([-1 1], [-1 1],'--','LineWidth',3)
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

x_label = xlabel('normalized slope difference')
y_label = ylabel('normalized \chi difference')

y_label.Rotation = 270

y_label.VerticalAlignment = 'bottom'
box on
legend('divide-channelhead', 'channelhead-waterfall','Location','southeast')
