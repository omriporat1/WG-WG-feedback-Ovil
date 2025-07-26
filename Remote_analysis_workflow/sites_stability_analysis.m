function [stability_table] = sites_stability_analysis(sites_table, channel_ratio, concav_ind)
%This funtion recieves a table with the sites parameters including the path
%to the DEMS, relative vertical part of the distabce between waterfall and
%divide that is channel, and concavity index, and calculates their slope
%and Chi asymmetry indexes.
%   The function receives the table with DEM paths and locations of the
%   divides and waterfalls. For each site it creates ST_cl and ST_ch from
%   the divide downwards to the height of the waterfall, than compares the
%   slopes of the relative parts of the channel (user-definded) upstream to
%   the waterfall height and calculates the normalized slope asymmetry.
%   it also the Chi value at the top of the channel section of each side
%   based on the given concavity index and a reference drainage area of 1
%   km^2, and calculates the normalized Chi asymmetry. The function returns
%   the original table with two additional columns - slope_asym and
%   chi_asym.
    [num_sites, ~] = size(sites_table);
    slope_asym_index = zeros(num_sites,1);
    chi_asym_index = zeros(num_sites,1);

    for i = 1:num_sites
        [Div,Div_cell,wg_table] = map_all_divides_and_windgaps(string(sites_table.DEM_path(i)),sites_table.min_area(i),[450 500]);
        DEM = GRIDobj(string(sites_table.DEM_path(i)));
        site_ind = sites_table.site_ind(i);
        cellsize = DEM.cellsize;
        min_area = 1000;
        FD = FLOWobj(DEM,'preprocess','c');
        Flow_acc = flowacc(FD);
        close

        wg_insec_ind = table2array(wg_table(site_ind,"wg_insec_ind"));
        wg_X = table2array(wg_table(site_ind,"wg_X"));
        wg_Y = table2array(wg_table(site_ind,"wg_Y"));
    
        [current_div_X1, current_div_Y1] = ind2coord(Div,cell2mat(Div_cell(site_ind)));

        next_div_X = current_div_X1(wg_insec_ind+1);
        next_div_Y = current_div_Y1(wg_insec_ind+1);
        
        if next_div_X == wg_X
            ch1_X = next_div_X+0.5*cellsize; ch2_X = next_div_X-0.5*cellsize;
            ch1_Y = (next_div_Y + wg_Y) / 2; ch2_Y = (next_div_Y + wg_Y) / 2;
        else
            ch1_Y = next_div_Y+0.5*cellsize; ch2_Y = next_div_Y-0.5*cellsize;
            ch1_X = (next_div_X + wg_X) / 2; ch2_X = (next_div_X + wg_X) / 2;
        end
            
        ST_2_trunks = STREAMobj(FD,'channelheads',coord2ind(DEM,[ch1_X;ch2_X],[ch1_Y;ch2_Y]));
 
        [ST_cl, ST_hl] = separate_ST_across_wg(DEM,ST_2_trunks);
        
        ST_cl = modify(ST_cl,'upstreamto', DEM>sites_table.WF_Z(i)); ST_hl = modify(ST_hl,'upstreamto', DEM>sites_table.WF_Z(i));
        
        ST_cl_Z = DEM.Z(ST_cl.IXgrid);
        cut_height = min(ST_cl_Z)+channel_ratio*(max(ST_cl_Z)-min(ST_cl_Z));
        ST_cl = modify(ST_cl,'downstreamto',DEM<cut_height);
        ST_hl = modify(ST_hl,'downstreamto',DEM<cut_height);
        slope_asym_index(i) = calc_slope_ind(DEM,ST_cl,ST_hl);
        
%         hl_ST_end_ind = ST_cl.IXgrid(ST_cl.distance == max(ST_cl.distance));
%         cl_ST_end_ind = coord2ind(DEM,sites_table.WF_X,sites_table.WF_Y);
% 
%         ST_hl_full = STREAMobj(FD,'minarea',min_area/(cellsize^2),'outlets',hl_ST_end_ind);
%         ST_cl_full = STREAMobj(FD,'minarea',min_area/(cellsize^2),'outlets',cl_ST_end_ind);
%         
%         Chi_val_hl = chitransform(ST_hl_full,Flow_acc, 'mn', concav_ind);
%         Chi_val_hl_ch = Chi_val_hl(ST_hl_full.IXgrid==hl_ST_end_ind);
% 
%         Chi_val_cl = chitransform(ST_cl_full,Flow_acc, 'mn', concav_ind);
%         Chi_val_cl_ch = Chi_val_cl(ST_cl_full.IXgrid==cl_ST_end_ind);
% 
%         chi_asym_index(i) = (Chi_val_hl_ch-Chi_val_cl_ch)/(Chi_val_hl_ch+Chi_val_cl_ch)
% 
%         % remove later:
%         figure
%         imageschs(DEM);
%     
%         hold on
%         plot(current_div_X1,current_div_Y1,'-', LineWidth = 2, Color = "#7E2F8E");
%         scatter(wg_X, wg_Y,'*r');
%         scatter([ch1_X,ch2_X],[ch1_Y,ch2_Y],'cyan','^');
%         plotc(ST_hl_full,Chi_val_hl);
%         plotc(ST_cl_full,Chi_val_cl);
%         colorbar

    end
    stability_table = table(slope_asym_index, chi_asym_index, 'VariableNames', {'slope_asym_ind','chi_asym_ind'});

end