% load DEM and process
DEM50 = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Fieldwork\Site28\DEM\site28_DEM_50cm.tif');
DEM50 = fillsinks(DEM50);
FD50 = FLOWobj(DEM50);
A50 = flowacc(FD50);

% load 2-network upstream to waterfall head STREAMobj's
ST50_2 = load('C:\Users\Omri\Desktop\University\MSc\Matlab\DEM_Chi_analysis\STREAMobjs\ST50_2_28_150m2.mat');
ST50_2 = ST50_2.ST50_2;

figure
subplot(1,2,1)
imageschs(DEM50);
hold on
plot(ST50_2,'b');
subplot(1,2,2)
plotdz(ST50_2,DEM50);


%%
mn = 0.05:0.05:0.6; % define concavity index range
bins = 10; % define # of bins for STD calculation
mean_std_all_bins = zeros(1,numel(mn));
std_all_bins = zeros(1,numel(mn));
Chi_val = zeros(numel(ST50_2.IXgrid),numel(mn)); % Chi-coordinates for each point (rows) for each m/n ratio (columns)
figure
for i = 1:numel(mn)
    Chi_val(:,i) = chitransform(ST50_2,A50, 'mn', mn(i)); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    subplot(4, 3, i)

    scatter(Chi_val(:,i),DEM50.Z(ST50_2.IXgrid), 10, '.'); % plot Chi-Z graph
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
    Z = DEM50.Z(ST50_2.IXgrid);
    for j = 1:bins
        bin_std(j) = std(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
        bin_N(j) = numel(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
        bin_weight(j) = bin_N(j)/numel(Chi_val(:,i));
        bin_mean(j) = mean(Z(Chi_val(:,i)>=bounds(j) & Chi_val(:,i)<bounds(j+1)));
    end
    mean_std_all_bins(i) = sum(bin_std.*bin_weight);
    bin_middle = bounds(1:end-1)+(diff(bounds)/2);
    errorbar(bin_middle,bin_mean,bin_std, '*k', 'LineWidth',1, 'CapSize', 15);
    text(min(xlim), max(ylim), sprintf('Weighted mean STD = %0.2f', mean_std_all_bins(i)), 'Horiz','left', 'Vert','top');
end
sgtitle('Chi-Z for site 28');

figure
plot(mn,mean_std_all_bins, '-o');
title('Site 28 - mean weighted STD vs. m/n ratio'); xlabel('m/n'), ylabel('Mean weighted STD [m]');