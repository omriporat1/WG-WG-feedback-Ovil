function [dist_dz_dchi_struct] = calculate_dz_dchi(sites_table_w_field_channelheads,ST_table, mn_ratio,A0)
%This function draws a figure with d_chi/dz as function of distance for a
%series of cliff and highland channels, and teturns the struct with
%distance, Z and chi for all of the sites
%   Detailed explanation goes here
    [num_sites,~] = size(sites_table_w_field_channelheads);
    data_struct = struct('distance', {}, 'chi', {}, 'z', {}, 'deriv', {});
    for site_ind = 1:num_sites
        data_struct.distance(site_ind) = ST_table.cl{site_ind}.distance;
        DEM = GRIDobj(string(sites_table_w_field_channelheads.DEM_path(i)));
        DEM = fillsinks(DEM);
        FD = FLOWobj(DEM);
        A = flowacc(FD);
        data_struct.z(site_ind) = sites_ST_coord_struct.site_ind.cl.z;
        DEM.Z(ST_table.cl{site_ind}.IXgrid)
        data_struct.chi(site_ind) = chitransform(ST_table.cl{site_ind},A, 'mn', mn_ratio,'a0',A0); % Chi-transform for the specific m/n ratio; A0 is by default 1e6 m
    end
    
%     for site_ind = 1:num_sites % calculate the derivative for each site
% 
%     end
end

%%

