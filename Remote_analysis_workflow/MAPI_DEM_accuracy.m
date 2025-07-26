DEM = GRIDobj('C:\Users\Omri\Desktop\University\MSc\MAPI_DEM\MAPI_DEM_UTM.tif');
resolution = DEM.cellsize; % [m/px]
%%
GPS = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Site_remote_analysis_workflow\GPS_coords_all_sites.csv');

DEM_Z = DEM.Z(coord2ind(DEM,GPS.GPS_X,GPS.GPS_Y));

Z_diff = GPS.GPS_Z-DEM_Z;

figure
scatter(GPS.GPS_X,GPS.GPS_Y,[],Z_diff,'filled');
axis equal
colorbar
%%
figure
histogram(Z_diff,20);
title('Distribution of difference between DEM and dGPS Z [m]')
%%
figure
scatter(GPS.GPS_Z,DEM_Z,'filled');
axis equal
hold on
line([450 520], [450 520], 'Color', 'k', 'LineStyle', '--');
axis([450 520 450 520]);
grid on;
title('MAPI DEM Z vs. dGPS Z');
xlabel('DGPS-measured Z [mASL]');
ylabel('MAPI-DEM extracted Z [mASL]');
%%
% rmse_MAPI_DEM = rmse(GPS.GPS_Z,DEM_Z)
data_size = 1:10:length(DEM_Z);
for i = 1:length(data_size)
    rmse_MAPI_DEM(i) = rmse(GPS.GPS_Z(1:data_size(i)),DEM_Z(1:data_size(i)));
end
figure
plot(data_size, rmse_MAPI_DEM,'-o', 'LineWidth',2,'MarkerFaceColor','auto');
title('RMSE vs. dataset size');
ylabel('RMSE');
xlabel('Dataset size');
grid on

RMSE = mean(rmse_MAPI_DEM(8:end));