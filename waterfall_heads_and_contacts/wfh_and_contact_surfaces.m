% this script is aimed to match a best fitting plane to the waterfall
% heads, the Menuha-Mishash contact and the waterfall heads found using
% knickpoint finder

field_data = xlsread('C:\Users\Omri\Desktop\University\MSc\Fieldwork\waterfalls_and_contacts_2022_08_09-15_17_manual.xlsx');

DEM = GRIDobj('C:\Users\Omri\Desktop\University\MSc\Matlab\DEMc_raw.tif');
wfh_kpfinder = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\cropped_DEMs\kp_coordinates_S.xlsx');
wfh_kpfinder_MAPI = xlsread('C:\Users\Omri\Desktop\University\MSc\Matlab\find_all_waterfall_heads\cropped_DEM_MAPI\kp_coordinates_MAPI_2022_08_08_like_field.xlsx');

% %%
% X_wfh = field_data(3:end,2);
% Y_wfh = field_data(3:end,3);
% Z_wfh = field_data(3:end,4);
% 
% X_wfh_kpf = wfh_kpfinder(:,1);
% Y_wfh_kpf = wfh_kpfinder(:,2);
% Z_wfh_kpf = wfh_kpfinder(:,3);
% 
% X_wfh_kpf_MAPI = wfh_kpfinder_MAPI(:,1);
% Y_wfh_kpf_MAPI = wfh_kpfinder_MAPI(:,2);
% Z_wfh_kpf_MAPI = wfh_kpfinder_MAPI(:,3);
% 
% 
% wfh_contact = field_data(3:end,5);
% Z_contact = field_data(3:end,6);


%%
X_wfh = field_data(1:end,2);
Y_wfh = field_data(1:end,3);
Z_wfh = field_data(1:end,4);

X_wfh_kpf = wfh_kpfinder(:,1);
Y_wfh_kpf = wfh_kpfinder(:,2);
Z_wfh_kpf = wfh_kpfinder(:,3);

X_wfh_kpf_MAPI = wfh_kpfinder_MAPI(:,1);
Y_wfh_kpf_MAPI = wfh_kpfinder_MAPI(:,2);
Z_wfh_kpf_MAPI = wfh_kpfinder_MAPI(:,3);


wfh_contact = field_data(1:end,5);
Z_contact = field_data(1:end,6);

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

[sf_wfh,gof_wfh] = fit([X_wfh, Y_wfh],Z_wfh,'poly11');
sf_wfh_kpf = fit([X_wfh_kpf, Y_wfh_kpf],Z_wfh_kpf,'poly11');
[sf_contact,gof_contacts] = fit([X_wfh, Y_wfh],Z_contact,'poly11');
[sf_diff,gof_diff] = fit([X_wfh, Y_wfh],Z_wfh-Z_contact,'poly11');
sf_wfh_kpf_MAPI = fit([X_wfh_kpf_MAPI, Y_wfh_kpf_MAPI],Z_wfh_kpf_MAPI,'poly11');

figure
s_diff = plot(sf_diff,[X_wfh, Y_wfh],Z_wfh-Z_contact);
s_diff(1).FaceColor = 'r';
s_diff(1).FaceAlpha = 0.5;
s_diff(1).EdgeAlpha = 0;
s_diff(2).MarkerFaceColor = 'r';

%%
figure
% % dGPS measured waterfall heads surface and points:
% s_wfh = plot(sf_wfh,[X_wfh, Y_wfh],Z_wfh);
% s_wfh(1).FaceColor = 'r';
% s_wfh(1).FaceAlpha = 0.5;
% s_wfh(1).EdgeAlpha = 0;
% s_wfh(2).MarkerFaceColor = 'r';

% TanDEM-X based knickpoint finder waterfall heads surface and points:
s_wfh_kpf = plot(sf_wfh_kpf,[X_wfh_kpf, Y_wfh_kpf],Z_wfh_kpf);
s_wfh_kpf(1).FaceColor = 'c';
s_wfh_kpf(1).FaceAlpha = 0.5;
s_wfh_kpf(1).EdgeAlpha = 0;
s_wfh_kpf(2).MarkerFaceColor = 'c';
% 
% % MAPI DEM based knickpoint finder waterfall heads surface and points:
% s_wfh_kpf_MAPI = plot(sf_wfh_kpf_MAPI,[X_wfh_kpf_MAPI, Y_wfh_kpf_MAPI],Z_wfh_kpf_MAPI);
% s_wfh_kpf_MAPI(1).FaceColor = 'g';
% s_wfh_kpf_MAPI(1).FaceAlpha = 0.5;
% s_wfh_kpf_MAPI(1).EdgeAlpha = 0;
% s_wfh_kpf_MAPI(2).MarkerFaceColor = 'g';
hold on

% dGPS +l laser rangefinder measured Menuha-Mishash contact surface and points:
s_contact = plot(sf_contact,[X_wfh, Y_wfh],Z_contact);
s_contact(1).FaceColor = 'b';
s_contact(1).FaceAlpha = 0.5;
s_contact(1).EdgeAlpha = 0;
s_contact(2).MarkerFaceColor = 'b';

xlabel('Easting'); ylabel('Northing'); zlabel('Height ASL [m]'); title('Measured waterfall heads, Menuha-Mishash contacts and knickpoint finder waterfall heads with fitted planes');
% legend('waterfall heads - DGPS', 'waterfall heads - kpf', 'waterfall heads - kpf - MAPI', 'Menuha-Mishash contact');
% legend('waterfall heads - DGPS', 'waterfall heads - kpf - MAPI', 'Menuha-Mishash contact');
legend('waterfall heads - kpf', 'Menuha-Mishash contact');


%%
%dip and dip direction calculation:

% horizontal_norm = [0 0 1];
% 
% wfh_normvec = [sf_wfh.p10, sf_wfh.p01, -1];
% if sf_wfh.p10<0
%     wfh_dip_az = 90-atand(sf_wfh.p01/sf_wfh.p10);
% else
%     wfh_dip_az = 270-atand(sf_wfh.p01/sf_wfh.p10);
% end
% wfh_dip = acosd((abs((dot(wfh_normvec,horizontal_norm))/(norm(wfh_normvec)*norm(horizontal_norm)))));

% contact_normvec = [sf_contact.p10, sf_contact.p01, -1];
% if sf_contact.p10<0
%     contact_dip_az = 90-atand(sf_contact.p01/sf_contact.p10);
% else
%     contact_dip_az = 270-atand(sf_contact.p01/sf_contact.p10);
% end
% contact_dip = acosd((abs((dot(contact_normvec,horizontal_norm))/(norm(contact_normvec)*norm(horizontal_norm)))));
[wfh_kpf_dip, wfh_kpf_dip_az] = plane2dip(sf_wfh_kpf.p10,sf_wfh_kpf.p01)
% [wfh_kpf_dip_MAPI, wfh_kpf_dip_az_MAPI] = plane2dip(sf_wfh_kpf_MAPI.p10,sf_wfh_kpf_MAPI.p01)


% [field_wfh_dip, field_wfh_dip_az] = plane2dip(sf_wfh.p10,sf_wfh.p01)
[contact_dip, contact_dip_az] = plane2dip(sf_contact.p10,sf_contact.p01)

%% match surface to contacts


