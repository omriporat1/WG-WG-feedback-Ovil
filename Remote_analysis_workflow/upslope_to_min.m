function [ST_table] = upslope_to_min(sites_table_w_field_channelheads,ST_table)
%This function receives an ST_table and cuts both STREAMObj to start above
%the higher one
%   Detailed explanation goes here
    [num_sites,~] = size(sites_table_w_field_channelheads);
    for site_ind = 1:num_sites
        
        DEM = GRIDobj(string(sites_table_w_field_channelheads.DEM_path(site_ind)));
        DEM = fillsinks(DEM);        
        cl_z = DEM.Z(ST_table.cl{site_ind}.IXgrid);
        hl_z = DEM.Z(ST_table.hl{site_ind}.IXgrid);
        min_height = max(min(cl_z),min(hl_z));
        
        ind_above_min_cl = find(cl_z >= min_height);
        ind_above_min_hl = find(hl_z >= min_height);

        cl_above_min = min(cl_z(ind_above_min_cl));
        hl_above_min = min(hl_z(ind_above_min_hl));

        cl_above_min_ind = find(cl_z == cl_above_min);
        hl_above_min_ind = find(hl_z == hl_above_min);

        min_equiv_cl_IX = ST_table.cl{site_ind}.IXgrid(cl_above_min_ind);
        min_equiv_hl_IX = ST_table.hl{site_ind}.IXgrid(hl_above_min_ind);

        ST_table.cl{site_ind} = modify(ST_table.cl{site_ind},'upstreamto', min_equiv_cl_IX);
        ST_table.hl{site_ind} = modify(ST_table.hl{site_ind},'upstreamto', min_equiv_hl_IX);
    end
end