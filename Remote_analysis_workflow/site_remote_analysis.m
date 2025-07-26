function [site_dat1,ST_2_trunks] = site_remote_analysis(DEM_path,wg_table,Div,Div_cell,site_ind)
%Recieves site and interactively finds waterfall, then calculates drainage
%area, anteceden slope, and windgap-waterfall distance
%   This function recieves DEM_path (path of DEM tif), wg_table (output of
%   map_all_divides_and_windaps), ,Div and Div_cell (outputs of
%   map_all_divides_and_windaps), site_ind (relevant [wg_sec_ind,
%   wg_sec_ind]), slope_params (initiation and termination distance from
%   windgap for slope calculation - [sl_start,sl_end]). It then finds the
%   two channels streaming from the windgap and interactively enables the
%   user to find the waterfall along the stream that ends lower.
%   It returns wf_dat (indexes of site and X,Y,Z of
%   the waterfall, antec_slope, wg_wf_dist, wf_area), and ST_2_trunks
%   (connected across divide STREAMobj).
    % Focus on divide [i]:
    figure
    DEM = GRIDobj(DEM_path);
    cellsize = DEM.cellsize;
    FD = FLOWobj(DEM,'preprocess','c');
    
    wg_insec_ind = table2array(wg_table(site_ind,"wg_insec_ind"));
    wg_X = table2array(wg_table(site_ind,"wg_X"));
    wg_Y = table2array(wg_table(site_ind,"wg_Y"));
    wg_Z = table2array(wg_table(site_ind,"wg_Z"));

    [current_div_X1, current_div_Y1] = ind2coord(Div,cell2mat(Div_cell(site_ind)));
    current_div_Z1 = DEM.Z(coord2ind(DEM,current_div_X1, current_div_Y1));


    subplot(1,2,1)
%     imageschs(DEM,[],'colormap',landcolor);
    imageschs(DEM);

    hold on
    plot(current_div_X1,current_div_Y1,'-', LineWidth = 2, Color = "#7E2F8E");
    scatter(wg_X, wg_Y,'*r');
    
    hold on
    next_div_X = current_div_X1(wg_insec_ind+1);
    next_div_Y = current_div_Y1(wg_insec_ind+1);
    
    if next_div_X == wg_X
        ch1_X = next_div_X+0.5*cellsize; ch2_X = next_div_X-0.5*cellsize;
        ch1_Y = (next_div_Y + wg_Y) / 2; ch2_Y = (next_div_Y + wg_Y) / 2;
    else
        ch1_Y = next_div_Y+0.5*cellsize; ch2_Y = next_div_Y-0.5*cellsize;
        ch1_X = (next_div_X + wg_X) / 2; ch2_X = (next_div_X + wg_X) / 2;
    end
    scatter([ch1_X,ch2_X],[ch1_Y,ch2_Y],'cyan','^');
    
%     ch_raster = DEM; ch_raster.Z(:) = 0;
%     ch_raster.Z([coord2ind(ch_raster,ch1_X,ch1_Y); coord2ind(ch_raster,ch2_X,ch2_Y)]) = 1;
%     ST_2_trunks = modify(ST,'downstreamto',ch_raster);

    ST_2_trunks = STREAMobj(FD,'channelheads',coord2ind(DEM,[ch1_X;ch2_X],[ch1_Y;ch2_Y]));
    plot(ST_2_trunks, 'LineWidth',2,'Color',"#A2142F");

    % cross divide
    GS = STREAMobj2GRIDobj(ST_2_trunks);
    DEMaux = DEM;
    DEMaux.Z(GS.Z) = 1;
    IX = streampoi(ST_2_trunks,'outlet','ix');
    DEMaux.Z = graydist(DEMaux.Z,IX(1));

    FDaux = FLOWobj(DEMaux);
    Saux = STREAMobj(FDaux,'channelhead',IX(2));

    plot(Saux,'LineWidth',1,'Color','k');
    subplot(1,2,2)
    plotdz(Saux,DEM,'LineWidth',2,'Color',"#A2142F")
    axis equal;
   
%     [ST_hl, ST_cl] = separate_ST_across_wg(DEM,ST_2_trunks); % changed order of ST_hl, ST_cl for S15!!!!!! the original line below:
    [ST_cl, ST_hl] = separate_ST_across_wg(DEM,ST_2_trunks);
    
    [kp_coord1,kp_ind] = find_kp(DEM,ST_cl); % shows the user to interactively choose the waterfall kp from the knickpoints along ST_cl and reutrns its coordinates and IX.
    
    A_drain1 = kp_drainage(DEM, kp_ind); % waterfall drainage area - recieve ST_cl, DEM and knickpoint index, snap to stream network, and return drainage area

    d_wf_dist1 = divide_wf_dist(ST_cl,kp_ind); % div-wf distance - recieve ST_cl and kp index, and return the distance from that channelhead (=divide) to the waterfall.
    
    antec_slope_range = [110 300];
    antec_slope1 = calc_range_slope(DEM, ST_hl, antec_slope_range); % antecedent slope - recieve DEM, ST_hl and distance range for calculation
    % of the antecedent slope.
    
    % embayment length - recieve DE - will be calculated separately based on
    % entire kp data list

    site_dat1 = [wg_X, wg_Y, wg_Z, kp_coord1, A_drain1,d_wf_dist1,antec_slope1];

end





