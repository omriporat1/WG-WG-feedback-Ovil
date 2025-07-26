% load DEM and process
DEM_MAPI = GRIDobj('C:\Users\Omri\Desktop\University\MSc\MAPI_DEM\MAPI_DEM_UTM.tif');
DEM_MAPI = resample(DEM_MAPI,1); % reduce resolution to 1 m^2/px
% imageschs(DEM_MAPI)
grad_map = gradient8(DEM_MAPI);
FD_MAPI = FLOWobj(DEM_MAPI);

%%
cliff_min_grad = 5; % minimal cliff slope for gradient calculation - units by default are tan
relief_calc_radius = 100; % radius for relief calculation in m
relief_min = 45; % minimal height of cliff in m
close all;
% figure
% DEMc = crop(DEM_MAPI,sub2ind(DEM_MAPI.size,[4000 13000],[7500 23500])); % the right dimensions for the entire cliff line
% DEMc = crop(DEM_MAPI,sub2ind(DEM_MAPI.size,[8000 10000],[15000 20000])) % remove later, smaller area for testing porposes
DEMc = crop(DEM_MAPI,sub2ind(DEM_MAPI.size,[1 7200],[1 12000])); %% the right dimensions for the entire cliff line, 1m resulotion

grad_DEMc = gradient8(DEMc);
grad_DEMc.Z(grad_DEMc.Z < cliff_min_grad) = 0;
grad_DEMc.Z(grad_DEMc.Z > cliff_min_grad) = 1;
% imagesc(grad_DEMc);
% clim([0,1]);
% colorbar

% title("gradient with min " + cliff_min_grad);


relief_DEMc = localtopography1(DEMc,relief_calc_radius,'type','rangebelow');

% remove this section - for testing of types of localtopography:

% figure
% subplot(2,2,1)
% relief_DEMc = localtopography1(DEMc,relief_calc_radius);
% imageschs(DEMc, relief_DEMc)
% title("range")
% 
% %%
% subplot(2,2,2)
% relief_DEMc = localtopography1(DEMc,relief_calc_radius, 'type','rangebelow');
% imageschs(DEMc, relief_DEMc)
% title("rangebelow")
% 
% %%
% subplot(2,2,3)
% relief_DEMc = localtopography1(DEMc,relief_calc_radius, 'type','rangeabove');
% imageschs(DEMc, relief_DEMc)
% title("rangeabove")
% 
% %%
% subplot(2,2,4)
% relief_DEMc = localtopography1(DEMc,10, 'type','std');
% imageschs(DEMc, relief_DEMc)
% title("std, r = 10m")


% end remove

figure
subplot(2,1,1)
imageschs(DEMc, relief_DEMc)
title("relief below map, radius = " + relief_calc_radius + "m");


relief_DEMc.Z(relief_DEMc.Z < relief_min | isnan(grad_DEMc.Z)) = 0;
relief_DEMc.Z(relief_DEMc.Z > relief_min) = 1;
subplot(2,1,2)
imagesc(relief_DEMc);
title("relief below, radius = " + relief_calc_radius + "m, min relief = " + relief_min + "m");
clim([0,1]);
colorbar
%%

DEMc.Z(isnan(DEMc.Z)) = -2000;
GRIDobj2geotiff(DEMc,'C:\Users\Omri\Desktop\University\MSc\Matlab\clifflines\MAPI_cut_wider_1m.tif')
GRIDobj2geotiff(relief_DEMc,'C:\Users\Omri\Desktop\University\MSc\Matlab\clifflines\MAPI_cut_wider_1m_relief_below_rad100_minrelief45.tif')