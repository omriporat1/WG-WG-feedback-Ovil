% load DEM and process
DEM50 = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Fieldwork\Site28\DEM\site28_DEM_50cm.tif');
DEM50 = fillsinks(DEM50);
FD50 = FLOWobj(DEM50);
A50 = flowacc(FD50);
site_name = "Site 28";

% load 2-network upstream to waterfall head STREAMobj's
ST50_2 = load('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST50_2_28_150m2.mat');
ST50_2 = ST50_2.ST50_2;

% extract cliff network and higland network
ST50_hl = klargestconncomps(ST50_2,1); % assuming the relevant channels are among the longest 3
ST50_cl = modify(ST50_2,'rmnodes',ST50_hl);

figure(1)
subplot(1,2,1)
imageschs(DEM50);
hold on
plot(ST50_hl,'color',[0, 0.4470, 0.7410]);
plot(ST50_cl,'color',[0.9290, 0.55, 0.15]);


subplot(1,2,2)
plotdz(ST50_hl,DEM50, 'color',[0, 0.4470, 0.7410]);
hold on
plotdz(ST50_cl,DEM50, 'color',[0.9290, 0.6940, 0.1250]);
legend('Highland network', 'Cliff network');

sgtitle(site_name + ' - Map and profile of highland and cliff networks');


%%
mn = 0.05:0.05:0.45; % define concavity index range
bins = 10; % define # of bins for STD calculation


mean_std_all_bins_hl = zeros(1,numel(mn));
mean_std_all_bins_cl = zeros(1,numel(mn));

% std_all_bins = zeros(1,numel(mn));

Chi_val_hl = zeros(numel(ST50_hl.IXgrid),numel(mn)); % Chi-coordinates for each point (rows) for each m/n ratio (columns)
Chi_val_cl = zeros(numel(ST50_cl.IXgrid),numel(mn)); % Chi-coordinates for each point (rows) for each m/n ratio (columns)
figure(2)
for i = 1:numel(mn)
    Chi_val_hl(:,i) = chitransform(ST50_hl,A50, 'mn', mn(i)); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    Chi_val_cl(:,i) = chitransform(ST50_cl,A50, 'mn', mn(i)); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    
    subplot(3, 3, i)
%     set(gca,'Color',[0.9 0.9 0.9])
    hold on
    scatter(Chi_val_hl(:,i),DEM50.Z(ST50_hl.IXgrid), 10, [0, 0.4470, 0.7410], '.'); % plot Chi-Z graph

    scatter(Chi_val_cl(:,i),DEM50.Z(ST50_cl.IXgrid), 10, [0.9290, 0.6940, 0.1250], '.'); % plot Chi-Z graph
    grid on
    xlabel('Chi [m]');
    ylabel('Z [m ASL]');
    title_str = "m/n = " + string(mn(i) + ", A_0 = 1Km^2");
    title(title_str);
    hold on

    % Now calculate the STD for 10 bins, add boxplot with 1SD to each bin, and add
    % the weighted mean STD for 10 bins to the subplot
    bounds_hl = linspace(0,max(Chi_val_hl(:,i)), bins+1);
    bounds_cl = linspace(0,max(Chi_val_cl(:,i)), bins+1);

    bin_std_hl = zeros(1,bins);
    bin_std_cl = zeros(1,bins);
    
    bin_N_hl = zeros(1,bins);
    bin_N_cl = zeros(1,bins);
    
    bin_weight_hl = zeros(1,bins);
    bin_weight_cl = zeros(1,bins);

    bin_mean_hl = zeros(1,bins);
    bin_mean_cl = zeros(1,bins);
    
    Z_hl = DEM50.Z(ST50_hl.IXgrid);
    Z_cl = DEM50.Z(ST50_cl.IXgrid);
    for j = 1:bins
        bin_std_hl(j) = std(Z_hl(Chi_val_hl(:,i)>=bounds_hl(j) & Chi_val_hl(:,i)<bounds_hl(j+1)));
        bin_N_hl(j) = numel(Z_hl(Chi_val_hl(:,i)>=bounds_hl(j) & Chi_val_hl(:,i)<bounds_hl(j+1)));
        bin_weight_hl(j) = bin_N_hl(j)/numel(Chi_val_hl(:,i));
        bin_mean_hl(j) = mean(Z_hl(Chi_val_hl(:,i)>=bounds_hl(j) & Chi_val_hl(:,i)<bounds_hl(j+1)));
        
        bin_std_cl(j) = std(Z_cl(Chi_val_cl(:,i)>=bounds_cl(j) & Chi_val_cl(:,i)<bounds_cl(j+1)));
        bin_N_cl(j) = numel(Z_cl(Chi_val_cl(:,i)>=bounds_cl(j) & Chi_val_cl(:,i)<bounds_cl(j+1)));
        bin_weight_cl(j) = bin_N_cl(j)/numel(Chi_val_cl(:,i));
        bin_mean_cl(j) = mean(Z_cl(Chi_val_cl(:,i)>=bounds_cl(j) & Chi_val_cl(:,i)<bounds_cl(j+1)));
    end
    mean_std_all_bins_hl(i) = sum(bin_std_hl.*bin_weight_hl);
    mean_std_all_bins_cl(i) = sum(bin_std_cl.*bin_weight_cl);

    bin_middle_hl = bounds_hl(1:end-1)+(diff(bounds_hl)/2);
    bin_middle_cl = bounds_cl(1:end-1)+(diff(bounds_cl)/2);
    
    errorbar(bin_middle_hl,bin_mean_hl,bin_std_hl, '*', 'Color', '#00e639', 'LineWidth',2, 'CapSize', 15);
    errorbar(bin_middle_cl,bin_mean_cl,bin_std_cl, '*', 'Color', '#ff6633','LineWidth',1.5, 'CapSize', 15);

    text(min(xlim), max(ylim)-1, sprintf('Weighted mean STD, highland = %0.2f', mean_std_all_bins_hl(i)), 'Horiz','left', 'Vert','top', 'Color',[0, 0.4470, 0.7410], 'FontWeight', 'Bold');
    text(min(xlim), max(ylim)-1, sprintf('Weighted mean STD, cliff = %0.2f', mean_std_all_bins_cl(i)), 'Horiz','left', 'Vert','bottom', 'Color',[0.9290, 0.6940, 0.1250], 'FontWeight', 'Bold');
end
sgtitle(site_name + ' - Chi-Z');

figure(3)
plot(mn,mean_std_all_bins_hl, '-o', 'Color', [0, 0.4470, 0.7410],'LineWidth',1.5);
hold on
plot(mn,mean_std_all_bins_cl, '-o', 'Color', [0.9290, 0.6940, 0.1250],'LineWidth',1.5);

min_STD_mn_hl = min(mean_std_all_bins_hl);
min_STD_mn_cl = min(mean_std_all_bins_cl);
scatter(mn(mean_std_all_bins_hl == min(mean_std_all_bins_hl)), min_STD_mn_hl, '*r');
scatter(mn(mean_std_all_bins_cl == min(mean_std_all_bins_cl)), min_STD_mn_cl, '*r');

title(site_name + ' - mean weighted STD vs. m/n ratio'); xlabel('m/n'); ylabel('Mean weighted STD [m]'); legend('highland','cliff', 'Location', 'NW');