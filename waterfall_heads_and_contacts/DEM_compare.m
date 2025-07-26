close all

Tan_correction = -17.9;
DEM_Tan = GRIDobj('C:\Users\Omri\Desktop\University\MSc\MAPI_DEM\DEM_Comparison\TanDEM_MAPI_extent.tif');
DEM_MAPI = GRIDobj('C:\Users\Omri\Desktop\University\MSc\MAPI_DEM\DEM_Comparison\MAPI_DEM_Tan_res.tif');
DEM_Tan.Z = DEM_Tan.Z+Tan_correction;

figure
h1 = histogram(DEM_Tan.Z);
hold on
h2 = histogram(DEM_MAPI.Z);
h1.BinWidth = 2; h2.BinWidth = 2;
h1.Normalization = 'probability'; h2.Normalization = 'probability';
h1.EdgeAlpha = 0; h2.EdgeAlpha = 0;
title('DEM Height Distribution - TanDEM and MAPI DEM - wide extent');
xlabel('Height ASL [m]'); ylabel('Probability');
mean_Tan = mean(DEM_Tan.Z(~isnan(DEM_Tan.Z)), 'all');
mean_MAPI = mean(DEM_MAPI.Z(~isnan(DEM_MAPI.Z)), 'all');

text(min(xlim), 0.95*max(ylim), ["Mean height - TanDEM - corrected by " + Tan_correction + "m: " + string(mean_Tan) + "[m]"; "Mean height - MAPI DEM: " + string(mean_MAPI) + "[m]"] , 'Horiz','left', 'Vert','top', 'Interpreter', 'none', 'BackgroundColor','w')

[f_Tan,xi_Tan] = ksdensity(reshape(DEM_Tan.Z(~isnan(DEM_Tan.Z)),1,[]));
plot(xi_Tan,f_Tan, '--b','LineWidth',2);
[f_MAPI,xi_MAPI] = ksdensity(reshape(DEM_MAPI.Z(~isnan(DEM_MAPI.Z)),1,[]));
plot(xi_MAPI,f_MAPI, ':r','LineWidth',2);

legend("DEM_Tan"+string(Tan_correction)+"m"', 'DEM_MAPI', 'TanDEM density', 'MAPI DEM density', 'Interpreter', 'none');

%%

close all

DEM_MAPI = GRIDobj('C:\Users\Omri\Desktop\University\MSc\MAPI_DEM\DEM_Comparison\MAPI_crop_17.tif');
DEM_drone = GRIDobj('C:\Users\Omri\Desktop\University\MSc\MAPI_DEM\DEM_Comparison\Drone_crop_17.tif');

% DEM_diff = DEM


figure
h1 = histogram(DEM_MAPI.Z);
hold on
h2 = histogram(DEM_drone.Z);
h1.BinWidth = 2;h2.BinWidth = 2;
h1.Normalization = 'probability'; h2.Normalization = 'probability';
h1.EdgeAlpha = 0; h2.EdgeAlpha = 0;
title('DEM Height Distribution - Site 17');
xlabel('Height ASL [m]'); ylabel('Probability');
mean_MAPI = mean(DEM_MAPI.Z(~isnan(DEM_MAPI.Z)), 'all');
mean_Drone = mean(DEM_drone.Z(~isnan(DEM_drone.Z)), 'all');

[f_MAPI,xi_MAPI] = ksdensity(reshape(DEM_MAPI.Z(~isnan(DEM_MAPI.Z)),1,[]));
plot(xi_MAPI,f_MAPI, '--b','LineWidth',2);
[f_Drone,xi_Drone] = ksdensity(reshape(DEM_drone.Z(~isnan(DEM_drone.Z)),1,[]));
plot(xi_Drone,f_Drone, ':r','LineWidth',2);

text(min(xlim), 0.95*max(ylim), ["Mean height - MAPI DEM: " + string(mean_MAPI) + "[m]"; "Mean height - Drone DEM: " + string(mean_Drone) + "[m]"] , 'Horiz','left', 'Vert','top', 'Interpreter', 'none', 'BackgroundColor','w')


legend('DEM MAPI', 'DEM Drone', 'MAPI density', 'Drone density', 'Interpreter', 'none');