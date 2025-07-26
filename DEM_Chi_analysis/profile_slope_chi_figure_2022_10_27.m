%% relations between Chi and Slope asymmetry

stability_parameters = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Chi_across_divide\stability_parameters.xlsx');

figure
hold on
scatter(stability_parameters.absChi_diff_HiRes_norm_low_ch,stability_parameters.chaennelhead_waterfall_slope_asymmetry_index, 'filled')
% scatter(stability_parameters.absChi_diff_HiRes_norm_high_ch,stability_parameters.chaennelhead_waterfall_slope_asymmetry_index,'*')
scatter(stability_parameters.absChi_diff_HiRes_norm_low_ch,stability_parameters.divide_chaennelhead_slope_asymmetry_index,'^')
% scatter(stability_parameters.absChi_diff_HiRes_norm_high_ch,stability_parameters.divide_chaennelhead_slope_asymmetry_index,'d')

% legend('low channelhead Chi, channelhead-waterfall slope', 'high channelhead Chi, channelhead-waterfall slope', 'low channelhead Chi, divide-channelhead slope','high channelhead Chi, divide-channelhead slope');
legend('low channelhead Chi, channelhead-waterfall slope', 'low channelhead Chi, divide-channelhead slope');
xlabel('Chi asymmetry'); ylabel('Slope Asymmetry');

b = num2str(stability_parameters.name); c = cellstr(b); %labeling
dx = 0; dy = 0.01; %labeling
text(stability_parameters.absChi_diff_HiRes_norm_low_ch+dx,stability_parameters.chaennelhead_waterfall_slope_asymmetry_index+dy, c);
text(stability_parameters.absChi_diff_HiRes_norm_low_ch+dx,stability_parameters.divide_chaennelhead_slope_asymmetry_index+dy, c);

%% figures like IGS meeting

T = tiledlayout(1,4,'TileSpacing','compact');
T_profiles = tiledlayout(T,8,1,'TileSpacing','compact');
T_profiles.Layout.Tile = (1);
T_profiles.Layout.TileSpan = [1 2];
title(T_profiles, "dGPS profiles", 'FontSize', 28)
T_slope = tiledlayout(T,8,1);
T_slope.Layout.Tile = 3;
title(T_slope, "Slope asymmetry", 'FontSize', 28)
T_chi = tiledlayout(T,8,1);
T_chi.Layout.Tile = 4;
title(T_chi, "Chi asymmetry", 'FontSize', 28)

[indexes,filenames,raw] = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\DGPS_profile_analysis\channelhead_locations.xlsx');
stability_parameters = readtable('C:\Users\Omri\Desktop\University\MSc\Matlab\Chi_across_divide\stability_parameters.xlsx');

[nsites,~] = size(indexes);

stability_indices = zeros(nsites,4); % all the stability parameters will be stored here - ch-kp (col 1), div-ch (col 2) div-kp (col3) and div - upper-ch.

filenames = string(filenames(2:end,1));
site_names = replaceBetween(filenames,"_","csv","","Boundaries","inclusive");

% plot DGPS profiles:

