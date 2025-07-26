%% This section loads 0/1 raster of the cliffs and a DEM and shows the cliffs over the DEM. Then it adds the waterfall heads as '*'
[A,R] = readgeoraster('C:\Users\Omri\Desktop\University\MSc\Matlab\clifflines\MAPI_cut_wider_1m_relief_below_rad100_minrelief45.tif','CoordinateSystemType','auto', 'OutputType', 'double');
 
A(1,1) = 1; % add 1 pixel with positive value at the corner to push the convex hull on the north-western side

DEM = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\Clifflines\MAPI_cut_wider_1m.tif');
DEM = fillsinks(DEM);

tif_info = geotiffinfo('C:\Users\Omri\Desktop\University\MSc\Matlab\Clifflines\MAPI_cut_wider_1m_relief_below_rad100_minrelief45.tif');
refmat = tif_info.RefMatrix;
resolution = DEM.cellsize; % [m/px]

A = 1-A;
%%
figure
fig1 = gcf;
imageschs(DEM,[],'caxis',[280 520], 'colormap', landcolor);
hold on


cliff_line = mapshow(A,refmat); 
hold off
alpha(cliff_line, 'color');
hold on

wfh = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\Cropped_DEM_MAPI\kp_coordinates_MAPI_2022_11_13.csv');
wfh_names = readcell('C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\cropped_DEM_MAPI\kp_names_MAPI_2022_11_13.csv', 'TextType', 'string');
wfh_names = string(wfh_names(:,1));

% p = geopoint(wfh(:,1), wfh(:,2));

% geoshow(p);
% 
% mapshow(wfh(:,1), wfh(:,2), 'DisplayType','point','Marker','*');
% This section matches a convex hull to all values of 1 in the cliff raster

[y_ind, x_ind] = find(A<0.5);
inds = [y_ind, x_ind];
conv = convhull(x_ind, y_ind);
conv = [x_ind(conv),y_ind(conv)];

% This section shows the convex-hull
conv(:,3) = 1;
xy_geo = zeros(length(conv),2);
    
for i = 1:length(conv)
    xy_geo(i,:) = [conv(i,2), conv(i,1), conv(i,3)] * refmat;
end


p_conv =  geopoint(xy_geo(:,2), xy_geo(:,1));
% plot(p_conv.Longitude, p_conv.Latitude, 'LineWidth', 3, 'Color', 'r');
mapshow(p_conv.Longitude, p_conv.Latitude,'Color', 'red', 'LineWidth', 2);

