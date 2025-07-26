function [ST_table,Coord_struct] = extract_site_trunk_table(sites_table)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


    [num_sites, ~] = size(sites_table);

    table_headers = {'Two_trunks','cl','hl'};
    ST_table = cell2table(cell(0,3),'VariableNames', table_headers);
    % Coord_struct = table('Size',[0,3], 'VariableTypes',{'table','table','table'},'VariableNames', table_headers);
    
   for i = 1:num_sites 
        sprintf("Strating to extract trunk table and coordinates for site # %d: %s", i,string(sites_table.site_name{i}))

        [Div,Div_cell,wg_table] = map_all_divides_and_windgaps(string(sites_table.DEM_path(i)),sites_table.min_area(i),[450 500]);
        DEM = GRIDobj(string(sites_table.DEM_path(i)));
        DEM = fillsinks(DEM);
        site_ind = sites_table.site_ind(i);
        cellsize = DEM.cellsize;
        FD = FLOWobj(DEM,'preprocess','c');
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
        
        ST_2_trunks = modify(ST_2_trunks,'upstreamto', DEM>sites_table.WF_Z(i)); ST_cl = modify(ST_cl,'upstreamto', DEM>sites_table.WF_Z(i)); ST_hl = modify(ST_hl,'upstreamto', DEM>sites_table.WF_Z(i));
        current_ST_table = table(STREAMobj2cell(ST_2_trunks),STREAMobj2cell(ST_cl),STREAMobj2cell(ST_hl),'VariableNames', table_headers);
        ST_table = [ST_table; current_ST_table];
        [x,y,z,d] = STREAMobj2XY(ST_2_trunks,DEM,ST_2_trunks.distance);
        current_2_trunks_table = table(x,y,z,d);
        Coord_struct(i).two_trunks = current_2_trunks_table;
        [x,y,z,d] = STREAMobj2XY(ST_cl,DEM,ST_cl.distance);
        current_cl_table = table(x,y,z,d);
        Coord_struct(i).cl = current_cl_table;
        [x,y,z,d] = STREAMobj2XY(ST_hl,DEM,ST_hl.distance);
        current_hl_table = table(x,y,z,d);
        Coord_struct(i).hl = current_hl_table;
    end


%         ST_cl_Z = DEM.Z(ST_cl.IXgrid);
% %         cut_height = min(ST_cl_Z)+channel_ratio*(max(ST_cl_Z)-min(ST_cl_Z));
%         ST_cl = modify(ST_cl,'downstreamto',DEM<cut_height);
%         ST_hl = modify(ST_hl,'downstreamto',DEM<cut_height);
%         slope_asym_index(i) = calc_slope_ind(DEM,ST_cl,ST_hl);
            
%         figure
%         imageschs(DEM,[])
%         hold on
%         plot(ST_2_trunks,'k','LineWidth',2)
%         plot(ST_cl,'b','LineWidth',1)
%         plot(ST_hl,'r','LineWidth',1)

end
