function [kp_coord, kp_DEM_ind] = find_kp(DEM, ST_cl)
%recieve ST_cl and DEM, interactively enable user to choose the correct KP
%# that represents the waterfall, and reutrn XYZ, index (with reference in
%DEM) of knickpoint
%     figure;
%     imageschs(DEM);

    [~,kp] = knickpointfinder(ST_cl,DEM,'tol',1,'split',false, 'verbose', false);
    close;
    figure('WindowState','maximized');
    subplot(2,1,1)
    plotdz(ST_cl, DEM);
    hold on
    plot(kp.distance, kp.z, '*');
    ind = 1:length(kp.z);
    labelpoints(kp.distance, kp.z, ind);

    subplot(2,1,2)
    imageschs(DEM);
    hold on;
    plot(ST_cl, 'k');
    xlim([min(ST_cl.x)-100, max(ST_cl.x)+100]); ylim([min(ST_cl.y)-100, max(ST_cl.y)+100]); 
    plot(kp.x, kp.y, '*');
    ind = 1:length(kp.x);
    labelpoints(kp.x, kp.y, ind);
    wfh_kp = inputdlg('Enter the number of correct knickpoint:');
    wfh_kp = str2double(wfh_kp{1});
    kp_coord = [kp.x(wfh_kp), kp.y(wfh_kp), kp.z(wfh_kp)];
    kp_DEM_ind = kp.IXgrid(wfh_kp);
end