% send to figure
% prep_fig(fig1,6.88e5,3.3475e6,'northwest','trial7','C:\Users\Omri\Desktop\University\MSc\MSc_Thesis\Figures by chapter\');
%% This section creates and shows the whole STREAMobj
FD = FLOWobj(DEM);
%%
A_drainage = flowacc(FD);
%% calculate drainage area at waterfalls - 2022_11_21
A_drainage = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\Clifflines\A_drainage_MAPI_cut_wider_1m.tif');
wfh = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\Cropped_DEM_MAPI\kp_coordinates_MAPI_2022_11_13.csv');
wfh_names = readcell('C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\cropped_DEM_MAPI\kp_names_MAPI_2022_11_13.csv', 'TextType', 'string');
wfh_names = string(wfh_names(:,1));

wfh_ind = coord2ind(A_drainage,wfh(:,1),wfh(:,2));
wfh_drain_A = A_drainage.Z(wfh_ind);
wfh_names = [wfh_names,wfh, string(wfh_drain_A)];

wfh_ind_only_manual_correction = coord2ind(A_drainage,wfh(~isnan(wfh(:,4)),4),wfh(~isnan(wfh(:,5)),5));
wfh_drain_A_only_corrected = A_drainage.Z(wfh_ind_only_manual_correction);
wfh_names_only_corrected = wfh_names(~isnan(wfh(:,4)),1);

% wfh_names = [wfh_names,wfh, string(wfh_drain_A)]
wfh_names(~ismissing(wfh_names(:,5)),7) = wfh_drain_A_only_corrected;

%%
ST_wfh = STREAMobj(FD,'channelheads',ind_wfh); % stream object downstream to waterfall heads (indexes)

% plot(ST,'color',[0 0 1])


%% Crop STREAMobj from each wfh to the cross of the convexhull using a for loop
% ST1 = modify(ST, 'distance', [400 10000]);

%Create ST_conv - stream network cut by the cliff polygon
conv_xy = [p_conv.Longitude',p_conv.Latitude']; 
ST_wfh = modify(ST_wfh, 'clip',conv_xy);

% figure
% imageschs(DEM,[], 'colormap', landcolor);
% hold on
% mapshow(p_conv.Longitude, p_conv.Latitude,'Color', 'red', 'LineWidth', 2);
%%

% Create DEM_is_wfh where waterfall head pixels = 1, all others = 0.
DEM_is_wfh = DEM;
DEM_is_wfh.Z = logical(DEM_is_wfh.Z);
DEM_is_wfh.Z(:,:) = false;
[wfh_row,wfh_col] = coord2sub(DEM,wfh(:,1),wfh(:,2));
ind_wfh = sub2ind(size(DEM_is_wfh.Z),wfh_row,wfh_col);

DEM_is_wfh.Z(ind_wfh) = true;

%%
figure
imageschs(DEM,[], 'caxis',[280 520], 'colormap', landcolor);
hold on
mapshow(p_conv.Longitude, p_conv.Latitude,'Color', 'red', 'LineWidth', 3);
mapshow(wfh(:,1), wfh(:,2), 'DisplayType','point','Marker','*');
% plot(ST_wfh_upstream,'color',[0 0 1])
%%
embayments_channel = STREAMobj2cell(ST_wfh,'channelheads');
x_channelhead = zeros(length(embayments_channel), 1); y_channelhead = zeros(length(embayments_channel), 1); dist_channelhead = zeros(length(embayments_channel), 1); names_channelhead = strings(length(embayments_channel),1); area_channelhead = zeros(length(embayments_channel), 1);
for i=1:length(embayments_channel)
    x_channelhead(i) = embayments_channel{1,i}.x(find(embayments_channel{1,i}.distance==max(embayments_channel{1,i}.distance)));
    y_channelhead(i) = embayments_channel{1,i}.y(find(embayments_channel{1,i}.distance==max(embayments_channel{1,i}.distance)));
    dist_channelhead(i) = max(embayments_channel{1,i}.distance);
    names_ind = find(abs(x_channelhead(i)-wfh(:,1))<20 & abs(y_channelhead(i)-wfh(:,2))<20);
    names_channelhead(i) = wfh_names(names_ind);
    area_channelhead(i) = A_drainage.Z(coord2ind(A_drainage,x_channelhead(i),y_channelhead(i)));
end
wfh(:,5) = 0;
wfh_ind = zeros(1,length(wfh));
for i = 1:length(embayments_channel)
    wfh_ind(i) = find(abs(wfh(:,1) - x_channelhead(i)) < 10 & abs(wfh(:,2) - y_channelhead(i)) < 10);
%     wfh(wfh_ind,5) = dist_channelhead(i);
end
channels_sorted = embayments_channel(wfh_ind);
x_channelhead_sorted = x_channelhead(wfh_ind);
y_channelhead_sorted = y_channelhead(wfh_ind);
z_channelhead_sorted = DEM.Z(coord2ind(DEM,x_channelhead_sorted,y_channelhead_sorted));
dist_channelhead_sorted = dist_channelhead(wfh_ind);
% area_channelhead_sorted = A_drainage.Z(coord2ind(DEM,x_channelhead_sorted,y_channelhead_sorted))*(resolution^2);
area_channelhead_sorted = area_channelhead(wfh_ind);
name_channelhead_sorted = names_channelhead(wfh_ind);

% unify and export data
wfh_data = [x_channelhead_sorted,y_channelhead_sorted,z_channelhead_sorted,dist_channelhead_sorted, area_channelhead_sorted];
varNames = {'Site','X','Y','Z','Distance','Area'};
wfh_data_table = table(name_channelhead_sorted,wfh_data(:,1), wfh_data(:,2), wfh_data(:,3), wfh_data(:,4), wfh_data(:,5),'VariableNames',varNames);
% writetable(wfh_data_table,'wfh_name_x_y_z_dist_area_2022_8_30_DEM_MAPI_1m.xlsx') % writing the table to file - enable when done

channel_dist_normalized = dist_channelhead_sorted/max(dist_channelhead_sorted);
for i = 1:length(channels_sorted)
%     plot(channels_sorted{i},'color', 1-channel_dist_normalized(i)*([1 1 0]), 'LineWidth',1+2*channel_dist_normalized(i));
    plot(channels_sorted{i},'color', 1-channel_dist_normalized(i)*([1 1 0]), 'LineWidth',2.5);

end

text(x_channelhead_sorted+40, y_channelhead_sorted+70, cellstr(string(uint16(dist_channelhead_sorted))), 'FontWeight', 'bold', 'FontSize',12);
% text(wfh(:,1)+40, wfh(:,2)+90, cellstr(wfh_names), 'FontWeight', 'bold');
text(x_channelhead_sorted+40, y_channelhead_sorted+150, cellstr(name_channelhead_sorted), 'FontWeight', 'bold','FontSize',12);
% text(wfh(:,1), wfh(:,2), cellstr(wfh_names), 'FontWeight', 'bold');
legend('reconstructed cliffline','waterfall','Embayment channel');

fig1 = gcf;
prep_fig(fig1,6.88e5,3.3475e6,'northwest','Embayment_lengths_1m-MAPI_relief_below_rad100_minrelief45','C:\Users\Omri\Desktop\University\MSc\MSc_Thesis\Figures by chapter\5 Results\');
%% Looking for correlations:
figure
subplot(2,2,1)
plot(x_channelhead_sorted,dist_channelhead_sorted, '*');
xlabel('easting [m]'); ylabel('embayment length [Km]'); title('Embayment length vs. easting');

subplot(2,2,2)
plot(dist_channelhead_sorted,y_channelhead_sorted, '*');
ylabel('northing [m]'); xlabel('embayment length [Km]');title('Northing vs. Embayment length');

subplot(2,2,3)
plot(dist_channelhead_sorted, wfh(:,3), '*');
xlabel('embayment length [Km]'); ylabel('Waterfall height ASL [m]'); title('Waterfall height vs. embayment length');
%%
site_nums = zeros(numel(name_channelhead_sorted),1);
for i = 1:length(name_channelhead_sorted)
    current_text = char(name_channelhead_sorted(i));
    digitIndexes = current_text < 'A';
    site_nums(i) = str2double(current_text(digitIndexes));
end
is_south = site_nums > 16;
figure
semilogx(area_channelhead_sorted(is_south),dist_channelhead_sorted(is_south), 'xr', 'MarkerSize', 13, 'linewidth',2);
hold on
% scatter(area_channelhead_sorted(~is_south),dist_channelhead_sorted(~is_south), '*b');
xlabel('drainage area [m^2]', 'FontSize', 13); ylabel('embayment length [m]', 'FontSize', 13); title('Embayment length vs. drainage area', 'FontSize', 14);
% legend('Southern cliff line');
grid on

