% this script is aimed to analyze the spatial distribution of the waterfall
% heads, the Menuha-Mishash contact and the heights of the waterfall heads above
% the contact

field_data = xlsread('C:\Users\Omri\Desktop\University\MSc\Fieldwork\waterfalls_and_contacts.csv');
DEM = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\DEMc_raw.tif');
wfh_kpfinder = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\cropped_DEMs\kp_coordinates_SE.xlsx');

%%
X_wfh = field_data(2:end,2);
Y_wfh = field_data(2:end,3);
Z_wfh = field_data(2:end,4);

X_wfh_kpf = wfh_kpfinder(:,1);
Y_wfh_kpf = wfh_kpfinder(:,2);
Z_wfh_kpf = wfh_kpfinder(:,3);

wfh_contact = field_data(2:end,5);
Z_contact = field_data(2:end,6);

%% waterfall heights on map
figure
imageschs(DEM);
hold on

Z_wfh_marker_range = 20*[27, 40];
wfh_contact_range = 15*[15, 25];
Z_contact_range = 10*[2, 10];
Z_wfh_norm = ((Z_wfh-min(Z_wfh))./(max(Z_wfh)-min(Z_wfh))).*(Z_wfh_marker_range(2)-Z_wfh_marker_range(1))+Z_wfh_marker_range(1);
wfh_contact_norm = ((wfh_contact-min(wfh_contact))./(max(wfh_contact)-min(wfh_contact))).*(wfh_contact_range(2)-wfh_contact_range(1))+wfh_contact_range(1);
Z_contact_norm = ((Z_contact-min(Z_contact))./(max(Z_contact)-min(Z_contact))).*(Z_contact_range(2)-Z_contact_range(1))+Z_contact_range(1);
sz = [Z_wfh_norm, wfh_contact_norm, Z_contact_norm];

s = scatter(X_wfh, Y_wfh, sz, 'filled');

labels = [];
for i = 1:length(X_wfh)
    labels = [labels; {[round(Z_wfh(i)), round(wfh_contact(i)), round(Z_contact(i))]}];
end

legend('waterfall absolute height', 'waterfall height above Menuha-Mishash contact', 'Menuha-Mishash contact height')

text(X_wfh+60, Y_wfh+60, labels);

%% contact heights on map


%% waterfall above contact on map


%% trends to north and east - waterfalls, contacts, vertical distance
figure
plot(X_wfh,Z_wfh,'or', X_wfh,Z_contact, 'xb');
title('Waterfall height and contact height vs. easting');
xlabel('Easting coordinate [m]'); ylabel('Height ASL [m]');

figure
plot(Z_wfh, Y_wfh,'*g', Z_contact, Y_wfh, 'dr');
title('Waterfall height and contact height vs. easting');
xlabel('Height ASL [m]'); ylabel('Northing coordinate [m]');

figure
plot3(X_wfh, Y_wfh, Z_wfh, 'o', X_wfh_kpf, Y_wfh_kpf, Z_wfh_kpf, 'd', X_wfh, Y_wfh, Z_contact, '*');
xlabel('X')
ylabel('Y')
zlabel('Height ASL [m]')
grid on
legend('waterfall absolute height - field', 'waterfall absolute height - Knickpoint finder', 'Menuha-Mishash contact height');

%% match surface to waterfalls

%% match surface to contacts


