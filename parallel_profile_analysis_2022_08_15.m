profile_data = readtable('C:\Users\Omri\Desktop\University\MSc\Fieldwork\Site27\Parallel_profiles\S27_parallel_left.csv');
expression = '\_';
main_r_l = regexp(string(profile_data.Name),expression,'split');
main_r_l = categorical(cellfun(@(v) v(end), main_r_l));
% main_r_l = 


% figure
% scatter3(profile_data.POINT_X, profile_data.POINT_Y, profile_data.POINT_Z,4, profile_data.Distance)
% h = colorbar;
% h.Label.String = "distance from channel profile [m]";
% h.Label.FontSize = 12;
% clim([0, range(profile_data.Distance)+50]);
% colormap parula
% title('Sections along windgap system - S28');

profile_names = string(unique(profile_data.Name));

figure
hold on
max_dist = 0;
for i = 1:length(profile_names)
    prof_ind = find(profile_data.Name == profile_names(i));
    X.(profile_names(i)) = profile_data.POINT_X(prof_ind);
    Y.(profile_names(i)) = profile_data.POINT_Y(prof_ind);
    Z.(profile_names(i)) = profile_data.POINT_Z(prof_ind);
    distance.(profile_names(i)) = profile_data.Distance(prof_ind);
    dist0.(profile_names(i)) = sqrt((X.(profile_names(i))-X.(profile_names(i))(1)).^2+(Y.(profile_names(i))-Y.(profile_names(i))(1)).^2);
    max_dist = max([max(dist0.(profile_names(i))), max_dist]);
end

for i = 1:length(profile_names)
    prof_ind = find(profile_data.Name == profile_names(i));
%     if (mod(profile_data.Distance(prof_ind(1)),25) == 0) & (main_r_l(prof_ind(1)) == "left" | main_r_l(prof_ind(1)) == "main")
    dist0.(profile_names(i)) = dist0.(profile_names(i))+(max_dist-max(dist0.(profile_names(i))));
    if mod(profile_data.Distance(prof_ind(1)),25) == 0

        if main_r_l(prof_ind(1)) == "main"
            scatter(dist0.(profile_names(i)), Z.(profile_names(i)), 13, distance.(profile_names(i)), 'filled');
            plot(dist0.(profile_names(i)), Z.(profile_names(i)), '-k');
        elseif main_r_l(prof_ind(1)) == "right"
%             scatter(dist0.(profile_names(i)), Z.(profile_names(i)), 13, distance.(profile_names(i)), 'filled');
%             plot(dist0.(profile_names(i)), Z.(profile_names(i)), '-k');
        else
            scatter(dist0.(profile_names(i)), Z.(profile_names(i)), 13, distance.(profile_names(i)), 'filled');
            plot(dist0.(profile_names(i)), Z.(profile_names(i)), '-k');
        end
        bound = boundary(dist0.(profile_names(i)), Z.(profile_names(i)), 0.4);
%         patch(dist0.(profile_names(i))(bound),Z.(profile_names(i))(bound),distance.(profile_names(i))(bound),'FaceAlpha', 0.4)
    
    end
end
grid on
xlim([0 max_dist]);
xlabel('distance [m]');
ylabel('height ASL [m]')
h = colorbar;
h.Label.String = "distance from channel profile [m]";
h.Label.FontSize = 12;
caxis([0, range(profile_data.Distance)+50]);
colormap hsv

title('Sections along windgap system - S27');
%%
figure
hold on
i = 3
prof_ind = find(profile_data.Name == profile_names(i));
X.(profile_names(i)) = profile_data.POINT_X(prof_ind);
Y.(profile_names(i)) = profile_data.POINT_Y(prof_ind);
Z.(profile_names(i)) = profile_data.POINT_Z(prof_ind);
distance.(profile_names(i)) = profile_data.Distance(prof_ind);
dist0.(profile_names(i)) = sqrt((X.(profile_names(i))-X.(profile_names(i))(1)).^2+(Y.(profile_names(i))-Y.(profile_names(i))(1)).^2);

if main_r_l(prof_ind(1)) == "main"
    scatter(dist0.(profile_names(i)), Z.(profile_names(i)), 10, distance.(profile_names(i)), 'filled');
    plot(dist0.(profile_names(i)), Z.(profile_names(i)), 'k');
elseif main_r_l(prof_ind(1)) == "right"
    scatter(dist0.(profile_names(i)), Z.(profile_names(i)), 10, distance.(profile_names(i)), 'filled');
    plot(dist0.(profile_names(i)), Z.(profile_names(i)), '--k');
else
    scatter(dist0.(profile_names(i)), Z.(profile_names(i)), 10, distance.(profile_names(i)), 'filled');
    plot(dist0.(profile_names(i)), Z.(profile_names(i)), ':k');

end

bound = boundary(dist0.(profile_names(i)), Z.(profile_names(i)), 0.4);
patch(dist0.(profile_names(i))(bound),Z.(profile_names(i))(bound), 'red','EdgeColor', 'red','FaceAlpha', 0.4)
 