ch_cl_hl_idx = zeros(length(indexes(:,1)),2);
for i = 1:nsites
    nexttile(T_profiles);
    % create profiles and mark points
    filename = 'C:\Users\Omri\Desktop\University\MSc\Matlab\DGPS_profile_analysis\profiles\'+filenames(i);
    original = readtable(filename);
    X = original{:,2};
    Y = original{:,3};
    Z = original{:,4};
    comulative_dist = zeros(1);
    for j = 2:length(X)
        comulative_dist(j) = comulative_dist(j-1)+sqrt((X(j)-X(j-1))^2+(Y(j)-Y(j-1))^2);
    end
    ch_cliff_idx = indexes(i,1); 
    ch_highland_idx = indexes(i,2);
    
    plot(comulative_dist(Z>=Z(1)),Z(Z>=Z(1)), 'LineWidth', 3);
    hold on
    ax = gca;
    ax.YGrid = 'on';
    set(ax,'FontSize',12);
    

    scatter(comulative_dist(1),Z(1),200,'p', 'filled');

    ylabel(site_names(i), "FontSize",16, "FontWeight","bold");
    
    % normalized stability index parameters calculation
    divide_ind = find(Z == max(Z));
    if Z(end)<Z(1)
        wf_equiv_ind = find(Z-Z(1)<0,1);
    else
        wf_equiv_ind = length(Z);
    end
    % calculate ch-wfh slopes:
    slopes_cliffside(i,1) = (Z(ch_cliff_idx)-Z(1))/(comulative_dist(ch_cliff_idx)-0);
    slopes_highland(i,1) = (Z(ch_highland_idx)-Z(wf_equiv_ind))/(comulative_dist(wf_equiv_ind)-comulative_dist(ch_highland_idx));
    % calculate divide-ch slopes:
    slopes_cliffside(i,2) = (Z(divide_ind)-Z(ch_cliff_idx))/(comulative_dist(divide_ind)-comulative_dist(ch_cliff_idx));
    slopes_highland(i,2) = (Z(divide_ind)-Z(ch_highland_idx))/(comulative_dist(ch_highland_idx)-comulative_dist(divide_ind));
    % calculate divide-wfh slopes:
    slopes_cliffside(i,3) = (Z(divide_ind)-Z(1))/(comulative_dist(divide_ind)-0);
    slopes_highland(i,3) = (Z(divide_ind)-Z(wf_equiv_ind))/(comulative_dist(wf_equiv_ind)-comulative_dist(divide_ind));
    % calculate divide-upper channel head and equivalent point:
    
    if Z(ch_cliff_idx)>Z(ch_highland_idx)
        ch_equiv_hl_idx = find(Z(ch_cliff_idx+1:end)-Z(ch_cliff_idx)<0,1)+ch_cliff_idx;
        slopes_cliffside(i,4) = slopes_cliffside(i,2);
        slopes_highland(i,4) = (Z(divide_ind)-Z(ch_equiv_hl_idx))/(comulative_dist(ch_equiv_hl_idx)-comulative_dist(divide_ind));
        scatter(comulative_dist(ch_equiv_hl_idx), Z(ch_equiv_hl_idx),200, '*r');
    else
        ch_equiv_cliff_idx = find(Z(1:(ch_highland_idx-1))-Z(ch_highland_idx)>0,1)-1;
        slopes_highland(i,4) = slopes_highland(i,2);
        slopes_cliffside(i,4) = (Z(divide_ind)-Z(ch_equiv_cliff_idx))/(comulative_dist(divide_ind)-comulative_dist(ch_equiv_cliff_idx));
        scatter(comulative_dist(ch_equiv_cliff_idx), Z(ch_equiv_cliff_idx),200, '*r');
    end

    % calculate divide-lower channel head and equivalent point:
    if Z(ch_cliff_idx)>Z(ch_highland_idx)
        ch_equiv_cl_idx = find(Z(1:(ch_cliff_idx))-Z(ch_highland_idx)>0,1)-1;
        ch_cl_hl_idx(i,1) = ch_equiv_cl_idx;
        ch_cl_hl_idx(i,2) = ch_highland_idx;

        scatter(comulative_dist(ch_equiv_cl_idx), Z(ch_equiv_cl_idx),200, '*r');
    else
        ch_equiv_hl_idx = find(Z(ch_highland_idx+1:end)-Z(ch_cliff_idx)<0,1)+ch_highland_idx;
        ch_cl_hl_idx(i,1) = ch_cliff_idx;
        ch_cl_hl_idx(i,2) = ch_equiv_hl_idx;

        scatter(comulative_dist(ch_equiv_hl_idx), Z(ch_equiv_hl_idx),200, '*r');
    end
    grid off

    slope_ax(i) = nexttile(T_slope);
    stability_indices(i,1) = (slopes_cliffside(i,1)-slopes_highland(i,1))/(slopes_cliffside(i,1)+slopes_highland(i,1));
    stability_indices(i,2) = (slopes_cliffside(i,2)-slopes_highland(i,2))/(slopes_cliffside(i,2)+slopes_highland(i,2));
    stability_indices(i,3) = (slopes_cliffside(i,3)-slopes_highland(i,3))/(slopes_cliffside(i,3)+slopes_highland(i,3));
    stability_indices(i,4) = (slopes_cliffside(i,4)-slopes_highland(i,4))/(slopes_cliffside(i,4)+slopes_highland(i,4));
    
    barh(slope_ax(i),i,stability_indices(i,[4,1]),'BaseValue',0);
