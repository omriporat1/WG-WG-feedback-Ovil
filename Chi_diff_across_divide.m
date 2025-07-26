% load DEM and process
DEM50 = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Fieldwork\Site19\DEM\site19_DEM_50cm.tif');
DEM50 = fillsinks(DEM50);
FD50 = FLOWobj(DEM50);
A50 = flowacc(FD50);
site_name = "Site 19";

site_ind = 2; % specify site from the list
mn = 0.25; % user defined concavity (m/n) index


resolution = DEM50.cellsize; % [m/px]
minarea = 10000; % user defined drainage area for channel initiation [m^2]

% load 2-network upstream to waterfall head STREAMobj's
ST50_2 = load('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST50_2_19.mat');
ST50_2 = ST50_2.ST50_2;

% extract cliff network and higland network
ST50_hl = klargestconncomps(ST50_2,1); % assuming the relevant channels are among the longest 3
ST50_cl = modify(ST50_2,'rmnodes',ST50_hl);


[indexes,filenames,raw] = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\DGPS_profile_analysis\channelhead_locations.xlsx');
filenames = string(filenames(2:end,1));
[nsites,~] = size(indexes);
hold on
site_names = replaceBetween(filenames,"_","csv","","Boundaries","inclusive");

figure(1)
subplot(2,2,1)
imageschs(DEM50);
hold on
plot(ST50_hl,'color',[0, 0.4470, 0.7410]);
plot(ST50_cl,'color',[0.9290, 0.5, 0.15]);




subplot(2,2,[2 4])
plotdz(ST50_hl,DEM50, 'color',[0, 0.4470, 0.7410]);
hold on
plotdz(ST50_cl,DEM50, 'color',[0.9290, 0.6940, 0.1250]);
legend('Highland network', 'Cliff network');

sgtitle(site_name + ' - Map and profile of highland and cliff networks');


subplot(2,2,3)
% create profiles and mark points
filename = 'C:\Users\Omri\Desktop\University\MSc\Matlab\DGPS_profile_analysis\profiles\'+filenames(site_ind);
original = readtable(filename);
X = original{:,2};
Y = original{:,3};
Z = original{:,4};
comulative_dist = zeros(1);
for j = 2:length(X)
    comulative_dist(j) = comulative_dist(j-1)+sqrt((X(j)-X(j-1))^2+(Y(j)-Y(j-1))^2);
end
ch_cliff_idx = indexes(site_ind,1);
ch_highland_idx = indexes(site_ind,1);
plot(comulative_dist,Z)
hold on
grid on
scatter([comulative_dist(ch_cliff_idx); comulative_dist(ch_highland_idx)], [Z(ch_cliff_idx); Z(ch_highland_idx)], '*');

title(site_names(site_ind));

% calculate divide-upper channel head and equivalent point:
if Z(ch_cliff_idx)>Z(ch_highland_idx)
    ch_equiv_hl_idx = find(Z(ch_cliff_idx+1:end)-Z(ch_cliff_idx)<0,1)+ch_cliff_idx;
    scatter(comulative_dist(ch_equiv_hl_idx), Z(ch_equiv_hl_idx), '*');
    subplot(2,2,1)
    scatter(X([ch_equiv_hl_idx, ch_cliff_idx]), Y([ch_equiv_hl_idx, ch_cliff_idx]), '*r');
    
    X_ch_cl = X(ch_cliff_idx);
    Y_ch_cl = Y(ch_cliff_idx);
    X_ch_hl = X(ch_equiv_hl_idx);
    Y_ch_hl = Y(ch_equiv_hl_idx);
else
    ch_equiv_cliff_idx = find(Z(1:(ch_highland_idx-1))-Z(ch_highland_idx)>0,1)-1;
    scatter(comulative_dist(ch_equiv_cliff_idx), Z(ch_equiv_cliff_idx), '*');
    subplot(2,2,1)
    scatter(X([ch_equiv_cliff_idx, ch_highland_idx]), Y([ch_equiv_cliff_idx, ch_highland_idx]), '*r');
    
    X_ch_cl = X(ch_equiv_cliff_idx);
    Y_ch_cl = Y(ch_equiv_cliff_idx);
    X_ch_hl = X(ch_highland_idx);
    Y_ch_hl = Y(ch_highland_idx);
end



dist_ch_cl_ST = sqrt((X_ch_cl-ST50_cl.x).^2+(Y_ch_cl-ST50_cl.y).^2);
dist_ch_hl_ST = sqrt((X_ch_hl-ST50_hl.x).^2+(Y_ch_hl-ST50_hl.y).^2);

ind_ch_cl_ST = find(dist_ch_cl_ST == min(dist_ch_cl_ST));
ind_ch_hl_ST = find(dist_ch_hl_ST == min(dist_ch_hl_ST));


scatter(ST50_cl.x(ind_ch_cl_ST),ST50_cl.y(ind_ch_cl_ST),'xg');
scatter(ST50_hl.x(ind_ch_hl_ST),ST50_hl.y(ind_ch_hl_ST),'xg');

% Chi calculation
Chi_val_hl = chitransform(ST50_hl,A50, 'mn', mn); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
Chi_val_cl = chitransform(ST50_cl,A50, 'mn', mn); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m

chi_diff = Chi_val_cl(ind_ch_cl_ST)-Chi_val_hl(ind_ch_hl_ST)

drainage_areas = (resolution^2)*A50.Z(coord2ind(A50,ST50_2.x(ind_wfh_ST), ST50_2.y(ind_wfh_ST)));
