% load DEM and process
DEM_TAN = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\DEMc_raw.tif');
DEM_TAN = fillsinks(DEM_TAN);
FD_TAN = FLOWobj(DEM_TAN);
A_TAN = flowacc(FD_TAN);

% load main network upstream to 429 [m] ASL STREAMobj
ST_TAN_main = load('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST_TAN_highland_east_above_429.mat');
ST_TAN_main = ST_TAN_main.ST_TAN_main;

figure(1)
subplot(1,2,1)
imageschs(DEM_TAN);
hold on
plot(ST_TAN_main,'b');
subplot(1,2,2)
plotdz(ST_TAN_main,DEM_TAN);
hold on
sgtitle('Highland stream network, above 429 [m] (suspected as fault)');


%%
mn = 0.05:0.05:0.45; % define concavity index range
bins = 10; % define # of bins for STD calculation
mean_std_all_bins_e = zeros(1,numel(mn));
% std_all_bins = zeros(1,numel(mn));
Chi_val = zeros(numel(ST_TAN_main.IXgrid),numel(mn)); % Chi-coordinates for each point (rows) for each m/n ratio (columns)
figure(2)
for i = 1:numel(mn)
    Chi_val(:,i) = chitransform(ST_TAN_main,A_TAN, 'mn', mn(i)); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    subplot(3, 3, i)

    scatter(Chi_val(:,i),DEM_TAN.Z(ST_TAN_main.IXgrid), 10, '.'); % plot Chi-Z graph
    grid on
    xlabel('Chi [m]');
    ylabel('Z [m ASL]');
    title_str = "m/n = " + string(mn(i) + ", A_0 = 1Km^2");
    title(title_str);
    hold on

    % Now calculate the STD for 10 bins, add boxplot with 1SD to each bin, and add
    % the weighted mean STD for 10 bins to the subplot
    bounds = linspace(0,max(Chi_val(:,i)), bins+1);
    bin_std = zeros(1,bins);
    bin_N = zeros(1,bins);
    bin_weight = zeros(1,bins);
    bin_mean = zeros(1,bins);
    Z = DEM_TAN.Z(ST_TAN_main.IXgrid);
    for j = 1:bins
        bin_std(j) = std(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
        bin_N(j) = numel(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
        bin_weight(j) = bin_N(j)/numel(Chi_val(:,i));
        bin_mean(j) = mean(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
    end
    mean_std_all_bins_e(i) = sum(bin_std.*bin_weight);
    bin_middle = bounds(1:end-1)+(diff(bounds)/2);
    errorbar(bin_middle,bin_mean,bin_std, '*b', 'LineWidth',1, 'CapSize', 15);
    text(min(xlim), max(ylim), sprintf('Weighted mean STD = %0.2f', mean_std_all_bins_e(i)), 'Horiz','left', 'Vert','top', 'Color','blue');
end
sgtitle('Chi-Z for highland stream network');

figure(3)
plot(mn,mean_std_all_bins_e, '-o');
hold on
title('Highland - mean weighted STD vs. m/n ratio'); xlabel('m/n'), ylabel('Mean weighted STD [m]');
%%
% load secondary network upstream to 429 [m] ASL STREAMobj
ST_TAN_secondary = load('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST_TAN_highland_west_above_429.mat');
ST_TAN_secondary = ST_TAN_secondary.ST_TAN_secondary;

figure(1)
subplot(1,2,1)

plot(ST_TAN_secondary,'k');
subplot(1,2,2)
plotdz(ST_TAN_secondary,DEM_TAN, 'color', 'k');
legend('Eastern system', 'Western system');

%%
mean_std_all_bins_w = zeros(1,numel(mn));
% std_all_bins = zeros(1,numel(mn));
Chi_val = zeros(numel(ST_TAN_secondary.IXgrid),numel(mn)); % Chi-coordinates for each point (rows) for each m/n ratio (columns)
figure(2)
for i = 1:numel(mn)
    Chi_val(:,i) = chitransform(ST_TAN_secondary,A_TAN, 'mn', mn(i)); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    subplot(3, 3, i)

    scatter(Chi_val(:,i),DEM_TAN.Z(ST_TAN_secondary.IXgrid), 10, '.'); % plot Chi-Z graph

    % Now calculate the STD for 10 bins, add boxplot with 1SD to each bin, and add
    % the weighted mean STD for 10 bins to the subplot
    bounds = linspace(0,max(Chi_val(:,i)), bins+1);
    bin_std = zeros(1,bins);
    bin_N = zeros(1,bins);
    bin_weight = zeros(1,bins);
    bin_mean = zeros(1,bins);
    Z = DEM_TAN.Z(ST_TAN_secondary.IXgrid);
    for j = 1:bins
        bin_std(j) = std(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
        bin_N(j) = numel(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
        bin_weight(j) = bin_N(j)/numel(Chi_val(:,i));
        bin_mean(j) = mean(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
    end
    mean_std_all_bins_w(i) = sum(bin_std.*bin_weight);
    bin_middle = bounds(1:end-1)+(diff(bounds)/2);
    errorbar(bin_middle,bin_mean,bin_std, '*k', 'LineWidth',1, 'CapSize', 15);
    text(min(xlim), max(ylim), sprintf('Weighted mean STD = %0.2f', mean_std_all_bins_w(i)), 'Horiz','left', 'Vert','top','Color','black');
end

figure(3)
plot(mn,mean_std_all_bins_w, '-ok');
title('Highland - mean weighted STD vs. m/n ratio'); xlabel('m/n'), ylabel('Mean weighted STD [m]');
legend('Eastern system', 'Western system');

%% Linear fit to find m/n for lowest STD value of western system (0.2):
figure(4)
i = 4;
% scatter(Chi_val(:,i),DEM_TAN.Z(ST_TAN_secondary.IXgrid), 10,[0.9290 0.6940 0.1250], '.'); % plot Chi-Z graph
scatter(Chi_val(:,i),DEM_TAN.Z(ST_TAN_secondary.IXgrid), 10, '.'); % plot Chi-Z graph
hold on
% [p,S] = polyfit(Chi_val(:,i),DEM_TAN.Z(ST_TAN_secondary.IXgrid),1); 
% [y_fit,delta] = polyval(p,Chi_val(:,i),S);
% plot(Chi_val(:,i),y_fit,'b-')
bounds = linspace(0,max(Chi_val(:,i)), bins+1);
bin_std = zeros(1,bins);
bin_N = zeros(1,bins);
bin_weight = zeros(1,bins);
bin_mean = zeros(1,bins);
bin_median = zeros(1,bins);
Z = DEM_TAN.Z(ST_TAN_secondary.IXgrid);

for j = 1:bins
    bin_std(j) = std(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
    bin_N(j) = numel(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
    bin_weight(j) = bin_N(j)/numel(Chi_val(:,i));
    bin_mean(j) = mean(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
    bin_median(j) = median(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
end
mean_std_all_bins_w(i) = sum(bin_std.*bin_weight);
bin_middle = bounds(1:end-1)+(diff(bounds)/2);
title('Linear Fit of Data with m/n = 0.2')
% fit 2 - force to reference height
min_height = min(Z);
Z_fix  = Z-min_height;
ft1 = fittype({'x'});
[p1, gof] = fit(Chi_val(:,i),Z_fix,ft1);
x_fit = linspace(0,max(bounds),10);
y1_fitted = feval(p1, x_fit)+min_height;
plot(x_fit,y1_fitted,'--b','LineWidth',1);
errorbar(bin_middle,bin_mean,bin_std, '-*k', 'LineWidth',1, 'CapSize', 15);
scatter(bin_middle,bin_median, 30, [0, 0.5, 0], '*');
legend('Data', 'Linear Fit through reference height', 'Mean with 1 STD', 'Median');