%     grid on
%     ax = gca;
%     ax.YTickLabels = {''};
%     xlim([-0.2, 0.8]);

    chi_ax(i) = nexttile(T_chi);
    b = barh(chi_ax(i),i,stability_parameters.absChi_diff_HiRes_norm_low_ch(i),'BaseValue',0);
%     ax = gca;
%     ax.YTickLabels = {''};
%     xlim([-0.2, 0.8]);
    b.FaceColor = [0.9290 0.6940 0.1250];
%     grid on
    grid off
end

nexttile(T_profiles,8);
lgd = legend('','waterfall head','channelheads','Orientation',"horizontal");
lgd.Layout.Tile = 'south';
lgd.FontSize = 15;



linkaxes([slope_ax(:)],'x');
xticklabels(slope_ax(1:end-1),{})
yticklabels(slope_ax(:),{})
xlim(slope_ax(:),[-0.2, 0.8]);



nexttile(T_slope,8);
lgd = legend('divide - channelhead','channelhead - waterfall','Orientation',"horizontal");
lgd.Layout.Tile = 'south';
lgd.FontSize = 15;
ax = gca;
% ax.YGrid = 'on';
set(ax,'FontSize',12);

nexttile(T_chi,8);
lgd = legend('Chi asymmetry','Orientation',"horizontal");
lgd.Layout.Tile = 'south';
lgd.FontSize = 15;
ax = gca;
% ax.YGrid = 'on';
set(ax,'FontSize',12);

linkaxes([chi_ax(:)],'x');
xticklabels(chi_ax(1:end-1),{})
yticklabels(chi_ax(:),{})
xlim(chi_ax(:),[-0.2, 0.8]);



%%
figure
% rows = 3;
% cols = 8;
% T = tiledlayout(1,rows);
% for k = 1:rows
%     T_profile = tiledlayout(T,1,k);
%     T_profile.Layout.Tile = k;
%     T_profile.Layout.TileSpan = [1 1];
%     nexttile(T_profile);
% %     for l = 1:cols
% %             t_profile = tiledlayout(T_profile,1,1);
% %             t_profile.Layout.Tile = l;
% %             t_profile.Layout.TileSpan = [1 1];
% %             nexttile(t_profile);
%             plot(rand(5,(l)));
% %     end
% end

T = tiledlayout(1,4,'TileSpacing','compact');
T_profiles = tiledlayout(T,8,1,'TileSpacing','Compact');
T_profiles.Layout.Tile = (1);
T_profiles.Layout.TileSpan = [1 2];
title(T_profiles, "dGPS profiles",'Size')
T_slope = tiledlayout(T,8,1,'TileSpacing','Compact');
T_slope.Layout.Tile = 3;
title(T_slope, "Slope asymmetry")
T_chi = tiledlayout(T,8,1,'TileSpacing','Compact');
T_chi.Layout.Tile = 4;
title(T_chi, "Chi asymmetry")

for k = 1:8
    nexttile(T_profiles);
    plot(rand(5,(l)));
end

for k = 1:8
    nexttile(T_slope);
    plot(rand(5,(l)));
end

for k = 1:8
    nexttile(T_chi);
    plot(rand(5,(l)));
end
