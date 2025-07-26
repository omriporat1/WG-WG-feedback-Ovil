% This script aims to create a streamOBJ that contains only the two
% relevant channels and tributaries, above the DGPS-measured height of the
% waterfall lip.

% load DEM 
DEM50 = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Fieldwork\Site15\DEM\S15_DEM_MAPI.tif');
kp_height = 445.327; % change according to measured height!!
minarea = 1000; % drainage area for channel initiation [m^2]
DEM50 = fillsinks(DEM50);
FD50 = FLOWobj(DEM50);
A50 = flowacc(FD50);
resolution = DEM50.cellsize; % [m/px]
ST50 = STREAMobj(FD50,'minarea',minarea/(resolution^2));
ST50m = modify(ST50,'upstreamto',DEM50>kp_height);

ST50_2 = klargestconncomps(ST50m,2); % assuming the relevant channels are among the longest 3

ST50_2 = modify(ST50_2,'interactive','polyselect');
% ST50_2 = modify(ST50m,'interactive','outletselect');

figure
imageschs(DEM50, [], 'colormap',[1 1 1],'colorbar',false);
hold on
plot(ST50_2,'b');

%%
save('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST50_2_15b','ST50_2');
