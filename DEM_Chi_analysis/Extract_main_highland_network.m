% This script aims to create a streamOBJ that contains the main stream
% network of the highland.

% load DEM 
DEM_TAN = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\DEMc_raw.tif');
cut_height = 429; % height of output
minarea = 1000; % drainage area for channel initiation [m^2]
DEM_TAN = fillsinks(DEM_TAN);
FD_TAN = FLOWobj(DEM_TAN);
A_TAN = flowacc(FD_TAN);
resolution = 12.5; % [m/px]
ST_TAN = STREAMobj(FD_TAN,'minarea',minarea/(resolution^2));
ST_TANm = modify(ST_TAN,'upstreamto',DEM_TAN>cut_height);

ST_TAN_all = klargestconncomps(ST_TANm,2); % assuming the relevant channels are among the longest 3

ST_TAN_main = klargestconncomps(ST_TANm,1); % assuming the relevant channels are among the longest 3


figure
imageschs(DEM_TAN, [], 'colormap',[1 1 1],'colorbar',false);
hold on
plot(ST_TAN_main,'b');

%%
save('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST_TAN_highland_east_above_429','ST_TAN_main');
%%
ST_TAN_secondary = modify(ST_TAN_all,'rmnodes',ST_TAN_main);

plot(ST_TAN_secondary,'k');
%%
save('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST_TAN_highland_west_above_429','ST_TAN_secondary');
