%% find minimum point (excluding edges) along all divide sections in DEM

DEM_path = 'C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\cropped_DEM_MAPI\19.tif';
min_area = 10000; height_axis = [450 500];

% sites_table  = cell2table(cell(0,13), 'VariableNames', {'site_name','DEM_path','min_area','site_ind','divide X', 'divide Y', 'divide Z','WF X', 'WF Y', 'WF Z', 'WF drainage area','divide - WF distance', 'antecedent slope'});
sites_table = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\sites_data.csv');

[Div,Div_cell,wg_table] = map_all_divides_and_windgaps(DEM_path,min_area,height_axis);
%% analyze specific divide based on the map created by previous section, and add it to data table
site_ind = 319;
site_name = "S19_n1";

[site_dat,ST_2_trunks] = site_remote_analysis(DEM_path,wg_table,Div,Div_cell,site_ind);

t = table2cell(wg_table(site_ind, 3:5));
[current_div_X, current_div_Y, current_div_Z] = deal(t{:});

t = num2cell(site_dat(4:9));
[kp_X, kp_y, kp_z, A_drain,d_wf_dist,antec_slope] = deal(t{:});

current_site_table = table(site_name, string(DEM_path), min_area, site_ind, current_div_X, current_div_Y, current_div_Z, kp_X, kp_y, kp_z, A_drain,d_wf_dist,antec_slope,...
    'VariableNames', {'site_name','DEM_path','min_area','site_ind','divide_X', 'divide_Y', 'divide_Z','WF_X', 'WF_Y', 'WF_Z', 'WF_drainage_area','divide_WF_distance', 'antecedent_slope'});
sites_table = [sites_table; current_site_table];
writetable(sites_table,'C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\sites_data_2023_09_21.csv');

%% Calculate stability parameters for all sites in table

sites_table = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\sites_data_w_emb_len_2022_12_04.csv');

channel_ratio = 0.7;
concav_ind = 0.25;
[asym_indexes] = sites_stability_analysis(sites_table, channel_ratio, concav_ind)

% sites_table = [sites_table; current_site_table];

% writetable(sites_table,'C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\sites_data_2022_12_11.csv');


%%
% Focus on divide [i]:
i = 319; % chosen divide
DEM = GRIDobj(DEM_path);
cellsize = DEM.cellsize;

% [current_div_X, current_div_Y] = ind2coord(Div,cell2mat(Div_sections_idx(i)));
current_div_Z = DEM.Z(coord2ind(DEM,current_div_X, current_div_Y));


current_div_dist = cumsum([0; hypot(diff(current_div_X), diff(current_div_Y))]);
TF = islocalmin(current_div_Z,'MaxNumExtrema',1);
current_serial_wg = 1:length(current_div_X);


subplot(2,2,1)
plot(current_div_X,current_div_Y,'-', LineWidth = 2, Color = "#7E2F8E");
scatter(current_div_X(TF), current_div_Y(TF),'*r');
text(current_div_X(TF),current_div_Y(TF),string(i) + "\" + string(current_serial_wg(TF)));

subplot(2,2,2)
imageschs(DEM,[], 'colormap', landcolor,'caxis',[450 490]);
hold on
% plot(ST10000,'k');
plot(current_div_X,current_div_Y,'-g', LineWidth = 2, Color = "#7E2F8E");
scatter(current_div_X(TF), current_div_Y(TF),'*r');
text(current_div_X(TF),current_div_Y(TF),string(i) + "\" + string(current_serial_wg(TF)));

subplot(2,2,3)
hold on
plot(current_div_dist,current_div_Z, '-','LineWidth', 2, 'Color', "#7E2F8E");
plot(current_div_dist(TF),current_div_Z(TF), '*r');
text(current_div_dist(TF),current_div_Z(TF),string(i) + "\" + string(current_serial_wg(TF)));

subplot(2,2,2)
prev_div_X = current_div_X(find(TF == 1)+1);
prev_div_Y = current_div_Y(find(TF == 1)+1);
%%
if prev_div_X == current_div_X(TF == 1)
    ch1_X = prev_div_X+0.5*cellsize; ch2_X = prev_div_X-0.5*cellsize;
    ch1_Y = (prev_div_Y + current_div_Y(TF == 1))/2; ch2_Y = (prev_div_Y + current_div_Y(TF == 1))/2;
else
    ch1_Y = prev_div_Y+0.5*cellsize; ch2_Y = prev_div_Y-0.5*cellsize;
    ch1_X = (prev_div_X + current_div_X(TF == 1))/2; ch2_X = (prev_div_X + current_div_X(TF == 1))/2;
end
% scatter([ch1_X,ch2_X],[ch1_Y,ch2_Y],'cyan','^');

ch_raster = DEM; ch_raster.Z(:) = 0;
ch_raster.Z([coord2ind(ch_raster,ch1_X,ch1_Y); coord2ind(ch_raster,ch2_X,ch2_Y)]) = 1;
% ST_2_trunks = modify(ST,'downstreamto',ch_raster);
ST_2_trunks = modify(ST_2_trunks ,'downstreamto',ch_raster);

plot(ST_2_trunks, 'LineWidth',2,'Color',"#A2142F");

% cross divide figure
GS = STREAMobj2GRIDobj(ST_2_trunks);
DEMaux = DEM;
DEMaux.Z(GS.Z) = 1;
IX = streampoi(ST_2_trunks,'outlet','ix');
DEMaux.Z = graydist(DEMaux.Z,IX(1));
% imageschs(DEM,DEMaux)

FDaux = FLOWobj(DEMaux);
Saux = STREAMobj(FDaux,'channelhead',IX(2));

% plot it
subplot(2,2,2)
% imageschs(DEM,[],'colormap',landcolor,'caxis',[450 490])
% hold on
plot(Saux,'LineWidth',1,'Color','k');
subplot(2,2,4)
plotdz(Saux,DEM,'LineWidth',2,'Color',"#A2142F")

% save windgap X,Y,Z in table:
table()
